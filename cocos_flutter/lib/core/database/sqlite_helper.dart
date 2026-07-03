import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
 
class SqliteHelper {
  SqliteHelper._();

  static final SqliteHelper instance = SqliteHelper._();

  static Database? _database;
 
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
 
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cocos_local.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE orders ADD COLUMN step_label TEXT');
      await db.execute('ALTER TABLE orders ADD COLUMN shipping_address TEXT');
      await db.execute('ALTER TABLE orders ADD COLUMN payment_method TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE chat_messages ADD COLUMN conversation_id TEXT');
    }
  }
 
  Future<void> _onCreate(Database db, int version) async {
    // Tabel Keranjang Belanja Belanja (Cart)
    await db.execute('''

      CREATE TABLE cart (

        id TEXT PRIMARY KEY,

        product_name TEXT,

        image_url TEXT,

        price REAL,

        quantity INTEGER,

        selected_size TEXT,

        selected_material TEXT,

        is_synced INTEGER DEFAULT 0,

        firebase_id TEXT

      )

    ''');
 
    // Tabel Pesanan (Orders)
    await db.execute('''

      CREATE TABLE orders (

        id TEXT PRIMARY KEY,

        order_number TEXT,

        product_name TEXT,

        image_url TEXT,

        price REAL,

        quantity INTEGER,

        selected_size TEXT,

        selected_material TEXT,

        category TEXT,

        current_step INTEGER,

        step_label TEXT,

        order_date TEXT,

        estimated_date TEXT,

        shipping_address TEXT,

        payment_method TEXT,

        is_synced INTEGER DEFAULT 0,

        firebase_id TEXT

      )

    ''');

    // Tabel Pesan Obrolan (Chat Messages)
    await db.execute('''

      CREATE TABLE chat_messages (

        id TEXT PRIMARY KEY,

        sender_id TEXT,

        text TEXT,

        timestamp TEXT,

        is_me INTEGER,

        image_url TEXT,

        conversation_id TEXT,

        is_synced INTEGER DEFAULT 0,

        firebase_id TEXT

      )

    ''');
  }
}