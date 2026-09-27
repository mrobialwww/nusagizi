# ===== Flutter & Flutter Engine =====
-keep class io.flutter.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.util.PathUtils { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**

# ===== JNI (path_provider_android dan plugin berbasis JNI lainnya) =====
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep class com.github.dart_lang.jni.** { *; }
-dontwarn com.github.dart_lang.jni.**

# ===== Keep Flutter plugin registrants =====
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { *; }

# ===== Auth0 =====
-keep class com.auth0.** { *; }
-keep interface com.auth0.** { *; }
-dontwarn com.auth0.**

# ===== Gson (dipakai Auth0 & beberapa plugin lain untuk serialize/deserialize) =====
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keep class * implements java.io.Serializable { *; }
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# ===== OkHttp (network layer Auth0) =====
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ===== MLKit Barcode Scanning (mobile_scanner) =====
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-keep class com.google.android.gms.vision.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# ===== Keep App Entry Points (Activity & Application) =====
# Mencegah R8 menghapus MainActivity dan class turunannya
-keep class com.nexuskesehatanina.nusagizi.** { *; }
-keep class * extends android.app.Activity { *; }
-keep class * extends android.app.Application { *; }
-keep class * extends androidx.fragment.app.Fragment { *; }
