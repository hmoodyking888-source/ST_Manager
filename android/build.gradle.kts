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
# 1. إيقاف تشغيل ديمون Gradle وتحديد حجم الذاكرة له
org.gradle.daemon=false
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m

# 2. تقييد ذاكرة ديمون الكوتلن ومنعه من التضخم
kotlin.daemon.jvm.options=-Xmx1024m

# 3. الحل السحري: إجبار الكوتلن على البناء داخل نفس عملية Gradle بدون فتح ديمون مستقل
kotlin.compiler.execution.strategy=in-process