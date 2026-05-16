// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    // إصدار الأندرويد المطابق لمشروعك
    id("com.android.application") version "8.11.1" apply false
    // تم تحديث إصدار كوتلن هنا إلى 2.2.20 ليطابق مشروعك تماماً وتنتهي المشكلة
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    // إضافة الفايربيس المستقرة
    id("com.google.gms.google-services") version "4.4.2" apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}