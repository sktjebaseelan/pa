import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 3)
class Employee extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Employee({required this.id, required this.name});
}
