import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/auth/presentation/widgets/company_logo_web_card.dart';

import '../../../../core/theme/app_colors.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isMobile) CompanyLogoWebCard(),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                        minHeight: 400,
                      ),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Sign in to your Account',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 20),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        _username = value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter username';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hoverColor: Colors.transparent,
                                        prefixIcon: Icon(Icons.person_outline),
                                        hint: Text('Enter User name'),
                                        label: Text('User name'),
                                      ),
                                      autofillHints: null,
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      autofillHints: null,
                                      onChanged: (value) {
                                        _password = value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hoverColor: Colors.transparent,
                                        prefixIcon: Icon(Icons.lock_outline),
                                        hint: Text('Enter Password'),
                                        label: Text('Password'),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                        ),
                                      ),
                                      obscureText: _obscurePassword,
                                    ),
                                    SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Will Coming soon',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('Sign In'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
