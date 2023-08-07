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
  double flowWaterConventrate;
  final tanks = ToOne<Tanks>();

  Production(this.tdsValue, this.flowWaterConventrate, this.flowWaterPermeate,
      this.temperatureValue);
}
