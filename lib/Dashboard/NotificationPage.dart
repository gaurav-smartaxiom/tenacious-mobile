import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int numberOfItems = 10; // Set the initial number of items
  TextEditingController searchController = TextEditingController();
  late List<String> itemList; // Declare 'itemList' as 'late'
  late List<String> filteredList; // Declare 'filteredList' as 'late'

  @override
  void initState() {
    super.initState();
    itemList = List.generate(10, (index) => '123654789000 ');
    filteredList = List.from(itemList);
    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    setState(() {
      filteredList = itemList
          .where((item) => item.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notification Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: 30,
                            title: 'Section 1',
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: 20,
                            title: 'Section 2',
                          ),
                          PieChartSectionData(
                            color: Colors.yellow,
                            value: 50,
                            title: 'Section 3',
                          ),
                        ],
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 83,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          // Add your ListView.builder here
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                // You can customize the items in the list
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(filteredList[index]),
                      onTap: () {
                        // Add your onTap logic here
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('Status: Connected'),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('Last Connected: 2 mins ago'),
                    ),
                    Divider(), // Add a Divider between items
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
