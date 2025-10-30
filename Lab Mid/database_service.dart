import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient.dart';

class DatabaseService extends ChangeNotifier {
  Database? _database;
  List<Patient> _patients = [];
  bool _isLoading = false;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'doctor_patient_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ✅ Patient Table
    await db.execute('''
      CREATE TABLE patients(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        dateOfBirth TEXT,
        phoneNumber TEXT,
        email TEXT,
        address TEXT,
        medicalHistory TEXT,
        allergies TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // ✅ Admin Table
    await db.execute('''
      CREATE TABLE admins(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // ✅ Default Admin Insert
    await db.insert('admins', {
      'username': 'rafia',
      'password': 'rafia123',
    });
  }

  // ✅ Verify Admin Login
  Future<bool> verifyAdminLogin(String username, String password) async {
    try {
      final db = await database;
      final result = await db.query(
        'admins',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      return result.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying admin: $e');
      }
      return false;
    }
  }

  // ---------- PATIENT CRUD SAME AS BEFORE ----------

  Future<void> loadPatients() async {
    _isLoading = true;
    notifyListeners();
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'patients',
        orderBy: 'createdAt DESC',
      );
      _patients = List.generate(maps.length, (i) {
        return Patient.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) print('Error loading patients: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPatient(Patient patient) async {
    try {
      final db = await database;
      await db.insert('patients', patient.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      await loadPatients();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error adding patient: $e');
      return false;
    }
  }

  Future<bool> updatePatient(Patient patient) async {
    try {
      final db = await database;
      await db.update('patients', patient.toMap(), where: 'id = ?', whereArgs: [patient.id]);
      await loadPatients();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error updating patient: $e');
      return false;
    }
  }

  Future<bool> deletePatient(int id) async {
    try {
      final db = await database;
      await db.delete('patients', where: 'id = ?', whereArgs: [id]);
      await loadPatients();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error deleting patient: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
