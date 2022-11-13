import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/Model/ItemGridView.dart';
import 'package:ecomart_app/Screens/GiftExchange/gift_exchange_screen.dart';
import 'package:ecomart_app/Screens/GiftExchange/gift_exchanged_screen.dart';
import 'package:ecomart_app/Screens/Guide/guide_screen.dart';
import 'package:ecomart_app/Screens/Notification/notification_screen.dart';
import 'package:ecomart_app/Screens/Order/order_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/auth_helper.dart';
import '../Book/book_screen.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<ItemGridView> listItem = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    listItem.addAll(getList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          opacity: 0.3,
          fit: BoxFit.fitHeight
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const NotificationScreen();
                    }));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5, right: 8),
                    child: Icon(Icons.email_outlined),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 5,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 3, right: 3, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(AuthHelper.getId())
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final user = snapshot.data!;
                              if (user['role'] == 'admin') {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("notice_admin")
                                        .where("readed", isEqualTo: false)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        final listNotice = snapshot.data!.docs;
                                        return Text(
                                          listNotice.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                      return const SizedBox();
                                    });
                              } else {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("notice_user")
                                        .where("uid_user",
                                            isEqualTo: AuthHelper.getId())
                                        .where("readed", isEqualTo: false)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        final listNotice = snapshot.data!.docs;
                                        return Text(
                                          listNotice.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.black12,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello,",
                    style: TextStyle(fontSize: 18, color: Colors.black26),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(AuthHelper.getId())
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapShot) {
                        if (snapShot.hasData) {
                          final user = snapShot.data!;
                          return Text(
                            user["name"] ?? "",
                            style: const TextStyle(
                                fontSize: 23, color: Colors.black54),
                          );
                        } else {
                          return const SizedBox();
                        }
                      })
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
              child: SingleChildScrollView(
                child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(listItem.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return listItem[index].screen!;
                        },
                      ),
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            left: 0,
                            bottom: 30,
                            top: 0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Icon(
                                      listItem[index].icon,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    listItem[index].name!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Container(
                              height: 30,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  listItem[index].des!,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
            }),
          ),
              )),
        ],
      ),
    );
  }

  List<ItemGridView> getList() {
    List<ItemGridView> list = List.empty(growable: true);
    list.add(ItemGridView(
        "Thu rác tại nhà", "Đặt lịch", Icons.recycling, const BookScreen()));
    list.add(ItemGridView("Đổi điểm lấy quà", "Đổi ngay", Icons.card_giftcard,
        const GiftExchangeScreen()));
    list.add(ItemGridView("Đơn đang xử lý", "Xem ngay", Icons.card_membership,
        const OrderScreen()));
    list.add(ItemGridView("Quà đã đổi", "Xem lại", Icons.account_balance_wallet,
        const GiftExchangedScreen()));
    list.add(ItemGridView("Phân loại rác", "Xem hướng dẫn", Icons.sort,
        const GuideScreen()));

    return list;
  }
}
