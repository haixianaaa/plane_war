plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.plane_war.app"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.plane_war.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // Force use of Make instead of Ninja to avoid Windows GetOverlappedResult bug
    defaultConfig {
        externalNativeBuild {
            cmake {
                arguments += listOf(
                    "-G", "Unix Makefiles",
                    "-DCMAKE_MAKE_PROGRAM=C:/Users/wangs/AppData/Local/Android/sdk/ndk/28.2.13676358/prebuilt/windows-x86_64/bin/make.exe"
                )
            }
        }
    }
}

dependencies {
    implementation("androidx.core:core:1.13.1")
}

flutter {
    source = "../.."
}
