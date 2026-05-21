import 'package:flutter/material.dart';
import 'package:user_search/models/user.dart';
import 'package:user_search/serivices/apiservice.dart';
import 'package:user_search/utilities/notifier.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final UserNotifier _userNotifier = UserNotifier();
  late Future<List<User>> users;

  TextEditingController keyword = TextEditingController();
  

  @override
  void initState() {
    super.initState();

    users = Apiservice().fetch().then((data) {
      _userNotifier.setUsers(data);
      return data;
    });

    keyword.addListener(() {
      _userNotifier.updateSearchQuery(keyword.text);
   
    });
  }


//testing

  @override
  void dispose() {
    _userNotifier.dispose();
    keyword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          'User List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _userNotifier,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: keyword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      hintText: 'Search  by name or email',
                      fillColor: Colors.white,
                      filled: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      suffixIcon:
                          _userNotifier.showClearButton
                              ? IconButton(
                                onPressed: () {
                                  keyword.clear();
                                },
                                icon: Icon(Icons.cancel, color: Colors.black),
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                FutureBuilder<List<User>>(
                  future: users,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }

                    final companies =
                        snapshot.data!.map((u) => u.comp.name).toSet().toList();

                    companies.sort();
                    companies.insert(0, 'All');

                    return Row(
                      children: [
                        Spacer(),
                        PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _userNotifier.selectedCompany ?? 'All',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          tooltip: 'Filter by company',
                          onSelected: (String company) {
                            _userNotifier.updateCompanyFilter(company);
                          },
                          itemBuilder: (BuildContext context) {
                            return companies.map((String company) {
                              final isSelected =
                                  (_userNotifier.selectedCompany ?? 'All') ==
                                  company;

                              return PopupMenuItem<String>(
                                value: company,
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color:
                                          isSelected
                                              ? Colors.green
                                              : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(company),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 50),

                Expanded(
                  child: FutureBuilder(
                    future: users,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('User not found'));
                      }

                      final filteredUsers = _userNotifier.filteredUsers;

                      if (filteredUsers.isEmpty) {
                        return Center(child: Text('No result found'));
                      }

                      return ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];

                          return SizedBox(
                            width: 300,
                            height: 100,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(
                                    user.comp.name,
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
