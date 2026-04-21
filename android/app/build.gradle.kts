import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseSigningProperties = Properties()
val releaseSigningFile = rootProject.file("key.properties")
val requiredReleaseSigningKeys = listOf(
    "storeFile",
    "storePassword",
    "keyAlias",
    "keyPassword",
)

if (releaseSigningFile.exists()) {
    releaseSigningFile.inputStream().use(releaseSigningProperties::load)
}

val releaseStoreFilePath = releaseSigningProperties.getProperty("storeFile")
val hasReleaseSigning = releaseSigningFile.exists() &&
    requiredReleaseSigningKeys.all { key ->
        !releaseSigningProperties.getProperty(key).isNullOrBlank()
    } &&
    !releaseStoreFilePath.isNullOrBlank() &&
    rootProject.file(releaseStoreFilePath).exists()

android {
    namespace = "com.mascotify.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                // Release signing is only enabled when the local keystore and
                // every required property exist. This avoids treating a half
                // configured key.properties as if release signing were ready.
                storeFile = rootProject.file(releaseStoreFilePath)
                storePassword = releaseSigningProperties.getProperty("storePassword")
                keyAlias = releaseSigningProperties.getProperty("keyAlias")
                keyPassword = releaseSigningProperties.getProperty("keyPassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.mascotify.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}
