import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/widgets/custom_appbar.dart';
import 'package:todo_app/widgets/custom_buton.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_dropdown.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskFormPage({this.task, this.index});

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  DateTime? _selectedDate;
  String _selectedPriority = 'Moderate';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _selectedDate = widget.task!.date;
      _selectedPriority = widget.task!.priority;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Task task = Task(
        title: _title!,
        description: _description!,
        isCompleted: widget.task?.isCompleted ?? false,
        date: _selectedDate ?? DateTime.now(),
        priority: _selectedPriority,
      );

      if (widget.task == null) {
        Provider.of<TaskProvider>(context, listen: false).addTask(task);
      } else {
        Provider.of<TaskProvider>(context, listen: false)
            .updateTask(widget.index!, task);
      }

      _showSuccessDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: AlertDialog(
            title: const Text('Success'),
            content: const Text('Task saved successfully!'),
            actions: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.blue.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop(); // Close both dialogs and page
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.task == null ? 'Add Task' : 'Edit Task',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title:',
                style: TextStyle(fontSize: 16),
              ),
              CustomTextField(
                initialValue: _title,
                onSaved: (value) {
                  _title = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Date:',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                key: Key('selectDateField'),
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: _selectedDate == null
                      ? 'Select a date'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDropdown(
                label: 'Priority',
                value: _selectedPriority,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 16),
              ),
              CustomTextField(
                initialValue: _description,
                maxLines: 5,
                onSaved: (value) {
                  _description = value;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, right: 10, left: 10),
        child: CustomButton(
          key: const Key('saveTaskButton'),
          isLoading: _isLoading,
          onPressed: _saveTask,
        ),
      ),
    );
  }
}
