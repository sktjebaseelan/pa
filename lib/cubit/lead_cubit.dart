import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/lead.dart';

class LeadCubit extends Cubit<List<Lead>> {
  final Box<Lead> box;

  LeadCubit(this.box) : super(box.values.toList());

  void addLead(Lead lead) {
    box.add(lead);
    emit(box.values.toList());
  }

  void deleteLead(Lead lead) {
    lead.delete();
    emit(box.values.toList());
  }
}
