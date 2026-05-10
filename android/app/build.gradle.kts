plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.coffee"
    compileSdk = 36  // Updated to 36 for new dependencies
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    lint {
        disable += listOf("GradleCompatible", "OldTargetApi")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.coffee"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36  // Updated to match compileSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isDebuggable = false
            isShrinkResources = false  // Disable resource shrinking
            isMinifyEnabled = false    // Disable minification (R8)
            
            // Suppress compiler warnings
            kotlinOptions {
                allWarningsAsErrors = false
            }
        }
    }
}

dependencies {
    // Exclude sign_in_with_apple plugin conflicts
    configurations.all {
        exclude(group = "com.aboutyou.dart_packages", module = "sign_in_with_apple")
        exclude(group = "io.flutter.plugins.sign_in_with_apple")
    }
}

flutter {
    source = "../.."
}
