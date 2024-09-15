import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/widgets/custom_appbar.dart';
import 'package:todo_app/widgets/filter_options.dart';
import 'package:todo_app/widgets/task_list.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_form_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedPriorityTemp = 'All';
  String _selectedStatusTemp = 'All';
  String _selectedPriority = 'All';
  String _selectedStatus = 'All';

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'en_US').format(date);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false)
          .filterByDate(_selectedDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilterOptions(
          selectedPriorityTemp: _selectedPriorityTemp,
          selectedStatusTemp: _selectedStatusTemp,
          onPrioritySelected: (String priority) {
            setState(() {
              _selectedPriorityTemp = priority;
            });
          },
          onStatusSelected: (String status) {
            setState(() {
              _selectedStatusTemp = status;
            });
          },
          onOkPressed: () {
            setState(() {
              _selectedPriority = _selectedPriorityTemp;
              _selectedStatus = _selectedStatusTemp;
              Navigator.of(context).pop();
            });
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String taskId, TaskProvider taskProvider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                taskProvider.deleteTaskById(taskId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'To-do App',
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.filter),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _formatDate(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                List<Task> filteredTasks =
                    taskProvider.filterByDate(_selectedDate);

                if (_selectedPriority != 'All') {
                  filteredTasks = filteredTasks
                      .where((task) => task.priority == _selectedPriority)
                      .toList();
                }

                if (_selectedStatus == 'Completed') {
                  filteredTasks =
                      filteredTasks.where((task) => task.isCompleted).toList();
                }

                return filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks found for this date.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : TaskList(
                        tasks: filteredTasks,
                        onCompleted: (index) {
                          Task task = filteredTasks[index];
                          task.isCompleted = !task
                              .isCompleted;
                          taskProvider.updateTask(
                              index, task);
                        },
                        onEdit: (index) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TaskFormPage(
                                  task: taskProvider.tasks[index],
                                  index: index),
                            ),
                          );
                        },
                        onTap: (index) {},
                        onDelete: (index) {
                          _showDeleteConfirmationDialog(
                              context, filteredTasks[index].id, taskProvider);
                        },
                      );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TaskFormPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Add Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
