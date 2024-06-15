import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:partypal/constants/asset_paths.dart';
import 'package:partypal/constants/route_paths.dart';
import 'package:partypal/models/user_model.dart';
import 'package:partypal/services/auth_service.dart';
import 'package:partypal/utils/router_util.dart';
import 'package:partypal/widgets/app_bars/app_bar.dart';
import 'package:partypal/widgets/buttons/google_sign_in_button.dart';
import 'package:partypal/widgets/buttons/wide_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  final Role role;
  const SignInScreen({
    required this.role,
    super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = '';
  String password = '';
  bool passwordVisible = false;
  bool _isSigningIn = false;
  final _formKey = GlobalKey<FormState>();

  late FocusNode emailFocus = FocusNode();
  late FocusNode passwordFocus = FocusNode();

  @override
  void initState(){
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  @override
  void dispose(){
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(title: 'Sign in'),
            Padding(
              padding: EdgeInsets.all(0.05.sw),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox.square(
                          dimension: 40,
                          child: Image.asset(AssetPaths.logoImage),
                        ),
                        10.horizontalSpace,
                        Text(
                          'Partypal',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface
                          ),
                        )
                      ],
                    ),
                    
                    0.01.sh.verticalSpace,
            
                    Text(
                      'Hey pal! Welcome Back.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
            
                    0.05.sh.verticalSpace,
            
                    AutofillGroup(
                      child: TextFormField( // email
                        focusNode: emailFocus,
                        autofillHints: const [AutofillHints.email, AutofillHints.username],
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).textTheme.labelLarge?.color?.withOpacity(0.5)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          
                        ),
                        validator: (value){
                    
                          if (value == null || value.isEmpty){
                            return 'Email is required';
                          }
                          email = value;
                          return null;
                        },
                        onFieldSubmitted: (value){
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                      ),
                    ),
            
                    0.02.sh.verticalSpace,
            
                    AutofillGroup(
                      child: TextFormField( // password
                        focusNode: passwordFocus,
                        autocorrect: false,
                        autofillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(
                              passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Password is required';
                          }
                          password = value;
                          return null;
                        },
                        onFieldSubmitted: (value){
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
            
                    0.03.sh.verticalSpace,

                    _isSigningIn
                    ? const SizedBox.square(
                        dimension: 40,
                        child: CircularProgressIndicator(),
                      )
                    : WideButton(
                        label: 'Sign in',
                        onTap: _signIn,
                      ),

                    0.03.sh.verticalSpace,
            
                    Row( // go to login
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No account?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: (){
                            GoRouter.of(context).pushReplacement(RoutePaths.signUpScreen, extra: {'role': widget.role});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'sign up',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    0.01.sh.verticalSpace,
                    GestureDetector(
                      onTap: (){
                        GoRouter.of(context).push(RoutePaths.resetPasswordScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'forgot your password?',
                          style: Theme.of(context).textTheme.labelLarge
                        ),
                      ),
                    ),
            
                    0.03.sh.verticalSpace,
            
                    const Row( // or
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('or'),
                        ),
                        Expanded(child: Divider())
                      ],
                    ),
            
                    0.03.sh.verticalSpace,
            
                    const GoogleSignInButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  void _signIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(_formKey.currentState!.validate()){
      setState(() => _isSigningIn = true);
      AuthService auth = Provider.of<AuthService>(context, listen: false);
      bool successful = await auth.signInWithEmailAndPassword(email, password);
      setState(() => _isSigningIn = false);
      if(successful){
        if(mounted){
          GoRouter.of(context).clearStackAndNavigate(RoutePaths.home);
        }
      }
    }
  }
}