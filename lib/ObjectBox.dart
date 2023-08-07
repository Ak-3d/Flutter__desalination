import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'Models/Production.dart';
import 'Models/Tanks.dart';
import 'Models/User.dart';

import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  late final Box<User> user;
  late final Box<Tanks> tanks;
  late final Box<Production> production;
  ObjectBox._create(this.store) {
    user = store.box<User>();
    tanks = store.box<Tanks>();
    production = store.box<Production>();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }
}
