import 'package:objectbox/objectbox.dart';

import 'Tanks.dart';

@Entity()
class Production {
  @Id()
  int id = 0;

  double tdsValue;
  double temperatureValue;
  DateTime createdDate = DateTime.now();
  double flowWaterPermeate;
  double flowWaterConcentrate;
  final tanks = ToOne<Tanks>();

  Production(this.tdsValue, this.flowWaterConcentrate, this.flowWaterPermeate,
      this.temperatureValue);
}
