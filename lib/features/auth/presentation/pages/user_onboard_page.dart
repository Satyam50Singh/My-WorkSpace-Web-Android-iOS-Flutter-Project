import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/widgets/company_logo_web_card.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/loader_utils.dart';

class UserOnboardPage extends StatefulWidget {
  const UserOnboardPage({super.key});

  @override
  State<UserOnboardPage> createState() => _UserOnboardPageState();
}

class _UserOnboardPageState extends State<UserOnboardPage> {
  final _formKey = GlobalKey<FormState>();
  String? _companyCode;

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
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is AuthFailure) {
                      Navigator.of(context).pop();
                      SnackBarUtils.showErrorSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is ValidatedCompanyCodeSuccess) {
                      Navigator.of(context).pop();
                      context.goNamed(
                        AppRoutes.login,
                        pathParameters: {
                          'companyId': state.companyDetails.companyId
                              .toString(),
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
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
                                    'Company Code',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          onChanged: (value) {
                                            _companyCode = value;
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter company code';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hoverColor: Colors.transparent,
                                            prefixIcon: Icon(Icons.business),
                                            hint: Text('Enter Company Code'),
                                            label: Text('Company Code'),
                                          ),
                                          autofillHints: null,
                                        ),
                                        SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // Will Integrate an API here...

                                                context.read<AuthBloc>().add(
                                                  ValidateCompanyCodeRequested(
                                                    companyCode:
                                                        _companyCode ?? "",
                                                  ),
                                                );

                                                // context.go(AppRoutes.login);
                                              }
                                            },
                                            child: Text('Submit'),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
