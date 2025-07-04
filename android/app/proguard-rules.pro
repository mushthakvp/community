# Keep all classes and methods annotated with @Keep
-keep @proguard.annotation.Keep class * {*;}
-keep @proguard.annotation.KeepClassMembers class * {*;}

# Keep Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep ProGuard annotations
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Additional rules for Razorpay
-keepattributes *Annotation*
-keepclassmembers class * {
    @proguard.annotation.Keep *;
}

# Keep all public classes that might be used by Razorpay
-keep public class * {
    public protected *;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Flutter and Dart specific classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }
-dontwarn io.flutter.**
-dontwarn androidx.**

# Keep Google Play Services (if using Google Sign-In)
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**