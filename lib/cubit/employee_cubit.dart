import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/employee.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final Box<Employee> box;

  EmployeeCubit(this.box) : super(box.values.toList());

  void addEmployee(Employee emp) {
    box.add(emp);
    emit(box.values.toList());
  }

  void deleteEmployee(Employee emp) {
    emp.delete();
    emit(box.values.toList());
  }
}
