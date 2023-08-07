import 'package:final_project/Models/Schedule.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Days {
  @Id()
  int id = 0;

  int day;
  bool isDeleted = false;

  final schedule = ToOne<Schedule>();

  Days(this.day);
}
