plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // تفعيل الفايربيس هنا في نظام الأندرويد الجديد
    id("com.google.gms.google-services")
}

android {
    namespace = "com.sultan.stn_manager" // 👈 تم التحديث ليطابق الفايربيس
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.sultan.stn_manager" // 👈 تم التحديث ليطابق الفايربيس
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so flutter run --release works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}