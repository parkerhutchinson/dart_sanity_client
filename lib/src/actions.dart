/// static class getter for action types
class Actions {
  /// create action api value
  static String get create => 'sanity.action.document.create';

  /// delete action api value
  static String get delete => 'sanity.action.document.delete';

  /// discard action api value
  static String get discard => 'sanity.action.document.discard';

  /// edit action api value
  static String get edit => 'sanity.action.document.edit';

  /// replaceDraft action api value
  static String get replaceDraft => 'sanity.action.document.replaceDraft';

  /// publish action api value
  static String get publish => 'sanity.action.document.publish';

  /// unpublish action api value
  static String get unpublish => 'sanity.action.document.unpublish';
}

/// static class getter for ifExists property
class Exists {
  /// ifExists const value
  static String get fail => 'fail';

  /// ifExists const value
  static String get ignore => 'ignore';
}

/// create sanity document using attributes(fields)
class CreateAction {
  /// "foo"
  final String publishedId;

  /// {"_id": "foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  /// fail, ignore
  final String? ifExists;

  /// constructor
  CreateAction({
    required this.publishedId,
    required this.attributes,
    ifExists,
  }) : ifExists = Exists.fail;
  // ignore: public_member_api_docs
  static String get action {
    return Actions.create;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'attributes': attributes,
        'ifExists': ifExists,
        'actionType': Actions.create,
      };
}

/// publish sanity document
class PublishAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  /// optonal Id for revision locking see: https://www.sanity.io/docs/http-actions#69d975d3725c
  final String? ifDraftRevisionId;

  /// optonal Id for revision locking see: https://www.sanity.io/docs/http-actions#69d975d3725c
  final String? ifPublishedRevisionId;

  /// constructor
  PublishAction({
    required this.publishedId,
    required this.draftId,
    this.ifPublishedRevisionId,
    this.ifDraftRevisionId,
  });
  // ignore: public_member_api_docs
  static String get action {
    return Actions.publish;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'actionType': Actions.publish,
        if (ifPublishedRevisionId != null)
          'ifPublishedRevisionId': ifPublishedRevisionId,
        if (ifDraftRevisionId != null) 'ifDraftRevisionId': ifDraftRevisionId
      };
}

/// delete sanity document
class DeleteAction {
  /// "foo"
  final String publishedId;

  /// ["drafts.foo", "drafts.bar"]
  final List<String>? includeDrafts;

  /// purges cdn cache
  final bool purge;

  /// constructor
  DeleteAction({
    required this.publishedId,
    this.includeDrafts,
    this.purge = false,
  });
  // ignore: public_member_api_docs
  static String get action {
    return Actions.delete;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'actionType': Actions.delete,
        'purge': purge,
        if (includeDrafts != null) 'includeDrafts': includeDrafts
      };
}

/// edit sanity document
class EditAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  /// {"set": {"name": "bar"}}
  final Map<String, dynamic> patch;

  /// constructor
  EditAction({
    required this.publishedId,
    required this.draftId,
    required this.patch,
  });
  // ignore: public_member_api_docs
  static String get action {
    return Actions.edit;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'patch': patch,
        'actionType': Actions.edit,
      };
}

/// replace existing draft with a new draft
class ReplaceDraftAction {
  /// "foo"
  final String publishedId;

  /// "_id" requires drafts prefix
  /// {"_id": "drafts.foo", "_type": "post", "title": "hello world"}
  final Map<String, dynamic> attributes;

  /// constructor
  ReplaceDraftAction({
    required this.publishedId,
    required this.attributes,
  });

  // ignore: public_member_api_docs
  static String get action {
    return Actions.replaceDraft;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'attributes': attributes,
        'actionType': Actions.replaceDraft,
      };
}

/// unpublish existing sanity document
class UnpublishAction {
  /// "foo"
  final String publishedId;

  /// "drafts.foo"
  final String draftId;

  /// constructor
  UnpublishAction({
    required this.publishedId,
    required this.draftId,
  });

  // ignore: public_member_api_docs
  static String get action {
    return Actions.unpublish;
  }

  // ignore: public_member_api_docs
  Map<String, dynamic> toJson() => {
        'publishedId': publishedId,
        'draftId': draftId,
        'actionType': Actions.unpublish,
      };
}
