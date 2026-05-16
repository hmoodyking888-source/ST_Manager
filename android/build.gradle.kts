// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    // تم تحديث الإصدار هنا إلى 8.11.1 ليطابق مشروعك تماماً
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    // إضافة الفايربيس المتوافقة
    id("com.google.gms.google-services") version "4.4.2" apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}