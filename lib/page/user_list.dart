import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart'


class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  String? errorMessage;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchUsers();
      }
    });
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users?page=$currentPage'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List newUsers = data['data'];

        if (newUsers.isEmpty) {
          hasMore = false;
        } else {
          users.addAll(newUsers.map((json) => User.fromJson(json)).toList());
          currentPage++;
        }
      } else {
        errorMessage = 'Failed to load users (Code ${response.statusCode})';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildUserCard(User user) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
      title: Text('${user.firstName} ${user.lastName}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReqRes Users')),
      body: Column(
        children: [
          if (errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.withOpacity(0.1),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: users.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < users.length) {
                  return buildUserCard(users[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
