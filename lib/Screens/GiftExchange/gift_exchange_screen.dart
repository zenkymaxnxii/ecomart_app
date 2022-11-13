import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/appbar_widget.dart';
import '../../constants.dart';
import 'gift_detail.dart';
import 'package:path/path.dart';

class GiftExchangeScreen extends StatefulWidget {
  const GiftExchangeScreen({Key? key}) : super(key: key);

  @override
  State<GiftExchangeScreen> createState() => _GiftExchangeScreenState();
}

class _GiftExchangeScreenState extends State<GiftExchangeScreen> {
  int point = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(AuthHelper.getId())
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            if (user['role'] == 'admin') {
              return FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController name = TextEditingController(text: "");
                      TextEditingController price = TextEditingController(text: "");
                      TextEditingController description = TextEditingController(text: "");
                      TextEditingController amount = TextEditingController(text: "");
                      TextEditingController photo = TextEditingController(text: "");
                      XFile? image;
                      String imageName = "";
                      return AlertDialog(
                        title: const Text('Thêm quà tặng'),
                        content: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: name,
                                    cursorColor: kPrimaryColor,
                                    decoration:
                                    const InputDecoration(
                                      hintText: "Tên quà",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(
                                            defaultPadding),
                                        child: Icon(Icons.card_giftcard),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: description,
                                    cursorColor: kPrimaryColor,
                                    maxLines: 5,
                                    decoration:
                                    const InputDecoration(
                                      hintText: "Mô tả",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(
                                            defaultPadding),
                                        child: Icon(Icons.description),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: price,
                                    cursorColor: kPrimaryColor,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                    const InputDecoration(
                                      hintText: "Điểm đổi quà",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(
                                            defaultPadding),
                                        child: Icon(Icons.star_border),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: amount,
                                    cursorColor: kPrimaryColor,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                    const InputDecoration(
                                      hintText: "Số lượng",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(
                                            defaultPadding),
                                        child: Icon(Icons.description),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                          width: 330,
                                          child: GestureDetector(
                                            onTap: () async {
                                              image = await ImagePicker()
                                                  .pickImage(source: ImageSource.gallery);
                                              if (image == null) return;
                                              imageName = basename(image!.path);
                                              setState(() {
                                                photo.text = imageName;
                                              });
                                            },
                                            child: TextFormField(
                                              controller: photo,
                                              cursorColor: kPrimaryColor,
                                              maxLines: 1,
                                              keyboardType: TextInputType.number,
                                              decoration:
                                              const InputDecoration(
                                                enabled: false,
                                                hintText: "Hình ảnh",
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.all(
                                                      defaultPadding),
                                                  child: Icon(Icons.description),
                                                ),
                                              ),
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(
                                context, 'Cancel'),
                            child: const Text('Huỷ'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final url = await UserHelper.upLoadImage(name: imageName, filePath: image!.path);
                              if(url!=""){
                                await UserHelper.addGift(amount: int.parse(amount.text), nameGift: name.text, price: int.parse(price.text), description: description.text, url: url);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: kPrimaryColor,
                                  content: Text("Thêm quà không thành công!"),
                                ));
                              }
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                backgroundColor: kPrimaryColor,
                                content: Text("Thêm quà thành công!"),
                              ));
                              return Navigator.pop(
                                  context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }),
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox();
            }
          }
          return const Center(
            child: SizedBox(),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Danh sách quà tặng",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("reward_points")
                      .doc(AuthHelper.getId())
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      point = snapshot.data!['point'] as int;
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Điểm của bạn: $point',
                              style:
                              const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const Icon(
                              Icons.stars,
                              size: 18,
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection("gifts").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final listGifts = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(listGifts.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return GiftDetail(gift: listGifts[index], point: point,);
                                },
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          listGifts[index]["url"].toString()),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kPrimaryLightColor,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(2, 5),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        listGifts[index]["name"].toString(),
                                        style: const TextStyle(
                                            color: kPrimaryColor, fontSize: 15),
                                      ))),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        listGifts[index]["price"].toString(),
                                        style: const TextStyle(
                                            color: kPrimaryColor, fontSize: 15),
                                      ),
                                      const Icon(
                                        Icons.stars,
                                        size: 18,
                                        color: Colors.deepOrangeAccent,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
