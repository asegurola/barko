import 'package:flutter/material.dart';

import '../../models/search_match.dart';

class EventFieldWidget extends StatelessWidget {
  final String fieldName;
  final dynamic fieldValue;
  final SearchMatch? searchMatch;
  final Color color;

  const EventFieldWidget({
    super.key,
    required this.fieldName,
    required this.fieldValue,
    required this.searchMatch,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fieldValueString = fieldValue.toString();
    final spanParts = _createSpanParts(
        context, fieldValueString, searchMatch?.matchesForField[fieldName]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Wrap(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                )),
            child: Text(
              fieldName,
              style: DefaultTextStyle.of(context).style.copyWith(color: color),
            ),
          ),
          SelectableText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(color: color),
              children: spanParts,
            ),
          )
        ],
      ),
    );
  }

  List<TextSpan> _createSpanParts(
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
