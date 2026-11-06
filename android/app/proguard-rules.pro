# shared_preferences_android 2.5.0+ calls its Kotlin API from Dart via raw JNI
# (jnigen), looking up methods and classes by name and descriptor. R8 renames
# the kotlin.* classes in those descriptors (kotlin.coroutines.Continuation ->
# e.g. v3.e), so the lookup dies at the first preferences read with
# NoSuchMethodError and the app hangs on the splash screen
# (flutter/flutter#194649). The plugin ships no consumer rules; keep the Kotlin
# classes here until package:jni ships them (dart-lang/native#3732).
-keep class kotlin.Unit { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }
