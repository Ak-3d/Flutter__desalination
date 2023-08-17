import 'package:final_project/Models/Irrgation.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import 'Days.dart';
import 'Tanks.dart';

@Entity()
class Schedule {
  @Id()
  int id = 0;

  @Backlink('schedule')
  final days = ToMany<Days>();

  @Backlink('schedule')
  final irrigation = ToMany<Irrigation>();

  bool isDeleted = false;

  @Property(type: PropertyType.date)
  DateTime createdDate = DateTime.now();

  @Property(type: PropertyType.date)
  DateTime modifiedDate = DateTime.now();

  int hours;
  int mins;

  final tanks = ToOne<Tanks>();

  Schedule(this.hours, this.mins, this.modifiedDate);
}
