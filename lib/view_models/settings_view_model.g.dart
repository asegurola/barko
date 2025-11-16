// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsViewModel on _SettingsViewModel, Store {
  late final _$apiKeyAtom =
      Atom(name: '_SettingsViewModel.apiKey', context: context);

  @override
  String get apiKey {
    _$apiKeyAtom.reportRead();
    return super.apiKey;
  }

  @override
  set apiKey(String value) {
    _$apiKeyAtom.reportWrite(value, super.apiKey, () {
      super.apiKey = value;
    });
  }

  late final _$accountIdAtom =
      Atom(name: '_SettingsViewModel.accountId', context: context);

  @override
  String get accountId {
    _$accountIdAtom.reportRead();
    return super.accountId;
  }

  @override
  set accountId(String value) {
    _$accountIdAtom.reportWrite(value, super.accountId, () {
      super.accountId = value;
    });
  }

  late final _$extraTablesAtom =
      Atom(name: '_SettingsViewModel.extraTables', context: context);

  @override
  String get extraTables {
    _$extraTablesAtom.reportRead();
    return super.extraTables;
  }

  @override
  set extraTables(String value) {
    _$extraTablesAtom.reportWrite(value, super.extraTables, () {
      super.extraTables = value;
    });
  }

  late final _$extraFieldsAtom =
      Atom(name: '_SettingsViewModel.extraFields', context: context);

  @override
  String get extraFields {
    _$extraFieldsAtom.reportRead();
    return super.extraFields;
  }

  @override
  set extraFields(String value) {
    _$extraFieldsAtom.reportWrite(value, super.extraFields, () {
      super.extraFields = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_SettingsViewModel.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  @override
  String toString() {
    return '''
apiKey: ${apiKey},
accountId: ${accountId},
extraTables: ${extraTables},
extraFields: ${extraFields}
    ''';
  }
}
