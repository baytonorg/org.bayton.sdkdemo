plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "org.bayton.sdkdemo"
    compileSdk = 36

    signingConfigs {
        create("bayton") {
            storeFile = file("/users/jasonbayton/baytonkeyandroidapp")
            storePassword = findProperty("keystorePassword") as String? ?: ""
            keyAlias = findProperty("keyAlias") as String? ?: ""
            keyPassword = findProperty("keyPassword") as String? ?: ""
        }
    }

    defaultConfig {
        applicationId = "org.bayton.sdkdemo"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("bayton")
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "sdk"

    productFlavors {
        // Android 5.0 - 17 (API 21 - 37)
        val sdkLevels = mapOf(
            21 to "5.0",
            22 to "5.1",
            23 to "6.0",
            24 to "7.0",
            25 to "7.1",
            26 to "8.0",
            27 to "8.1",
            28 to "9",
            29 to "10",
            30 to "11",
            31 to "12",
            32 to "12L",
            33 to "13",
            34 to "14",
            35 to "15",
            36 to "16",
            // Uncomment when Android 17 SDK (API 37) is installed:
            // 37 to "17",
        )

        sdkLevels.forEach { (api, version) ->
            create("sdk$api") {
                dimension = "sdk"
                targetSdk = api
                versionNameSuffix = "-sdk$api"
                buildConfigField("String", "ANDROID_VERSION_LABEL", "\"Android $version\"")
                buildConfigField("int", "TARGET_SDK_LEVEL", "$api")
            }
        }
    }

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.constraintlayout:constraintlayout:2.2.1")
}
