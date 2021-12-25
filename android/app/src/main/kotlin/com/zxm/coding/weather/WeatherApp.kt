package com.zxm.coding.weather

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import com.coding.zxm.upgrade.UpgradeManager

/**
 * Created by ZhangXinmin on 2021/12/25.
 * Copyright (c) 2021/12/25 . All rights reserved.
 */
class WeatherApp : Application() {

    override fun onCreate() {
        super.onCreate()
        initUpgrade()
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    private fun initUpgrade() {
        val config = UpgradeManager.UpgradeConfig()
            .setContext(this)
            .setUpgradeToken("911a59ee1bfdd702ccdd1935bde1fe30")
            .setApkName("weather")
            .create()

        UpgradeManager.getInstance().init(config)
    }
}