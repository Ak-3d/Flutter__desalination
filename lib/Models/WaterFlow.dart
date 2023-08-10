import 'package:objectbox/objectbox.dart';

@Entity()
class WaterFlow {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date = DateTime.now();

  double tds;

  @Property(
      uid: 2940801573140608108) //this number came from json file to rename
  double flow1; //TODO should be renamed to match in or out

  double flow2;

  double tempreture;

  WaterFlow(this.tds, this.flow1, this.flow2, this.tempreture, this.date);
}
