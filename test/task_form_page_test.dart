import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/task_form_page.dart';
import 'package:todo_app/providers/task_provider.dart';

void main() {
  testWidgets('Deve exibir o formulário e salvar a tarefa corretamente', (WidgetTester tester) async {

    final taskProvider = TaskProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: MaterialApp(
          home: Scaffold(
            body: TaskFormPage(),
          ),
        ),
      ),
    );


    expect(find.byType(TextFormField), findsNWidgets(3)); // Título, Descrição e Data


    await tester.enterText(find.byType(TextFormField).first, 'Nova Tarefa');
    await tester.enterText(find.byType(TextFormField).last, 'Descrição da nova tarefa');


    await tester.tap(find.text('Salvar Tarefa'));
    

    await tester.pumpAndSettle();


    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks.first.title, 'Nova Tarefa');
    expect(taskProvider.tasks.first.description, 'Descrição da nova tarefa');
  });
}
