import 'package:flutter/material.dart';
import 'package:user_search/models/user.dart';

class UserNotifier extends ChangeNotifier {
  List<User> allusers = [];
  List<User> filteredUsers = [];
  String? selectedCompany='All';
  String currentQuery = '';
  bool showClearButton = false;

  void setUsers(List<User> users) {
   allusers = users;
    applyFilterAndSort();
  }

  void updateSearchQuery(String query) {
    currentQuery = query;
     showClearButton = query.isNotEmpty;
    applyFilterAndSort();
  }

  void updateCompanyFilter(String company) {
    selectedCompany = company;
   
    
    applyFilterAndSort();
  }

  void applyFilterAndSort() {
    filteredUsers =
        allusers.where((u) {
          final query = currentQuery.toLowerCase();
          final matchesSearch =
              u.name.toLowerCase().contains(query) ||
              u.email.toLowerCase().contains(query);

          final matchesCompany =
              selectedCompany == 'All' || u.comp.name == selectedCompany;

          return matchesSearch && matchesCompany;
        }).toList();

    filteredUsers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    notifyListeners();
  }

 
}
