import 'package:ecomart_app/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:ecomart_app/Model/user_data.dart';
import 'package:ecomart_app/components/appbar_widget.dart';

// This class handles the Page to edit the About Me Section of the User Profile.
class EditDescriptionFormPage extends StatefulWidget {
  @override
  _EditDescriptionFormPageState createState() =>
      _EditDescriptionFormPageState();
}

class _EditDescriptionFormPageState extends State<EditDescriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  var user = UserData.myUser;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  void updateUserValue(String address) {
    UserHelper.updateUser("address", address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                    width: 350,
                    child: Text(
                      "Địa chỉ của bạn ở đâu vậy?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      // Handles Form Validation
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Xin vui lòng nhập địa chỉ!';
                        }
                        return null;
                      },
                      controller: addressController,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding:
                              EdgeInsets.fromLTRB(10, 15, 10, 70),
                          hintMaxLines: 3,
                          hintText:"Địa chỉ của bạn, ví dụ:\nSố 333/43/12, Đường Phan Đình Phùng, Quận Bắc Nam, Thành Phố Lào Cai"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                updateUserValue(addressController.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Cập nhật',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
