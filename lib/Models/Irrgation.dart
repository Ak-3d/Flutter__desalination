import 'Schedule.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Irrigation {
  @Id()
  int id = 0;

  bool isDeleted = false;
  double tdsValue;
  String plantName;
  double irrigationVolume;
  int tankPort;
  DateTime createdDate = DateTime.now();

  final schedule = ToOne<Schedule>();
  Irrigation(
      this.irrigationVolume, this.plantName, this.tankPort, this.tdsValue);
}
