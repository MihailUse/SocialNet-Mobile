import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET("/api/User/GetUserProfile")
  Future<UserProfileModel> getUserProfile(@Query("userId") userId);

  @GET("/api/User/GetCurrentUserProfile")
  Future<UserProfileModel> getCurrentUserProfile();

  @GET("/api/Post/GetPersonalPosts")
  Future<List<PostModel>> getPersonalPosts(@Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(@Query("skip") int skip, @Query("take") int take);

  @POST("/api/User/SetUserAvatar")
  Future<void> setUserAvatar(@Body() AttachModel attach);

  @POST("/api/Post/CreatePost")
  Future<String> createPost(@Body() CreatePostModel createPostModel);

  @POST("/api/Attach/UploadFile")
  Future<AttachModel> uploadFile(@Part(name: "file") File file);

  @POST("/api/Attach/UploadMultipleFiles")
  Future<List<AttachModel>> uploadMultipleFiles({@Part(name: "files") required List<File> files});
}
