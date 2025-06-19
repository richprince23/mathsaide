import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
var hasValidKeystore = false

if (keystorePropertiesFile.exists()) {
    try {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))

        // Validate all required keystore properties exist and are not empty
        val requiredProps = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
        val missingProps = requiredProps.filter {
            keystoreProperties.getProperty(it).isNullOrBlank()
        }

        if (missingProps.isEmpty()) {
            // Validate store file exists
            val storeFile = file(keystoreProperties.getProperty("storeFile"))
            if (storeFile.exists()) {
                hasValidKeystore = true
                println("✓ Valid keystore configuration found")
            } else {
                println("⚠️  Keystore file not found: ${storeFile.absolutePath}")
            }
        } else {
            println("⚠️  Missing keystore properties: ${missingProps.joinToString(", ")}")
        }
    } catch (e: Exception) {
        println("⚠️  Error loading keystore properties: ${e.message}")
    }
} else {
    println("⚠️  key.properties file not found at: ${keystorePropertiesFile.absolutePath}")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    try {
        localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
            localProperties.load(reader)
        }
    } catch (e: Exception) {
        throw GradleException("Error reading local.properties: ${e.message}")
    }
} else {
    throw GradleException("local.properties file not found. This file is required for Flutter projects.")
}

val flutterRoot = localProperties.getProperty("flutter.sdk")
    ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

// Validate and parse version properties with fallbacks
val flutterVersionCode = try {
    val versionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
    versionCode.toInt()
} catch (e: NumberFormatException) {
    println("⚠️  Invalid flutter.versionCode, using default: 1")
    1
}

val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

plugins {
    id("com.android.application")
    id("kotlin-android")
    // id("com.google.gms.google-services") // Uncomment when ready to use
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.suptle.mathsaide"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion
    // ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.suptle.mathsaide"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true

        // Add these for better debugging
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            if (hasValidKeystore) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                println("✓ Release signing configured with keystore")
            } else {
                println("⚠️  Release builds will use debug signing (not suitable for production)")
                // Will fall back to debug signing
            }
        }
    }

    buildTypes {
        getByName("debug") {
            isDebuggable = true
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }

        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Only use release signing if we have a valid keystore
            if (hasValidKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Will use debug signing - warn the user
                println("⚠️  WARNING: Release build using debug signing - not suitable for production!")
            }
        }
    }

    // Add lint options to catch potential issues
    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }

    // Handle potential build issues
    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}

// Add helpful tasks for keystore management
tasks.register("checkKeystore") {
    doLast {
        if (hasValidKeystore) {
            println("✓ Keystore configuration is valid")
            println("  - Keystore file: ${keystoreProperties.getProperty("storeFile")}")
            println("  - Key alias: ${keystoreProperties.getProperty("keyAlias")}")
        } else {
            println("❌ Keystore configuration issues detected")
            println("To fix:")
            println("1. Create a key.properties file in your project root")
            println("2. Add the following properties:")
            println("   storePassword=your_store_password")
            println("   keyPassword=your_key_password")
            println("   keyAlias=your_key_alias")
            println("   storeFile=path/to/your/keystore.jks")
        }
    }
}

tasks.register("createKeystore") {
    doLast {
        println("To create a new keystore, run:")
        println("keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload")
    }
}