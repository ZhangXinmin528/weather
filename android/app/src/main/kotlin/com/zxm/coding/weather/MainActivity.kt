package com.zxm.coding.weather

import android.os.Bundle
import com.coding.zxm.upgrade.UpgradeManager
import com.coding.zxm.upgrade.network.UpgradeProgressProvider
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initUpgrade()
    }

    private fun initUpgrade() {
        val provider = UpgradeProgressProvider(this)
        UpgradeManager.getInstance().checkUpgrade(provider)
    }

}
