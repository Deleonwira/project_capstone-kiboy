import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/itinerary.dart';
import '../models/activity.dart';
import '../models/user.dart';
import '../models/user_preferences.dart';
import '../models/shared_itinerary.dart';
import '../models/document.dart';
import '../models/reminder.dart';
import '../models/expense.dart';
import '../models/packing_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = 'itinerary_planner.db';
    if (!kIsWeb) {
      path = join(await getDatabasesPath(), path);
    }
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 5,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE itineraries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT,
        destination TEXT,
        startDate TEXT,
        endDate TEXT,
        status TEXT DEFAULT 'published',
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itineraryId INTEGER,
        title TEXT,
        description TEXT,
        date TEXT,
        time TEXT,
        FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE user_preferences(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL UNIQUE,
        currency TEXT DEFAULT 'IDR',
        distanceUnit TEXT DEFAULT 'km',
        interests TEXT DEFAULT '',
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE shared_itineraries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itineraryId INTEGER NOT NULL,
        ownerUserId INTEGER NOT NULL,
        sharedWithUserId INTEGER NOT NULL,
        accessLevel TEXT DEFAULT 'readonly',
        FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE,
        FOREIGN KEY (ownerUserId) REFERENCES users (id),
        FOREIGN KEY (sharedWithUserId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE documents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        itineraryId INTEGER,
        fileName TEXT NOT NULL,
        filePath TEXT NOT NULL,
        fileType TEXT DEFAULT 'other',
        category TEXT DEFAULT 'other',
        createdAt TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activityId INTEGER NOT NULL,
        reminderTime TEXT NOT NULL,
        message TEXT,
        isActive INTEGER DEFAULT 1,
        FOREIGN KEY (activityId) REFERENCES activities (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itineraryId INTEGER NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE packing_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itineraryId INTEGER NOT NULL,
        name TEXT NOT NULL,
        isPacked INTEGER DEFAULT 0,
        FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        )
      ''');
      await db.execute(
          'ALTER TABLE itineraries ADD COLUMN userId INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      // Add status column to itineraries
      try {
        await db.execute(
            "ALTER TABLE itineraries ADD COLUMN status TEXT DEFAULT 'published'");
      } catch (_) {}

      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_preferences(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL UNIQUE,
          currency TEXT DEFAULT 'IDR',
          distanceUnit TEXT DEFAULT 'km',
          interests TEXT DEFAULT '',
          FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS shared_itineraries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itineraryId INTEGER NOT NULL,
          ownerUserId INTEGER NOT NULL,
          sharedWithUserId INTEGER NOT NULL,
          accessLevel TEXT DEFAULT 'readonly',
          FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE,
          FOREIGN KEY (ownerUserId) REFERENCES users (id),
          FOREIGN KEY (sharedWithUserId) REFERENCES users (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS documents(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          itineraryId INTEGER,
          fileName TEXT NOT NULL,
          filePath TEXT NOT NULL,
          fileType TEXT DEFAULT 'other',
          category TEXT DEFAULT 'other',
          createdAt TEXT,
          FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
          FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE SET NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS reminders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          activityId INTEGER NOT NULL,
          reminderTime TEXT NOT NULL,
          message TEXT,
          isActive INTEGER DEFAULT 1,
          FOREIGN KEY (activityId) REFERENCES activities (id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itineraryId INTEGER NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS packing_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          itineraryId INTEGER NOT NULL,
          name TEXT NOT NULL,
          isPacked INTEGER DEFAULT 0,
          FOREIGN KEY (itineraryId) REFERENCES itineraries (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // ==========================================
  // CRUD for Users
  // ==========================================

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<User?> loginUser(String email, String hashedPassword) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((m) => User.fromMap(m)).toList();
  }

  // ==========================================
  // CRUD for Itineraries
  // ==========================================

  Future<int> insertItinerary(Itinerary itinerary) async {
    Database db = await database;
    return await db.insert('itineraries', itinerary.toMap());
  }

  Future<List<Itinerary>> getItineraries({int? userId}) async {
    Database db = await database;
    List<Map<String, dynamic>> maps;
    if (userId != null) {
      maps = await db.query(
        'itineraries',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'id DESC',
      );
    } else {
      maps = await db.query('itineraries', orderBy: 'id DESC');
    }
    return maps.map((m) => Itinerary.fromMap(m)).toList();
  }

  Future<List<Itinerary>> getUpcomingTrips(int userId) async {
    Database db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    List<Map<String, dynamic>> maps = await db.query(
      'itineraries',
      where: "userId = ? AND endDate >= ? AND status = 'published'",
      whereArgs: [userId, today],
      orderBy: 'startDate ASC',
    );
    return maps.map((m) => Itinerary.fromMap(m)).toList();
  }

  Future<List<Itinerary>> getPastTrips(int userId) async {
    Database db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    List<Map<String, dynamic>> maps = await db.query(
      'itineraries',
      where: "userId = ? AND endDate < ? AND status = 'published'",
      whereArgs: [userId, today],
      orderBy: 'endDate DESC',
    );
    return maps.map((m) => Itinerary.fromMap(m)).toList();
  }

  Future<List<Itinerary>> getDraftTrips(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'itineraries',
      where: "userId = ? AND status = 'draft'",
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return maps.map((m) => Itinerary.fromMap(m)).toList();
  }

  Future<int> updateItinerary(Itinerary itinerary) async {
    Database db = await database;
    return await db.update(
      'itineraries',
      itinerary.toMap(),
      where: 'id = ?',
      whereArgs: [itinerary.id],
    );
  }

  Future<int> deleteItinerary(int id) async {
    Database db = await database;
    return await db.delete('itineraries', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // CRUD for Activities
  // ==========================================

  Future<int> insertActivity(Activity activity) async {
    Database db = await database;
    return await db.insert('activities', activity.toMap());
  }

  Future<List<Activity>> getActivitiesForItinerary(int itineraryId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'activities',
      where: 'itineraryId = ?',
      whereArgs: [itineraryId],
      orderBy: 'date ASC, time ASC',
    );
    return maps.map((m) => Activity.fromMap(m)).toList();
  }

  Future<int> updateActivity(Activity activity) async {
    Database db = await database;
    return await db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    Database db = await database;
    return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // CRUD for UserPreferences
  // ==========================================

  Future<int> insertOrUpdatePreferences(UserPreferences prefs) async {
    Database db = await database;
    final existing = await getPreferences(prefs.userId);
    if (existing != null) {
      return await db.update(
        'user_preferences',
        prefs.toMap(),
        where: 'userId = ?',
        whereArgs: [prefs.userId],
      );
    }
    return await db.insert('user_preferences', prefs.toMap());
  }

  Future<UserPreferences?> getPreferences(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'user_preferences',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) return UserPreferences.fromMap(maps.first);
    return null;
  }

  // ==========================================
  // CRUD for SharedItineraries
  // ==========================================

  Future<int> shareItinerary(SharedItinerary share) async {
    Database db = await database;
    return await db.insert('shared_itineraries', share.toMap());
  }

  Future<List<Map<String, dynamic>>> getSharedWithMe(int userId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT si.*, i.title, i.destination, i.startDate, i.endDate, i.status,
             i.userId, u.name as ownerName
      FROM shared_itineraries si
      JOIN itineraries i ON si.itineraryId = i.id
      JOIN users u ON si.ownerUserId = u.id
      WHERE si.sharedWithUserId = ?
      ORDER BY i.startDate DESC
    ''', [userId]);
  }

  Future<List<Map<String, dynamic>>> getSharesForItinerary(
      int itineraryId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT si.*, u.name as sharedWithName, u.email as sharedWithEmail
      FROM shared_itineraries si
      JOIN users u ON si.sharedWithUserId = u.id
      WHERE si.itineraryId = ?
    ''', [itineraryId]);
  }

  Future<int> removeShare(int shareId) async {
    Database db = await database;
    return await db
        .delete('shared_itineraries', where: 'id = ?', whereArgs: [shareId]);
  }

  Future<String?> getAccessLevel(int itineraryId, int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'shared_itineraries',
      where: 'itineraryId = ? AND sharedWithUserId = ?',
      whereArgs: [itineraryId, userId],
    );
    if (maps.isNotEmpty) return maps.first['accessLevel'] as String?;
    return null;
  }

  // ==========================================
  // CRUD for Documents (Vault)
  // ==========================================

  Future<int> insertDocument(Document doc) async {
    Database db = await database;
    return await db.insert('documents', doc.toMap());
  }

  Future<List<Document>> getDocuments(int userId, {String? category}) async {
    Database db = await database;
    List<Map<String, dynamic>> maps;
    if (category != null) {
      maps = await db.query(
        'documents',
        where: 'userId = ? AND category = ?',
        whereArgs: [userId, category],
        orderBy: 'createdAt DESC',
      );
    } else {
      maps = await db.query(
        'documents',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );
    }
    return maps.map((m) => Document.fromMap(m)).toList();
  }

  Future<int> deleteDocument(int id) async {
    Database db = await database;
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // CRUD for Reminders
  // ==========================================

  Future<int> insertReminder(Reminder reminder) async {
    Database db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<Reminder?> getReminderForActivity(int activityId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      where: 'activityId = ?',
      whereArgs: [activityId],
    );
    if (maps.isNotEmpty) return Reminder.fromMap(maps.first);
    return null;
  }

  Future<List<Reminder>> getActiveReminders() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      where: 'isActive = 1',
    );
    return maps.map((m) => Reminder.fromMap(m)).toList();
  }

  Future<int> deleteReminder(int id) async {
    Database db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReminderForActivity(int activityId) async {
    Database db = await database;
    return await db.delete('reminders',
        where: 'activityId = ?', whereArgs: [activityId]);
  }

  // ==========================================
  // CRUD for Expenses
  // ==========================================

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpensesForItinerary(int itineraryId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'itineraryId = ?',
      whereArgs: [itineraryId],
    );
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<int> deleteExpense(int id) async {
    Database db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // CRUD for Packing Items
  // ==========================================

  Future<int> insertPackingItem(PackingItem item) async {
    Database db = await database;
    return await db.insert('packing_items', item.toMap());
  }

  Future<List<PackingItem>> getPackingItemsForItinerary(int itineraryId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'packing_items',
      where: 'itineraryId = ?',
      whereArgs: [itineraryId],
    );
    return maps.map((m) => PackingItem.fromMap(m)).toList();
  }

  Future<int> updatePackingItem(PackingItem item) async {
    Database db = await database;
    return await db.update(
      'packing_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deletePackingItem(int id) async {
    Database db = await database;
    return await db.delete('packing_items', where: 'id = ?', whereArgs: [id]);
  }
}
