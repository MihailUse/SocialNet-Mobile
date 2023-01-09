import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/post_card_widget/post_carousel_indicator_widget.dart';
import 'package:social_net/ui/widgets/common/select_file_alert_dialog.dart';
import 'package:social_net/ui/widgets/tab_home/create_post_widget/create_post_view_model.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreatePostViewModel>();
    final post = context.select((CreatePostViewModel value) => value.state);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              key: viewModel.formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: viewModel.postTextController,
                    decoration: const InputDecoration(
                      hintText: "Enter post text",
                      labelText: "post text",
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text(
                      "Post can be commented",
                      textAlign: TextAlign.start,
                    ),
                    value: post.isCommentable,
                    onChanged: viewModel.isCommentableChenged,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) => SelectFileAlertDialog(
                        onTakeImageButtonPressed: viewModel.onTakeImageButtonPressed,
                        onSelectImageButtonPressed: viewModel.onSelectImageButtonPressed,
                      ),
                    ),
                    child: const Text("add image"),
                  ),
                  const SizedBox(height: 20),
                  if (post.attaches!.isNotEmpty) const ImageCarouselWidget(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: viewModel.onCreateButtonPressed,
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<CreatePostViewModel>(
        lazy: false,
        create: (context) => CreatePostViewModel(context),
        child: const CreatePostWidget(),
      );
}

class ImageCarouselWidget extends StatelessWidget {
  const ImageCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewModel = context.watch<CreatePostViewModel>();

    return Container(
      color: Theme.of(context).shadowColor.withOpacity(0.2),
      height: size.width * 0.5,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: viewModel.onAttachIndexChenged,
            itemCount: viewModel.attaches.length,
            itemBuilder: (context, pageIndex) {
              return Image.file(viewModel.attaches[viewModel.currentAttachIndex]);
            },
          ),
          if (viewModel.attaches.length > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: PostCarouselIndicatorWidget(
                count: viewModel.attaches.length,
                currentIndex: viewModel.currentAttachIndex,
              ),
            ),
        ],
      ),
    );
  }
}
