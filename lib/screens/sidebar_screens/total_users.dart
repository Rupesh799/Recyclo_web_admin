import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalUsers extends StatefulWidget {
  const TotalUsers({Key? key}) : super(key: key);

  @override
  _TotalUserState createState() => _TotalUserState();
}

class _TotalUserState extends State<TotalUsers> {
  Set<int> selectedRows = Set<int>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var users = snapshot.data!.docs;
            int totalusers = users.length;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Total Users ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          totalusers.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: DataTable(
                        showCheckboxColumn: true,
                        dividerThickness: 3,
                        showBottomBorder: true,
                        // dataRowHeight: 70,
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
                        ],
                        rows: users.asMap().entries.map((entry) {
                          var index = entry.key;
                          var user = entry.value;
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
                              DataCell(Text(user['fullName'])),
                              DataCell(Text(user['phone'])),
                              DataCell(Text(user['email'])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform delete operation on selected rows
                        for (int index in selectedRows.toList()) {
                          // Use the user[index] data to perform the delete operation
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(users[index].id)
                              .delete();
                          selectedRows.remove(index);
                        }
                      },
                      child: Text('Delete Selected Rows'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          },
        ),
      );
}
