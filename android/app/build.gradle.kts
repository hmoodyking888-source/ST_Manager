plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // اسم الحزمة الصحيح لتطبيقك
    namespace = "com.sultan.stn_manager" 
    compileSdk = flutter.compileSdkVersion
    
    // إصدار الـ NDK المطلوب للسيرفر السحابي
    ndkVersion = "28.2.13676358" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.sultan.stn_manager"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // أو الـ release الخاص بك
        }
    }
}

flutter {
    source = "../.."
}