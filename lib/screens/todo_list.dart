import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = false;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map;
            final id = item['_id'];
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(onSelected: (value) {
                if (value == 'edit') {
                } else if (value == 'delete') {
                  print('deleted');
                  deleteById(id);
                }
              }, itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                      child: Text(
                    'edit',
                  )),
                  PopupMenuItem(child: Text('delete'))
                ];
              }),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add Button')),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(builder: (context) => const AddTodo());
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //remove the content;
      print(response.body);
    } else {
      //not deleted
      print(response.body);
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading:
      true;
    });

    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      //Show error
    }
    setState(() {
      isLoading:
      false;
    });
  }
}
