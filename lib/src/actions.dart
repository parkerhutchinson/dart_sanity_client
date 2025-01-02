class Actions {
  static String get create => 'sanity.action.document.create';
  static String get delete => 'sanity.action.document.delete';
  static String get discard => 'sanity.action.document.discard';
  static String get edit => 'sanity.action.document.edit';
  static String get replaceDraft => 'sanity.action.document.replaceDraft';
  static String get publish => 'sanity.action.document.publish';
  static String get unpublish => 'sanity.action.document.unpublish';
}

class Exists {
  static String get fail => 'fail';
  static String get ignore => 'ignore';
}

class CreateAction {
  /// "foo"
  final String publishedId;

  /// {"_id": "foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  /// fail, ignore
  final String? ifExists;

  CreateAction({
    required this.publishedId,
    required this.attributes,
    ifExists,
  }) : ifExists = Exists.fail;

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

class PublishAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  PublishAction({
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

class DeleteAction {
  /// "foo"
  final String publishedId;

  /// ["drafts.foo", "drafts.bar"]
  final List<String>? includeDrafts;

  final bool purge;
  DeleteAction({
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

class EditAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  /// {"set": {"name": "bar"}}
  final Map<String, dynamic> patch;

  EditAction({
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

class ReplaceDraftAction {
  /// "foo"
  final String publishedId;

  /// "_id" requires drafts prefix
  /// {"_id": "drafts.foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  ReplaceDraftAction({
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

class UnpublishAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  UnpublishAction({
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
