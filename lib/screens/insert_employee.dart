import 'dart:convert';

import 'package:dummyEmployeeApi/config/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class InsertEmployee extends StatefulWidget {
  @override
  _InsertEmployeeState createState() => _InsertEmployeeState();
}

class _InsertEmployeeState extends State<InsertEmployee> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Logger log = getLogger("EmployeeList");
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();

  TextEditingController iDController = TextEditingController();

  TextEditingController salaryController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  Future _insertEmployee(
      String employeeName, String employeeSalary, String employeeAge) async {


    setState(() {
      isLoading = true;
    });

    var url = 'http://dummy.restapiexample.com/api/v1/create';

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': employeeName,
        'salary': employeeSalary,
        'age': employeeAge,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);

      log.i(parsedData['status']);

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Employee Record added Successfully"),
          duration: Duration(seconds: 3),
        ),
      );
    }
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Error Inserting Data"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[200],
      appBar: AppBar(title: Text('Ganerat Post Page')),
      body: SafeArea(
          child: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: salaryController,
                    decoration: InputDecoration(labelText: 'Salary'),
                  ),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  SizedBox(height: 300),
                  Container(
                    color: Colors.blue,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: FlatButton(
                          child: Text(
                            'Save Employee',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            log.i(nameController.text);
                            log.i(salaryController.text);
                            log.i(ageController.text);
                            _insertEmployee(nameController.text,
                                salaryController.text, ageController.text);
                          },
                        ))
                      ],
                    ),
                  )
                ]),
              ),
      )),
    );
  }
}
