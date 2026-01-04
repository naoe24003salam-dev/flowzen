# Flutter and plugin keeps
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Hive keeps - CRITICAL for app to work
-keep class * extends com.hivedb.** { *; }
-keep class com.hivedb.** { *; }
-keepclassmembers class * extends com.hivedb.** { *; }

# Keep all models and adapters
-keep class com.flowzen.app.** { *; }
-keepclassmembers class * {
    @com.hivedb.** <fields>;
}

# Gson (if used)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
