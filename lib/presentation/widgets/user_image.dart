import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double? radius;
  final String? imageUrl;

  const UserAvatar(this.imageUrl, {this.radius});

  @override
  Widget build(BuildContext context) {
    // For some wierd error, they have to be seperated
    return imageUrl != null
        ? CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(imageUrl!),
          )
        : CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
          );
  }
}
