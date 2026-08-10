import 'package:bloc/bloc.dart';
import 'package:my_worksphere_web/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/employee_detail.dart';

part 'employee_detail_state.dart';

class EmployeeDetailCubit extends Cubit<EmployeeDetailState> {
  final AuthRepository authRepository;

  EmployeeDetailCubit(this.authRepository) : super(EmployeeDetailInitial()) {
    _restoreFromCache();
  }

  Future<void> _restoreFromCache() async {
    final cached = await authRepository.getCachedEmployeeDetails();
    emit(
      cached != null
          ? EmployeeDetailFetched(employeeDetail: cached)
          : EmployeeDetailInitial(),
    );
  }

  void saveEmployeeDetails(EmployeeDetail employeeDetail) async {
    await authRepository.saveEmployeeDetails(employeeDetail);
    emit(EmployeeDetailFetched(employeeDetail: employeeDetail));
  }

  void clearEmployeeDetails() async {
    await authRepository.clearEmployeeDetails();
    emit(EmployeeDetailCleared());
  }
}
