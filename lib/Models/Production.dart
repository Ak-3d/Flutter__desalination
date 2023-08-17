import 'package:objectbox/objectbox.dart';

import 'Tanks.dart';

@Entity()
class Production {
  @Id()
  int id = 0;

  double tdsValue;
  double temperatureValue;
  double flowWaterPermeate;
  double flowWaterConcentrate;

  final tanks = ToOne<Tanks>();

  @Property(type: PropertyType.date)
  DateTime createdDate = DateTime.now();

  Production(this.tdsValue, this.flowWaterConcentrate, this.flowWaterPermeate,
      this.temperatureValue);
}
