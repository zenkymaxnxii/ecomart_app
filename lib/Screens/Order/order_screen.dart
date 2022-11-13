import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
  }

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
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(AuthHelper.getId())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  if (user['role'] == 'admin') {
                    return listViewOrder(true);
                  } else {
                    return listViewOrder(false);
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewOrder(bool role) {
    return StreamBuilder(
        stream: getStream(role),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listOrders = snapshot.data!.docs;
            listOrders.sort((a,b)=>b['date_time'].compareTo(a['date_time']));
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listOrders.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  Container(
                    padding: role
                        ? const EdgeInsets.only(bottom: 40)
                        : const EdgeInsets.only(bottom: 0),
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
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  "Ngày đến lấy: ${listOrders[index]['pick_up_date'] ?? ""}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (role)
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: SizedBox(
                        width: 100,
                        height: 30,
                        child: listOrders[index]['status'] == 0
                            ? ElevatedButton(
                                onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController date =
                                          TextEditingController(text: "");
                                      TextEditingController time =
                                          TextEditingController(text: "");
                                      return AlertDialog(
                                        title: const Text('Đến lấy hàng'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 130,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: date,
                                                  cursorColor: kPrimaryColor,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Ngày",
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.all(
                                                          defaultPadding),
                                                      child: Icon(
                                                          Icons.date_range),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: time,
                                                  cursorColor: kPrimaryColor,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Giờ",
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.all(
                                                          defaultPadding),
                                                      child: Icon(
                                                          Icons.lock_clock),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                            onPressed: () {
                                              UserHelper.handleBooked(
                                                  orderId: listOrders[index].id,
                                                  status: 1,
                                                  date: date.text,
                                                  time: time.text);
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    }),
                                child: const Text("Đến lấy"))
                            : ElevatedButton(
                                onPressed: () {
                                  UserHelper.handleBooked(
                                      orderId: listOrders[index].id, status: 2);
                                },
                                child: const Text("Đã nhận")),
                      ),
                    )
                ]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  getStream(bool isAdmin) {
    return isAdmin
        ? FirebaseFirestore.instance
            .collection("orders")
            .where("status", whereIn: [0, 1])
            .snapshots()
        : FirebaseFirestore.instance
            .collection("orders")
            .where("uid", isEqualTo: AuthHelper.getId().toString())
            .where("status", whereIn: [0, 1])
            .snapshots();
  }
}
