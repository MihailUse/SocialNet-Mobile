import 'package:flutter/material.dart';
import 'package:social_net/domain/entities/tag.dart';
import 'package:social_net/domain/services/database_service.dart';
import 'package:social_net/domain/services/sync_service.dart';
import 'package:social_net/domain/services/tag_service.dart';

class TagDetailViewModel extends ChangeNotifier {
  TagDetailViewModel(this.context, this.tag, this.onChanged) {
    asyncInit();
  }

  Tag tag;
  final BuildContext context;
  final Function()? onChanged;
  final _tagService = TagService();
  final _syncService = SyncService();
  final _databaseService = DatabaseService();

  void changeFollowStatus() async {
    try {
      await _tagService.changeTagFollowStatus(tag.id);
      asyncInit();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to change status"),
        ),
      );
    }
  }

  void asyncInit() async {
    try {
      await _syncService.syncTagById(tag.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("failed to update tag"),
        ),
      );
    }

    tag = await _databaseService.getTagById(tag.id) ?? tag;
    onChanged?.call();
    notifyListeners();
  }
}
