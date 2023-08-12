import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Pages/Dashboard.dart';
import '../Widgets/alertShow.dart';
import '../main.dart';

class PasswordSetup extends StatefulWidget {
  const PasswordSetup({Key? key, required this.passwordId}) : super(key: key);
  final int passwordId;
  @override
  _PasswordSetupState createState() => _PasswordSetupState();
}

class _PasswordSetupState extends State<PasswordSetup> {
  final userName = TextEditingController();
  final passWord = TextEditingController();
  final phoneNum = TextEditingController();
  late User getUser;
  late bool statue;

  void saveData() {
    if (objectbox.user.isEmpty()) {
      getUser = User(userName.text, (int.parse(phoneNum.text)), passWord.text);
      Navigator.pushNamed(context, '/TanksSetup');
    } else {
      getUser.name = userName.text;
      getUser.phoneNumber = (int.parse(phoneNum.text));
      getUser.password = passWord.text;
    }
    objectbox.user.put(getUser);
  }

  checkDialog(BuildContext context) async {
    statue = await alertShow(context, 'Do You want to save ?', 'Verify');
    if (statue) {
      saveData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          ModalRoute.withName("/Dashboard"));
    } else {
      print('Complete not Save !');
    }
  }

  @override
  void initState() {
    super.initState();
    if (!objectbox.user.isEmpty()) {
      getUser = objectbox.user.get(widget.passwordId)!;
      userName.text = getUser.name;
      passWord.text = getUser.password;
      phoneNum.text = getUser.phoneNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account setup"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: userName,
                decoration: InputDecoration(
                  icon: Icon(Icons.perm_identity),
                  labelText: 'enter your name',
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
              )),
          Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: passWord,
                decoration: InputDecoration(
                    icon: Icon(Icons.person_remove_outlined),
                    labelText: 'enter a strong password',
                    floatingLabelAlignment: FloatingLabelAlignment.center),
              )),
          Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: phoneNum,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.perm_contact_cal),
                    labelText: 'enter your phone number',
                    floatingLabelAlignment: FloatingLabelAlignment.center),
              )),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(onSurface: Colors.deepPurple.shade600),
            onPressed: () async {
              checkDialog(context);
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
