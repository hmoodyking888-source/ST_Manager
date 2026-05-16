// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    // إصدار الأندرويد المطابق لمشروعك
    id("com.android.application") version "8.11.1" apply false
    // إصدار كوتلن المطابق لمشروعك
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    // تم حذف تحديد الإصدار هنا ليقوم فلاتر بإدارة نفسه تلقائياً ومنع التضارب
    id("dev.flutter.flutter-gradle-plugin") apply false
    // إضافة الفايربيس المستقرة
    id("com.google.gms.google-services") version "4.4.2" apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}