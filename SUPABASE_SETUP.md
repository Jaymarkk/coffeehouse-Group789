# 🍵 Supabase Setup Guide for Coffee House App

## Quick Start

### 1. Get Your Supabase Credentials

1. Go to [https://app.supabase.com](https://app.supabase.com)
2. Sign in or create a new account
3. Create a new project
4. Once created, go to **Settings > API**
5. Copy these two values:
   - **Project URL** (e.g., `https://your-project-id.supabase.co`)
   - **Anon Key** (the public key)

### 2. Configure Your App

Open `lib/config/supabase_config.dart` and replace the placeholder values:

```dart
const String SUPABASE_URL = 'https://your-project-id.supabase.co';
const String SUPABASE_ANON_KEY = 'your-anon-key-here';
```

**Example:**
```dart
const String SUPABASE_URL = 'https://abcdef123456.supabase.co';
const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 3. Get Dependencies

Run this command to install the Supabase package:

```bash
flutter pub get
```

### 4. You're Done! 🎉

Your app will automatically initialize Supabase when it starts. Check the console logs for confirmation:
- ✅ `Supabase initialized in main()`
- ✅ `Supabase initialized successfully`

---

## 📚 Using Supabase in Your Code

### Initialize Service (Already done in main.dart)
```dart
import 'services/supabase_service.dart';

await SupabaseService().initialize();
```

### Access the Client
```dart
final supabaseService = SupabaseService();
final client = supabaseService.client;
```

### Common Operations

#### Fetch Data
```dart
final supabaseService = SupabaseService();
final data = await supabaseService.fetchFromTable('products');
```

#### Insert Data
```dart
final newProduct = await supabaseService.insertIntoTable(
  'products',
  {
    'name': 'Espresso',
    'price': 3.50,
    'description': 'Strong coffee'
  },
);
```

#### Update Data
```dart
await supabaseService.updateTable(
  'products',
  {'price': 4.00},
  'id',
  1, // product id
);
```

#### Delete Data
```dart
await supabaseService.deleteFromTable('products', 'id', 1);
```

#### Use Supabase Client Directly
```dart
final client = SupabaseService().client;

// Authentication
await client.auth.signUp(email: 'user@example.com', password: 'password');
await client.auth.signInWithPassword(email: 'user@example.com', password: 'password');
await client.auth.signOut();

// Real-time subscriptions
final subscription = client
    .from('products')
    .on(SupabaseEventTypes.all, (payload) {
      print('Change: ${payload.eventType}');
    })
    .subscribe();
```

---

## 🔐 Security Tips

1. **Keep your credentials safe!**
   - Never commit `supabase_config.dart` with real credentials to public repos
   - Use environment variables in production

2. **Use Row Level Security (RLS)**
   - Enable RLS on your Supabase tables
   - Create policies for your authentication rules

3. **Restrict API Keys**
   - Set column permissions on your Anon Key
   - Only allow access to necessary data

---

## 🆘 Troubleshooting

### "Supabase not initialized" Error
- Ensure `await SupabaseService().initialize()` is called in `main()`
- Check that your credentials are correct in `supabase_config.dart`

### Network Errors
- Check your internet connection
- Verify the Supabase URL is correct (no typos)
- Check if your Supabase project is active (not paused)

### "Anon Key is invalid"
- Go to Supabase dashboard and regenerate if needed
- Copy the entire key including the long string

---

## 📦 Migrating from Mock Data

Currently, your app uses mock data. To migrate to Supabase:

1. Update `AuthenticationService` to use Supabase Auth:
```dart
final supabaseService = SupabaseService();
await supabaseService.client.auth.signUp(
  email: email,
  password: password,
);
```

2. Update `DatabaseService` to fetch from Supabase tables:
```dart
final products = await supabaseService.fetchFromTable('products');
```

3. Test and deploy! 🚀

---

## 📖 More Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Library](https://pub.dev/packages/supabase_flutter)
- [Flutter Database Best Practices](https://flutter.dev/docs/development/data-and-backend/state-mgmt)

---

**Happy coding! ☕**
