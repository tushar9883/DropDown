import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.data.dart';

class Drop_Down extends StatefulWidget {
  const Drop_Down({Key? key}) : super(key: key);

  @override
  State<Drop_Down> createState() => _Drop_DownState();
}

class _Drop_DownState extends State<Drop_Down> {
  Country? selectedCountry;

  bool isLoading = false;
  DropDownData? dropDownData;

  Future<DropDowns?> getPost() async {
    setState(() {
      isLoading = true;
    });
    const String url = "http://18.207.31.188:5046/en/api/dropdownvalue";
    var res = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMTQwLCJleHAiOjE2NTY1OTU0MTB9.6diQ0R4BqYX1J_hi3IqA92nKMQBKW3Que5DTG6qXKjk'
    });

    var reportModel = DropDowns.fromJson(jsonDecode(res.body));

    if (res.body != null) {
      try {
        if (reportModel.data != null) {
          dropDownData = reportModel.data;
          setState(() {
            isLoading = false;
          });
        } else {
          print("Error >>1 ");
        }
      } catch (e) {
        print("Error >>2 ");
      }
    } else {
      print("No Data Found >>3 ");
    }
  }

  @override
  void initState() {
    isLoading = true;
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              DropdownButton<Country>(
                value: selectedCountry,
                isExpanded: true,
                onChanged: (Country? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                    print(selectedCountry);
                  });
                },
                items: (dropDownData?.country ?? [])
                    .map((value) => DropdownMenuItem<Country>(
                          value: value,
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Loading...',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : Text(
                                  value.name ?? "",
                                  style: const TextStyle(color: Colors.black),
                                ),
                        ))
                    .toList(),
                hint: const Text('Select Country'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
