import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  int phoneNumber;
  String name;

  String password;

  User(this.name, this.phoneNumber, this.password);
}
