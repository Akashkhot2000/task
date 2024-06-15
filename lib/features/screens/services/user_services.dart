import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:task/models/user_model.dart';
import 'package:task/provider/user_provider.dart';

int currentPage = 0;
int usersPerPage = 10;

Future<Map<String, dynamic>> fetchUserData(int page, int limit) async {
  final response = await http.get(
    Uri.parse('https://dummyapi.io/data/v1/user?limit=$limit&page=$page'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'app-id': '666a92cbe42133bf4cdb3081',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<void> getUserData(BuildContext context,
    {int page = 0, int limit = 10}) async {
  try {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
    final response = await fetchUserData(page, limit);
    if (kDebugMode) {
      debugPrint('Response: $response');
    }
    UserModel userModel = UserModel.fromJson(response);
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    if (page == 0) {
      userProvider.setUser(userModel);
    } else {
      userProvider.addUsers(userModel.data ?? []);
    }

    currentPage = page;
  } catch (e) {
    Exception('Failed to ');
    // showSnackBar(context, e.toString());
  }
}
