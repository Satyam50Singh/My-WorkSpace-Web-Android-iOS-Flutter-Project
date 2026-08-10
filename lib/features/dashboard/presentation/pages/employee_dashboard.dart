import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/employee_detail_cubit.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<EmployeeDetailCubit, EmployeeDetailState>(
          builder: (context, state) {
            if (state is EmployeeDetailInitial) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is EmployeeDetailCleared) {
              return Center(child: Text("No Data"));
            }
            if (state is EmployeeDetailFetched) {
              return Padding(
                padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Side Menu ${state.employeeDetail.fullName}",
                      style: TextStyle(fontSize: 48),
                    ),
                    Text("Main Menu", style: TextStyle(fontSize: 48)),
                  ],
                ),
              );
            }
            return Center(child: Text("No Data"));
          },
        ),
      ),
    );
  }
}
