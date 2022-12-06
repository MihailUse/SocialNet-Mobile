import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/user_profile_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetUserProfile")
  Future<UserProfileModel> getUserProfile(@Query("userId") userId);

  @GET("/api/User/GetCurrentUserProfile")
  Future<UserProfileModel> getCurrentUserProfile();
}
