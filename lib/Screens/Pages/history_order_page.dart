import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomart_app/constants.dart';
import 'package:ecomart_app/utils/auth_helper.dart';
import 'package:flutter/material.dart';

class HistoryOrderPage extends StatefulWidget {
  const HistoryOrderPage({Key? key}) : super(key: key);

  @override
  State<HistoryOrderPage> createState() => _HistoryOrderPageState();
}

class _HistoryOrderPageState extends State<HistoryOrderPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 10,
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ))),
          child: const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Text(
              "Đơn hàng",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
        TabBar(
          unselectedLabelColor: Colors.black26,
          labelColor: kPrimaryColor,
          tabs: const [
            Tab(
              text: 'Lịch sử',
            ),
            Tab(
              text: 'Đang xử lý',
            ),
            Tab(
              text: 'Đã hoàn thành',
            ),
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TabBarView(
              controller: _tabController,
              children: [
                listViewOrder(typeGet: 3),
                listViewOrder(typeGet: 2),
                listViewOrder(typeGet: 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listViewOrder({required int typeGet}) {
    return StreamBuilder(
        stream: getStream(typeGet),
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
  getStream(int typeGet) {
    switch(typeGet){
      case 2:
        return FirebaseFirestore.instance
            .collection("orders")
            .where("uid", isEqualTo: AuthHelper.getId().toString())
            .where("status", whereIn: [0 , 1])
            .snapshots();
      case 1:
        return FirebaseFirestore.instance
            .collection("orders")
            .where("uid", isEqualTo: AuthHelper.getId().toString())
            .where("status", isEqualTo: 2)
            .snapshots();
    }
    return FirebaseFirestore.instance
        .collection("orders")
        .where("uid", isEqualTo: AuthHelper.getId().toString())
        .snapshots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
