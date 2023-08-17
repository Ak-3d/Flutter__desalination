import 'package:objectbox/objectbox.dart';

import 'Status.dart';

@Entity()
class Report {
  @Id()
  int id = 0;

  final status = ToOne<Status>();

  String note;

  @Property(type: PropertyType.date)
  DateTime createdDate = DateTime.now();

  @Property(type: PropertyType.date)
  DateTime modifiedDate = DateTime.now();

  Report(this.note);
}
