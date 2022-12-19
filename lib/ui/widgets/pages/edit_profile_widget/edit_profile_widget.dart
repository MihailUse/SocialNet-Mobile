import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/common/user_avatar_widget.dart';
import 'package:social_net/ui/widgets/pages/edit_profile_widget/edit_profile_view_model.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EditProfileViewModel>();
    final user = context.select((EditProfileViewModel value) => value.user);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: viewModel.formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 86.0, vertical: 32.0),
                    child: GestureDetector(
                      onTap: viewModel.onAvatarPressed,
                      child: UserAvatarWidget(userId: user.id),
                    ),
                  ),
                  // TextFormField(controller: viewModel.nicknameController),
                  // TextFormField(controller: viewModel.fullNameController),
                  // TextFormField(controller: viewModel.aboutController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<EditProfileViewModel>(
        lazy: false,
        create: (_) => EditProfileViewModel(),
        child: const EditProfileWidget(),
      );
}
