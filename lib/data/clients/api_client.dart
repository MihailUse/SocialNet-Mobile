import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_net/data/models/attach_model.dart';
import 'package:social_net/data/models/comment_model.dart';
import 'package:social_net/data/models/create_comment_model.dart';
import 'package:social_net/data/models/create_post_model.dart';
import 'package:social_net/data/models/notification_model.dart';
import 'package:social_net/data/models/post_model.dart';
import 'package:social_net/data/models/notification_token_model.dart';
import 'package:social_net/data/models/search_list_user_model.dart';
import 'package:social_net/data/models/tag_model.dart';
import 'package:social_net/data/models/update_user_model.dart';
import 'package:social_net/data/models/user_profile_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:social_net/utils.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // user
  @GET("/api/User/GetUserProfile")
  Future<UserProfileModel> getUserProfile(@Query("userId") String userId);

  @PATCH("/api/User/UpdateUser")
  Future<void> updateUser(@Body() UpdateUserModel updateUserModel);

  @GET("/api/User/GetCurrentUserProfile")
  Future<UserProfileModel> getCurrentUserProfile();

  @GET("/api/User/SearchUsers")
  Future<List<SearchListUserModel>> searchUsers(
    @Query("search") String search,
    @Query("skip") int? skip,
    @Query("take") int? take,
  );

  @PATCH("/api/User/ChangeFollowStatus")
  Future<bool> changeUserFollowStatus(@Query("followingId") String followingId);

  // post
  @GET("/api/Post/GetPersonalPosts")
  Future<List<PostModel>> getPersonalPosts(
    @Query("skip") int? skip,
    @Query("take") int? take,
    @Query("fromTime") DateTime? fromTime,
  );

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>> getPosts(
    @Query("skip") int? skip,
    @Query("take") int? take,
    @Query("fromTime") DateTime? fromTime,
  );

  @GET("/api/Post/GetUserPosts")
  Future<List<PostModel>> getUserPosts(
    @Query("userId") String userId,
    @Query("skip") int? skip,
    @Query("take") int? take,
    @Query("fromTime") DateTime? fromTime,
  );

  @GET("/api/Post/GetPostsByTag")
  Future<List<PostModel>> getPostsByTag(
    @Query("tagId") String tagId,
    @Query("skip") int? skip,
    @Query("take") int? take,
    @Query("fromTime") DateTime? fromTime,
  );

  @POST("/api/Post/CreatePost")
  Future<String> createPost(@Body() CreatePostModel createPostModel);

  @PATCH("/api/Post/ChangeLikeStatus")
  Future<bool> changePostLikeStatus(@Query("postId") String postId);

  // attach
  @MultiPart()
  @POST("/api/Attach/UploadFile")
  Future<AttachModel> uploadFile(@Part(name: "file", contentType: "image/*") File file);

  @POST("/api/Attach/UploadMultipleFiles")
  Future<List<AttachModel>> uploadMultipleFiles({@Part(name: "files", contentType: "image/*") required List<File> files});

  // tag
  @GET("/api/Tag/SearchTags")
  Future<List<TagModel>> searchTags(
    @Query("search") String search,
    @Query("skip") int? skip,
    @Query("take") int? take,
  );

  @GET("/api/Tag/GetTagById")
  Future<TagModel> getTagById(@Query("tagId") String tagId);

  @PATCH("/api/Tag/ChangeFollowStatus")
  Future<bool> changeTagFollowStatus(@Query("tagId") String tagId);

  // comment
  @GET("/api/Comment/GetPostComments")
  Future<List<CommentModel>> getPostComments(
    @Query("postId") String postId,
    @Query("skip") int? skip,
    @Query("take") int? take,
  );

  @POST("/api/Comment/CreateComment")
  Future<String> createComment(@Body() CreateCommentModel createCommentModel);

  @PATCH("/api/Comment/ChangeLikeStatus")
  Future<bool> changeCommentLikeStatus(@Query("commentId") String commentId);

  // notifications
  @GET("/api/Notification/GetNotifications")
  Future<List<NotificationModel>> getNotifications(
    @Query("skip") int? skip,
    @Query("take") int? take,
    @Query("fromTime") DateTime? fromTime,
  );

  @POST("/api/Notification/Subscribe")
  Future<void> subscribe(@Body() NotificationTokenModel notificationTokenModel);

  @DELETE("/api/Notification/Unsubscribe")
  Future<void> unsubscribe();

  @DELETE("/api/Notification/DeleteNotification")
  Future<void> deleteNotification(@Query("notificationId") String notificationId);
}
