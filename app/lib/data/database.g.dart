// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalOwnersTable extends LocalOwners
    with TableInfo<$LocalOwnersTable, LocalOwner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalOwnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDexNumberMeta = const VerificationMeta(
    'nextDexNumber',
  );
  @override
  late final GeneratedColumn<int> nextDexNumber = GeneratedColumn<int>(
    'next_dex_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nextDexNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_owners';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalOwner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('next_dex_number')) {
      context.handle(
        _nextDexNumberMeta,
        nextDexNumber.isAcceptableOrUnknown(
          data['next_dex_number']!,
          _nextDexNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalOwner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalOwner(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nextDexNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_dex_number'],
      )!,
    );
  }

  @override
  $LocalOwnersTable createAlias(String alias) {
    return $LocalOwnersTable(attachedDatabase, alias);
  }
}

class LocalOwner extends DataClass implements Insertable<LocalOwner> {
  final String id;
  final int nextDexNumber;
  const LocalOwner({required this.id, required this.nextDexNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['next_dex_number'] = Variable<int>(nextDexNumber);
    return map;
  }

  LocalOwnersCompanion toCompanion(bool nullToAbsent) {
    return LocalOwnersCompanion(
      id: Value(id),
      nextDexNumber: Value(nextDexNumber),
    );
  }

  factory LocalOwner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalOwner(
      id: serializer.fromJson<String>(json['id']),
      nextDexNumber: serializer.fromJson<int>(json['nextDexNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nextDexNumber': serializer.toJson<int>(nextDexNumber),
    };
  }

  LocalOwner copyWith({String? id, int? nextDexNumber}) => LocalOwner(
    id: id ?? this.id,
    nextDexNumber: nextDexNumber ?? this.nextDexNumber,
  );
  LocalOwner copyWithCompanion(LocalOwnersCompanion data) {
    return LocalOwner(
      id: data.id.present ? data.id.value : this.id,
      nextDexNumber: data.nextDexNumber.present
          ? data.nextDexNumber.value
          : this.nextDexNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalOwner(')
          ..write('id: $id, ')
          ..write('nextDexNumber: $nextDexNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nextDexNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalOwner &&
          other.id == this.id &&
          other.nextDexNumber == this.nextDexNumber);
}

class LocalOwnersCompanion extends UpdateCompanion<LocalOwner> {
  final Value<String> id;
  final Value<int> nextDexNumber;
  final Value<int> rowid;
  const LocalOwnersCompanion({
    this.id = const Value.absent(),
    this.nextDexNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalOwnersCompanion.insert({
    required String id,
    this.nextDexNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<LocalOwner> custom({
    Expression<String>? id,
    Expression<int>? nextDexNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nextDexNumber != null) 'next_dex_number': nextDexNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalOwnersCompanion copyWith({
    Value<String>? id,
    Value<int>? nextDexNumber,
    Value<int>? rowid,
  }) {
    return LocalOwnersCompanion(
      id: id ?? this.id,
      nextDexNumber: nextDexNumber ?? this.nextDexNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nextDexNumber.present) {
      map['next_dex_number'] = Variable<int>(nextDexNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalOwnersCompanion(')
          ..write('id: $id, ')
          ..write('nextDexNumber: $nextDexNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatsTable extends Cats with TableInfo<$CatsTable, CatRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_owners (id)',
    ),
  );
  static const VerificationMeta _dexNumberMeta = const VerificationMeta(
    'dexNumber',
  );
  @override
  late final GeneratedColumn<int> dexNumber = GeneratedColumn<int>(
    'dex_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coatColorMeta = const VerificationMeta(
    'coatColor',
  );
  @override
  late final GeneratedColumn<String> coatColor = GeneratedColumn<String>(
    'coat_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    dexNumber,
    name,
    coatColor,
    pattern,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cats';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('dex_number')) {
      context.handle(
        _dexNumberMeta,
        dexNumber.isAcceptableOrUnknown(data['dex_number']!, _dexNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_dexNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('coat_color')) {
      context.handle(
        _coatColorMeta,
        coatColor.isAcceptableOrUnknown(data['coat_color']!, _coatColorMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {ownerId, dexNumber},
  ];
  @override
  CatRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      dexNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dex_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      coatColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coat_color'],
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $CatsTable createAlias(String alias) {
    return $CatsTable(attachedDatabase, alias);
  }
}

class CatRecord extends DataClass implements Insertable<CatRecord> {
  final String id;
  final String ownerId;
  final int dexNumber;
  final String? name;
  final String? coatColor;
  final String? pattern;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool dirty;
  const CatRecord({
    required this.id,
    required this.ownerId,
    required this.dexNumber,
    this.name,
    this.coatColor,
    this.pattern,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['dex_number'] = Variable<int>(dexNumber);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || coatColor != null) {
      map['coat_color'] = Variable<String>(coatColor);
    }
    if (!nullToAbsent || pattern != null) {
      map['pattern'] = Variable<String>(pattern);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  CatsCompanion toCompanion(bool nullToAbsent) {
    return CatsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      dexNumber: Value(dexNumber),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      coatColor: coatColor == null && nullToAbsent
          ? const Value.absent()
          : Value(coatColor),
      pattern: pattern == null && nullToAbsent
          ? const Value.absent()
          : Value(pattern),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
    );
  }

  factory CatRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatRecord(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      dexNumber: serializer.fromJson<int>(json['dexNumber']),
      name: serializer.fromJson<String?>(json['name']),
      coatColor: serializer.fromJson<String?>(json['coatColor']),
      pattern: serializer.fromJson<String?>(json['pattern']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'dexNumber': serializer.toJson<int>(dexNumber),
      'name': serializer.toJson<String?>(name),
      'coatColor': serializer.toJson<String?>(coatColor),
      'pattern': serializer.toJson<String?>(pattern),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  CatRecord copyWith({
    String? id,
    String? ownerId,
    int? dexNumber,
    Value<String?> name = const Value.absent(),
    Value<String?> coatColor = const Value.absent(),
    Value<String?> pattern = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? dirty,
  }) => CatRecord(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    dexNumber: dexNumber ?? this.dexNumber,
    name: name.present ? name.value : this.name,
    coatColor: coatColor.present ? coatColor.value : this.coatColor,
    pattern: pattern.present ? pattern.value : this.pattern,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dirty: dirty ?? this.dirty,
  );
  CatRecord copyWithCompanion(CatsCompanion data) {
    return CatRecord(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      dexNumber: data.dexNumber.present ? data.dexNumber.value : this.dexNumber,
      name: data.name.present ? data.name.value : this.name,
      coatColor: data.coatColor.present ? data.coatColor.value : this.coatColor,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatRecord(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('dexNumber: $dexNumber, ')
          ..write('name: $name, ')
          ..write('coatColor: $coatColor, ')
          ..write('pattern: $pattern, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    dexNumber,
    name,
    coatColor,
    pattern,
    notes,
    createdAt,
    updatedAt,
    deletedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatRecord &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.dexNumber == this.dexNumber &&
          other.name == this.name &&
          other.coatColor == this.coatColor &&
          other.pattern == this.pattern &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty);
}

class CatsCompanion extends UpdateCompanion<CatRecord> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<int> dexNumber;
  final Value<String?> name;
  final Value<String?> coatColor;
  final Value<String?> pattern;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const CatsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.dexNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.coatColor = const Value.absent(),
    this.pattern = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatsCompanion.insert({
    required String id,
    required String ownerId,
    required int dexNumber,
    this.name = const Value.absent(),
    this.coatColor = const Value.absent(),
    this.pattern = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       dexNumber = Value(dexNumber),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CatRecord> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<int>? dexNumber,
    Expression<String>? name,
    Expression<String>? coatColor,
    Expression<String>? pattern,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (dexNumber != null) 'dex_number': dexNumber,
      if (name != null) 'name': name,
      if (coatColor != null) 'coat_color': coatColor,
      if (pattern != null) 'pattern': pattern,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<int>? dexNumber,
    Value<String?>? name,
    Value<String?>? coatColor,
    Value<String?>? pattern,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return CatsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      dexNumber: dexNumber ?? this.dexNumber,
      name: name ?? this.name,
      coatColor: coatColor ?? this.coatColor,
      pattern: pattern ?? this.pattern,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (dexNumber.present) {
      map['dex_number'] = Variable<int>(dexNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coatColor.present) {
      map['coat_color'] = Variable<String>(coatColor.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('dexNumber: $dexNumber, ')
          ..write('name: $name, ')
          ..write('coatColor: $coatColor, ')
          ..write('pattern: $pattern, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SightingsTable extends Sightings
    with TableInfo<$SightingsTable, SightingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SightingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cats (id)',
    ),
  );
  static const VerificationMeta _seenAtMeta = const VerificationMeta('seenAt');
  @override
  late final GeneratedColumn<DateTime> seenAt = GeneratedColumn<DateTime>(
    'seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    seenAt,
    lat,
    lng,
    placeName,
    countryCode,
    note,
    updatedAt,
    deletedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sightings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SightingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('seen_at')) {
      context.handle(
        _seenAtMeta,
        seenAt.isAcceptableOrUnknown(data['seen_at']!, _seenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_seenAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SightingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SightingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      )!,
      seenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}seen_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $SightingsTable createAlias(String alias) {
    return $SightingsTable(attachedDatabase, alias);
  }
}

class SightingRecord extends DataClass implements Insertable<SightingRecord> {
  final String id;
  final String catId;
  final DateTime seenAt;
  final double? lat;
  final double? lng;
  final String? placeName;
  final String? countryCode;
  final String? note;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool dirty;
  const SightingRecord({
    required this.id,
    required this.catId,
    required this.seenAt,
    this.lat,
    this.lng,
    this.placeName,
    this.countryCode,
    this.note,
    required this.updatedAt,
    this.deletedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cat_id'] = Variable<String>(catId);
    map['seen_at'] = Variable<DateTime>(seenAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || placeName != null) {
      map['place_name'] = Variable<String>(placeName);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  SightingsCompanion toCompanion(bool nullToAbsent) {
    return SightingsCompanion(
      id: Value(id),
      catId: Value(catId),
      seenAt: Value(seenAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      placeName: placeName == null && nullToAbsent
          ? const Value.absent()
          : Value(placeName),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
    );
  }

  factory SightingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SightingRecord(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String>(json['catId']),
      seenAt: serializer.fromJson<DateTime>(json['seenAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      placeName: serializer.fromJson<String?>(json['placeName']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String>(catId),
      'seenAt': serializer.toJson<DateTime>(seenAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'placeName': serializer.toJson<String?>(placeName),
      'countryCode': serializer.toJson<String?>(countryCode),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  SightingRecord copyWith({
    String? id,
    String? catId,
    DateTime? seenAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<String?> placeName = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? dirty,
  }) => SightingRecord(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    seenAt: seenAt ?? this.seenAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    placeName: placeName.present ? placeName.value : this.placeName,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dirty: dirty ?? this.dirty,
  );
  SightingRecord copyWithCompanion(SightingsCompanion data) {
    return SightingRecord(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      seenAt: data.seenAt.present ? data.seenAt.value : this.seenAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SightingRecord(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('seenAt: $seenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('placeName: $placeName, ')
          ..write('countryCode: $countryCode, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    seenAt,
    lat,
    lng,
    placeName,
    countryCode,
    note,
    updatedAt,
    deletedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SightingRecord &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.seenAt == this.seenAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.placeName == this.placeName &&
          other.countryCode == this.countryCode &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty);
}

class SightingsCompanion extends UpdateCompanion<SightingRecord> {
  final Value<String> id;
  final Value<String> catId;
  final Value<DateTime> seenAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> placeName;
  final Value<String?> countryCode;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const SightingsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.seenAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.placeName = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SightingsCompanion.insert({
    required String id,
    required String catId,
    required DateTime seenAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.placeName = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catId = Value(catId),
       seenAt = Value(seenAt),
       updatedAt = Value(updatedAt);
  static Insertable<SightingRecord> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<DateTime>? seenAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? placeName,
    Expression<String>? countryCode,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (seenAt != null) 'seen_at': seenAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (placeName != null) 'place_name': placeName,
      if (countryCode != null) 'country_code': countryCode,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SightingsCompanion copyWith({
    Value<String>? id,
    Value<String>? catId,
    Value<DateTime>? seenAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String?>? placeName,
    Value<String?>? countryCode,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return SightingsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      seenAt: seenAt ?? this.seenAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      placeName: placeName ?? this.placeName,
      countryCode: countryCode ?? this.countryCode,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (seenAt.present) {
      map['seen_at'] = Variable<DateTime>(seenAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SightingsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('seenAt: $seenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('placeName: $placeName, ')
          ..write('countryCode: $countryCode, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, PhotoRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sightingIdMeta = const VerificationMeta(
    'sightingId',
  );
  @override
  late final GeneratedColumn<String> sightingId = GeneratedColumn<String>(
    'sighting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sightings (id)',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storageKeyMeta = const VerificationMeta(
    'storageKey',
  );
  @override
  late final GeneratedColumn<String> storageKey = GeneratedColumn<String>(
    'storage_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blurhashMeta = const VerificationMeta(
    'blurhash',
  );
  @override
  late final GeneratedColumn<String> blurhash = GeneratedColumn<String>(
    'blurhash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sightingId,
    localPath,
    storageKey,
    width,
    height,
    blurhash,
    updatedAt,
    deletedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhotoRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sighting_id')) {
      context.handle(
        _sightingIdMeta,
        sightingId.isAcceptableOrUnknown(data['sighting_id']!, _sightingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sightingIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('storage_key')) {
      context.handle(
        _storageKeyMeta,
        storageKey.isAcceptableOrUnknown(data['storage_key']!, _storageKeyMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('blurhash')) {
      context.handle(
        _blurhashMeta,
        blurhash.isAcceptableOrUnknown(data['blurhash']!, _blurhashMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sightingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sighting_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      storageKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_key'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      blurhash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blurhash'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class PhotoRecord extends DataClass implements Insertable<PhotoRecord> {
  final String id;
  final String sightingId;
  final String localPath;
  final String? storageKey;
  final int width;
  final int height;
  final String? blurhash;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool dirty;
  const PhotoRecord({
    required this.id,
    required this.sightingId,
    required this.localPath,
    this.storageKey,
    required this.width,
    required this.height,
    this.blurhash,
    required this.updatedAt,
    this.deletedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sighting_id'] = Variable<String>(sightingId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || storageKey != null) {
      map['storage_key'] = Variable<String>(storageKey);
    }
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    if (!nullToAbsent || blurhash != null) {
      map['blurhash'] = Variable<String>(blurhash);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      sightingId: Value(sightingId),
      localPath: Value(localPath),
      storageKey: storageKey == null && nullToAbsent
          ? const Value.absent()
          : Value(storageKey),
      width: Value(width),
      height: Value(height),
      blurhash: blurhash == null && nullToAbsent
          ? const Value.absent()
          : Value(blurhash),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
    );
  }

  factory PhotoRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoRecord(
      id: serializer.fromJson<String>(json['id']),
      sightingId: serializer.fromJson<String>(json['sightingId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      storageKey: serializer.fromJson<String?>(json['storageKey']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      blurhash: serializer.fromJson<String?>(json['blurhash']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sightingId': serializer.toJson<String>(sightingId),
      'localPath': serializer.toJson<String>(localPath),
      'storageKey': serializer.toJson<String?>(storageKey),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'blurhash': serializer.toJson<String?>(blurhash),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  PhotoRecord copyWith({
    String? id,
    String? sightingId,
    String? localPath,
    Value<String?> storageKey = const Value.absent(),
    int? width,
    int? height,
    Value<String?> blurhash = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? dirty,
  }) => PhotoRecord(
    id: id ?? this.id,
    sightingId: sightingId ?? this.sightingId,
    localPath: localPath ?? this.localPath,
    storageKey: storageKey.present ? storageKey.value : this.storageKey,
    width: width ?? this.width,
    height: height ?? this.height,
    blurhash: blurhash.present ? blurhash.value : this.blurhash,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dirty: dirty ?? this.dirty,
  );
  PhotoRecord copyWithCompanion(PhotosCompanion data) {
    return PhotoRecord(
      id: data.id.present ? data.id.value : this.id,
      sightingId: data.sightingId.present
          ? data.sightingId.value
          : this.sightingId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      storageKey: data.storageKey.present
          ? data.storageKey.value
          : this.storageKey,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      blurhash: data.blurhash.present ? data.blurhash.value : this.blurhash,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoRecord(')
          ..write('id: $id, ')
          ..write('sightingId: $sightingId, ')
          ..write('localPath: $localPath, ')
          ..write('storageKey: $storageKey, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('blurhash: $blurhash, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sightingId,
    localPath,
    storageKey,
    width,
    height,
    blurhash,
    updatedAt,
    deletedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoRecord &&
          other.id == this.id &&
          other.sightingId == this.sightingId &&
          other.localPath == this.localPath &&
          other.storageKey == this.storageKey &&
          other.width == this.width &&
          other.height == this.height &&
          other.blurhash == this.blurhash &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty);
}

class PhotosCompanion extends UpdateCompanion<PhotoRecord> {
  final Value<String> id;
  final Value<String> sightingId;
  final Value<String> localPath;
  final Value<String?> storageKey;
  final Value<int> width;
  final Value<int> height;
  final Value<String?> blurhash;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.sightingId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.storageKey = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.blurhash = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required String sightingId,
    required String localPath,
    this.storageKey = const Value.absent(),
    required int width,
    required int height,
    this.blurhash = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sightingId = Value(sightingId),
       localPath = Value(localPath),
       width = Value(width),
       height = Value(height),
       updatedAt = Value(updatedAt);
  static Insertable<PhotoRecord> custom({
    Expression<String>? id,
    Expression<String>? sightingId,
    Expression<String>? localPath,
    Expression<String>? storageKey,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? blurhash,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sightingId != null) 'sighting_id': sightingId,
      if (localPath != null) 'local_path': localPath,
      if (storageKey != null) 'storage_key': storageKey,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (blurhash != null) 'blurhash': blurhash,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? sightingId,
    Value<String>? localPath,
    Value<String?>? storageKey,
    Value<int>? width,
    Value<int>? height,
    Value<String?>? blurhash,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      sightingId: sightingId ?? this.sightingId,
      localPath: localPath ?? this.localPath,
      storageKey: storageKey ?? this.storageKey,
      width: width ?? this.width,
      height: height ?? this.height,
      blurhash: blurhash ?? this.blurhash,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sightingId.present) {
      map['sighting_id'] = Variable<String>(sightingId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (storageKey.present) {
      map['storage_key'] = Variable<String>(storageKey.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (blurhash.present) {
      map['blurhash'] = Variable<String>(blurhash.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('sightingId: $sightingId, ')
          ..write('localPath: $localPath, ')
          ..write('storageKey: $storageKey, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('blurhash: $blurhash, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalOwnersTable localOwners = $LocalOwnersTable(this);
  late final $CatsTable cats = $CatsTable(this);
  late final $SightingsTable sightings = $SightingsTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localOwners,
    cats,
    sightings,
    photos,
  ];
}

typedef $$LocalOwnersTableCreateCompanionBuilder =
    LocalOwnersCompanion Function({
      required String id,
      Value<int> nextDexNumber,
      Value<int> rowid,
    });
typedef $$LocalOwnersTableUpdateCompanionBuilder =
    LocalOwnersCompanion Function({
      Value<String> id,
      Value<int> nextDexNumber,
      Value<int> rowid,
    });

final class $$LocalOwnersTableReferences
    extends BaseReferences<_$AppDatabase, $LocalOwnersTable, LocalOwner> {
  $$LocalOwnersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CatsTable, List<CatRecord>> _catsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cats,
    aliasName: 'local_owners__id__cats__owner_id',
  );

  $$CatsTableProcessedTableManager get catsRefs {
    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_catsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalOwnersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalOwnersTable> {
  $$LocalOwnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextDexNumber => $composableBuilder(
    column: $table.nextDexNumber,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> catsRefs(
    Expression<bool> Function($$CatsTableFilterComposer f) f,
  ) {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalOwnersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalOwnersTable> {
  $$LocalOwnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextDexNumber => $composableBuilder(
    column: $table.nextDexNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalOwnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalOwnersTable> {
  $$LocalOwnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get nextDexNumber => $composableBuilder(
    column: $table.nextDexNumber,
    builder: (column) => column,
  );

  Expression<T> catsRefs<T extends Object>(
    Expression<T> Function($$CatsTableAnnotationComposer a) f,
  ) {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalOwnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalOwnersTable,
          LocalOwner,
          $$LocalOwnersTableFilterComposer,
          $$LocalOwnersTableOrderingComposer,
          $$LocalOwnersTableAnnotationComposer,
          $$LocalOwnersTableCreateCompanionBuilder,
          $$LocalOwnersTableUpdateCompanionBuilder,
          (LocalOwner, $$LocalOwnersTableReferences),
          LocalOwner,
          PrefetchHooks Function({bool catsRefs})
        > {
  $$LocalOwnersTableTableManager(_$AppDatabase db, $LocalOwnersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalOwnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalOwnersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalOwnersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> nextDexNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalOwnersCompanion(
                id: id,
                nextDexNumber: nextDexNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> nextDexNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalOwnersCompanion.insert(
                id: id,
                nextDexNumber: nextDexNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalOwnersTable, LocalOwner>(table),
                  $$LocalOwnersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (catsRefs) db.cats],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (catsRefs)
                    await $_getPrefetchedData<
                      LocalOwner,
                      $LocalOwnersTable,
                      CatRecord
                    >(
                      currentTable: table,
                      referencedTable: $$LocalOwnersTableReferences
                          ._catsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocalOwnersTableReferences(db, table, p0).catsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ownerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocalOwnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalOwnersTable,
      LocalOwner,
      $$LocalOwnersTableFilterComposer,
      $$LocalOwnersTableOrderingComposer,
      $$LocalOwnersTableAnnotationComposer,
      $$LocalOwnersTableCreateCompanionBuilder,
      $$LocalOwnersTableUpdateCompanionBuilder,
      (LocalOwner, $$LocalOwnersTableReferences),
      LocalOwner,
      PrefetchHooks Function({bool catsRefs})
    >;
typedef $$CatsTableCreateCompanionBuilder = CatsCompanion Function({
  required String id,
  required String ownerId,
  required int dexNumber,
  Value<String?> name,
  Value<String?> coatColor,
  Value<String?> pattern,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});
typedef $$CatsTableUpdateCompanionBuilder = CatsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<int> dexNumber,
  Value<String?> name,
  Value<String?> coatColor,
  Value<String?> pattern,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});

final class $$CatsTableReferences
    extends BaseReferences<_$AppDatabase, $CatsTable, CatRecord> {
  $$CatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocalOwnersTable _ownerIdTable(_$AppDatabase db) =>
      db.localOwners.createAlias('cats__owner_id__local_owners__id');

  $$LocalOwnersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<String>('owner_id')!;

    final manager = $$LocalOwnersTableTableManager(
      $_db,
      $_db.localOwners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SightingsTable, List<SightingRecord>>
  _sightingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sightings,
    aliasName: 'cats__id__sightings__cat_id',
  );

  $$SightingsTableProcessedTableManager get sightingsRefs {
    final manager = $$SightingsTableTableManager(
      $_db,
      $_db.sightings,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sightingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatsTableFilterComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dexNumber => $composableBuilder(
    column: $table.dexNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coatColor => $composableBuilder(
    column: $table.coatColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalOwnersTableFilterComposer get ownerId {
    final $$LocalOwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.localOwners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalOwnersTableFilterComposer(
            $db: $db,
            $table: $db.localOwners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sightingsRefs(
    Expression<bool> Function($$SightingsTableFilterComposer f) f,
  ) {
    final $$SightingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sightings,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SightingsTableFilterComposer(
            $db: $db,
            $table: $db.sightings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatsTableOrderingComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dexNumber => $composableBuilder(
    column: $table.dexNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coatColor => $composableBuilder(
    column: $table.coatColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalOwnersTableOrderingComposer get ownerId {
    final $$LocalOwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.localOwners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalOwnersTableOrderingComposer(
            $db: $db,
            $table: $db.localOwners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dexNumber =>
      $composableBuilder(column: $table.dexNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coatColor =>
      $composableBuilder(column: $table.coatColor, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  $$LocalOwnersTableAnnotationComposer get ownerId {
    final $$LocalOwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.localOwners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalOwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.localOwners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sightingsRefs<T extends Object>(
    Expression<T> Function($$SightingsTableAnnotationComposer a) f,
  ) {
    final $$SightingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sightings,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SightingsTableAnnotationComposer(
            $db: $db,
            $table: $db.sightings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatsTable,
          CatRecord,
          $$CatsTableFilterComposer,
          $$CatsTableOrderingComposer,
          $$CatsTableAnnotationComposer,
          $$CatsTableCreateCompanionBuilder,
          $$CatsTableUpdateCompanionBuilder,
          (CatRecord, $$CatsTableReferences),
          CatRecord,
          PrefetchHooks Function({bool ownerId, bool sightingsRefs})
        > {
  $$CatsTableTableManager(_$AppDatabase db, $CatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<int> dexNumber = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> coatColor = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatsCompanion(
                id: id,
                ownerId: ownerId,
                dexNumber: dexNumber,
                name: name,
                coatColor: coatColor,
                pattern: pattern,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required int dexNumber,
                Value<String?> name = const Value.absent(),
                Value<String?> coatColor = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatsCompanion.insert(
                id: id,
                ownerId: ownerId,
                dexNumber: dexNumber,
                name: name,
                coatColor: coatColor,
                pattern: pattern,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatsTable, CatRecord>(table),
                  $$CatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ownerId = false, sightingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sightingsRefs) db.sightings],
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
                    if (ownerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ownerId,
                        referencedTable: $$CatsTableReferences._ownerIdTable(
                          db,
                        ),
                        referencedColumn: $$CatsTableReferences
                            ._ownerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sightingsRefs)
                    await $_getPrefetchedData<
                      CatRecord,
                      $CatsTable,
                      SightingRecord
                    >(
                      currentTable: table,
                      referencedTable: $$CatsTableReferences
                          ._sightingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CatsTableReferences(db, table, p0).sightingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.catId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatsTable,
      CatRecord,
      $$CatsTableFilterComposer,
      $$CatsTableOrderingComposer,
      $$CatsTableAnnotationComposer,
      $$CatsTableCreateCompanionBuilder,
      $$CatsTableUpdateCompanionBuilder,
      (CatRecord, $$CatsTableReferences),
      CatRecord,
      PrefetchHooks Function({bool ownerId, bool sightingsRefs})
    >;
typedef $$SightingsTableCreateCompanionBuilder = SightingsCompanion Function({
  required String id,
  required String catId,
  required DateTime seenAt,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> placeName,
  Value<String?> countryCode,
  Value<String?> note,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});
typedef $$SightingsTableUpdateCompanionBuilder = SightingsCompanion Function({
  Value<String> id,
  Value<String> catId,
  Value<DateTime> seenAt,
  Value<double?> lat,
  Value<double?> lng,
  Value<String?> placeName,
  Value<String?> countryCode,
  Value<String?> note,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});

final class $$SightingsTableReferences
    extends BaseReferences<_$AppDatabase, $SightingsTable, SightingRecord> {
  $$SightingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatsTable _catIdTable(_$AppDatabase db) =>
      db.cats.createAlias('sightings__cat_id__cats__id');

  $$CatsTableProcessedTableManager get catId {
    final $_column = $_itemColumn<String>('cat_id')!;

    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<PhotoRecord>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'sightings__id__photos__sighting_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.sightingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SightingsTableFilterComposer
    extends Composer<_$AppDatabase, $SightingsTable> {
  $$SightingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  $$CatsTableFilterComposer get catId {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.sightingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SightingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SightingsTable> {
  $$SightingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get seenAt => $composableBuilder(
    column: $table.seenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatsTableOrderingComposer get catId {
    final $$CatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableOrderingComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SightingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SightingsTable> {
  $$SightingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get seenAt =>
      $composableBuilder(column: $table.seenAt, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  $$CatsTableAnnotationComposer get catId {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.sightingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SightingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SightingsTable,
          SightingRecord,
          $$SightingsTableFilterComposer,
          $$SightingsTableOrderingComposer,
          $$SightingsTableAnnotationComposer,
          $$SightingsTableCreateCompanionBuilder,
          $$SightingsTableUpdateCompanionBuilder,
          (SightingRecord, $$SightingsTableReferences),
          SightingRecord,
          PrefetchHooks Function({bool catId, bool photosRefs})
        > {
  $$SightingsTableTableManager(_$AppDatabase db, $SightingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SightingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SightingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SightingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catId = const Value.absent(),
                Value<DateTime> seenAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SightingsCompanion(
                id: id,
                catId: catId,
                seenAt: seenAt,
                lat: lat,
                lng: lng,
                placeName: placeName,
                countryCode: countryCode,
                note: note,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catId,
                required DateTime seenAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SightingsCompanion.insert(
                id: id,
                catId: catId,
                seenAt: seenAt,
                lat: lat,
                lng: lng,
                placeName: placeName,
                countryCode: countryCode,
                note: note,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SightingsTable, SightingRecord>(table),
                  $$SightingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false, photosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (photosRefs) db.photos],
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
                    if (catId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.catId,
                        referencedTable: $$SightingsTableReferences._catIdTable(
                          db,
                        ),
                        referencedColumn: $$SightingsTableReferences
                            ._catIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (photosRefs)
                    await $_getPrefetchedData<
                      SightingRecord,
                      $SightingsTable,
                      PhotoRecord
                    >(
                      currentTable: table,
                      referencedTable: $$SightingsTableReferences
                          ._photosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SightingsTableReferences(db, table, p0).photosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sightingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SightingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SightingsTable,
      SightingRecord,
      $$SightingsTableFilterComposer,
      $$SightingsTableOrderingComposer,
      $$SightingsTableAnnotationComposer,
      $$SightingsTableCreateCompanionBuilder,
      $$SightingsTableUpdateCompanionBuilder,
      (SightingRecord, $$SightingsTableReferences),
      SightingRecord,
      PrefetchHooks Function({bool catId, bool photosRefs})
    >;
typedef $$PhotosTableCreateCompanionBuilder = PhotosCompanion Function({
  required String id,
  required String sightingId,
  required String localPath,
  Value<String?> storageKey,
  required int width,
  required int height,
  Value<String?> blurhash,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});
typedef $$PhotosTableUpdateCompanionBuilder = PhotosCompanion Function({
  Value<String> id,
  Value<String> sightingId,
  Value<String> localPath,
  Value<String?> storageKey,
  Value<int> width,
  Value<int> height,
  Value<String?> blurhash,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<bool> dirty,
  Value<int> rowid,
});

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, PhotoRecord> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SightingsTable _sightingIdTable(_$AppDatabase db) =>
      db.sightings.createAlias('photos__sighting_id__sightings__id');

  $$SightingsTableProcessedTableManager get sightingId {
    final $_column = $_itemColumn<String>('sighting_id')!;

    final manager = $$SightingsTableTableManager(
      $_db,
      $_db.sightings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sightingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blurhash => $composableBuilder(
    column: $table.blurhash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  $$SightingsTableFilterComposer get sightingId {
    final $$SightingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sightingId,
      referencedTable: $db.sightings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SightingsTableFilterComposer(
            $db: $db,
            $table: $db.sightings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blurhash => $composableBuilder(
    column: $table.blurhash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  $$SightingsTableOrderingComposer get sightingId {
    final $$SightingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sightingId,
      referencedTable: $db.sightings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SightingsTableOrderingComposer(
            $db: $db,
            $table: $db.sightings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get storageKey => $composableBuilder(
    column: $table.storageKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get blurhash =>
      $composableBuilder(column: $table.blurhash, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  $$SightingsTableAnnotationComposer get sightingId {
    final $$SightingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sightingId,
      referencedTable: $db.sightings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SightingsTableAnnotationComposer(
            $db: $db,
            $table: $db.sightings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          PhotoRecord,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (PhotoRecord, $$PhotosTableReferences),
          PhotoRecord,
          PrefetchHooks Function({bool sightingId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sightingId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> storageKey = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<String?> blurhash = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                sightingId: sightingId,
                localPath: localPath,
                storageKey: storageKey,
                width: width,
                height: height,
                blurhash: blurhash,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sightingId,
                required String localPath,
                Value<String?> storageKey = const Value.absent(),
                required int width,
                required int height,
                Value<String?> blurhash = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                sightingId: sightingId,
                localPath: localPath,
                storageKey: storageKey,
                width: width,
                height: height,
                blurhash: blurhash,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PhotosTable, PhotoRecord>(table),
                  $$PhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sightingId = false}) {
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
                    if (sightingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sightingId,
                        referencedTable: $$PhotosTableReferences
                            ._sightingIdTable(db),
                        referencedColumn: $$PhotosTableReferences
                            ._sightingIdTable(db)
                            .id,
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

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      PhotoRecord,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (PhotoRecord, $$PhotosTableReferences),
      PhotoRecord,
      PrefetchHooks Function({bool sightingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalOwnersTableTableManager get localOwners =>
      $$LocalOwnersTableTableManager(_db, _db.localOwners);
  $$CatsTableTableManager get cats => $$CatsTableTableManager(_db, _db.cats);
  $$SightingsTableTableManager get sightings =>
      $$SightingsTableTableManager(_db, _db.sightings);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
}
