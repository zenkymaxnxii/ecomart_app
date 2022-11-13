import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';

import '../../utils/auth_helper.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  BookScreenState createState() {
    return BookScreenState();
  }
}

class BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _desController = TextEditingController();
  final _noteController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isSelectedAmount = false;
  int amountSelected = -1;
  String name = "";

  @override
  void dispose() {
    _desController.dispose();
    _noteController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
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
            const Center(
              child: SizedBox(
                child: Text(
                  "Đặt lịch thu gom",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(AuthHelper.getId())
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapShot) {
                        if (snapShot.hasData) {
                          final userData = snapShot.data!;
                          name = userData['name'];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.scale,
                                      color: kPrimaryColor,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Số lượng thu gom",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    height: 60,
                                    child: ListView.builder(
                                        itemCount: getListAmount().length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSelectedAmount = true;
                                                amountSelected = index;
                                              });
                                            },
                                            child: Container(
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: index == amountSelected
                                                      ? Colors.green
                                                      : null),
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getListAmount()[index]
                                                        .title,
                                                    style: TextStyle(
                                                        color: index ==
                                                                amountSelected
                                                            ? Colors.white
                                                            : Colors.grey),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    getListAmount()[index].type,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: index ==
                                                                amountSelected
                                                            ? Colors.white
                                                            : Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              if (isSelectedAmount)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Số điểm bạn nhận được: ${getListAmount()[amountSelected].point}"),
                                  ),
                                ),
                              customEditText(
                                  Icons.description,
                                  "Mô tả",
                                  "Mô tả về các loại rác, ví dụ:\n- Nhựa 5Kg\n- Giấy 5Kg...",
                                  "Vui lòng nhập mô tả!",
                                  _desController),
                              customEditText(
                                  Icons.note,
                                  "Ghi chú (Tùy chọn)",
                                  "Ghi chú cho shipper:\n(Không bắt buộc)",
                                  "",
                                  _noteController,
                                  require: false),
                              customEditText(
                                  Icons.location_city,
                                  "Địa chỉ",
                                  "Địa chỉ của bạn:",
                                  "Vui lòng nhập địa chỉ!",
                                  _addressController,
                                  text: userData['address']),
                              customEditText(
                                  Icons.phone_android,
                                  "Số điện thoại",
                                  "Nhập số điện thoại của bạn:",
                                  "Vui lòng nhập số điện thoại!",
                                  _phoneController,
                                  text: userData['phone_number'],
                                  maxLine: 1),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!isSelectedAmount) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          backgroundColor: kPrimaryColor,
                                          content: Text(
                                              "Hãy chọn số lượng thu gom!"),
                                        ));
                                        return;
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        booking(name);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          backgroundColor: kPrimaryColor,
                                          content: Text(
                                              "Đặt thành công!"),
                                        ));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text(
                                      'Đặt lịch',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customEditText(IconData iconData, String title, String hintTextStr,
      String errorText, TextEditingController controller,
      {String text = "", int maxLine = 4, bool require = true}) {
    controller.text = text;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Icon(
                iconData,
                color: kPrimaryColor,
                size: 16,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        SizedBox(
          child: TextFormField(
            // Handles Form Validation for First Name
            validator: (value) {
              if ((value == null || value.isEmpty) && require) {
                return errorText;
              }
              return null;
            },
            maxLines: maxLine,
            decoration: InputDecoration(
              filled: false,
              hintText: hintTextStr,
              hintStyle: const TextStyle(color: Colors.black26),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.green, width: 1),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
            ),
            controller: controller,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void booking(String name) {
    UserHelper.booking(
        amount: getListAmount()[amountSelected].type,
        description: _desController.text,
        note: _noteController.text,
        name: name,
        address: _addressController.text,
        phoneNumber: _phoneController.text);
    UserHelper.updatePoint(
        point: getListAmount()[amountSelected].point, calculation: true);
  }

  List<Amount> getListAmount() {
    List<Amount> list = List.empty(growable: true);
    list.add(Amount("Nhỏ", "< 5kg", 100));
    list.add(Amount("Vừa", "5 - 15kg", 200));
    list.add(Amount("Lớn", "15 - 30kg", 300));
    list.add(Amount("Rất lớn", "> 30kg", 400));
    return list;
  }
}

class Amount {
  String title;
  String type;
  int point;

  Amount(this.title, this.type, this.point);
}
