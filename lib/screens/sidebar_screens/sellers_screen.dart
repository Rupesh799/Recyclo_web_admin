// import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SellerScreen extends StatefulWidget {
  // const SellerScreen({super.key});
  static const String routeName = '\SellerScreen';

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  Set<int> selectedRows = Set<int>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var sellers = snapshot.data!.docs;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Sellers",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 1150,
                      thickness: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text(
                            'S.N',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                          DataColumn(
                              label: Text(
                            'FullName',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                          DataColumn(
                              label: Text(
                            'Mobile Number',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                          DataColumn(
                              label: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                          // DataColumn(
                          //     label: Text(
                          //   'Status',
                          //   style: TextStyle(
                          //       fontSize: 18, fontWeight: FontWeight.w500),
                          // )),
                        ],
                        rows: sellers.asMap().entries.map((entry) {
                          var index = entry.key;
                          var seller = entry.value;
                          return DataRow(
                              selected: selectedRows.contains(index),
                              onSelectChanged: (selected) {
                                setState(() {
                                  if (selected != null && selected) {
                                    selectedRows.add(index);
                                  } else {
                                    selectedRows.remove(index);
                                  }
                                });
                              },
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(seller['fullname'])),
                                DataCell(Text(seller['phone'])),
                                DataCell(Text(seller['email'])),
                              ]);
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            for (int index in selectedRows.toList()) {
                              FirebaseFirestore.instance
                                  .collection("sellers")
                                  .doc(sellers[index].id)
                                  .delete();
                              selectedRows.remove(index);
                            }
                          },
                          child: Text("Delete Selected Rows"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(
                                    fontSize: 16)), // Set button text style
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(16)), // Set button padding
                            elevation: MaterialStateProperty.all<double>(
                                8), // Set button elevation
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red), // Set button shape
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      );
}
