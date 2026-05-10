import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Supabase Service - Singleton wrapper for Supabase client
///
/// Usage:
/// ```dart
/// final supabaseService = SupabaseService();
/// await supabaseService.initialize();
/// final client = supabaseService.client;
/// ```
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  late SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Initialize Supabase with your credentials
  Future<void> initialize() async {
    try {
      await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);
      _client = Supabase.instance.client;
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Error initializing Supabase: $e');
      rethrow;
    }
  }

  /// Get Supabase client instance
  SupabaseClient get client => _client;

  /// Get authenticated user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Example: Get data from a table
  Future<List<Map<String, dynamic>>> fetchFromTable(String tableName) async {
    try {
      final response = await _client.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching from $tableName: $e');
      rethrow;
    }
  }

  /// Example: Insert data into a table
  Future<Map<String, dynamic>> insertIntoTable(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.from(tableName).insert(data).select();
      return response[0];
    } catch (e) {
      print('Error inserting into $tableName: $e');
      rethrow;
    }
  }

  /// Example: Update data in a table
  Future<void> updateTable(
    String tableName,
    Map<String, dynamic> data,
    String filterColumn,
    dynamic filterValue,
  ) async {
    try {
      await _client.from(tableName).update(data).eq(filterColumn, filterValue);
    } catch (e) {
      print('Error updating $tableName: $e');
      rethrow;
    }
  }

  /// Example: Delete data from a table
  Future<void> deleteFromTable(
    String tableName,
    String filterColumn,
    dynamic filterValue,
  ) async {
    try {
      await _client.from(tableName).delete().eq(filterColumn, filterValue);
    } catch (e) {
      print('Error deleting from $tableName: $e');
      rethrow;
    }
  }
}
