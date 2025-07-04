plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "xin.ctkqiang.identity_scanner"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "xin.ctkqiang.identity_scanner"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") { // Use 'create("name")' for Kotlin DSL
            // IMPORTANT: These hardcoded values are for your current, rejected upload key.
            // After the Google Play Console upload key reset, you will update these
            // to reference your new, unique key.properties file.
            storeFile = file("upload-keystore.jks")
            storePassword = "1300177"
            keyAlias = "upload"
            keyPassword = "1300177"
        }
    }

    buildTypes {
        getByName("release") { // Use 'getByName("name")' for existing build types
            // This correctly applies the signing config defined above
            signingConfig = signingConfigs.getByName("release")
            // ... other release configurations if any
        }
    }
}

flutter {
    source = "../.."
}
