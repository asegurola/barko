import 'generic_event_entry.dart';
import 'search_match.dart';

class RichEventEntry {
  final GenericEventEntry entry;
  final SearchMatch? searchMatch;

  const RichEventEntry({required this.entry, required this.searchMatch});
}
