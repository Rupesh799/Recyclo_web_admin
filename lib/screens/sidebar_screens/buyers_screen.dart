import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerScreen extends StatefulWidget {
  static const String routeName = '\BuyerScreen';

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  Set<int> selectedRows = Set<int>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('buyers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var buyers = snapshot.data!.docs;

            // Ensure that the selectedRows list has the same length as the number of buyers
            

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Buyers",
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
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'FullName',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Mobile Number',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Status',
                        //     style: TextStyle(
                        //         fontSize: 18, fontWeight: FontWeight.w500),
                        //   ),
                        // ),
                      ],
                      rows: buyers.asMap().entries.map((entry) {
                        var index = entry.key;
                        var buyer = entry.value;
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
                              DataCell(Text(buyer['fullname'])),
                              DataCell(Text(buyer['phone'])),
                              DataCell(Text(buyer['email'])),
                            ]);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          for (int index in selectedRows.toList()) {
                            FirebaseFirestore.instance
                                .collection("buyers")
                                .doc(buyers[index].id)
                                .delete();
                            selectedRows.remove(index);
                          }
                        },
                        child: Text("Delete Selected Rows"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 16)), // Set button text style
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
          },
        ),
      );
}
