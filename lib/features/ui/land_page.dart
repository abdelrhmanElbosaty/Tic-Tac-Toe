import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tak_toe/core/dimensions.dart';

import '../../core/app_colors.dart';
import '../../core/text_styles.dart';
import 'tasks_page/tasks_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _numberTextController = TextEditingController();
  final TextEditingController _sequenceTextController = TextEditingController();

  late ValueNotifier<bool> isBtnEnabledValueNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _numberTextController.dispose();
    _sequenceTextController.dispose();
    isBtnEnabledValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('Tic Tac Toe', style: TextStyles.bold())),
                const SizedBox(height: PaddingDimensions.large),
                _TextFieldWidget(
                  controller: _numberTextController,
                  maxLength: 4,
                  label: 'Number of tasks',
                  onChanged: (p0) => _isDataField,
                ),
                const SizedBox(height: PaddingDimensions.large),
                _TextFieldWidget(
                  controller: _sequenceTextController,
                  maxLength: 4,
                  label: 'Sequence of each task',
                  onChanged: (p0) => _isDataField,
                ),
                const SizedBox(height: PaddingDimensions.large),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: isBtnEnabledValueNotifier,
                        builder: (context, value, child) => MaterialButton(
                          onPressed: () {
                            _navigateToTaskPage();
                          },
                          height: 52,
                          color: value
                              ? AppColors.primaryColor
                              : Colors.grey.withOpacity(0.8),
                          child: Text(
                            'Go',
                            style: TextStyles.bold(color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTaskPage() {
    if (_numberTextController.text.isNotEmpty &&
        _sequenceTextController.text.isNotEmpty) {
      Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (ctx) {
            return TasksPage(
                numberOfTasks: int.parse(_numberTextController.text),
                tasksSequence: int.parse(_sequenceTextController.text));
          },
        ),
      );
    }
  }

  void get _isDataField {
    isBtnEnabledValueNotifier.value = (_numberTextController.text.isNotEmpty &&
        _sequenceTextController.text.isNotEmpty);
  }
}

class _TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final int? maxLength;
  final Function(String)? onChanged;

  const _TextFieldWidget({
    this.controller,
    this.label,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      // maxLength: maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1,
                style: BorderStyle.solid),
          ),
          border: const OutlineInputBorder(),
          label: Text(label ?? '')),
      onChanged: onChanged,
    );
  }
}
