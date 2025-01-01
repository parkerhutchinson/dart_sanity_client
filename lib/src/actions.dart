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
  final String publishedId;
  final Map<String, dynamic> attributes;
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
        'actionType': Actions.create,
      };
}

class PublishTransaction {
  final String publishedId;
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
