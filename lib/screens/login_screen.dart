import 'package:fl_productos_app/providers/login_form_provider.dart';
import 'package:fl_productos_app/services/services.dart';
import 'package:fl_productos_app/ui/custom_input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:fl_productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 175),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: CustomInputDecorations.authInputDecoration(
              hintText: 'example@example.com',
              labelText: 'Email',
              icon: Icons.alternate_email,
            ),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Formato de email no valido';
            },
            onChanged: (value) => loginForm.email = value,
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            obscureText: true,
            enableSuggestions: false,
            decoration: CustomInputDecorations.authInputDecoration(
              hintText: '*****',
              labelText: 'Password',
              icon: Icons.key,
            ),
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'Password debe contener al menos de 6 caracteres';
            },
            onChanged: (value) => loginForm.password = value,
          ),
          const SizedBox(height: 15),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    final String? error = await authService.login(
                      loginForm.email,
                      loginForm.password,
                    );
                    loginForm.isLoading = false;

                    if (error == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      // Mostrar el mensaje de error en pantalla
                      NotificationsService.showSnackbar(error);
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Text(
                loginForm.isLoading ? 'Espere...' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
