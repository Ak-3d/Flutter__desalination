import 'package:objectbox/objectbox.dart';

import 'Tanks.dart';

@Entity()
class SingleTank {
  @Id()
  int id = 0;
  double level;
  bool isFilling;
  DateTime createdDate = DateTime.now();

  final tanks = ToOne<Tanks>();

  SingleTank(this.level, this.isFilling );
}
