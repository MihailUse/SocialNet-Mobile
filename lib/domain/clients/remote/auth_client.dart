import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:social_net/domain/models/create_user_request_model.dart';
import 'package:social_net/domain/models/token_refresh_request_model.dart';
import 'package:social_net/domain/models/token_request_model.dart';
import 'package:social_net/domain/models/token_model.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST("/api/Auth/GetToken")
  Future<TokenModel> getTokens(@Body() TokenRequestModel model);

  @POST("/api/Auth/GetRefreshToken")
  Future<TokenModel> getTokensByRefresh(@Body() TokenRefreshRequestModel model);

  @POST("/api/Auth/CreateUser")
  Future<String> createUser(@Body() CreateUserRequestModel model);
}
