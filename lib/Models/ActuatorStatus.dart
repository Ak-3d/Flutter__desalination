import 'package:final_project/Models/Schedule.dart';
import 'package:objectbox/objectbox.dart';

// @Entity()
class ActuatorStatus {
  // @Id()
  // int id = 0;
  bool inPumps;
  bool mainPump;
  bool plantPump;
  bool plantValve;
  bool drinkPump;
  bool drinkValve;

  ActuatorStatus(
      {this.inPumps = false,
      this.mainPump = false,
      this.plantPump = false,
      this.plantValve = false,
      this.drinkPump = false,
      this.drinkValve = false});
}
