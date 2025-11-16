import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../models/generic_event_entry.dart';
import '../../models/rich_event_entry.dart';
import '../../view_models/search_view_model.dart';
import '../../view_models/settings_view_model.dart';
import '../../view_models/view_model_locator.dart';
import 'event_field_widget.dart';

class EventEntryWidget extends StatelessWidget {
  final RichEventEntry richEventEntry;
  final Color color;

  SearchViewModel get searchViewModel => viewModelLocator<SearchViewModel>();

  SettingsViewModel get settingsViewModel =>
      viewModelLocator<SettingsViewModel>();

  Iterable<String> get nonEmptyFields =>
      (richEventEntry.entry.fieldsForType + settingsViewModel.extraFieldList)
          .where((element) => richEventEntry.entry.fields[element] != null);

  const EventEntryWidget({
    super.key,
    required this.richEventEntry,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final eventEntry = richEventEntry.entry;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: DefaultTextStyle(
          style: TextStyle(color: color),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Wrap(
              children: [
                if (searchViewModel.showTimestamp)
                  MainField(
                      minWidth: 200,
                      text: eventEntry.timestamp.toIso8601String(),
                      color: color),
                if (searchViewModel.showAppName)
                  MainField(
                      minWidth: 160, text: eventEntry.appName, color: color),
                if (searchViewModel.showUserId)
                  MainField(
                      minWidth: 60,
                      text: eventEntry.userId ?? 'null',
                      color: color),
                if (searchViewModel.showDeviceUuid)
                  MainField(
                      minWidth: 60,
                      text: eventEntry.deviceUuid ?? 'null',
                      color: color),
                if (searchViewModel.showAppVersion)
                  MainField(
                      minWidth: 60, text: eventEntry.appVersion, color: color),
                if (searchViewModel.showAppBuild)
                  MainField(
                      minWidth: 60, text: eventEntry.appBuild, color: color),
                Tooltip(
                  message: eventEntry.entryType.name,
                  child: SizedBox.square(
                    dimension: 24.0,
                    child: Icon(
                      color: color,
                      semanticLabel: eventEntry.entryType.name,
                      _getIconForType(eventEntry.entryType),
                    ),
                  ),
                ),
                for (final fieldName in nonEmptyFields)
                  EventFieldWidget(
                    fieldName: fieldName,
                    fieldValue: eventEntry.fields[fieldName],
                    searchMatch: richEventEntry.searchMatch,
                    color: color,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  IconData? _getIconForType(EntryType entryType) {
    switch (entryType) {
      case EntryType.request:
        return Icons.sync_alt;
      case EntryType.requestError:
        return Icons.sync_problem;
      case EntryType.handledException:
        return Icons.warning;
      case EntryType.breadcrumb:
        return Icons.preview;
      case EntryType.crash:
        return Icons.error;
      case EntryType.customEvent:
        return Icons.lightbulb;
      case EntryType.networkEvent:
        return Icons.sync_disabled;
      case EntryType.other:
        return Icons.info;
    }
  }

  List<TextSpan> createSpanParts(
      BuildContext context, String text, Iterable<RegExpMatch>? matches) {
    final spans = <TextSpan>[];
    if (matches == null) {
      spans.add(TextSpan(text: text));
      return spans;
    }

    var offset = 0;
    for (final match in matches) {
      if (match.start > offset) {
        spans.add(TextSpan(text: text.substring(offset, match.start)));
      }
      spans.add(TextSpan(
          text: text.substring(match.start, match.end),
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(backgroundColor: Colors.amber)));
      offset = match.end;
    }

    if (offset < text.length) {
      spans.add(TextSpan(text: text.substring(offset, text.length)));
    }
    return spans;
  }
}

class MainField extends StatelessWidget {
  final double minWidth;
  final Color color;
  final String text;

  const MainField(
      {super.key,
      required this.minWidth,
      this.color = Colors.black87,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SelectableText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(color: color),
              text: text,
            ),
          )),
    );
  }
}
