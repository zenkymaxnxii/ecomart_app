import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/Screens/GiftExchange/gift_exchange_screen.dart';
import 'package:ecomart_app/utils/auth_helper.dart';
import 'package:flutter/material.dart';

import '../../components/appbar_widget.dart';
import '../../constants.dart';

class GiftExchangedScreen extends StatefulWidget {
  const GiftExchangedScreen({Key? key}) : super(key: key);

  @override
  State<GiftExchangedScreen> createState() => _GiftExchangedScreenState();
}

class _GiftExchangedScreenState extends State<GiftExchangedScreen> {
  int point = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const GiftExchangeScreen();
              },
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Danh sách quà đã đổi",
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
                              style: const TextStyle(
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
              stream: FirebaseFirestore.instance
                  .collection("order_gift")
                  .where("uid_user", isEqualTo: AuthHelper.getId())
                  .snapshots(),
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
                        return Stack(
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
                                      listGifts[index]["name_gift"]
                                          .toString(),
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
                                      listGifts[index]["status"]
                                          ? "Đã nhận"
                                          : "Đang giao",
                                      style: TextStyle(
                                          color: listGifts[index]
                                                  ["status"]
                                              ? Colors.red
                                              : Colors.grey,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
