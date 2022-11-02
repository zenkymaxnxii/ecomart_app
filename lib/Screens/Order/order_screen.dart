import 'package:flutter/material.dart';
import 'package:ecomart_app/components/appbar_widget.dart';

import '../../Model/order.dart';
import '../../constants.dart';

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
          allOrder(allOrder: false)
        ],
      ),
    );
  }
}

Widget allOrder({required bool allOrder}) {
  final List<Order> entries = List.empty(growable: true);

  entries.addAll(getList(allOrder: allOrder));

  return Expanded(
    child: ListView.builder(
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
    ),
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
