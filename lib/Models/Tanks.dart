import 'package:objectbox/objectbox.dart';

import 'SingleTank.dart';
import 'Schedule.dart';
import 'Production.dart';

@Entity()
class Tanks {
  @Id()
  int id = 0;

  @Backlink('tanks')
  final singleTank = ToMany<SingleTank>();
  @Backlink('tanks')
  final schedule =ToMany<Schedule>();
  @Backlink('tanks')
  final production =ToMany<Production>();
  
  int portNumber;
  String plantName;
  double tdsValue;
  double irrigationVolume;
  bool isDeleted = false;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  Tanks(this.portNumber, this.plantName, this.tdsValue, this.irrigationVolume);
}
