import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodotate();
}

class _AddTodotate extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Ttile'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: submitData,
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      '_is_completed': false,
    };

    //Submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print(response.statusCode);

      showSuccessMessage('Succesfully sent!');
      titleController.text = '';
      descriptionController.text = '';
    } else {
      print('Creation failed');

      showErrorMessage('Not Successful!');
    }

    //show success or fail message based on status
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(244, 255, 36, 36),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
