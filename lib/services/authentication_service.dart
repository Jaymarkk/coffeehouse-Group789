import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Supabase Authentication Service
/// Handles user registration with email confirmation and login
class AuthenticationService {
  static final AuthenticationService _instance =
      AuthenticationService._internal();
  factory AuthenticationService() => _instance;
  AuthenticationService._internal();

  late SupabaseClient _client;

  // Initialize the service
  void init() {
    _client = SupabaseService().client;
  }

  // Get current authenticated user
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  /// Sign up new user with email and password
  /// Email confirmation will be sent to the user
  /// User must confirm email before they can log in
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? middleName,
    String? phoneNumber,
  }) async {
    try {
      print('📝 Signing up user: $email');

      // Sign up with Supabase Auth
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          if (middleName != null) 'middle_name': middleName,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );

      if (response.user == null) {
        throw Exception('Sign up failed - No user returned');
      }

      print('✅ Sign up successful! Check email for confirmation.');
      print('📧 Confirmation email sent to: $email');

      // Store additional user data in public.users table if allowed by policies.
      await _storeUserProfile(
        userId: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        middleName: middleName,
        phoneNumber: phoneNumber,
      );

      return true;
    } on AuthException catch (e) {
      print('❌ Sign up error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('❌ Unexpected sign up error: $e');
      rethrow;
    }
  }

  /// Sign in user with email and password
  /// User must have confirmed their email first
  Future<bool> signIn({required String email, required String password}) async {
    try {
      print('🔑 Signing in user: $email');

      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      // Check if email is confirmed
      if (response.user!.emailConfirmedAt == null) {
        print(
          '⚠️  Email not confirmed yet. Check your email for confirmation link.',
        );
        await _client.auth.signOut();
        throw Exception(
          'Please confirm your email before logging in. Check your inbox for the confirmation email.',
        );
      }

      print('✅ Sign in successful!');
      return true;
    } on AuthException catch (e) {
      print('❌ Sign in error: ${e.message}');
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('Invalid email or password');
      }
      throw Exception(e.message);
    } catch (e) {
      print('❌ Unexpected sign in error: $e');
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      print('👋 Signing out user');
      await _client.auth.signOut();
      print('✅ Signed out successfully');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      print('📧 Sending password reset email to: $email');
      await _client.auth.resetPasswordForEmail(email);
      print('✅ Password reset email sent. Check your inbox.');
    } on AuthException catch (e) {
      print('❌ Password reset error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// Resend confirmation email (if user didn't receive it)
  Future<void> resendConfirmationEmail(String email) async {
    try {
      print('📧 Resending confirmation email to: $email');
      await _client.auth.resend(type: OtpType.signup, email: email);
      print('✅ Confirmation email resent. Check your inbox.');
    } on AuthException catch (e) {
      print('❌ Resend error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  /// Store user profile data in database
  Future<void> _storeUserProfile({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    String? middleName,
    String? phoneNumber,
  }) async {
    try {
      await _client.from('users').insert({
        'id': userId,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'middle_name': middleName,
        'phone_number': phoneNumber,
        'is_admin': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('✅ User profile stored in database');
    } catch (e) {
      print('⚠️  Warning: Could not store user profile: $e');
      // Don't throw - auth was successful even if profile storage failed
    }
  }

  /// Check if current user is admin
  Future<bool> isCurrentUserAdmin() async {
    if (currentUser == null) return false;

    try {
      final response = await _client
          .from('users')
          .select('is_admin')
          .eq('id', currentUser!.id)
          .single();

      return response['is_admin'] ?? false;
    } catch (e) {
      print('⚠️  Could not fetch admin status: $e');
      return false;
    }
  }

  /// Get current user email
  Future<String?> getUserEmail() async {
    return currentUser?.email;
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    return currentUser?.id;
  }

  /// Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (e) {
      print('⚠️  Could not fetch user profile from users table: $e');
    }

    try {
      final metadata = currentUser!.userMetadata;
      final firstName = metadata?['first_name']?.toString() ?? '';
      final lastName = metadata?['last_name']?.toString() ?? '';
      if (firstName.isEmpty && lastName.isEmpty) {
        return null;
      }
      return {
        'email': currentUser!.email,
        'first_name': firstName,
        'last_name': lastName,
        'middle_name': metadata?['middle_name']?.toString(),
        'phone_number': metadata?['phone_number']?.toString(),
      };
    } catch (e) {
      print('⚠️  Could not build fallback profile from metadata: $e');
      return null;
    }
  }

  /// Update the current user's profile row in the users table.
  Future<void> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? city,
  }) async {
    if (firstName == null &&
        lastName == null &&
        email == null &&
        phoneNumber == null &&
        city == null) {
      return;
    }

    final values = <String, dynamic>{
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (city != null) 'city': city,
    };

    try {
      await _client.from('users').update(values).eq('id', userId);
      print('✅ User profile updated in database');
    } catch (e) {
      print('⚠️  Could not update user profile: $e');
    }
  }

  /// Get error message from exception
  String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    return error.toString();
  }

  /// Check email confirmation status
  Future<bool> isEmailConfirmed() async {
    if (currentUser == null) return false;
    return currentUser!.emailConfirmedAt != null;
  }

  /// Update user password (used in password reset flow)
  Future<void> updatePassword(String newPassword) async {
    try {
      print('🔐 Updating password');
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      print('✅ Password updated successfully');
    } on AuthException catch (e) {
      print('❌ Password update error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }
}
