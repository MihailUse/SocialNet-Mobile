import 'dart:io';

import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/domain/repository/api_repository.dart';

class AttachService {
  Future<AttachModel> uploadFile(File file) {
    return ApiRepository.instance.api.uploadFile(file);
  }
}
