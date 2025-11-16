import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../view_models/search_view_model.dart';
import '../../view_models/view_model_locator.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/view_model_container.dart';

const textfieldWidthM = 500.0;
const textfieldWidthS = 200.0;

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchViewModel get _viewModel => viewModelLocator<SearchViewModel>();

  final _userIdController = TextEditingController();
  final _deviceUuidController = TextEditingController();
  final _appBuildController = TextEditingController();
  final _daysController = TextEditingController();
  final _limitController = TextEditingController();
  final _filterController = TextEditingController();
  final _searchController = TextEditingController();

  List<ReactionDisposer> _disposers = [];

  final ScrollController _scrollController = ScrollController();

  ReactionDisposer textReaction(
    String Function() textValueGetter,
    TextEditingController controller,
  ) {
    return reaction((_) => textValueGetter(), (value) {
      controller.text = value;
      controller.selection = TextSelection.collapsed(offset: value.length);
    });
  }

  ReactionDisposer intReaction(
    int? Function() intValueGetter,
    TextEditingController controller,
  ) {
    return reaction((_) => intValueGetter(), (value) {
      final textValue = value?.toString() ?? '';
      controller.text = textValue;
      controller.selection = TextSelection.collapsed(offset: textValue.length);
    });
  }

  void _loadValues() {
    _userIdController.text = _viewModel.userId;
    _deviceUuidController.text = _viewModel.deviceUuid;
    _appBuildController.text = _viewModel.appBuild;
    _daysController.text = _viewModel.days.toString();
    _limitController.text = _viewModel.limit.toString();
    _filterController.text = _viewModel.filter;
    _searchController.text = _viewModel.search;

    _disposers = [
      textReaction(() => _viewModel.userId, _userIdController),
      textReaction(() => _viewModel.deviceUuid, _deviceUuidController),
      textReaction(() => _viewModel.appBuild, _appBuildController),
      intReaction(() => _viewModel.limit, _limitController),
      intReaction(() => _viewModel.days, _daysController),
      textReaction(() => _viewModel.search, _searchController),
      textReaction(() => _viewModel.filter, _filterController),
    ];
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelContainer(
      viewModel: _viewModel,
      afterInit: _loadValues,
      child: Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true, // only show when scrolling
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text('('),
                            WrapFieldWidget(
                              width: textfieldWidthM,
                              child: CustomTextFormField.text(
                                controller: _userIdController,
                                label: 'User id',
                                onChanged: (value) => _viewModel.userId = value,
                              ),
                            ),
                            const Text('or'),
                            WrapFieldWidget(
                              width: textfieldWidthM,
                              child: CustomTextFormField.text(
                                controller: _deviceUuidController,
                                label: 'Device uuid',
                                onChanged: (value) =>
                                    _viewModel.deviceUuid = value,
                              ),
                            ),
                            const Text(')'),
                            const Text(' and '),
                            WrapFieldWidget(
                              width: textfieldWidthM,
                              child: CustomTextFormField.text(
                                controller: _appBuildController,
                                label: 'App Build',
                                onChanged: (value) =>
                                    _viewModel.appBuild = value,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _viewModel.isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                              tooltip: 'Expand/Collapse search options',
                              onPressed: _viewModel.onToggleExpanded,
                            ),
                          ],
                        ),
                        if (_viewModel.isExpanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              WrapFieldWidget(
                                width: textfieldWidthS,
                                child: CustomTextFormField.number(
                                  controller: _daysController,
                                  label: 'days',
                                  errorText: _viewModel.daysError,
                                  onChanged: (value) =>
                                      _viewModel.daysAsString = value,
                                ),
                              ),
                              WrapFieldWidget(
                                width: textfieldWidthS,
                                child: CustomTextFormField.number(
                                  controller: _limitController,
                                  label: 'limit',
                                  errorText: _viewModel.limitError,
                                  onChanged: (value) =>
                                      _viewModel.limitAsString = value,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('Timestamp'),
                                  value: _viewModel.showTimestamp,
                                  onChanged: (value) =>
                                      _viewModel.showTimestamp = value ?? true,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('App Name'),
                                  value: _viewModel.showAppName,
                                  onChanged: (value) =>
                                      _viewModel.showAppName = value ?? true,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('UserId'),
                                  value: _viewModel.showUserId,
                                  onChanged: (value) =>
                                      _viewModel.showUserId = value ?? true,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('DeviceUuid'),
                                  value: _viewModel.showDeviceUuid,
                                  onChanged: (value) =>
                                      _viewModel.showDeviceUuid = value ?? true,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('App Version'),
                                  value: _viewModel.showAppVersion,
                                  onChanged: (value) =>
                                      _viewModel.showAppVersion =
                                          value ?? false,
                                ),
                              ),
                              WrapCheckbox(
                                child: CheckboxListTile(
                                  title: const Text('App Build'),
                                  value: _viewModel.showAppBuild,
                                  onChanged: (value) =>
                                      _viewModel.showAppBuild = value ?? false,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              if (_viewModel.isExpanded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WrapFieldWidget(
                      child: CustomTextFormField.text(
                        iconData: Icons.filter_alt_outlined,
                        controller: _filterController,
                        label: 'Filter',
                        onChanged: (value) => _viewModel.filter = value,
                      ),
                    ),
                    WrapFieldWidget(
                      child: CustomTextFormField.text(
                        iconData: Icons.search,
                        controller: _searchController,
                        label: 'Search',
                        onChanged: (value) => _viewModel.search = value,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
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
      child: Padding(padding: const EdgeInsets.all(4.0), child: child),
    );
  }
}

class WrapCheckbox extends StatelessWidget {
  final CheckboxListTile child;

  const WrapCheckbox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 170, child: child);
  }
}
