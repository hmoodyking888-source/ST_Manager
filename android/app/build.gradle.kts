plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.sultan.stn_manager" 
    
    // تم التحديث إلى 36 بناءً على طلب بيئة التشغيل
    compileSdk = 36
    
    ndkVersion = "28.2.13676358" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    // الهيكلية الحديثة والمعتمدة لـ جافا وكوتلن بدلاً من القديمة
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
    }

    defaultConfig {
        applicationId = "com.sultan.stn_manager"
        
        minSdk = 21
        // تم التحديث إلى 36 ليتوافق تماماً مع البيئة السحابية
        targetSdk = 36
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}