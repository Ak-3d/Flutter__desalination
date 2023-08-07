import 'package:objectbox/objectbox.dart';

@Entity()
class Status {
  @Id()
  int id = 0;
  String name;

  Status(this.name);
}
