import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../view_models/base_view_model.dart';
import 'screen_init_error.dart';

class ViewModelContainer extends StatefulWidget {
  final BaseViewModel viewModel;
  final Widget child;
  final bool autoRunInit;
  final VoidCallback? afterInit;

  const ViewModelContainer({
    super.key,
    required this.viewModel,
    required this.child,
    this.autoRunInit = true,
    this.afterInit,
  });

  @override
  State<ViewModelContainer> createState() => _ViewModelContainerState();
}

class _ViewModelContainerState extends State<ViewModelContainer> {
  @override
  void initState() {
    super.initState();
    if (widget.autoRunInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.viewModel.runInit();
        widget.afterInit?.call();
      });
    }
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  void closeKeyboard(BuildContext context) => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: Observer(builder: (context) {
        return Stack(children: [
          if (!viewModel.initFailed) widget.child,
          if (viewModel.initFailed)
            ScreenInitError(
              customErrorMessage: viewModel.customInitErrorMessage,
              allowRetry: viewModel.allowInitRetry,
              onTryAgain: viewModel.runInit,
              onExitApp: viewModel.onExitApp,
            ),
          if (viewModel.isLoading)
            Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ]);
      }),
    );
  }
}
