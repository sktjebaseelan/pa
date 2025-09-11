import 'package:expense_tracker/cubit/employee_cubit.dart';
import 'package:expense_tracker/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeScreen extends StatelessWidget {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employees")),
      body: BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final emp = employees[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(emp.name[0])),
                  title: Text(emp.name),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Add Employee"),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Employee name"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      context.read<EmployeeCubit>().addEmployee(
                        Employee(
                          id: DateTime.now().toIso8601String(),
                          name: name,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
