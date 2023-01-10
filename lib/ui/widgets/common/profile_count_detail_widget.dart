import 'package:flutter/material.dart';

class ProfileCountDetailWidget extends StatelessWidget {
  const ProfileCountDetailWidget({super.key, required this.value, required this.description});

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
