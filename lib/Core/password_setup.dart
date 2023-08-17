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

   final formKey = GlobalKey<FormState>();
  bool validated = true;

    TextEditingController userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  bool userNameHasFocus = false;
  
   TextEditingController passWordController = TextEditingController();
  FocusNode passWordFocusNode = FocusNode();
  bool passWordHasFocus = false;
  
  TextEditingController phoneNumController = TextEditingController();
  FocusNode phoneNumFocusNode = FocusNode();
  bool phoneNumHasFocus = false;

  late User getUser;
  late bool statue;

  void saveData() {
    if (objectbox.user.isEmpty()) {
      getUser = User(userNameController.text, (int.parse(phoneNumController.text)), passWordController.text);
      Navigator.pushNamed(context, '/TanksSetup');
    } else {
      getUser.name = userNameController.text;
      getUser.phoneNumber = (int.parse(phoneNumController.text));
      getUser.password = passWordController.text;
    }
    objectbox.user.put(getUser);
  }

  checkDialog(BuildContext context) async {
    statue = await alertShow(context, 'Do You want to save ?', 'Verify');
    if (statue) {
      saveData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
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
      userNameController.text = getUser.name;
      passWordController.text = getUser.password;
      phoneNumController.text = getUser.phoneNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter User Name :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: userNameFocusNode,
                        controller: userNameController,
                        decoration: InputDecoration(
                            labelText: "Please Enter User Name",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            userNameFocusNode.requestFocus();
                            userNameHasFocus = true;
                            return "You must enter User Name";
                          } else {
                            userNameHasFocus = false;
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              validated = true;
                              // formKey.currentState!.validate();
                            });
                          }
                        },
                      )),
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter Your Password  :",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: passWordFocusNode,
                        controller: passWordController,
                        obscureText: true,
                        decoration:  InputDecoration(
                            labelText: "Please Enter Password",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            passWordFocusNode.requestFocus();
                            passWordHasFocus = true;
                            return "You must enter Password";
                          } else {
                            passWordHasFocus = false;
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              validated = true;
                              // formKey.currentState!.validate();
                            });
                          }
                        },
                      )),
                  Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 35.0),
                      margin:
                          const EdgeInsets.only(top: 20, right: 5, left: 10),
                      child: Text(
                        "Enter Your PhoneNumber :",
                        style: Theme.of(context).textTheme.bodySmall,
                         
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      margin: const EdgeInsets.only(
                          top: 1, bottom: 2, right: 1, left: 10),
                      child: TextFormField(
                        focusNode: phoneNumFocusNode,
                        controller: phoneNumController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Please Enter  Your PhoneNumber",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone),
                            suffixIcon: !validated
                                ? const Icon(Icons.error_outline_rounded,
                                    color: Colors.red)
                                : const SizedBox()),
                        validator: (phoneNo) {
                          if (phoneNo!.isEmpty) {
                            phoneNumFocusNode.requestFocus();
                            phoneNumHasFocus = true;
                            return "You must enter Your PhoneNumber";
                          } else {
                            phoneNumHasFocus = false;
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              validated = true;
                              // formKey.currentState!.validate();
                            });
                          }
                        },
                      )),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            child: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  validated = formKey.currentState!.validate();

                                  checkDialog(context);
                                });
                              } else {
                                setState(() {
                                  validated = formKey.currentState!.validate();
                                });
                              }
                            }),
                     
                      ],
                    ),
                  ),
                ]))));
  }
}
