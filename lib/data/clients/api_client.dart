import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/create_comment_model.dart';
import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/notification_token_model.dart';
import 'package:social_net/data/models/search_list_user_model.dart';
import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // user
  @GET("/api/User/GetUserProfile")
  Future<UserProfileModel> getUserProfile(@Query("userId") String userId);

  @POST("/api/User/SetUserAvatar")
  Future<void> setUserAvatar(@Body() AttachModel attach);

  @GET("/api/User/GetCurrentUserProfile")
  Future<UserProfileModel> getCurrentUserProfile();

  @GET("/api/User/SearchUsers")
  Future<List<SearchListUserModel>> searchUsers(
    @Query("search") String search,
    @Query("skip") int skip,
    @Query("take") int take,
  );

  @POST("/api/User/ChangeFollowStatus")
  Future<bool> changeUserFollowStatus(@Query("followingId") String followingId);

  // post
  @GET("/api/Post/GetPersonalPosts")
  Future<List<PostModel>> getPersonalPosts(@Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(@Query("skip") int skip, @Query("take") int take);

  @GET("/api/Post/GetPostsByTag")
  Future<List<PostModel>> getPostsByTag(
    @Query("tagId") String tagId,
    @Query("skip") int skip,
    @Query("take") int take,
  );

  @POST("/api/Post/CreatePost")
  Future<String> createPost(@Body() CreatePostModel createPostModel);

  @POST("/api/Post/ChangeLikeStatus")
  Future<bool> changePostLikeStatus(@Query("postId") String postId);

  // attach
  @POST("/api/Attach/UploadFile")
  Future<AttachModel> uploadFile(@Part(name: "file") File file);

  @POST("/api/Attach/UploadMultipleFiles")
  Future<List<AttachModel>> uploadMultipleFiles({@Part(name: "files") required List<File> files});

  // tag
  @GET("/api/Tag/SearchTags")
  Future<List<TagModel>> searchTags(
    @Query("search") String search,
    @Query("skip") int skip,
    @Query("take") int take,
  );

  @GET("/api/Tag/GetTagById")
  Future<TagModel> getTagById(@Query("tagId") String tagId);

  @POST("/api/Tag/ChangeFollowStatus")
  Future<bool> changeTagFollowStatus(@Query("tagId") String tagId);

  // comment
  @GET("/api/Comment/GetPostComments")
  Future<List<CommentModel>> getPostComments(
    @Query("postId") String postId,
    @Query("skip") String search,
    @Query("take") int take,
  );

  @POST("/api/Comment/CreateComment")
  Future<String> createComment(@Body() CreateCommentModel createCommentModel);

  // notifications
  @POST("/api/Notification/Subscribe")
  Future<void> subscribe(@Body() NotificationTokenModel notificationTokenModel);

  @DELETE("/api/Notification/Unsubscribe")
  Future<void> unsubscribe();
}
