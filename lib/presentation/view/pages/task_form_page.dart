import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasks_riverpod/shared/responsive.dart';
import 'dart:async';
import '../../../domain/model/task.dart';
import '../../viewmodel/taskform/task_form_viewmodel.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  final Task? _task;

  const TaskFormPage(this._task);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  late final TaskFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _dueDateFormFocusNode = _DisabledFocusNode();
  late TextEditingController _dueDateTextFieldController;
  var objectId = '';

  _TaskFormPageState();

  @override
  void initState() {
    super.initState();

    _viewModel = ref.read(taskFormViewModelProvider(widget._task));
    _dueDateTextFieldController = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(_viewModel.initialDueDateValue()),
    );
  }

  @override
  void dispose() {
    _dueDateFormFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_viewModel.appBarTitle()),
        actions: [
          if (_viewModel.shouldShowDeleteTaskIcon())
            _buildDeleteTaskIconWidget(),
        ],
      ),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 16),
      margin: !Responsive.isMobile(context)
          ? EdgeInsets.symmetric(horizontal: 500)
          : EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFormWidget(),
            _buildSaveButtonWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButtonWidget() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          saveTodo(_viewModel);
          final currentState = _formKey.currentState;
          if (currentState != null && currentState.validate()) {
            _viewModel.createOrUpdateTask();
            Navigator.pop(context);
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  Widget _buildFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTitleFormWidget(),
          const SizedBox(height: 16),
          _buildDescriptionFormWidget(),
          const SizedBox(height: 16),
          _buildDueDateFormWidget()
        ],
      ),
    );
  }

  Widget _buildTitleFormWidget() {
    return TextFormField(
      initialValue: _viewModel.initialTitleValue(),
      maxLength: 20,
      onChanged: (value) => _viewModel.setTitle(value),
      validator: (_) => _viewModel.validateTitle(),
      decoration: const InputDecoration(
        icon: Icon(Icons.edit),
        labelText: 'Title',
        helperText: 'Required',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionFormWidget() {
    return TextFormField(
      initialValue: _viewModel.initialDescriptionValue(),
      maxLength: 150,
      onChanged: (value) => _viewModel.setDescription(value),
      validator: (_) => _viewModel.validateDescription(),
      decoration: const InputDecoration(
        icon: Icon(Icons.view_headline),
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDueDateFormWidget() {
    return TextFormField(
      focusNode: _dueDateFormFocusNode,
      controller: _dueDateTextFieldController,
      maxLength: 50,
      onTap: () => _showDatePicker(context),
      onChanged: (value) => _viewModel.setTitle(value),
      validator: (_) => _viewModel.validateDescription(),
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_today_rounded),
        labelText: 'DueDate',
        helperText: 'Required',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDeleteTaskIconWidget() {
    return IconButton(
      onPressed: () => _showConfirmDeleteTodoDialog(),
      icon: const Icon(Icons.delete),
    );
  }

  Future<DateTime?> _showDatePicker(final BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _viewModel.initialDueDateValue(),
      firstDate: _viewModel.datePickerFirstDate(),
      lastDate: _viewModel.datePickerLastDate(),
    );
    if (selectedDate != null) {
      _dueDateTextFieldController.text =
          DateFormat('yyyy/MM/dd').format(selectedDate);
      _viewModel.setDueDate(selectedDate);
    }

    return null;
  }

  Future<void> saveTodo(TaskFormViewModel _viewModel) async {
    if (_viewModel.isNewTask()) {
      final todo = ParseObject('FlutterDatabase')
        ..set('title', _viewModel.getTitle())
        ..set('isCompleted', _viewModel.getTodoStatus())
        ..set('Description', _viewModel.getDescription())
        ..set('DueDate', _viewModel.getDueDate());
      final ParseResponse response = await todo.save();
      if (response.success && response.result != null) {
        objectId = response.result.objectId;
      }
    } else {
      final query = QueryBuilder<ParseObject>(ParseObject("FlutterDatabase"));
      query.whereEqualTo(
          "title", _viewModel.getTitle()); // Condition to find objects
      final response = await query.query();
      if (response.success && response.result != null) {
        final List<ParseObject> objects = response.result;

        for (final object in objects) {
          object
            ..set('title', _viewModel.getTitle())
            ..set('isCompleted', _viewModel.getTodoStatus())
            ..set('Description', _viewModel.getDescription())
            ..set('DueDate', _viewModel.getDueDate()); // Updating a field
          await object.update(); // Save changes
        }
      }
    }
    getTodo();
  }

  Future<List<ParseObject>> getTodo() async {
    final query = QueryBuilder<ParseObject>(ParseObject('FlutterDatabase'));
    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      return response.result as List<ParseObject>;
    }
    return [];
  }

  Future<void> updateTodo(String id, bool done) async {
    await Future.delayed(Duration(seconds: 1), () {});
  }

  Future<void> deleteTodo(TaskFormViewModel _viewModel) async {
    final query = QueryBuilder<ParseObject>(ParseObject('FlutterDatabase'));
    query.whereEqualTo('title', _viewModel.getTitle());
    final ParseResponse response = await query.query();

    if (response.success && response.result != null) {
      final List<ParseObject> objects = response.result;

      for (final object in objects) {
        await object.delete();
      }
    }
  }

  _showConfirmDeleteTodoDialog() async {
    final bool result = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: const Text('Delete Task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
    if (result) {
      _viewModel.deleteTask();
      deleteTodo(_viewModel);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _DisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
