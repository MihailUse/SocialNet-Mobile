import 'package:flutter/material.dart';

class CountDetailWidget extends StatelessWidget {
  const CountDetailWidget({super.key, required this.value, required this.description});

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
