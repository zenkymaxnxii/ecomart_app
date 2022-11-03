import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/constants.dart';
import 'package:flutter/material.dart';
import '../../Model/user_data.dart';
import '../../components/display_image_widget.dart';
import '../../utils/auth_helper.dart';
import 'components/edit_description.dart';
import 'components/edit_email.dart';
import 'components/edit_name.dart';
import 'components/edit_phone.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserData.myUser;

    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 10,
        ),
        Stack(
          children: [
            const Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Sửa thông tin',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ))),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  AuthHelper.logOut();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.logout,
                    size: 30,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
        DisplayImage(
          imagePath: user.image,
          onPressed: () {},
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(AuthHelper.getId())
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapShot) {
              if (snapShot.hasData){
                final userData = snapShot.data!;
                return Column(
                  children: [
                    buildUserInfoDisplay(
                        userData['name'], 'Họ tên', const EditNameFormPage()),
                    buildUserInfoDisplay(
                        userData['phone_number'], 'Số điện thoại', const EditPhoneFormPage()),
                    buildUserInfoDisplay(
                        userData['email'], 'Email', const EditEmailFormPage(), isEdit: false),
                    buildUserInfoDisplay(userData['address'], 'Địa chỉ',
                        const EditDescriptionFormPage()),
                  ],
                );
              } else {
                return const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ],
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage, {bool isEdit = true}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              if(isEdit) navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: kPrimaryColor),
                            ))),
                    if(isEdit) const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
