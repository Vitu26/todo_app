import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/task_form_page.dart';
import 'package:todo_app/providers/task_provider.dart';

void main() {
  group('TaskFormPage', () {
    late TaskProvider taskProvider;

    setUp(() {
      taskProvider = TaskProvider();
    });

    Widget createTestWidget({Task? task, int? index}) {
      return ChangeNotifierProvider<TaskProvider>.value(
        value: taskProvider,
        child: MaterialApp(
          home: TaskFormPage(task: task, index: index),
        ),
      );
    }

    testWidgets('Deve exibir o formulário para adicionar uma tarefa', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());


      expect(find.text('Title:'), findsOneWidget);
      expect(find.text('Date:'), findsOneWidget);
      expect(find.text('Priority'), findsOneWidget);
      expect(find.text('Description:'), findsOneWidget);
    });

    testWidgets('Deve validar campos obrigatórios no formulário', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());


      await tester.tap(find.byKey(Key('saveTaskButton')));
      await tester.pumpAndSettle();


      expect(find.text('Please enter a title'), findsOneWidget);
      expect(find.text('Please select a date'), findsOneWidget);
    });

    testWidgets('Deve permitir a seleção de uma data', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());


      await tester.tap(find.byKey(Key('selectDateField')));
      await tester.pumpAndSettle();


      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();


      expect(find.text('15/09/2024'), findsOneWidget); 
    });

  });
}
