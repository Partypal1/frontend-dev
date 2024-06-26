import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:partypal/utils/toasts.dart';
import 'package:partypal/widgets/app_bars/app_bar.dart';
import 'package:partypal/widgets/buttons/wide_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = '';
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState(){
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: CustomSliverAppBar(title: 'Reset password')),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(0.03.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your details to continue'),

                  0.02.sh.verticalSpace,

                  Form( // email
                    key: formKey,
                    child: TextFormField( 
                      controller: emailController,
                      autofillHints: const [AutofillHints.email, AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'enter your email address',
                        hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).textTheme.labelLarge?.color?.withOpacity(0.5)
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        
                      ),
                      validator: (value){
                        String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        RegExp regex = RegExp(pattern);
                        if (value == null || !regex.hasMatch(value)){
                          return 'Enter a valid email';
                        }
                        email = value;
                        return null;
                      },
                    ),
                  ),
                  0.05.sh.verticalSpace,
                  WideButton(
                    label: 'Send reset link',
                    onTap: _sendResetlink,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _sendResetlink(){
    if(formKey.currentState!.validate()){
      FocusScope.of(context).requestFocus(FocusNode());
      emailController.text = '';
      // TODO: send a reset link
      log('sending a reset link to $email');
      Toasts.showToast('We sent you an email to reset your password');
    }
  }
}