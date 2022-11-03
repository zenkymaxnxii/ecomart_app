import 'package:ecomart_app/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    UserHelper.updateUser("name", name);
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
                  width: 330,
                  child: Text(
                    "Họ và tên của bạn là gì?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: TextFormField(
                    // Handles Form Validation for First Name
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Xin vui lòng nhập họ và tên!';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Họ và tên'),
                    controller: fullNameController,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              updateUserValue(fullNameController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Cập nhật',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ],
          ),
        ));
  }
}
