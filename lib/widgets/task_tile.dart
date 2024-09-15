import 'package:flutter/material.dart';
import '../models/task.dart';
import '../pages/task_details_page.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onCompleted;
  final VoidCallback onEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  TaskTile({
    required this.task,
    required this.onCompleted,
    required this.onEdit,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.redAccent;
        break;
      case 'Moderate':
        priorityColor = Colors.orangeAccent;
        break;
      case 'Low':
        priorityColor = Colors.greenAccent;
        break;
      default:
        priorityColor = Colors.blueAccent;
    }

    return ListTile(
      tileColor: priorityColor.withOpacity(0.1),
      title: Row(
        children: [
          Expanded(child: Text(task.title)),
          if (task.isCompleted)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(color: Colors.white),
              ),
            )
        ],
      ),
      subtitle: Text('${task.description} - Priority: ${task.priority}'),
      trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert),
        onSelected: (String value) {
          switch (value) {
            case 'Complete':
              onCompleted();
              break;
            case 'Unmark':
              onCompleted();
              break;
            case 'Edit':
              onEdit();
              break;
            case 'Delete':
              onDelete();
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            task.isCompleted ? 'Unmark' : 'Complete',
            'Edit',
            'Delete',
          ].map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(task: task),
          ),
        );
      },
    );
  }
}
