import 'package:objectbox/objectbox.dart';

@Entity()
class Electricity {
  @Id()
  int id = 0;

  int duration;
  double voltageIn;
  double currentIn;
  double currentOut;
  double batteryLevel;
  bool isBattery;

  @Property(type: PropertyType.date)
  DateTime createdDate = DateTime.now();

  Electricity(this.voltageIn, this.currentIn, this.currentOut,
      this.batteryLevel, this.isBattery, this.duration);
}
