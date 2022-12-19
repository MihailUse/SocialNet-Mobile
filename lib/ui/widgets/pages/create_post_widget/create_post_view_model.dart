import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/domain/services/attach_service.dart';
import 'package:social_net/domain/services/post_service.dart';
import 'package:social_net/ui/app_navigator.dart';

class CreatePostViewModel extends ChangeNotifier {
  CreatePostViewModel(this.context) {
    postTextController = TextEditingController(text: state.text);

    postTextController.addListener(() => state = state.copyWith(text: postTextController.text));
  }

  int currentAttachIndex = 0;
  final _attachService = AttachService();
  final _postService = PostService();
  final formGlobalKey = GlobalKey<FormState>();
  final List<File> attaches = [];
  late final TextEditingController postTextController;
  final BuildContext context;
  CreatePostModel _state = const CreatePostModel(
    text: "",
    isCommentable: true,
    attaches: [],
  );

  CreatePostModel get state => _state;

  void onAttachIndexChenged(int value) {
    currentAttachIndex = value;
    notifyListeners();
  }

  set state(CreatePostModel value) {
    _state = value;
    notifyListeners();
  }

  void onCreateButtonPressed() async {
    await _postService.createPost(state);
    AppNavigator.toLast();
  }

  void isCommentableChenged(bool? value) {
    state = state.copyWith(isCommentable: value ?? false);
  }

  void onImageSelected(File file) async {
    final attach = await _attachService.uploadFile(file);
    attaches.add(file);
    state = state.copyWith(attaches: [...state.attaches!, attach]);
  }
}
