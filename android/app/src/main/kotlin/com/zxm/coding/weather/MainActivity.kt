package com.zxm.coding.weather

import androidx.lifecycle.Observer
import com.coding.zxm.upgrade.UpgradeManager
import com.coding.zxm.upgrade.network.UpgradeProgressProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    companion object {
        private const val UPGRADE_CHANNEL = "upgrade_channel"
    }


    private fun checkUpgrade() {
        UpgradeManager.getInstance().checkUpgrade(UpgradeProgressProvider(this))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        initFlutterChannel(flutterEngine)
    }

    private fun initFlutterChannel(flutterEngine: FlutterEngine) {

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPGRADE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when {
                    call.method.equals("checkUpgrade") -> {
                        checkUpgrade()
                        result.success("success")
                    }
                    call.method.equals("hasNewVersion") -> {
                        UpgradeManager.getInstance().hasNewVersion(UpgradeProgressProvider(this))
                            .observe(this, Observer {
                                if (it != null) {
                                    result.success(it)
                                } else {
                                    result.error("-1", "网络异常", "版本信息比对失败")
                                }
                            })
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }


}
