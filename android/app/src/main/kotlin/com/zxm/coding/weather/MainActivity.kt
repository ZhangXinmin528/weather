package com.zxm.coding.weather

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.lifecycle.Observer
import com.alibaba.fastjson.JSON
import com.coding.zxm.upgrade.UpgradeManager
import com.coding.zxm.upgrade.network.UpgradeProgressProvider
import com.coding.zxm.upgrade.utils.UpgradeUtils
import com.zxm.coding.weather.entity.WeatherWarning
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private lateinit var mContext: Context
    private var mNotificationManager: NotificationManager? = null

    //天气预警
    private var mWarningBuilder: NotificationCompat.Builder? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mContext = this

        mNotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    private fun checkUpgrade() {
        UpgradeManager.getInstance().checkUpgrade(UpgradeProgressProvider(this))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        initUpgradeChannel(flutterEngine)

        initWeatherNotification(flutterEngine)
    }

    /**
     * 更新相关
     */
    private fun initUpgradeChannel(flutterEngine: FlutterEngine) {

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ChannelConstants.UPGRADE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when {
                    call.method.equals(ChannelConstants.UPGRADE_CHECK) -> {
                        checkUpgrade()
                        result.success("success")
                    }
                    call.method.equals(ChannelConstants.UPGRADE_NEWVERSION) -> {
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

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

    }

    /**
     * 天气通知
     */
    private fun initWeatherNotification(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ChannelConstants.NOTIFICATION_WEATHER
        )
            .setMethodCallHandler { call, result ->
                when {
                    call.method.equals(ChannelConstants.NOTIFI_WEATHER_WARNING) -> {
                        initWeatherNotifiChannel()

                        if (call.hasArgument(ChannelConstants.WEATHER_WARNING_ARGS)) {
                            val json = call.argument<String>(ChannelConstants.WEATHER_WARNING_ARGS)
                            Log.d("zxm==", "warning:$json")
                            if (!TextUtils.isEmpty(json)) {
                                val weatherWarning =
                                    JSON.parseObject(json, WeatherWarning::class.java)
                                val warningList = weatherWarning.warning
                                if (warningList != null && warningList.isNotEmpty()) {
                                    val iconDrawable = UpgradeUtils.getAppIcon(this)
                                    warningList.forEach {
                                        val intent = getLaunchIntent(mContext)

                                        var flags = PendingIntent.FLAG_UPDATE_CURRENT
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                            flags = flags or PendingIntent.FLAG_IMMUTABLE
                                        }

                                        val pendingIntent =
                                            PendingIntent.getActivity(
                                                mContext,
                                                ChannelConstants.WEATHER_WARNING_NOTIFI_CHANNEL_ID,
                                                intent,
                                                flags
                                            )
                                        mWarningBuilder?.setContentTitle("ceshi")
                                            ?.setContentText("hahah")
                                            ?.setSmallIcon(R.mipmap.ic_launcher)
                                            ?.setLargeIcon(iconDrawable?.let { drawable ->
                                                UpgradeUtils.drawableToBitmap(
                                                    drawable
                                                )
                                            })
                                            ?.setContentIntent(pendingIntent)
                                            ?.setWhen(System.currentTimeMillis())
                                        mNotificationManager?.notify(
                                            ChannelConstants.WEATHER_WARNING_NOTIFI_CHANNEL_ID,
                                            mWarningBuilder!!.build()
                                        )
                                    }
                                }

                            }
                            result.success("success")
                        }

                    }
                }
            }
    }

    private fun getLaunchIntent(context: Context): Intent? {
        val packageName = context.packageName
        val packageManager = context.packageManager
        return packageManager.getLaunchIntentForPackage(packageName)
    }

    private fun initWeatherNotifiChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    ChannelConstants.NOTIFI_WEATHER_WARNING_CHANNEL_ID,
                    ChannelConstants.NOTIFI_WEATHER_WARNING_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_HIGH
                )

            channel.enableLights(true)
            channel.enableVibration(true)
            channel.setShowBadge(true)

            mNotificationManager?.createNotificationChannel(channel)
        }
        mWarningBuilder =
            NotificationCompat.Builder(this, ChannelConstants.NOTIFI_WEATHER_WARNING_CHANNEL_ID)

    }

    override fun onDestroy() {
        super.onDestroy()
        mNotificationManager = null
    }


}
