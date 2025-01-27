import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ka_inventory/components/appBar.dart';
import 'package:ka_inventory/hive/boxes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEditing = false;
  final formKey = GlobalKey<FormState>();
  final unameCon = TextEditingController();
  final passCon = TextEditingController();
  final confirmPassCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userDataBox.listenable(),
        builder: (context, box, _) {
          final userData = box.get(userKey);

          unameCon.text = userData.uname;
          passCon.text = userData.password;

          updateUser() {
            if (formKey.currentState!.validate()) {
              userData.uname = unameCon.text;
              userData.password = passCon.text;

              userDataBox.put(userKey, userData);

              setState(() {
                isEditing = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User details updated!')),
              );
            }
          }

          toggleLogin() {
            userData.isLogged = !userData.isLogged;
            userDataBox.put(userKey, userData);
          }

          logOut() {
            if (userData.isLogged) {
              toggleLogin();
            }

            userKey = '';
            Navigator.pushNamedAndRemoveUntil(
                context, '/auth', (route) => false);
          }

          return Scaffold(
            appBar: Appbar(title: 'Profile', leading: true),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // user profile
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              userData.uname,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // edit profile
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('User Details',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        unameCon.text = userData.uname;
                                        passCon.text = userData.password;
                                        confirmPassCon.clear();
                                        isEditing = !isEditing;
                                      });
                                    },
                                    icon: Icon(
                                      isEditing
                                          ? Icons.edit_off_rounded
                                          : Icons.edit_rounded,
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: isEditing,
                                controller: unameCon,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Username is required';
                                  } else {
                                    if (userData.uname == value.trim()) {
                                      return null;
                                    }
                                    // check if existing username
                                    for (var element in userDataBox.values) {
                                      if (element.uname == value.trim()) {
                                        return 'Username already exists';
                                      }
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                enabled: isEditing,
                                controller: passCon,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              isEditing
                                  ? TextFormField(
                                      enabled: isEditing,
                                      controller: confirmPassCon,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirm Password',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Confirm Password is required';
                                        }
                                        if (value != passCon.text) {
                                          return 'Confirm Password does not match';
                                        }
                                        return null;
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 10),
                              isEditing
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: updateUser,
                                      child: const Text('Save Changes'),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      // user preferences
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preference',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Keep me logged in?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Text('no', style: TextStyle(fontSize: 13)),
                                    Switch(
                                        value: userData.isLogged,
                                        onChanged: (value) {
                                          toggleLogin();
                                        }),
                                    Text('yes', style: TextStyle(fontSize: 13)),
                                  ],
                                )
                                // SwitchListTile(value: false, onChanged: (val) {})
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // logout btn
                      userData.isLogged
                          ? const SizedBox()
                          : MaterialButton(
                              elevation: 0,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: logOut,
                              child: const Text('Log Out',
                                  style: TextStyle(color: Colors.white)),
                            )
                      // app version
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
