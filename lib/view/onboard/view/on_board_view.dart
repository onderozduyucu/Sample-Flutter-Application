import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermvvmtemplate/core/base/view/base_widget.dart';
import 'package:fluttermvvmtemplate/core/components/text/auto_locale_text.dart';
import 'package:fluttermvvmtemplate/core/extension/context_extension.dart';
import 'package:fluttermvvmtemplate/view/_product/_widgets/avatar/on_board_circle.dart';
import 'package:fluttermvvmtemplate/view/onboard/model/on_board_model.dart';
import 'package:fluttermvvmtemplate/view/onboard/viewModel/on_board_view_model.dart';

@RoutePage()
class OnBoardView extends StatelessWidget {
  const OnBoardView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseView<OnBoardViewModel>(
      viewModel: OnBoardViewModel(),
      onModelReady: (model) {
        model
          ..setContext(context)
          ..init();
      },
      onPageBuilder: (BuildContext context, OnBoardViewModel viewModel) => Scaffold(
        body: Padding(
          padding: context.paddingNormalHorizontal,
          child: Column(
            children: [
              const Spacer(),
              Expanded(flex: 5, child: buildPageView(viewModel)),
              Expanded(flex: 2, child: buildRowFooter(viewModel, context)),
            ],
          ),
        ),
      ),
    );
  }

  PageView buildPageView(OnBoardViewModel viewModel) {
    return PageView.builder(
      itemCount: viewModel.onBoardItems.length,
      onPageChanged: (value) {
        viewModel.changeCurrentIndex(value);
      },
      itemBuilder: (context, index) => buildColumnBody(context, viewModel.onBoardItems[index]),
    );
  }

  Row buildRowFooter(OnBoardViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildListViewCircles(viewModel),
        Expanded(
          child: Center(
            child: Observer(
              builder: (_) {
                return Visibility(
                  visible: viewModel.isLoading,
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        buildFloatingActionButtonSkip(context, viewModel),
      ],
    );
  }

  ListView buildListViewCircles(OnBoardViewModel viewModel) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Observer(
          builder: (_) {
            return OnBoardCircle(
              isSelected: viewModel.currentIndex == index,
            );
          },
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButtonSkip(
    BuildContext context,
    OnBoardViewModel viewModel,
  ) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.outline,
      child: Icon(
        Icons.keyboard_arrow_right,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      onPressed: () {
        viewModel.completeToOnBoard();
      },
    );
  }

  Column buildColumnBody(BuildContext context, OnBoardModel model) {
    return Column(
      children: [
        Expanded(flex: 5, child: buildSvgPicture(model.imagePath)),
        buildColumnDescription(context, model),
      ],
    );
  }

  Column buildColumnDescription(BuildContext context, OnBoardModel model) {
    return Column(
      children: [
        buildAutoLocaleTextTitle(model, context),
        Padding(
          padding: context.paddingMediumHorizontal,
          child: buildAutoLocaleTextDescription(model, context),
        ),
      ],
    );
  }

  AutoLocaleText buildAutoLocaleTextTitle(
    OnBoardModel model,
    BuildContext context,
  ) {
    return AutoLocaleText(
      value: model.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
    );
  }

  AutoLocaleText buildAutoLocaleTextDescription(
    OnBoardModel model,
    BuildContext context,
  ) {
    return AutoLocaleText(
      value: model.description,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
    );
  }

  SvgPicture buildSvgPicture(String path) => SvgPicture.asset("module/gen/${path}");
}
