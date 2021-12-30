package com.zxm.coding.weather

/**
 * Created by ZhangXinmin on 2021/12/30.
 * Copyright (c) 2021/12/30 . All rights reserved.
 */
object ChannelConstants {
    /**
     * 更新
     */
    const val UPGRADE_CHANNEL = "upgrade_channel"

    //检查更新
    const val UPGRADE_CHECK = "checkUpgrade"

    //新版本
    const val UPGRADE_NEWVERSION = "hasNewVersion"

    /**
     * notification
     */
    const val NOTIFICATION_WEATHER = "notification_weather"

    //NOTIFICATION
    const val WEATHER_WARNING_NOTIFI_CHANNEL_ID = 2001

    //NOTIFICATION WEATHER WARNING
    const val NOTIFI_WEATHER_WARNING_CHANNEL_ID = "weather_warning_channel_id"
    const val NOTIFI_WEATHER_WARNING_CHANNEL_NAME = "weather_warning_channel"

    const val NOTIFI_WEATHER_WARNING = "notifiWeatherWarning"
    const val WEATHER_WARNING_ARGS = "notifi_weather_warning_args"
}