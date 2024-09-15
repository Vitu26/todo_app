import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  void _showErrorDialog(String errorMessage) {
    if (_context != null) {
      showDialog(
        context: _context!,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void loadTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? taskData = prefs.getString('tasks');
      if (taskData != null) {
        List<dynamic> decodedTasks = jsonDecode(taskData);
        _tasks = decodedTasks.map((task) => Task.fromJson(task)).toList();
        notifyListeners();
      }
    } catch (error) {
      _showErrorDialog('Error loading tasks.');
      print('Error loading tasks: $error');
    }
  }

  void saveTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> taskList =
          _tasks.map((task) => task.toJson()).toList();
      await prefs.setString('tasks', jsonEncode(taskList));
    } catch (error) {
      _showErrorDialog('Error saving tasks.');
      print('Error saving tasks: $error');
    }
  }

  void addTask(Task task) {
    try {
      _tasks.add(task);
      saveTasks();
      notifyListeners();
    } catch (error) {
      _showErrorDialog('Error adding task.');
      print('Error adding task: $error');
    }
  }

  void updateTask(int index, Task task) {
    try {
      _tasks[index] = task;
      saveTasks();
      notifyListeners();
    } catch (error) {
      _showErrorDialog('Error updating task.');
      print('Error updating task: $error');
    }
  }

  void completeTaskById(String taskId) {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].isCompleted = true;
        saveTasks();
        notifyListeners();
      } else {
        _showErrorDialog('Task not found.');
      }
    } catch (error) {
      _showErrorDialog('Error completing the task.');
      print('Error completing task: $error');
    }
  }

  void deleteTaskById(String taskId) {
    try {
      _tasks.removeWhere((task) => task.id == taskId);
      saveTasks();
      notifyListeners();
    } catch (error) {
      _showErrorDialog('Error deleting task.');
      print('Error deleting task: $error');
    }
  }

  List<Task> filterTasks(String filterType) {
    try {
      if (filterType == 'All') {
        return _tasks;
      } else if (filterType == 'Completed') {
        return _tasks.where((task) => task.isCompleted).toList();
      }
      return _tasks;
    } catch (error) {
      _showErrorDialog('Error filtering tasks.');
      print('Error filtering tasks: $error');
      return [];
    }
  }

  List<Task> filterByDate(DateTime selectedDate) {
    try {
      return _tasks.where((task) {
        return task.date.year == selectedDate.year &&
            task.date.month == selectedDate.month &&
            task.date.day == selectedDate.day;
      }).toList();
    } catch (error) {
      _showErrorDialog('Error filtering tasks by date.');
      print('Error filtering tasks by date: $error');
      return [];
    }
  }

  List<Task> filterByToday() {
    try {
      DateTime today = DateTime.now();
      return _tasks.where((task) {
        return task.date.year == today.year &&
            task.date.month == today.month &&
            task.date.day == today.day;
      }).toList();
    } catch (error) {
      _showErrorDialog('Error filtering today\'s tasks.');
      print('Error filtering today\'s tasks: $error');
      return [];
    }
  }

  List<Task> filterByPriority(String filterPriority) {
    try {
      return _tasks.where((task) => task.priority == filterPriority).toList();
    } catch (error) {
      _showErrorDialog('Error filtering tasks by priority.');
      print('Error filtering tasks by priority: $error');
      return [];
    }
  }
}
