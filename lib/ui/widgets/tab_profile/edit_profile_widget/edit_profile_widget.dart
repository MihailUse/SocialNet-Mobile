import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/repository/api_repository.dart';
import 'package:social_net/ui/widgets/common/select_file_alert_dialog.dart';
import 'package:social_net/ui/widgets/tab_profile/edit_profile_widget/edit_profile_view_model.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EditProfileViewModel>();
    final user = context.select((EditProfileViewModel value) => value.user);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            title: Text(user?.nickname ?? "..."),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: user == null
                ? const CircularProgressIndicator()
                : Form(
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
                              child: CircleAvatar(
                                minRadius: 32,
                                maxRadius: 86,
                                foregroundImage: user.avatarLink == null
                                    ? const AssetImage("./assets/person.jpg") as ImageProvider
                                    : CachedNetworkImageProvider(ApiRepository.getUserAvatarPath(user.avatarLink!)),
                                backgroundImage: const AssetImage("./assets/person.jpg"),
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
                        TextFormField(controller: viewModel.nicknameController),
                        TextFormField(controller: viewModel.fullNameController),
                        TextFormField(controller: viewModel.aboutController),
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
        create: (context) => EditProfileViewModel(context),
        child: const EditProfileWidget(),
      );
}
