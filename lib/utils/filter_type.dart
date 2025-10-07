enum FilterType {
  all,
  read,
  unread,
}

extension FilterTypeExtension on FilterType {
  String get displayName {
    switch (this) {
      case FilterType.all:
        return 'All';
      case FilterType.read:
        return 'Read';
      case FilterType.unread:
        return 'Unread';
    }
  }

  String get icon {
    switch (this) {
      case FilterType.all:
        return 'all';
      case FilterType.read:
        return 'read';
      case FilterType.unread:
        return 'unread';
    }
  }
}
