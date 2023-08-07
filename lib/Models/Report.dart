import 'package:objectbox/objectbox.dart';

import 'Status.dart';

@Entity()
class Report {
  @Id()
  int id = 0;


  final status = ToOne<Status>();

  String note;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  Report(this.note);
}
