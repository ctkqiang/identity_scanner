# Flutter specific
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Google Play Services (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Prevent Kotlin reflection being removed
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# Flutter plugins (if any)
-keep class com.yourplugin.** { *; }

# Optional: keep annotations
-keepattributes *Annotation*
