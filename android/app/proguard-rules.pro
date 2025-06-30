# Remove unused classes
-dontwarn android.support.**
-dontwarn com.google.**
-dontwarn com.facebook.**
-keep class com.huawei.** { *; }
-dontwarn com.huawei.**

# Flutter-related
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
# Remove debug metadata
-keepattributes !SourceFile,!LineNumberTable