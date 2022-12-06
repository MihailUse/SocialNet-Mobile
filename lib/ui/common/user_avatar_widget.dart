import 'package:flutter/material.dart';
import 'package:social_net/domain/clients/local/session_client.dart';
import 'package:social_net/domain/config.dart';

class UserAvatarWidget extends StatelessWidget {
  UserAvatarWidget({super.key, this.path});

  final _sessionClient = SessionClient();
  final String? path;

  Future<NetworkImage> _loadImage() async {
    if (path == null) return Future.error(Exception());

    final token = await _sessionClient.getToken();
    final headers = {"Authorization": "Bearer $token"};

    return NetworkImage("${Config.apiBaseUrl}$path", headers: headers);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black.withOpacity(0.0)),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 6, offset: Offset.zero, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: FutureBuilder<NetworkImage>(
        future: _loadImage(),
        builder: (BuildContext context, AsyncSnapshot<NetworkImage> snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              minRadius: 48,
              backgroundImage: snapshot.data,
              backgroundColor: Colors.transparent,
            );
          }

          // TODO: remove fixed size
          return const SizedBox(
            width: 96,
            height: 96,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black26,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}
