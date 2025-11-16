import 'package:flutter/material.dart';

import '../../view_models/settings_view_model.dart';
import '../../view_models/view_model_locator.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/view_model_container.dart';


const textFieldWidthS = 100.0;
const textFieldWidthM = 400.0;
const textFieldWidthL = 600.0;

Future<void> showSettingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Settings'),
        content: const SettingsView(),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsViewModel get _viewModel => viewModelLocator<SettingsViewModel>();

  final _apiKeyController = TextEditingController();
  final _accountIdController = TextEditingController();
  final _extraTablesController = TextEditingController();
  final _extraFieldsController = TextEditingController();

  void _loadValues() {
    _apiKeyController.text = _viewModel.apiKey;
    _accountIdController.text = _viewModel.accountId;
    _extraTablesController.text = _viewModel.extraTables;
    _extraFieldsController.text = _viewModel.extraFields;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelContainer(
      viewModel: _viewModel,
      afterInit: _loadValues,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          WrapFieldWidget(
            width: textFieldWidthL,
            child: CustomTextFormField.text(
              controller: _apiKeyController,
              label: 'Newrelic API key',
              obscureText: true,
              onChanged: (value) => _viewModel.apiKey = value,
            ),
          ),
          WrapFieldWidget(
            width: textFieldWidthL,
            child: CustomTextFormField.text(
              controller: _accountIdController,
              label: 'Account id',
              onChanged: (value) => _viewModel.accountId = value,
            ),
          ),
          WrapFieldWidget(
            width: textFieldWidthL,
            child: CustomTextFormField.text(
              controller: _extraTablesController,
              label: 'Extra Tables',
              onChanged: (value) => _viewModel.extraTables = value,
            ),
          ),
          WrapFieldWidget(
            width: textFieldWidthL,
            child: CustomTextFormField.text(
              controller: _extraFieldsController,
              label: 'Extra Fields',
              onChanged: (value) => _viewModel.extraFields = value,
            ),
          ),
        ],
      ),
    );
  }
}

class WrapFieldWidget extends StatelessWidget {
  final double? width;
  final Widget child;

  const WrapFieldWidget({super.key, this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    if (width != null) {
      return Container(
        width: width,
        padding: const EdgeInsets.all(4.0),
        child: child,
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }
}

class WrapCheckbox extends StatelessWidget {
  final CheckboxListTile child;

  const WrapCheckbox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: child,
    );
  }
}
