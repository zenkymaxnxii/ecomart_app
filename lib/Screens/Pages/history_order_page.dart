import 'package:ecomart_app/Model/order.dart';
import 'package:ecomart_app/constants.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
                allOrder(allOrder: true),
                allOrder(allOrder: false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget allOrder({required bool allOrder}) {
    final List<Order> entries = List.empty(growable: true);

    entries.addAll(getList(allOrder: allOrder));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
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
                          entries[index].name!,
                          style: const TextStyle(
                              color: kPrimaryColor, fontSize: 22),
                        ),
                        const Text(" - "),
                        Text("${entries[index].amount} Kg")
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(entries[index].dateTime!),
                        const Text(" - "),
                        Text(
                          entries[index].status! ? "Hoàn tất" : "Đang xử lý",
                          style: TextStyle(
                            color: entries[index].status!
                                ? Colors.yellow
                                : Colors.red,
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
                        entries[index].address!,
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
  }

  Iterable<Order> getList({required bool allOrder}) {
    final List<Order> entries = List.empty(growable: true);

    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: false));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: false));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: false));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: false));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    entries.add(Order(
        name: "Nhật Minh",
        address: "Số 9 ngõ 54, đường Trần Quốc Tuấn, tp Đà Lạt",
        des: "Nhựa: 5kg, Giấy: 10kg, Rau: 10kg, Khác: 5kg",
        note: "Ghi chú",
        dateTime: "10:30 11/02/2022",
        amount: 30,
        status: true));
    Iterable<Order> result = entries.where((element) => !element.status!);
    return allOrder ? entries : result;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
