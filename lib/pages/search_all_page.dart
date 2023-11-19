import 'dart:convert';
import 'dart:io';

import 'package:csci361_vms_frontend/models/user.dart';
import 'package:csci361_vms_frontend/pages/user_details_page.dart';
import 'package:csci361_vms_frontend/providers/jwt_token_provider.dart';
import 'package:csci361_vms_frontend/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SearchAllPage extends ConsumerStatefulWidget {
  const SearchAllPage({super.key});

  @override
  ConsumerState<SearchAllPage> createState() {
    return _SearchAllPageState();
  }
}

class _SearchAllPageState extends ConsumerState<SearchAllPage> {
  final formKey = GlobalKey<FormState>();
  final searchResults = [];
  String enteredName = '';
  String selectedRole = '';
  int currentPage = 1;
  int perPage = 20;
  int totalPages = 0;

  void _loadResults() async {
    FocusManager.instance.primaryFocus?.unfocus();
    formKey.currentState!.save();
    currentPage = 1;
    final queryParams = {
      'name': enteredName,
      'page': currentPage.toString(),
      'per_page': perPage.toString(),
    };
    if (selectedRole != '') {
      queryParams['role'] = selectedRole;
    }
    final url = Uri.http('vms-api.madi-wka.xyz', '/user/search/', queryParams);
    final response = await http.get(url);
    var decodedResponse = json.decode(response.body);
    setState(() {
      searchResults.clear();
      searchResults.addAll(decodedResponse['users']);
      totalPages = decodedResponse['total_pages'];
    });
    return;
  }

  void _loadMoreResults() async {
    if (currentPage == totalPages) {
      return;
    }
    currentPage++;
    final queryParams = {
      'name': enteredName,
      'page': currentPage.toString(),
      'per_page': perPage.toString(),
    };

    if (selectedRole != '') {
      queryParams['role'] = selectedRole;
    }
    final url = Uri.http('vms-api.madi-wka.xyz', '/user/search/', queryParams);
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader:
          'Bearer ${ref.read(jwt.jwtTokenProvider)}',
    });
    var decodedResponse = json.decode(response.body);
    setState(() {
      searchResults.addAll(decodedResponse['users']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          maxLength: 100,
                          onSaved: (value) {
                            if (value == null || value.isEmpty) {
                              enteredName = '';
                            }
                            enteredName = value!;
                          },
                          decoration: const InputDecoration(
                            label: Text('Name'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField(
                          value: selectedRole,
                          items: [
                            const DropdownMenuItem(
                              value: '',
                              child: Text('All roles'),
                            ),
                            for (final role in allRoles)
                              DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _loadResults();
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter == 0) {
                  _loadMoreResults();
                }
                return false;
              },
              child: ListView.builder(
                itemCount:
                    (searchResults.isEmpty) ? 0 : searchResults.length + 1,
                itemBuilder: (context, index) {
                  if (index < searchResults.length) {
                    return ListTile(
                      leading: Text(searchResults[index]['Role']),
                      title: Text(
                          '${searchResults[index]['Name']} ${searchResults[index]['LastName']}, ${searchResults[index]['Email']}'),
                      trailing: IconButton(
                        onPressed: () {
                          print(searchResults[index]['id']);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return UserDetailsPage(
                                    userId: searchResults[index]['id']);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_outward),
                      ),
                    );
                  } else {
                    if (currentPage == totalPages) {
                      return const Text('You have reached the end.');
                    } else {
                      return const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
