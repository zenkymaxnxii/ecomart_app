import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/constants.dart';
import 'package:flutter/material.dart';

import '../../components/appbar_widget.dart';
import '../../utils/auth_helper.dart';
import '../Order/order_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(
          child: Text(
            "Thông báo",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
        ),
        Expanded(
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
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final listNotice = snapshot.data!.docs;
                          return listViewNotice(listNotice, true);
                        }
                        return const SizedBox();
                      });
                } else {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("notice_user")
                          .where("uid_user", isEqualTo: AuthHelper.getId())
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final listNotice = snapshot.data!.docs;
                          return listViewNotice(listNotice, false);
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
      ]),
    );
  }

  Widget listViewNotice(List<QueryDocumentSnapshot> listNotice, bool isAdmin) {
    return ListView.builder(
        itemCount: listNotice.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              UserHelper.readNotice(noticeId: listNotice[index].id, collection: isAdmin?"notice_admin":"notice_user");
              Navigator.push(context, MaterialPageRoute(builder: (_){
                return const OrderScreen();
              }));
            },
            child: Opacity(
              opacity: listNotice[index]['readed'] ? 0.4 : 1,
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            isAdmin
                                ?
                            "${listNotice[index]['name']} đã đặt lịch."
                                :
                            listNotice[index]['status'] == 1 ?
                            "Đơn của bạn đang được xử lý."
                                :
                            "Đơn của bạn đã hoàn thành."
                            ,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18,
                                color: kPrimaryColor,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            isAdmin?
                            "${listNotice[index]['name']} đã đặt:\n${listNotice[index]['description']}.\nTại: ${listNotice[index]['address']} sdt ${listNotice[index]['phone_number']}.":
                            listNotice[index]['status'] == 1 ?
                            "Đơn:\n${listNotice[index]['description']}.\n đang được shipper tới nhận."
                                :
                            "Đơn:\n${listNotice[index]['description']}.\n đã hoàn thành"
                            ,
                            maxLines: 10,
                            style: const TextStyle(
                                fontSize: 15, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
