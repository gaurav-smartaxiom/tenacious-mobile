import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MasterDataPage extends StatefulWidget {
  const MasterDataPage({Key? key}) : super(key: key);

  @override
  _MasterDataPageState createState() => _MasterDataPageState();
}

class _MasterDataPageState extends State<MasterDataPage> {
  List<DataRow> filteredRows = []; // Initialize as an empty list
  TextEditingController searchController = TextEditingController();

  String url = 'https://jsonplaceholder.org/users';

  List<Map<String, dynamic>>? data;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData is List) {
          setState(() {
            data = List<Map<String, dynamic>>.from(jsonData);
            // Initialize filteredRows with the data
            filteredRows = data!.map((item) {
              return DataRow(cells: [
                DataCell(Text(
                  item['id'].toString(),
                  textAlign: TextAlign.start, // Align text to the left
                )),
                DataCell(Text(
                  item['firstname'].toString(),
                  textAlign: TextAlign.start,
                )),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: Text(
                      item['login']['username'].toString(),
                    ),
                  ),
                ),
              ]);
            }).toList();
          });
        } else {
          print('Response body is not a List');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MasterDataPage"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 Expanded(
  child: Container(
    margin: EdgeInsets.only(left: 15),
    height: 42,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(1.0),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10), // Adjust padding as needed
        ),
        onChanged: (value) {
          filterRows(value);
        },
      ),
    ),
  ),
),

                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.grey[600],
                        size: 45,
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'search',
                          child: Text('Search'),
                        ),
                        PopupMenuItem<String>(
                          value: 'lastConnected',
                          child: Text('Last Connected'),
                        ),
                        PopupMenuItem<String>(
                          value: 'status',
                          child: Text('Status'),
                        ),
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'search':
                            print("Search");
                            break;
                          case 'lastConnected':
                            break;
                          case 'status':
                            break;
                        }
                      },
                      offset: Offset(0, 30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Container(
                            // margin: EdgeInsets.only(right: 2), // Add margin here
                            child: Text(
                              'DeviceUUID',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            // margin: EdgeInsets.only(right: 2),
                            child: Text(
                              'firstname',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: filteredRows,
                    ),
                  ),
                ),
              ),

              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: Container(
              //       height: 50,
              //       width: MediaQuery.of(context).size.width,
              //       color: Colors.red[300],
              //       child: DataTable(
              //         columns: [
              //           DataColumn(
              //             label: Container(
              //               child: Text('DeviceUUID',
              //                   style: TextStyle(
              //                       fontSize: 15, fontWeight: FontWeight.bold)),
              //             ),
              //           ),
              //           DataColumn(
              //             label: Container(
              //               padding: EdgeInsets.only(left: 2),
              //               child: Text('firstname',
              //                   style: TextStyle(
              //                       fontSize: 15, fontWeight: FontWeight.bold)),
              //             ),
              //           ),
              //           DataColumn(
              //             label: Container(
              //               padding: EdgeInsets.only(left: 10),
              //               child: Text('Email',
              //                   style: TextStyle(
              //                       fontSize: 15, fontWeight: FontWeight.bold)),
              //             ),
              //           ),
              //         ],
              //         rows: filteredRows,
              //       ),
              //     ),
              //     //       // child: DataTable(
              //     //       //   columns: [
              //     //       //     DataColumn(
              //     //       //       label: Container(
              //     //       //         child: Text('DeviceUUID',
              //     //       //             style: TextStyle(
              //     //       //                 fontSize: 15, fontWeight: FontWeight.bold)),
              //     //       //       ),
              //     //       //     ),
              //     //       //     DataColumn(
              //     //       //       label: Container(
              //     //       //         padding: EdgeInsets.only(
              //     //       //             left: 2),
              //     //       //         child: Text('firstname',
              //     //       //             style: TextStyle(
              //     //       //                 fontSize: 15, fontWeight: FontWeight.bold)),
              //     //       //       ),
              //     //       //     ),
              //     //       //     DataColumn(
              //     //       //       label: Container(
              //     //       //         padding: EdgeInsets.only(
              //     //       //             left: 10),
              //     //       //         child: Text('Email',
              //     //       //             style: TextStyle(
              //     //       //                 fontSize:15, fontWeight: FontWeight.bold)),
              //     //       //       ),
              //     //       //     ),
              //     //       //   ],
              //     //       //   rows: filteredRows,
              //     // ),
              //   ),
              // )
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.window),
            label: 'Window',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bus.png',
              width: 35,
              height: 35,
            ),
            label: 'Shipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
          ),
        ],
      ),
    );
  }

  void filterRows(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        filteredRows = data!.map((item) {
          return DataRow(cells: [
            DataCell(Text(
              item['id'].toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  item['username'].toString(),
                  //textAlign: TextAlign.start,
                ),
              ),
            ),
            DataCell(
              Padding(
                padding:
                    const EdgeInsets.only(left: 10), // Add left margin here
                child: Text(
                  item['email'].toString(),
                  // textAlign: TextAlign.start,
                ),
              ),
            ),
          ]);
        }).toList();
      });
    } else {
      setState(() {
        filteredRows = data!
            .where((item) =>
                item['username'].toString().contains(searchTerm) ||
                item['email'].toString().contains(searchTerm) ||
                item['id'].toString().contains(searchTerm))
            .map((item) {
          return DataRow(cells: [
            DataCell(Text(
              item['id'].toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(
              item['username'].toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  item['email'].toString(),
                  //textAlign: TextAlign.start,
                ),
              ),
            ),
          ]);
        }).toList();
      });
    }
  }
}
