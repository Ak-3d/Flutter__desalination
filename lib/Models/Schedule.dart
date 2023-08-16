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

  int hours;
  int minutes;

  bool isDeleted = false;
  @Property(type: PropertyType.date)
  DateTime createdDate = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime modifiedDate = DateTime.now();

  final tanks = ToOne<Tanks>();

  Schedule(this.hours,this.minutes, this.modifiedDate);
}
