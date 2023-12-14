import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobileapp/api_endPoint/api_endpoints.dart';
class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState(); 
}

class _UserManagementPageState extends State<UserManagementPage> {
  late List<String> namelist = [];
  final useremail = [];
 final userLevels = ["Level 1", "Superadmin", "Level 3", "Level 4"]; 

  List<String> filteredNamelist = [];

  @override
  void initState() {
    super.initState();
    loadSessionData().then((token) {
      // Fetch shipments from the API when the widget is initialized
      fetchUserDetail(token);
    });
  }

  Future<String?> loadSessionData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    final password = sharedPreferences.getString('password');
    final token = sharedPreferences.getString('token');

    print('Stored Email: $email');
    print('Stored Password: $password');
    print("token-------------$token");
    return token;
  }

  Future<void> fetchUserDetail(String? token) async {
    print('Token: "$token"');

    //final String backendUrl = 'http://10.0.2.2:4000/api/v1/users/get-registered-user';

     final String backendUrl = 'http://10.0.2.2:4000/api/v1/users?email=gaurav@smartaxiom.com&organizationName=HoneywellInternational(India)PvtLtd&userId=6374d57c02a306fc6501380e';
//final String backendUrl= UserManagementDetail;
    final response = await http.get(
      Uri.parse(backendUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print("if");
      final Map<String, dynamic> responseData = json.decode(response.body);
      //final Map<String,dynamic> userData = responseData['data'];
      print("rrrrrrrrrrrrrrrrrrrr,$responseData");

      final List<dynamic> userDataList = responseData['data'];
      if (userDataList.isNotEmpty) {
          for (var user in userDataList) {
    final String userFullName = user['fullName'] ?? ''; // Use ?? '' to handle null values
 final String UserOfficalEmail = user['officialEmail'] ?? '';
 final String userLevel = user['userLevel'] ?? '';
    print('User Full Name: $userFullName');
    print('User Full Name: $UserOfficalEmail');
print(userLevel);
    namelist.add(userFullName);
    useremail.add(UserOfficalEmail);
    userLevels.add(userLevel);
  }
        setState(() {
          filteredNamelist.addAll(namelist);
        });
      } else {
        print('No user data found in the response.');
      }
    } else {
      print('Failed to fetch user details. Status code: ${response.statusCode}');
    }
  }

  void filterSearchResults(String query) {
    List<String> searchResults = [];
    searchResults.addAll(namelist);

    if (query.isNotEmpty) {
      searchResults.retainWhere((item) => item.toLowerCase().contains(query.toLowerCase()));
    }

    setState(() {
      filteredNamelist.clear();
      filteredNamelist.addAll(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management Page"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Container(
              width: 500.0,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      Expanded(
          child: ListView.builder(
            itemCount: filteredNamelist.length,
            itemBuilder: (BuildContext context, int index) {
              if (index < userLevels.length) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(filteredNamelist[index]),
                      subtitle: Text(useremail[index],style: TextStyle(

                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                              //decorationThickness: 1.,
                              color: Colors.black,

                      )),
                      trailing: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            ' ${userLevels[index]}',
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                      },
                    ),
                    Divider( 
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink(); 
              }
            },
          ),
        ),
        ],
      ),
    );
  }
}
