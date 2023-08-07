import 'package:objectbox/objectbox.dart';

@Entity()
class Electricity {
  @Id()
  int id = 0;

  double voltageIn;
  double voltageOut;
  double currentIn;
  double currentOut;
  double batteryLevel;
  bool isBattery;

  Electricity(this.voltageIn, this.voltageOut, this.currentIn, this.currentOut,
      this.batteryLevel, this.isBattery);
 
      
}
