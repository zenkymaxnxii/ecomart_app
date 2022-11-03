import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';

import '../../constants.dart';
import '../../utils/auth_helper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  OrderScreenState createState() {
    return OrderScreenState();
  }
}

class OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          const Center(
            child: SizedBox(
              child: Text(
                "Đang xử lý",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
            ),
          ),
          Expanded(child: listViewOrder()),
        ],
      ),
    );
  }

  Widget listViewOrder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("uid", isEqualTo: AuthHelper.getId().toString())
            .where("status", whereIn: [0, 1]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listOrders = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listOrders.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryLightColor),
                        child: const Icon(Icons.recycling),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  listOrders[index]['name'],
                                  style: const TextStyle(
                                      color: kPrimaryColor, fontSize: 22),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("(${listOrders[index]['amount']})")
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text(listOrders[index]['date_time']
                                    .toString()
                                    .substring(0, 16)),
                                const Text(" - "),
                                Text(
                                  listOrders[index]['status'] == 0
                                      ? "Đang xử lý"
                                      : listOrders[index]['status'] == 1
                                      ? "Đang đến lấy"
                                      : "Đã hoàn thành",
                                  style: TextStyle(
                                    color: listOrders[index]['status'] == 0
                                        ? Colors.yellow
                                        : listOrders[index]['status'] == 1
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                listOrders[index]['address'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                listOrders[index]['description'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                listOrders[index]['note'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
