import 'package:final_project/Models/Irrgation.dart';
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

  DateTime time = DateTime.timestamp();
  bool isDeleted = false;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  final tanks = ToOne<Tanks>();

  Schedule(this.time, this.modifiedDate);
}
