import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../exceptions/needs_settings.dart';
import '../../models/generic_event_entry.dart';
import '../../models/rich_event_entry.dart';
import '../../theme/dimens.dart';
import '../../view_models/search_view_model.dart';
import '../../view_models/user_events_view_model.dart';
import '../../view_models/view_model_locator.dart';
import '../../widgets/view_model_container.dart';
import '../search/search_view.dart';
import '../settings/settings_view.dart';
import 'event_entry_widget.dart';
import 'query_widget.dart';

class MainAppView extends StatefulWidget {
  static const String routeName = 'search';

  final String? userId;
  final String? deviceUuid;
  final String? appBuild;
  final int? limit;
  final int? days;

  final String? filter;
  final String? search;

  const MainAppView({
    super.key,
    this.userId,
    this.deviceUuid,
    this.appBuild,
    this.limit,
    this.days,
    this.filter,
    this.search,
  });

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  final _viewModel = UserEventsViewModel();

  final _searchViewModel = viewModelLocator<SearchViewModel>();

  final scrollController = ScrollController();

  @override
  void initState() {
    _updateSearchViewMode();
    super.initState();
  }

  void _updateSearchViewMode() {
    if (widget.userId != null) {
      _searchViewModel.userId = widget.userId!;
    }
    if (widget.deviceUuid != null) {
      _searchViewModel.deviceUuid = widget.deviceUuid!;
    }
    if (widget.appBuild != null) {
      _searchViewModel.appBuild = widget.appBuild!;
    }
    if (widget.limit != null) {
      _searchViewModel.limit = widget.limit!;
    }
    if (widget.days != null) {
      _searchViewModel.days = widget.days!;
    }
    if (widget.filter != null) {
      _searchViewModel.filter = widget.filter!;
    }
    if (widget.search != null) {
      _searchViewModel.search = widget.search!;
    }
  }

  @override
  void didUpdateWidget(covariant MainAppView oldWidget) {
    _updateSearchViewMode();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _doSearch(BuildContext context) async {
    context.goNamed(
      'root',
      queryParameters: {
        'userId': _searchViewModel.userId,
        'deviceUuid': _searchViewModel.deviceUuid,
        'appBuild': _searchViewModel.appBuild,
        'limit': _searchViewModel.limit.toString(),
        'days': _searchViewModel.days.toString(),
        'filter': _searchViewModel.filter,
        'search': _searchViewModel.search,
      },
    );

    try {
      await _viewModel.fetchUserEvents();
      scrollController.jumpTo(0);
    } on NeedsSettings catch (_) {
      if (context.mounted) {
        unawaited(showSettingsDialog(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Material(
            elevation: spacingS,
            child: Padding(
              padding: const EdgeInsets.all(spacingM),
              child: Column(
                children: [
                  const SearchView(),
                  QueryWidget(viewModel: _viewModel),
                ],
              ),
            ),
          ),
          DropTarget(
            onDragDone: _viewModel.onDragAndDrop,
            child: Expanded(
              child: ViewModelContainer(
                viewModel: _viewModel,
                child: Observer(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _viewModel.filteredEvents.length,
                        itemBuilder: (context, index) {
                          final richEvent = _viewModel.filteredEvents[index];
                          return _buildEventWidget(richEvent);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _doSearch(context),
        tooltip: 'Go',
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildEventWidget(RichEventEntry richEventEntry) {
    final eventType = richEventEntry.entry.entryType;

    Color color;
    switch (eventType) {
      case EntryType.request:
        color = Colors.blue;
        break;
      case EntryType.requestError:
        color = Colors.orange;
        break;
      case EntryType.handledException:
        color = Colors.red;
        break;
      case EntryType.crash:
        color = Colors.red;
        break;
      case EntryType.breadcrumb:
        color = Colors.black;
        break;
      case EntryType.customEvent:
        color = Colors.black;
        break;
      case EntryType.other:
        color = Colors.black54;
        break;
      case EntryType.networkEvent:
        color = Colors.purple;
        break;
    }

    return EventEntryWidget(richEventEntry: richEventEntry, color: color);
  }
}
