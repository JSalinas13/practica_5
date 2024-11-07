import 'dart:math';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class MyForm extends StatefulWidget {
  MyForm({
    super.key,
    Random? seed,
    required this.onSave,
    this.initialFullName = '',
    this.initialEmail = '',
    this.initialPhone = '',
  }) : seed = seed ?? Random();

  final Random seed;
  final void Function(String fullName, String email, String phone) onSave;
  final String initialFullName;
  final String initialEmail;
  final String initialPhone;

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _key = GlobalKey<FormState>();
  late MyFormState _state;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  void _onFullNameChanged() {
    setState(() {
      _state = _state.copyWith(fullName: _fullNameController.text);
    });
  }

  void _onEmailChanged() {
    setState(() {
      _state = _state.copyWith(email: Email.dirty(_emailController.text));
    });
  }

  void _onPhoneChanged() {
    setState(() {
      _state = _state.copyWith(phone: _phoneController.text);
    });
  }

  Future<void> _onSubmit() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _state = _state.copyWith(status: FormzSubmissionStatus.inProgress);
    });

    try {
      await _submitForm();
      _state = _state.copyWith(status: FormzSubmissionStatus.success);
      widget.onSave(
        _fullNameController.text,
        _emailController.text,
        _phoneController.text,
      );
    } catch (_) {
      _state = _state.copyWith(status: FormzSubmissionStatus.failure);
    }

    if (!mounted) return;

    setState(() {});

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();

    final successSnackBar = const SnackBar(
      content: Text('Submitted successfully! 🎉'),
    );
    final failureSnackBar = const SnackBar(
      content: Text('Something went wrong... 🚨'),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _state.status.isSuccess ? successSnackBar : failureSnackBar,
      );

    if (_state.status.isSuccess) _resetForm();
  }

  Future<void> _submitForm() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (widget.seed.nextInt(2) == 0) throw Exception();
  }

  void _resetForm() {
    _key.currentState!.reset();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() => _state = MyFormState());
  }

  @override
  void initState() {
    super.initState();
    _state = MyFormState();
    _fullNameController = TextEditingController(text: widget.initialFullName)
      ..addListener(_onFullNameChanged);
    _emailController = TextEditingController(text: widget.initialEmail)
      ..addListener(_onEmailChanged);
    _phoneController = TextEditingController(text: widget.initialPhone)
      ..addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        children: [
          TextFormField(
            key: const Key('myForm_fullNameInput'),
            controller: _fullNameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Nombre completo',
            ),
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            key: const Key('myForm_emailInput'),
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Correo',
              helperText: 'Ingrese un correo valido ejemplo: joe.doe@gmail.com',
            ),
            validator: (value) {
              final emailValidationError = _state.email.validator(value ?? '');
              if (emailValidationError != null) {
                return 'Correo invalido';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            key: const Key('myForm_phoneInput'),
            controller: _phoneController,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Teléfono',
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a phone number' : null,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          if (_state.status.isInProgress)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              key: const Key('myForm_submit'),
              onPressed: _onSubmit,
              child: const Text('Guardar'),
            ),
        ],
      ),
    );
  }
}

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([super.value = '']) : super.pure();

  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

class MyFormState with FormzMixin {
  MyFormState({
    this.fullName = '',
    Email? email,
    this.phone = '',
    this.status = FormzSubmissionStatus.initial,
  }) : email = email ?? Email.pure();

  final String fullName;
  final Email email;
  final String phone;
  final FormzSubmissionStatus status;

  MyFormState copyWith({
    String? fullName,
    Email? email,
    String? phone,
    FormzSubmissionStatus? status,
  }) {
    return MyFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email];
}
