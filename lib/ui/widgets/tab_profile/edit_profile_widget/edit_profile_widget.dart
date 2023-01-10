import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/common/select_file_alert_dialog.dart';
import 'package:social_net/ui/widgets/common/user_avatar_widget.dart';
import 'package:social_net/ui/widgets/tab_profile/edit_profile_widget/edit_profile_view_model.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            title: Text(viewModel.updateUserModel.nickname ?? ""),
          ),
        ],
        body: SingleChildScrollView(
          child: Center(
            child: viewModel.updateUserModel.nickname == null
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Form(
                      key: viewModel.formGlobalKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 86.0, vertical: 32.0),
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 10, color: Theme.of(context).shadowColor),
                                  ],
                                ),
                                child: _EditUserAvatarWidget(
                                  file: viewModel.avatarFile,
                                  avatarLink: viewModel.avatarLink,
                                ),
                              ),
                              onTap: () => showDialog(
                                context: context,
                                useRootNavigator: false,
                                builder: (_) => SelectFileAlertDialog(
                                  onTakeImageButtonPressed: viewModel.onTakeImageButtonPressed,
                                  onSelectImageButtonPressed: viewModel.onSelectImageButtonPressed,
                                ),
                              ),
                            ),
                          ),
                          _ProfileTextFormWidget(
                            hintText: "Enter nickname",
                            labelText: "Nickname",
                            validator: viewModel.validateNickname,
                            controller: viewModel.nicknameController,
                          ),
                          _ProfileTextFormWidget(
                            hintText: "Enter full name",
                            labelText: "Full name",
                            controller: viewModel.fullNameController,
                          ),
                          _ProfileTextFormWidget(
                            hintText: "Enter about yourself",
                            labelText: "About",
                            maxLines: null,
                            controller: viewModel.aboutController,
                          ),
                          ElevatedButton(
                            onPressed: viewModel.onSaveButtonPressed,
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<EditProfileViewModel>(
        lazy: false,
        create: (context) => EditProfileViewModel(context),
        child: const EditProfileWidget(),
      );
}

class _ProfileTextFormWidget extends StatelessWidget {
  const _ProfileTextFormWidget({
    this.hintText,
    this.maxLines,
    this.labelText,
    this.validator,
    required this.controller,
  });

  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}

class _EditUserAvatarWidget extends StatelessWidget {
  const _EditUserAvatarWidget({required this.file, required this.avatarLink});

  final File? file;
  final String? avatarLink;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return CircleAvatar(
        minRadius: 86,
        foregroundImage: FileImage(file!),
      );
    }

    return UserAvatarWidget(
      minRadius: 86,
      avatarLink: avatarLink,
    );
  }
}
