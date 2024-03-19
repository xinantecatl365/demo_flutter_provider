import 'dart:developer' as dev;

import 'package:fl_productos_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black87),
        color: Colors.grey.shade200,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black54,
            // spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
        border: const Border.fromBorderSide(
          BorderSide(color: Colors.black38, width: 0.5),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              'Iniciar Sesión',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            const CustomFormField(
              keyboardType: TextInputType.emailAddress,
              iconData: Icons.email,
              labelText: 'Email',
              key: Key('_loginform_email_'),
            ),
            SizedBox(height: 10.h),
            const CustomFormField(
              keyboardType: TextInputType.visiblePassword,
              iconData: Icons.key,
              labelText: 'Password',
              key: Key('_loginform_password_'),
              obscureText: true,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(SelectRolePage.route());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ingresar'),
            ),
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                text: '¿No tienes una cuenta? ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Regístrate aquí',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        dev.log('Go to: Register');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
