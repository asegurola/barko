// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_events_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserEventsViewModel on _UserEventsViewModel, Store {
  Computed<String>? _$nrqueryComputed;

  @override
  String get nrquery =>
      (_$nrqueryComputed ??= Computed<String>(() => super.nrquery,
              name: '_UserEventsViewModel.nrquery'))
          .value;

  late final _$isShowQueryAtom =
      Atom(name: '_UserEventsViewModel.isShowQuery', context: context);

  @override
  bool get isShowQuery {
    _$isShowQueryAtom.reportRead();
    return super.isShowQuery;
  }

  @override
  set isShowQuery(bool value) {
    _$isShowQueryAtom.reportWrite(value, super.isShowQuery, () {
      super.isShowQuery = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_UserEventsViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$fetchUserEventsAsyncAction =
      AsyncAction('_UserEventsViewModel.fetchUserEvents', context: context);

  @override
  Future<void> fetchUserEvents() {
    return _$fetchUserEventsAsyncAction.run(() => super.fetchUserEvents());
  }

  late final _$onDragAndDropAsyncAction =
      AsyncAction('_UserEventsViewModel.onDragAndDrop', context: context);

  @override
  Future<void> onDragAndDrop(DropDoneDetails dropDetails) {
    return _$onDragAndDropAsyncAction
        .run(() => super.onDragAndDrop(dropDetails));
  }

  late final _$_UserEventsViewModelActionController =
      ActionController(name: '_UserEventsViewModel', context: context);

  @override
  void doFilteringAndSearch() {
    final _$actionInfo = _$_UserEventsViewModelActionController.startAction(
        name: '_UserEventsViewModel.doFilteringAndSearch');
    try {
      return super.doFilteringAndSearch();
    } finally {
      _$_UserEventsViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isShowQuery: ${isShowQuery},
nrquery: ${nrquery}
    ''';
  }
}
