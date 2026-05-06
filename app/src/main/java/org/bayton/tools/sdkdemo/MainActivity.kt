package org.bayton.tools.sdkdemo

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Go fullscreen - hide system bars
        WindowCompat.setDecorFitsSystemWindows(window, false)
        val controller = WindowInsetsControllerCompat(window, window.decorView)
        controller.hide(WindowInsetsCompat.Type.systemBars())
        controller.systemBarsBehavior =
            WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

        setContentView(R.layout.activity_main)

        val targetSdk = applicationInfo.targetSdkVersion

        // Target SDK / Min API section
        findViewById<TextView>(R.id.targetSdkValue).text =
            getString(R.string.target_sdk_value, BuildConfig.ANDROID_VERSION_LABEL, targetSdk)

        // Current device Android version
        findViewById<TextView>(R.id.deviceVersionValue).text =
            getString(R.string.device_version_value, Build.VERSION.RELEASE, Build.VERSION.SDK_INT)

        findViewById<TextView>(R.id.learnMoreLink).setOnClickListener {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://bayton.org/android/android-minimum-targetsdk-matrix")))
        }
    }
}
