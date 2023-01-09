import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/ui/navigation/nested_navigator_routes.dart';
import 'package:social_net/ui/widgets/common/comment_list_widget/comment_list_view_model.dart';

class CommentListWidget extends StatelessWidget {
  const CommentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CommentListViewModel>();

    return WillPopScope(
      onWillPop: () async {
        if (viewModel.showCreateComment) {
          viewModel.showCreateComment = false;
          return false;
        }

        return true;
      },
      child: Scaffold(
        floatingActionButton: viewModel.showCreateComment
            ? null
            : FloatingActionButton(
                onPressed: () => viewModel.showCreateComment = true,
                child: const Icon(Icons.add_comment_outlined),
              ),
        bottomNavigationBar: viewModel.showCreateComment ? const _CreateCommentTextFieldWidget() : null,
        body: RefreshIndicator(
          onRefresh: viewModel.asyncInit,
          child: CustomScrollView(
            controller: viewModel.scrollController,
            slivers: [
              const SliverAppBar(
                floating: true,
                title: Text("Post comments"),
              ),
              if (viewModel.comments == null || viewModel.comments!.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: viewModel.comments == null ? const CircularProgressIndicator() : const Text("comments not found"),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildListDelegate(
                    List.generate(
                      viewModel.comments!.length,
                      (index) => _CommentCardWidget(comment: viewModel.comments![index]),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  static Widget create(String postId) => ChangeNotifierProvider<CommentListViewModel>(
        lazy: false,
        create: (context) => CommentListViewModel(context, postId),
        child: const CommentListWidget(),
      );
}

class _CreateCommentTextFieldWidget extends StatelessWidget {
  const _CreateCommentTextFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CommentListViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        minLines: 1,
        maxLines: null,
        onChanged: (value) => viewModel.createCommentText = value,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "Enter post text",
            suffixIcon: IconButton(
              onPressed: viewModel.onCreateButtonPresed,
              icon: const Icon(
                Icons.send,
                textDirection: TextDirection.rtl,
              ),
            )),
      ),
    );
  }
}

class _CommentCardWidget extends StatelessWidget {
  _CommentCardWidget({required this.comment});

  final dateFormat = DateFormat("HH:mm");
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async =>
                    await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profile, arguments: comment.author.id),
                child: CircleAvatar(
                  foregroundImage: comment.author.avatarLink == null
                      ? const AssetImage("./assets/person.jpg") as ImageProvider
                      : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(comment.author.avatarLink!)),
                  backgroundImage: const AssetImage("./assets/person.jpg"),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(comment.author.nickname, style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    onTap: () async =>
                        await Navigator.of(context).pushNamed(NestedNavigatorRoutes.profile, arguments: comment.author.id),
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text),
                  const SizedBox(height: 4),
                  Text(dateFormat.format(comment.createdAt), style: Theme.of(context).textTheme.bodySmall),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
