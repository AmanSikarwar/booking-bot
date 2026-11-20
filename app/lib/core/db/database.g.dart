// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConversationsTable extends Conversations with TableInfo<$ConversationsTable, Conversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flaggedMeta = const VerificationMeta('flagged');
  @override
  late final GeneratedColumn<bool> flagged = GeneratedColumn<bool>(
    'flagged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("flagged" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, locale, title, flagged, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Conversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(_localeMeta, locale.isAcceptableOrUnknown(data['locale']!, _localeMeta));
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('flagged')) {
      context.handle(_flaggedMeta, flagged.isAcceptableOrUnknown(data['flagged']!, _flaggedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Conversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversation(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      flagged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}flagged'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class Conversation extends DataClass implements Insertable<Conversation> {
  final String id;
  final String locale;
  final String? title;
  final bool flagged;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Conversation({
    required this.id,
    required this.locale,
    this.title,
    required this.flagged,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['locale'] = Variable<String>(locale);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['flagged'] = Variable<bool>(flagged);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      locale: Value(locale),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      flagged: Value(flagged),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversation(
      id: serializer.fromJson<String>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      title: serializer.fromJson<String?>(json['title']),
      flagged: serializer.fromJson<bool>(json['flagged']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locale': serializer.toJson<String>(locale),
      'title': serializer.toJson<String?>(title),
      'flagged': serializer.toJson<bool>(flagged),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Conversation copyWith({
    String? id,
    String? locale,
    Value<String?> title = const Value.absent(),
    bool? flagged,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Conversation(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    title: title.present ? title.value : this.title,
    flagged: flagged ?? this.flagged,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Conversation copyWithCompanion(ConversationsCompanion data) {
    return Conversation(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      title: data.title.present ? data.title.value : this.title,
      flagged: data.flagged.present ? data.flagged.value : this.flagged,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversation(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('title: $title, ')
          ..write('flagged: $flagged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, locale, title, flagged, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversation &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.title == this.title &&
          other.flagged == this.flagged &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConversationsCompanion extends UpdateCompanion<Conversation> {
  final Value<String> id;
  final Value<String> locale;
  final Value<String?> title;
  final Value<bool> flagged;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.title = const Value.absent(),
    this.flagged = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    required String locale,
    this.title = const Value.absent(),
    this.flagged = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       locale = Value(locale),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Conversation> custom({
    Expression<String>? id,
    Expression<String>? locale,
    Expression<String>? title,
    Expression<bool>? flagged,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (title != null) 'title': title,
      if (flagged != null) 'flagged': flagged,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? locale,
    Value<String?>? title,
    Value<bool>? flagged,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConversationsCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      title: title ?? this.title,
      flagged: flagged ?? this.flagged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (flagged.present) {
      map['flagged'] = Variable<bool>(flagged.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('title: $title, ')
          ..write('flagged: $flagged, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES conversations (id)'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MessageRole>($MessagesTable.$converterrole);
  @override
  late final GeneratedColumnWithTypeConverter<MessageKind, String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  ).withConverter<MessageKind>($MessagesTable.$converterkind);
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _displayMeta = const VerificationMeta('display');
  @override
  late final GeneratedColumn<String> display = GeneratedColumn<String>(
    'display',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<ChatCard>, String> cards =
      GeneratedColumn<String>(
        'cards',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<ChatCard>>($MessagesTable.$convertercards);
  @override
  late final GeneratedColumnWithTypeConverter<MessageStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MessageStatus>($MessagesTable.$converterstatus);
  static const VerificationMeta _replyToMeta = const VerificationMeta('replyTo');
  @override
  late final GeneratedColumn<String> replyTo = GeneratedColumn<String>(
    'reply_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeToolMeta = const VerificationMeta('activeTool');
  @override
  late final GeneratedColumn<String> activeTool = GeneratedColumn<String>(
    'active_tool',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt = GeneratedColumn<DateTime>(
    'next_attempt_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    kind,
    locale,
    body,
    display,
    cards,
    status,
    replyTo,
    activeTool,
    attempts,
    nextAttemptAt,
    error,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(data['conversation_id']!, _conversationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(_localeMeta, locale.isAcceptableOrUnknown(data['locale']!, _localeMeta));
    }
    if (data.containsKey('body')) {
      context.handle(_bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('display')) {
      context.handle(_displayMeta, display.isAcceptableOrUnknown(data['display']!, _displayMeta));
    }
    if (data.containsKey('reply_to')) {
      context.handle(_replyToMeta, replyTo.isAcceptableOrUnknown(data['reply_to']!, _replyToMeta));
    }
    if (data.containsKey('active_tool')) {
      context.handle(
        _activeToolMeta,
        activeTool.isAcceptableOrUnknown(data['active_tool']!, _activeToolMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(data['next_attempt_at']!, _nextAttemptAtMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(_errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: $MessagesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      ),
      kind: $MessagesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      ),
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      body: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      display: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display'],
      ),
      cards: $MessagesTable.$convertercards.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}cards'])!,
      ),
      status: $MessagesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      ),
      replyTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to'],
      ),
      activeTool: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_tool'],
      ),
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MessageRole, String, String> $converterrole =
      const EnumNameConverter<MessageRole>(MessageRole.values);
  static JsonTypeConverter2<MessageKind, String, String> $converterkind =
      const EnumNameConverter<MessageKind>(MessageKind.values);
  static TypeConverter<List<ChatCard>, String> $convertercards = const CardListConverter();
  static JsonTypeConverter2<MessageStatus, String, String> $converterstatus =
      const EnumNameConverter<MessageStatus>(MessageStatus.values);
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String conversationId;
  final MessageRole role;
  final MessageKind kind;
  final String locale;
  final String body;
  final String? display;
  final List<ChatCard> cards;
  final MessageStatus status;
  final String? replyTo;
  final String? activeTool;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? error;
  final DateTime createdAt;
  const Message({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.kind,
    required this.locale,
    required this.body,
    this.display,
    required this.cards,
    required this.status,
    this.replyTo,
    this.activeTool,
    required this.attempts,
    this.nextAttemptAt,
    this.error,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    {
      map['role'] = Variable<String>($MessagesTable.$converterrole.toSql(role));
    }
    {
      map['kind'] = Variable<String>($MessagesTable.$converterkind.toSql(kind));
    }
    map['locale'] = Variable<String>(locale);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || display != null) {
      map['display'] = Variable<String>(display);
    }
    {
      map['cards'] = Variable<String>($MessagesTable.$convertercards.toSql(cards));
    }
    {
      map['status'] = Variable<String>($MessagesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || replyTo != null) {
      map['reply_to'] = Variable<String>(replyTo);
    }
    if (!nullToAbsent || activeTool != null) {
      map['active_tool'] = Variable<String>(activeTool);
    }
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      kind: Value(kind),
      locale: Value(locale),
      body: Value(body),
      display: display == null && nullToAbsent ? const Value.absent() : Value(display),
      cards: Value(cards),
      status: Value(status),
      replyTo: replyTo == null && nullToAbsent ? const Value.absent() : Value(replyTo),
      activeTool: activeTool == null && nullToAbsent ? const Value.absent() : Value(activeTool),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      error: error == null && nullToAbsent ? const Value.absent() : Value(error),
      createdAt: Value(createdAt),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: $MessagesTable.$converterrole.fromJson(serializer.fromJson<String>(json['role'])),
      kind: $MessagesTable.$converterkind.fromJson(serializer.fromJson<String>(json['kind'])),
      locale: serializer.fromJson<String>(json['locale']),
      body: serializer.fromJson<String>(json['body']),
      display: serializer.fromJson<String?>(json['display']),
      cards: serializer.fromJson<List<ChatCard>>(json['cards']),
      status: $MessagesTable.$converterstatus.fromJson(serializer.fromJson<String>(json['status'])),
      replyTo: serializer.fromJson<String?>(json['replyTo']),
      activeTool: serializer.fromJson<String?>(json['activeTool']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>($MessagesTable.$converterrole.toJson(role)),
      'kind': serializer.toJson<String>($MessagesTable.$converterkind.toJson(kind)),
      'locale': serializer.toJson<String>(locale),
      'body': serializer.toJson<String>(body),
      'display': serializer.toJson<String?>(display),
      'cards': serializer.toJson<List<ChatCard>>(cards),
      'status': serializer.toJson<String>($MessagesTable.$converterstatus.toJson(status)),
      'replyTo': serializer.toJson<String?>(replyTo),
      'activeTool': serializer.toJson<String?>(activeTool),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    MessageRole? role,
    MessageKind? kind,
    String? locale,
    String? body,
    Value<String?> display = const Value.absent(),
    List<ChatCard>? cards,
    MessageStatus? status,
    Value<String?> replyTo = const Value.absent(),
    Value<String?> activeTool = const Value.absent(),
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
  }) => Message(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    kind: kind ?? this.kind,
    locale: locale ?? this.locale,
    body: body ?? this.body,
    display: display.present ? display.value : this.display,
    cards: cards ?? this.cards,
    status: status ?? this.status,
    replyTo: replyTo.present ? replyTo.value : this.replyTo,
    activeTool: activeTool.present ? activeTool.value : this.activeTool,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present ? data.conversationId.value : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      kind: data.kind.present ? data.kind.value : this.kind,
      locale: data.locale.present ? data.locale.value : this.locale,
      body: data.body.present ? data.body.value : this.body,
      display: data.display.present ? data.display.value : this.display,
      cards: data.cards.present ? data.cards.value : this.cards,
      status: data.status.present ? data.status.value : this.status,
      replyTo: data.replyTo.present ? data.replyTo.value : this.replyTo,
      activeTool: data.activeTool.present ? data.activeTool.value : this.activeTool,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present ? data.nextAttemptAt.value : this.nextAttemptAt,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('kind: $kind, ')
          ..write('locale: $locale, ')
          ..write('body: $body, ')
          ..write('display: $display, ')
          ..write('cards: $cards, ')
          ..write('status: $status, ')
          ..write('replyTo: $replyTo, ')
          ..write('activeTool: $activeTool, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    role,
    kind,
    locale,
    body,
    display,
    cards,
    status,
    replyTo,
    activeTool,
    attempts,
    nextAttemptAt,
    error,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.kind == this.kind &&
          other.locale == this.locale &&
          other.body == this.body &&
          other.display == this.display &&
          other.cards == this.cards &&
          other.status == this.status &&
          other.replyTo == this.replyTo &&
          other.activeTool == this.activeTool &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.error == this.error &&
          other.createdAt == this.createdAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<MessageRole> role;
  final Value<MessageKind> kind;
  final Value<String> locale;
  final Value<String> body;
  final Value<String?> display;
  final Value<List<ChatCard>> cards;
  final Value<MessageStatus> status;
  final Value<String?> replyTo;
  final Value<String?> activeTool;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.kind = const Value.absent(),
    this.locale = const Value.absent(),
    this.body = const Value.absent(),
    this.display = const Value.absent(),
    this.cards = const Value.absent(),
    this.status = const Value.absent(),
    this.replyTo = const Value.absent(),
    this.activeTool = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String conversationId,
    required MessageRole role,
    this.kind = const Value.absent(),
    this.locale = const Value.absent(),
    this.body = const Value.absent(),
    this.display = const Value.absent(),
    this.cards = const Value.absent(),
    required MessageStatus status,
    this.replyTo = const Value.absent(),
    this.activeTool = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       role = Value(role),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? kind,
    Expression<String>? locale,
    Expression<String>? body,
    Expression<String>? display,
    Expression<String>? cards,
    Expression<String>? status,
    Expression<String>? replyTo,
    Expression<String>? activeTool,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (kind != null) 'kind': kind,
      if (locale != null) 'locale': locale,
      if (body != null) 'body': body,
      if (display != null) 'display': display,
      if (cards != null) 'cards': cards,
      if (status != null) 'status': status,
      if (replyTo != null) 'reply_to': replyTo,
      if (activeTool != null) 'active_tool': activeTool,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<MessageRole>? role,
    Value<MessageKind>? kind,
    Value<String>? locale,
    Value<String>? body,
    Value<String?>? display,
    Value<List<ChatCard>>? cards,
    Value<MessageStatus>? status,
    Value<String?>? replyTo,
    Value<String?>? activeTool,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? error,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      kind: kind ?? this.kind,
      locale: locale ?? this.locale,
      body: body ?? this.body,
      display: display ?? this.display,
      cards: cards ?? this.cards,
      status: status ?? this.status,
      replyTo: replyTo ?? this.replyTo,
      activeTool: activeTool ?? this.activeTool,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>($MessagesTable.$converterrole.toSql(role.value));
    }
    if (kind.present) {
      map['kind'] = Variable<String>($MessagesTable.$converterkind.toSql(kind.value));
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (display.present) {
      map['display'] = Variable<String>(display.value);
    }
    if (cards.present) {
      map['cards'] = Variable<String>($MessagesTable.$convertercards.toSql(cards.value));
    }
    if (status.present) {
      map['status'] = Variable<String>($MessagesTable.$converterstatus.toSql(status.value));
    }
    if (replyTo.present) {
      map['reply_to'] = Variable<String>(replyTo.value);
    }
    if (activeTool.present) {
      map['active_tool'] = Variable<String>(activeTool.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('kind: $kind, ')
          ..write('locale: $locale, ')
          ..write('body: $body, ')
          ..write('display: $display, ')
          ..write('cards: $cards, ')
          ..write('status: $status, ')
          ..write('replyTo: $replyTo, ')
          ..write('activeTool: $activeTool, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookingsTable extends Bookings with TableInfo<$BookingsTable, Booking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookingRefMeta = const VerificationMeta('bookingRef');
  @override
  late final GeneratedColumn<String> bookingRef = GeneratedColumn<String>(
    'booking_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageIdMeta = const VerificationMeta('packageId');
  @override
  late final GeneratedColumn<String> packageId = GeneratedColumn<String>(
    'package_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameEnMeta = const VerificationMeta('packageNameEn');
  @override
  late final GeneratedColumn<String> packageNameEn = GeneratedColumn<String>(
    'package_name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageNameHiMeta = const VerificationMeta('packageNameHi');
  @override
  late final GeneratedColumn<String> packageNameHi = GeneratedColumn<String>(
    'package_name_hi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotDateMeta = const VerificationMeta('slotDate');
  @override
  late final GeneratedColumn<String> slotDate = GeneratedColumn<String>(
    'slot_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeWindowMeta = const VerificationMeta('timeWindow');
  @override
  late final GeneratedColumn<String> timeWindow = GeneratedColumn<String>(
    'time_window',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressLabelMeta = const VerificationMeta('addressLabel');
  @override
  late final GeneratedColumn<String> addressLabel = GeneratedColumn<String>(
    'address_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patientNameMeta = const VerificationMeta('patientName');
  @override
  late final GeneratedColumn<String> patientName = GeneratedColumn<String>(
    'patient_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookingRef,
    conversationId,
    packageId,
    packageNameEn,
    packageNameHi,
    slotDate,
    timeWindow,
    addressLabel,
    patientName,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookings';
  @override
  VerificationContext validateIntegrity(Insertable<Booking> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('booking_ref')) {
      context.handle(
        _bookingRefMeta,
        bookingRef.isAcceptableOrUnknown(data['booking_ref']!, _bookingRefMeta),
      );
    } else if (isInserting) {
      context.missing(_bookingRefMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(data['conversation_id']!, _conversationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('package_id')) {
      context.handle(
        _packageIdMeta,
        packageId.isAcceptableOrUnknown(data['package_id']!, _packageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packageIdMeta);
    }
    if (data.containsKey('package_name_en')) {
      context.handle(
        _packageNameEnMeta,
        packageNameEn.isAcceptableOrUnknown(data['package_name_en']!, _packageNameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_packageNameEnMeta);
    }
    if (data.containsKey('package_name_hi')) {
      context.handle(
        _packageNameHiMeta,
        packageNameHi.isAcceptableOrUnknown(data['package_name_hi']!, _packageNameHiMeta),
      );
    } else if (isInserting) {
      context.missing(_packageNameHiMeta);
    }
    if (data.containsKey('slot_date')) {
      context.handle(
        _slotDateMeta,
        slotDate.isAcceptableOrUnknown(data['slot_date']!, _slotDateMeta),
      );
    } else if (isInserting) {
      context.missing(_slotDateMeta);
    }
    if (data.containsKey('time_window')) {
      context.handle(
        _timeWindowMeta,
        timeWindow.isAcceptableOrUnknown(data['time_window']!, _timeWindowMeta),
      );
    } else if (isInserting) {
      context.missing(_timeWindowMeta);
    }
    if (data.containsKey('address_label')) {
      context.handle(
        _addressLabelMeta,
        addressLabel.isAcceptableOrUnknown(data['address_label']!, _addressLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_addressLabelMeta);
    }
    if (data.containsKey('patient_name')) {
      context.handle(
        _patientNameMeta,
        patientName.isAcceptableOrUnknown(data['patient_name']!, _patientNameMeta),
      );
    } else if (isInserting) {
      context.missing(_patientNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookingRef};
  @override
  Booking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Booking(
      bookingRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_ref'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      packageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_id'],
      )!,
      packageNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name_en'],
      )!,
      packageNameHi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name_hi'],
      )!,
      slotDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot_date'],
      )!,
      timeWindow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_window'],
      )!,
      addressLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_label'],
      )!,
      patientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookingsTable createAlias(String alias) {
    return $BookingsTable(attachedDatabase, alias);
  }
}

class Booking extends DataClass implements Insertable<Booking> {
  final String bookingRef;
  final String conversationId;
  final String packageId;
  final String packageNameEn;
  final String packageNameHi;
  final String slotDate;
  final String timeWindow;
  final String addressLabel;
  final String patientName;
  final String status;
  final DateTime createdAt;
  const Booking({
    required this.bookingRef,
    required this.conversationId,
    required this.packageId,
    required this.packageNameEn,
    required this.packageNameHi,
    required this.slotDate,
    required this.timeWindow,
    required this.addressLabel,
    required this.patientName,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['booking_ref'] = Variable<String>(bookingRef);
    map['conversation_id'] = Variable<String>(conversationId);
    map['package_id'] = Variable<String>(packageId);
    map['package_name_en'] = Variable<String>(packageNameEn);
    map['package_name_hi'] = Variable<String>(packageNameHi);
    map['slot_date'] = Variable<String>(slotDate);
    map['time_window'] = Variable<String>(timeWindow);
    map['address_label'] = Variable<String>(addressLabel);
    map['patient_name'] = Variable<String>(patientName);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookingsCompanion toCompanion(bool nullToAbsent) {
    return BookingsCompanion(
      bookingRef: Value(bookingRef),
      conversationId: Value(conversationId),
      packageId: Value(packageId),
      packageNameEn: Value(packageNameEn),
      packageNameHi: Value(packageNameHi),
      slotDate: Value(slotDate),
      timeWindow: Value(timeWindow),
      addressLabel: Value(addressLabel),
      patientName: Value(patientName),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Booking(
      bookingRef: serializer.fromJson<String>(json['bookingRef']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      packageId: serializer.fromJson<String>(json['packageId']),
      packageNameEn: serializer.fromJson<String>(json['packageNameEn']),
      packageNameHi: serializer.fromJson<String>(json['packageNameHi']),
      slotDate: serializer.fromJson<String>(json['slotDate']),
      timeWindow: serializer.fromJson<String>(json['timeWindow']),
      addressLabel: serializer.fromJson<String>(json['addressLabel']),
      patientName: serializer.fromJson<String>(json['patientName']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookingRef': serializer.toJson<String>(bookingRef),
      'conversationId': serializer.toJson<String>(conversationId),
      'packageId': serializer.toJson<String>(packageId),
      'packageNameEn': serializer.toJson<String>(packageNameEn),
      'packageNameHi': serializer.toJson<String>(packageNameHi),
      'slotDate': serializer.toJson<String>(slotDate),
      'timeWindow': serializer.toJson<String>(timeWindow),
      'addressLabel': serializer.toJson<String>(addressLabel),
      'patientName': serializer.toJson<String>(patientName),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Booking copyWith({
    String? bookingRef,
    String? conversationId,
    String? packageId,
    String? packageNameEn,
    String? packageNameHi,
    String? slotDate,
    String? timeWindow,
    String? addressLabel,
    String? patientName,
    String? status,
    DateTime? createdAt,
  }) => Booking(
    bookingRef: bookingRef ?? this.bookingRef,
    conversationId: conversationId ?? this.conversationId,
    packageId: packageId ?? this.packageId,
    packageNameEn: packageNameEn ?? this.packageNameEn,
    packageNameHi: packageNameHi ?? this.packageNameHi,
    slotDate: slotDate ?? this.slotDate,
    timeWindow: timeWindow ?? this.timeWindow,
    addressLabel: addressLabel ?? this.addressLabel,
    patientName: patientName ?? this.patientName,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Booking copyWithCompanion(BookingsCompanion data) {
    return Booking(
      bookingRef: data.bookingRef.present ? data.bookingRef.value : this.bookingRef,
      conversationId: data.conversationId.present ? data.conversationId.value : this.conversationId,
      packageId: data.packageId.present ? data.packageId.value : this.packageId,
      packageNameEn: data.packageNameEn.present ? data.packageNameEn.value : this.packageNameEn,
      packageNameHi: data.packageNameHi.present ? data.packageNameHi.value : this.packageNameHi,
      slotDate: data.slotDate.present ? data.slotDate.value : this.slotDate,
      timeWindow: data.timeWindow.present ? data.timeWindow.value : this.timeWindow,
      addressLabel: data.addressLabel.present ? data.addressLabel.value : this.addressLabel,
      patientName: data.patientName.present ? data.patientName.value : this.patientName,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Booking(')
          ..write('bookingRef: $bookingRef, ')
          ..write('conversationId: $conversationId, ')
          ..write('packageId: $packageId, ')
          ..write('packageNameEn: $packageNameEn, ')
          ..write('packageNameHi: $packageNameHi, ')
          ..write('slotDate: $slotDate, ')
          ..write('timeWindow: $timeWindow, ')
          ..write('addressLabel: $addressLabel, ')
          ..write('patientName: $patientName, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bookingRef,
    conversationId,
    packageId,
    packageNameEn,
    packageNameHi,
    slotDate,
    timeWindow,
    addressLabel,
    patientName,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Booking &&
          other.bookingRef == this.bookingRef &&
          other.conversationId == this.conversationId &&
          other.packageId == this.packageId &&
          other.packageNameEn == this.packageNameEn &&
          other.packageNameHi == this.packageNameHi &&
          other.slotDate == this.slotDate &&
          other.timeWindow == this.timeWindow &&
          other.addressLabel == this.addressLabel &&
          other.patientName == this.patientName &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class BookingsCompanion extends UpdateCompanion<Booking> {
  final Value<String> bookingRef;
  final Value<String> conversationId;
  final Value<String> packageId;
  final Value<String> packageNameEn;
  final Value<String> packageNameHi;
  final Value<String> slotDate;
  final Value<String> timeWindow;
  final Value<String> addressLabel;
  final Value<String> patientName;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookingsCompanion({
    this.bookingRef = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.packageId = const Value.absent(),
    this.packageNameEn = const Value.absent(),
    this.packageNameHi = const Value.absent(),
    this.slotDate = const Value.absent(),
    this.timeWindow = const Value.absent(),
    this.addressLabel = const Value.absent(),
    this.patientName = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookingsCompanion.insert({
    required String bookingRef,
    required String conversationId,
    required String packageId,
    required String packageNameEn,
    required String packageNameHi,
    required String slotDate,
    required String timeWindow,
    required String addressLabel,
    required String patientName,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : bookingRef = Value(bookingRef),
       conversationId = Value(conversationId),
       packageId = Value(packageId),
       packageNameEn = Value(packageNameEn),
       packageNameHi = Value(packageNameHi),
       slotDate = Value(slotDate),
       timeWindow = Value(timeWindow),
       addressLabel = Value(addressLabel),
       patientName = Value(patientName),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<Booking> custom({
    Expression<String>? bookingRef,
    Expression<String>? conversationId,
    Expression<String>? packageId,
    Expression<String>? packageNameEn,
    Expression<String>? packageNameHi,
    Expression<String>? slotDate,
    Expression<String>? timeWindow,
    Expression<String>? addressLabel,
    Expression<String>? patientName,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookingRef != null) 'booking_ref': bookingRef,
      if (conversationId != null) 'conversation_id': conversationId,
      if (packageId != null) 'package_id': packageId,
      if (packageNameEn != null) 'package_name_en': packageNameEn,
      if (packageNameHi != null) 'package_name_hi': packageNameHi,
      if (slotDate != null) 'slot_date': slotDate,
      if (timeWindow != null) 'time_window': timeWindow,
      if (addressLabel != null) 'address_label': addressLabel,
      if (patientName != null) 'patient_name': patientName,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookingsCompanion copyWith({
    Value<String>? bookingRef,
    Value<String>? conversationId,
    Value<String>? packageId,
    Value<String>? packageNameEn,
    Value<String>? packageNameHi,
    Value<String>? slotDate,
    Value<String>? timeWindow,
    Value<String>? addressLabel,
    Value<String>? patientName,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BookingsCompanion(
      bookingRef: bookingRef ?? this.bookingRef,
      conversationId: conversationId ?? this.conversationId,
      packageId: packageId ?? this.packageId,
      packageNameEn: packageNameEn ?? this.packageNameEn,
      packageNameHi: packageNameHi ?? this.packageNameHi,
      slotDate: slotDate ?? this.slotDate,
      timeWindow: timeWindow ?? this.timeWindow,
      addressLabel: addressLabel ?? this.addressLabel,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookingRef.present) {
      map['booking_ref'] = Variable<String>(bookingRef.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (packageId.present) {
      map['package_id'] = Variable<String>(packageId.value);
    }
    if (packageNameEn.present) {
      map['package_name_en'] = Variable<String>(packageNameEn.value);
    }
    if (packageNameHi.present) {
      map['package_name_hi'] = Variable<String>(packageNameHi.value);
    }
    if (slotDate.present) {
      map['slot_date'] = Variable<String>(slotDate.value);
    }
    if (timeWindow.present) {
      map['time_window'] = Variable<String>(timeWindow.value);
    }
    if (addressLabel.present) {
      map['address_label'] = Variable<String>(addressLabel.value);
    }
    if (patientName.present) {
      map['patient_name'] = Variable<String>(patientName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingsCompanion(')
          ..write('bookingRef: $bookingRef, ')
          ..write('conversationId: $conversationId, ')
          ..write('packageId: $packageId, ')
          ..write('packageNameEn: $packageNameEn, ')
          ..write('packageNameHi: $packageNameHi, ')
          ..write('slotDate: $slotDate, ')
          ..write('timeWindow: $timeWindow, ')
          ..write('addressLabel: $addressLabel, ')
          ..write('patientName: $patientName, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaData(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaData extends DataClass implements Insertable<AppMetaData> {
  final String key;
  final String value;
  const AppMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetaData copyWith({String? key, String? value}) =>
      AppMetaData(key: key ?? this.key, value: value ?? this.value);
  AppMetaData copyWithCompanion(AppMetaCompanion data) {
    return AppMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaData && other.key == this.key && other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $BookingsTable bookings = $BookingsTable(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [conversations, messages, bookings, appMeta];
  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ConversationsTableCreateCompanionBuilder = ConversationsCompanion Function({
  required String id,
  required String locale,
  Value<String?> title,
  Value<bool> flagged,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ConversationsTableUpdateCompanionBuilder = ConversationsCompanion Function({
  Value<String> id,
  Value<String> locale,
  Value<String?> title,
  Value<bool> flagged,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ConversationsTableReferences
    extends BaseReferences<_$AppDatabase, $ConversationsTable, Conversation> {
  $$ConversationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.messages,
        aliasName: 'conversations__id__messages__conversation_id',
      );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ConversationsTableFilterComposer extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get flagged =>
      $composableBuilder(column: $table.flagged, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> messagesRefs(Expression<bool> Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.conversationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConversationsTableOrderingComposer extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get flagged =>
      $composableBuilder(column: $table.flagged, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConversationsTableAnnotationComposer extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get flagged =>
      $composableBuilder(column: $table.flagged, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.conversationId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTable,
          Conversation,
          $$ConversationsTableFilterComposer,
          $$ConversationsTableOrderingComposer,
          $$ConversationsTableAnnotationComposer,
          $$ConversationsTableCreateCompanionBuilder,
          $$ConversationsTableUpdateCompanionBuilder,
          (Conversation, $$ConversationsTableReferences),
          Conversation,
          PrefetchHooks Function({bool messagesRefs})
        > {
  $$ConversationsTableTableManager(_$AppDatabase db, $ConversationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> flagged = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion(
                id: id,
                locale: locale,
                title: title,
                flagged: flagged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String locale,
                Value<String?> title = const Value.absent(),
                Value<bool> flagged = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion.insert(
                id: id,
                locale: locale,
                title: title,
                flagged: flagged,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConversationsTable, Conversation>(table),
                  $$ConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedDataByColumns<
                      Conversation,
                      $ConversationsTable,
                      Message,
                      $MessagesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ConversationsTableReferences._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ConversationsTableReferences(db, table, p0).messagesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'conversation_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTable,
      Conversation,
      $$ConversationsTableFilterComposer,
      $$ConversationsTableOrderingComposer,
      $$ConversationsTableAnnotationComposer,
      $$ConversationsTableCreateCompanionBuilder,
      $$ConversationsTableUpdateCompanionBuilder,
      (Conversation, $$ConversationsTableReferences),
      Conversation,
      PrefetchHooks Function({bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String conversationId,
  required MessageRole role,
  Value<MessageKind> kind,
  Value<String> locale,
  Value<String> body,
  Value<String?> display,
  Value<List<ChatCard>> cards,
  required MessageStatus status,
  Value<String?> replyTo,
  Value<String?> activeTool,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> error,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> conversationId,
  Value<MessageRole> role,
  Value<MessageKind> kind,
  Value<String> locale,
  Value<String> body,
  Value<String?> display,
  Value<List<ChatCard>> cards,
  Value<MessageStatus> status,
  Value<String?> replyTo,
  Value<String?> activeTool,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> error,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.conversations.createAlias('messages__conversation_id__conversations__id');

  $$ConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ConversationsTableTableManager(
      $_db,
      $_db.conversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessagesTableFilterComposer extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MessageRole, MessageRole, String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MessageKind, MessageKind, String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get display =>
      $composableBuilder(column: $table.display, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<ChatCard>, List<ChatCard>, String> get cards =>
      $composableBuilder(
        column: $table.cards,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<MessageStatus, MessageStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get replyTo =>
      $composableBuilder(column: $table.replyTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeTool =>
      $composableBuilder(column: $table.activeTool, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt =>
      $composableBuilder(column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ConversationsTableFilterComposer get conversationId {
    final $$ConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ConversationsTableFilterComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableOrderingComposer extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get display =>
      $composableBuilder(column: $table.display, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cards =>
      $composableBuilder(column: $table.cards, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyTo =>
      $composableBuilder(column: $table.replyTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeTool =>
      $composableBuilder(column: $table.activeTool, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ConversationsTableOrderingComposer get conversationId {
    final $$ConversationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ConversationsTableOrderingComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get display =>
      $composableBuilder(column: $table.display, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<ChatCard>, String> get cards =>
      $composableBuilder(column: $table.cards, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get replyTo =>
      $composableBuilder(column: $table.replyTo, builder: (column) => column);

  GeneratedColumn<String> get activeTool =>
      $composableBuilder(column: $table.activeTool, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt =>
      $composableBuilder(column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ConversationsTableAnnotationComposer get conversationId {
    final $$ConversationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversations,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ConversationsTableAnnotationComposer(
            $db: $db,
            $table: $db.conversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, $$MessagesTableReferences),
          Message,
          PrefetchHooks Function({bool conversationId})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<MessageRole> role = const Value.absent(),
                Value<MessageKind> kind = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> display = const Value.absent(),
                Value<List<ChatCard>> cards = const Value.absent(),
                Value<MessageStatus> status = const Value.absent(),
                Value<String?> replyTo = const Value.absent(),
                Value<String?> activeTool = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                kind: kind,
                locale: locale,
                body: body,
                display: display,
                cards: cards,
                status: status,
                replyTo: replyTo,
                activeTool: activeTool,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                error: error,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required MessageRole role,
                Value<MessageKind> kind = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> display = const Value.absent(),
                Value<List<ChatCard>> cards = const Value.absent(),
                required MessageStatus status,
                Value<String?> replyTo = const Value.absent(),
                Value<String?> activeTool = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                kind: kind,
                locale: locale,
                body: body,
                display: display,
                cards: cards,
                status: status,
                replyTo: replyTo,
                activeTool: activeTool,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                error: error,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, Message>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.conversationId,
                        referencedTable: $$MessagesTableReferences._conversationIdTable(db),
                        referencedColumn: $$MessagesTableReferences._conversationIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, $$MessagesTableReferences),
      Message,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$BookingsTableCreateCompanionBuilder = BookingsCompanion Function({
  required String bookingRef,
  required String conversationId,
  required String packageId,
  required String packageNameEn,
  required String packageNameHi,
  required String slotDate,
  required String timeWindow,
  required String addressLabel,
  required String patientName,
  required String status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookingsTableUpdateCompanionBuilder = BookingsCompanion Function({
  Value<String> bookingRef,
  Value<String> conversationId,
  Value<String> packageId,
  Value<String> packageNameEn,
  Value<String> packageNameHi,
  Value<String> slotDate,
  Value<String> timeWindow,
  Value<String> addressLabel,
  Value<String> patientName,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$BookingsTableFilterComposer extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bookingRef =>
      $composableBuilder(column: $table.bookingRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId =>
      $composableBuilder(column: $table.conversationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packageNameEn =>
      $composableBuilder(column: $table.packageNameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packageNameHi =>
      $composableBuilder(column: $table.packageNameHi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slotDate =>
      $composableBuilder(column: $table.slotDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeWindow =>
      $composableBuilder(column: $table.timeWindow, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressLabel =>
      $composableBuilder(column: $table.addressLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientName =>
      $composableBuilder(column: $table.patientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BookingsTableOrderingComposer extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bookingRef =>
      $composableBuilder(column: $table.bookingRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packageNameEn => $composableBuilder(
    column: $table.packageNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageNameHi => $composableBuilder(
    column: $table.packageNameHi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotDate =>
      $composableBuilder(column: $table.slotDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeWindow =>
      $composableBuilder(column: $table.timeWindow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressLabel =>
      $composableBuilder(column: $table.addressLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientName =>
      $composableBuilder(column: $table.patientName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BookingsTableAnnotationComposer extends Composer<_$AppDatabase, $BookingsTable> {
  $$BookingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bookingRef =>
      $composableBuilder(column: $table.bookingRef, builder: (column) => column);

  GeneratedColumn<String> get conversationId =>
      $composableBuilder(column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<String> get packageId =>
      $composableBuilder(column: $table.packageId, builder: (column) => column);

  GeneratedColumn<String> get packageNameEn =>
      $composableBuilder(column: $table.packageNameEn, builder: (column) => column);

  GeneratedColumn<String> get packageNameHi =>
      $composableBuilder(column: $table.packageNameHi, builder: (column) => column);

  GeneratedColumn<String> get slotDate =>
      $composableBuilder(column: $table.slotDate, builder: (column) => column);

  GeneratedColumn<String> get timeWindow =>
      $composableBuilder(column: $table.timeWindow, builder: (column) => column);

  GeneratedColumn<String> get addressLabel =>
      $composableBuilder(column: $table.addressLabel, builder: (column) => column);

  GeneratedColumn<String> get patientName =>
      $composableBuilder(column: $table.patientName, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookingsTable,
          Booking,
          $$BookingsTableFilterComposer,
          $$BookingsTableOrderingComposer,
          $$BookingsTableAnnotationComposer,
          $$BookingsTableCreateCompanionBuilder,
          $$BookingsTableUpdateCompanionBuilder,
          (Booking, BaseReferences<_$AppDatabase, $BookingsTable, Booking>),
          Booking,
          PrefetchHooks Function()
        > {
  $$BookingsTableTableManager(_$AppDatabase db, $BookingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BookingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BookingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bookingRef = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> packageId = const Value.absent(),
                Value<String> packageNameEn = const Value.absent(),
                Value<String> packageNameHi = const Value.absent(),
                Value<String> slotDate = const Value.absent(),
                Value<String> timeWindow = const Value.absent(),
                Value<String> addressLabel = const Value.absent(),
                Value<String> patientName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookingsCompanion(
                bookingRef: bookingRef,
                conversationId: conversationId,
                packageId: packageId,
                packageNameEn: packageNameEn,
                packageNameHi: packageNameHi,
                slotDate: slotDate,
                timeWindow: timeWindow,
                addressLabel: addressLabel,
                patientName: patientName,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookingRef,
                required String conversationId,
                required String packageId,
                required String packageNameEn,
                required String packageNameHi,
                required String slotDate,
                required String timeWindow,
                required String addressLabel,
                required String patientName,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BookingsCompanion.insert(
                bookingRef: bookingRef,
                conversationId: conversationId,
                packageId: packageId,
                packageNameEn: packageNameEn,
                packageNameHi: packageNameHi,
                slotDate: slotDate,
                timeWindow: timeWindow,
                addressLabel: addressLabel,
                patientName: patientName,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookingsTable, Booking>(table),
                  BaseReferences<_$AppDatabase, $BookingsTable, Booking>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookingsTable,
      Booking,
      $$BookingsTableFilterComposer,
      $$BookingsTableOrderingComposer,
      $$BookingsTableAnnotationComposer,
      $$BookingsTableCreateCompanionBuilder,
      $$BookingsTableUpdateCompanionBuilder,
      (Booking, BaseReferences<_$AppDatabase, $BookingsTable, Booking>),
      Booking,
      PrefetchHooks Function()
    >;
typedef $$AppMetaTableCreateCompanionBuilder = AppMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppMetaTableUpdateCompanionBuilder = AppMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppMetaTableFilterComposer extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppMetaTableOrderingComposer extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppMetaTableAnnotationComposer extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaData,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (AppMetaData, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>),
          AppMetaData,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppMetaTable, AppMetaData>(table),
                  BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaData,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaData, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>),
      AppMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$MessagesTableTableManager get messages => $$MessagesTableTableManager(_db, _db.messages);
  $$BookingsTableTableManager get bookings => $$BookingsTableTableManager(_db, _db.bookings);
  $$AppMetaTableTableManager get appMeta => $$AppMetaTableTableManager(_db, _db.appMeta);
}
