import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../view_models/user_events_view_model.dart';
import '../settings/settings_view.dart';

class QueryWidget extends StatefulWidget {
  final UserEventsViewModel viewModel;

  const QueryWidget({super.key, required this.viewModel});

  @override
  State<QueryWidget> createState() => _QueryWidgetState();
}

class _QueryWidgetState extends State<QueryWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Observer(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 240,
                child: CheckboxListTile(
                  title: const Text('Show NQL Query'),
                  value: viewModel.isShowQuery,
                  onChanged: (value) => viewModel.isShowQuery = value!,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: viewModel.nrquery));
                  },
                  icon: const Icon(Icons.copy)),
              const Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () async {
                    await showSettingsDialog(context);
                  },
                  icon: const Icon(Icons.settings)),
            ],
          ),
          Visibility(
            visible: viewModel.isShowQuery,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText.rich(
                TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(color: Colors.blueAccent),
                  text: viewModel.nrquery,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
