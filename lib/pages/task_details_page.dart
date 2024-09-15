import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_appbar.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  TaskDetailsPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Task Details',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),


            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(task.date)}',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 15),


            Row(
              children: [
                Icon(Icons.flag, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Prioridade: ${task.priority}',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 15),


            Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              task.description.isNotEmpty
                  ? task.description
                  : 'Nenhuma descrição disponível.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),


            if (!task.isCompleted)
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Marcar como Concluída',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {

                    Provider.of<TaskProvider>(context, listen: false)
                        .completeTaskById(task.id);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
