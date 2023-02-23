// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Alarm {
  String? label;
  List<TimeOfDay>? times;
  String? note;
  IconData? icon;
  bool isActive;
  List<bool> repeatDays;
  List<String>? products;
  DateTime? startDate;
  DateTime? endDate;

  Alarm({
    this.label,
    this.times,
    this.note,
    this.icon,
    this.isActive = false,
    this.products,
    this.startDate,
    this.endDate,
    this.repeatDays = const [false, false, false, false, false, false, false],
  });

  Alarm copyWith({
    String? label,
    List<TimeOfDay>? times,
    String? note,
    IconData? icon,
    bool? isActive,
    List<bool>? repeatDays,
    List<String>? products,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Alarm(
      label: label ?? this.label,
      times: times ?? this.times,
      note: note ?? this.note,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
      products: products ?? this.products,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
