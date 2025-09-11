import 'package:hive/hive.dart';

part 'lead.g.dart';

@HiveType(typeId: 4)
enum LeadStatus { Arrived, InProcess, Scheduled, Postponed, Completed }

@HiveType(typeId: 5)
class Lead extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String candidateName;

  @HiveField(2)
  String companyName;

  @HiveField(3)
  int persons;

  @HiveField(4)
  String address;

  @HiveField(5)
  String pincode;

  @HiveField(6)
  double lat;

  @HiveField(7)
  double long;

  @HiveField(8)
  DateTime tentativeDate;

  @HiveField(9)
  DateTime? scheduledDate;

  @HiveField(10)
  LeadStatus status;

  @HiveField(11)
  String assigneeId;

  Lead({
    required this.id,
    required this.candidateName,
    required this.companyName,
    required this.persons,
    required this.address,
    required this.pincode,
    required this.lat,
    required this.long,
    required this.tentativeDate,
    this.scheduledDate,
    required this.status,
    required this.assigneeId,
  });
}
