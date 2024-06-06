# Keep Firebase Analytics classes
-keep class com.google.firebase.analytics.** { *; }

# Keep Firebase Messaging classes
-keep class com.google.firebase.messaging.** { *; }

# Keep classes for the Kotlin standard library
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }
-keepclassmembers class kotlin.Metadata { *; }

# Keep all the classes and members in the com.talabatek.app namespace
-keep class com.talabatek.app.** { *; }

# Keep any other classes you might need
-keep class com.google.android.gms.** { *; }
