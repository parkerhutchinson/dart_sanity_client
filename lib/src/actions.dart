class Actions {
  static String get create {
    return 'sanity.action.document.create';
  }

  static String get delete {
    return 'sanity.action.document.delete';
  }

  static String get discard {
    return 'sanity.action.document.discard';
  }

  static String get edit {
    return 'sanity.action.document.edit';
  }

  static String get replaceDraft {
    return 'sanity.action.document.replaceDraft';
  }

  static String get publish {
    return 'sanity.action.document.publish';
  }

  static String get unpublish {
    return 'sanity.action.document.unpublish';
  }
}

enum Exists {
  fail,
  ignore,
}

class CreateTransaction {
  /// "foo"
  final String publishedId;

  /// {"_id": "foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  /// fail, ignore
  final Exists ifExists;

  CreateTransaction({
    required this.publishedId,
    required this.attributes,
    this.ifExists = Exists.fail,
  });

  static String get action {
    return Actions.create;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'attributes': attributes,
        'ifExists': ifExists,
        'actionType': Actions.create,
      };
}

class PublishTransaction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  PublishTransaction({
    required this.publishedId,
    required this.draftId,
  });

  static String get action {
    return Actions.publish;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'actionType': Actions.publish,
      };
}

class DeleteTransaction {
  /// "foo"
  final String publishedId;

  /// ["drafts.foo", "drafts.bar"]
  final List<String>? includeDrafts;

  final bool purge;
  DeleteTransaction({
    required this.publishedId,
    this.includeDrafts,
    this.purge = false,
  });

  static String get action {
    return Actions.delete;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'actionType': Actions.delete,
        'purge': purge
      };
}

class EditTransaction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  /// {"set": {"name": "bar"}}
  final Map<String, dynamic> patch;

  EditTransaction({
    required this.publishedId,
    required this.draftId,
    required this.patch,
  });

  static String get action {
    return Actions.edit;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'patch': patch,
        'actionType': Actions.edit,
      };
}

class ReplaceDraftTransaction {
  /// "foo"
  final String publishedId;

  /// "_id" requires drafts prefix
  /// {"_id": "drafts.foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  ReplaceDraftTransaction({
    required this.publishedId,
    required this.attributes,
  });

  static String get action {
    return Actions.replaceDraft;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'attributes': attributes,
        'actionType': Actions.replaceDraft,
      };
}

class UnpublishTransaction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  UnpublishTransaction({
    required this.publishedId,
    required this.draftId,
  });

  static String get action {
    return Actions.unpublish;
  }

  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'actionType': Actions.unpublish,
      };
}
