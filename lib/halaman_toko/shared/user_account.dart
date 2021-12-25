
import 'package:flutter/widgets.dart';

class UserAccount{
  Image photo_profile;
  String full_name;
  String username;

  UserAccount({
    required this.photo_profile,
    required this.full_name,
    required this.username,
  });


  @override
  bool operator ==(Object other) {
    if (identityHashCode(this) == identityHashCode(other)) {
      return true;
    }
    if (other is! UserAccount) {
      return false;
    }
    UserAccount o = other;
    return photo_profile == o.photo_profile
        && full_name == o.full_name
        && username == o.username
    ;
  }

  @override
  int get hashCode =>
      photo_profile.hashCode
      ^ full_name.hashCode
      ^ username.hashCode
  ;

}