# 🔐 Email Verification Authentication Flow - Complete Setup Guide

## Overview

Your Coffee House app now has **real Supabase authentication** with email verification:

1. **User Signs Up** → Email confirmation sent
2. **User Confirms Email** → Clicks link in email
3. **User Logs In** → Can only log in after confirming email
4. **Admin Portal** → Separate admin authentication

---

## 📋 Prerequisites

1. ✅ Supabase account and project created
2. ✅ Credentials already in `lib/config/supabase_config.dart`
3. ✅ Supabase email provider configured (default)

---

## ⚙️ Setup Steps

### Step 1: Create Database Tables

1. Go to your Supabase project dashboard
2. Click **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy and paste the entire content from `database/supabase_migration.sql`
5. Click **Run**

✅ This creates:
- `users` table with RLS policies
- `products` table with admin controls
- Security policies for data protection

### Step 2: Enable Email Provider

1. Go to **Authentication** > **Providers**
2. Find **Email** provider
3. Click to expand and ensure it's **enabled**
4. Under **Email settings**, enable:
   - ✅ Confirm email
   - ✅ (Optional) Double confirm change

### Step 3: Setup Email Templates (Optional but Recommended)

1. Go to **Authentication** > **Email Templates**
2. Customize the confirmation email template
3. Make sure it includes the `{{ confirmation_url }}` variable

---

## 🔄 Authentication Flow

### User Registration Flow

```
User → Signup Screen
↓
Enters email, password, name
↓
AuthenticationService.signUp()
↓
Supabase sends confirmation email
↓
"Check your email" dialog shown
↓
User receives email with confirmation link
↓
User clicks link → Email confirmed in Supabase
```

### User Login Flow

```
User → Login Screen
↓
Enters email, password
↓
AuthenticationService.signIn()
↓
✅ Email confirmed? → Login successful → Navigate to Home
❌ Email not confirmed? → Error message → Offer to resend email
```

---

## 📱 User Experience

### Signup (New User)

1. User fills signup form with name, email, password
2. Clicks "SIGN UP"
3. App sends request to Supabase
4. **Dialog shows**: "Confirm Your Email"
   - Message: "Check your inbox for confirmation email"
   - Email address displayed
5. User checks email inbox
6. User clicks confirmation link in email
7. Email is verified in Supabase

### Login (After Email Confirmed)

1. User enters email and password
2. Clicks "Log In"
3. ✅ **If email confirmed**: Login successful → Home screen
4. ❌ **If email NOT confirmed**: Error + "Resend Email" button
5. User can click "Resend Email" to get confirmation email again

### Forgot Password

1. User clicks "Forgot Password?" on login screen
2. Enters email
3. Supabase sends password reset email
4. User clicks link and resets password

---

## 🛠️ Code Structure

### Files Modified/Created:

1. **`lib/config/supabase_config.dart`** - Credentials config
2. **`lib/services/supabase_service.dart`** - Supabase client wrapper
3. **`lib/services/authentication_service.dart`** - Auth logic (UPDATED)
4. **`lib/signup.dart`** - Signup screen (UPDATED)
5. **`lib/login.dart`** - Login screen (UPDATED)
6. **`lib/main.dart`** - Initialize Supabase (UPDATED)
7. **`database/supabase_migration.sql`** - Database schema (NEW)

### Key Methods:

#### SignUp
```dart
await authService.signUp(
  email: 'user@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
);
```

#### SignIn
```dart
await authService.signIn(
  email: 'user@example.com',
  password: 'password123',
);
```

#### Resend Confirmation Email
```dart
await authService.resendConfirmationEmail('user@example.com');
```

#### Check Email Confirmation Status
```dart
bool isConfirmed = await authService.isEmailConfirmed();
```

---

## 🧪 Testing the Flow

### Test Signup → Confirmation → Login

1. **Sign Up**
   - Go to Signup screen
   - Enter: test@example.com, password, name
   - Click "SIGN UP"
   - See "Confirm Your Email" dialog

2. **Confirm Email** (Dev/Testing)
   - Go to Supabase Dashboard
   - Click **Authentication** > **Users**
   - Find your test user
   - Click the user
   - Scroll to "User Metadata"
   - If email not confirmed: You can manually confirm in dev (not available in prod)
   - OR check your email if using real email provider

3. **Login**
   - After email confirmed, go to Login screen
   - Enter same email and password
   - Should successfully login

### Test with Real Email

For actual testing with real emails:

1. Use your real email address during signup
2. Check your inbox for confirmation email
3. Click the verification link
4. Once confirmed, you can login

### Test without Real Email (Dev Only)

If you haven't configured real email sending:

1. Sign up normally
2. In Supabase dashboard > Authentication > Users
3. View the user you created
4. Manually confirm email (dev feature only)

---

## 🔒 Security Features

### Row Level Security (RLS)
- Users can only read their own profile
- Admins can read all users
- Only admins can modify products

### Password Security
- Passwords hashed by Supabase
- Never stored in plaintext
- Minimum 6 characters

### Email Verification
- Confirms email ownership
- Prevents fake email registrations
- Only verified users can login

---

## ⚠️ Common Issues & Solutions

### Issue: "Supabase not initialized"
**Solution**: Check `main.dart` - ensure `await SupabaseService().initialize()` is called

### Issue: Confirmation email not received
**Solutions**:
1. Check spam/junk folder
2. Wait 1-2 minutes for email delivery
3. Use "Resend Email" button in login error
4. Verify email provider is enabled in Supabase

### Issue: "Invalid login credentials" after confirming email
**Solutions**:
1. Double-check password spelling
2. Make sure email is confirmed (check Supabase > Users)
3. Try resetting password via "Forgot Password"

### Issue: Can signup but can't login with same credentials
**Solution**: This means email is not confirmed yet. Look for confirmation email.

---

## 🚀 Next Steps

### 1. Test the Full Flow
- [ ] Sign up with test email
- [ ] Confirm email
- [ ] Login successfully
- [ ] Check home screen loads

### 2. Configure Email (Optional)
- Set up custom email templates
- Configure "from" email address
- Set up email branding

### 3. Update Other Services
- Update database queries to use Supabase
- Migrate mock data to real database
- Connect cart/orders to Supabase

### 4. Deploy
- Test on device
- Ensure email sending works in production
- Monitor authentication logs

---

## 📚 API Reference

### AuthenticationService Methods

```dart
// Signup
Future<bool> signUp({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  String? middleName,
  String? phoneNumber,
})

// Signin
Future<bool> signIn({
  required String email,
  required String password,
})

// Signout
Future<void> signOut()

// Password reset
Future<void> resetPassword(String email)

// Resend confirmation
Future<void> resendConfirmationEmail(String email)

// Check email confirmed
Future<bool> isEmailConfirmed()

// Check admin status
Future<bool> isCurrentUserAdmin()

// Get user info
Future<String?> getUserEmail()
Future<String?> getUserId()
Future<Map<String, dynamic>?> getUserProfile()
```

---

## 📞 Support

For issues with Supabase:
- [Supabase Docs](https://supabase.com/docs)
- [Email Configuration](https://supabase.com/docs/guides/auth/auth-email)
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)

---

**Happy authenticating! 🍵🔐**
