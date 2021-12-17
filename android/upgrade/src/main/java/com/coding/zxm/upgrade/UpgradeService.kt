package com.coding.zxm.upgrade

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import com.coding.zxm.upgrade.callback.FileDownloadCallback
import com.coding.zxm.upgrade.network.IUpgradeProvider
import com.coding.zxm.upgrade.utils.UpgradeUtils
import java.io.File
import kotlin.math.roundToInt

/**
 * Created by ZhangXinmin on 2021/05/19.
 * Copyright (c) 5/19/21 . All rights reserved.
 * 用户控制更新包的下载
 */
class UpgradeService : Service() {

    companion object {
        private var isDownloading: Boolean = false
        private const val TAG = "UpgradeService"

        private var context: Context? = null
        private var conn: ServiceConnection? = null

        //Notification
        private const val NOTIFY_ID: Int = 1001
        private const val CHANNEL_ID = "app_update_id"
        private const val CHANNEL_NAME: String = "app_update_channel"
        private var mNotificationManager: NotificationManager? = null
        private var mBuilder: NotificationCompat.Builder? = null

        fun bindService(context: Context, connection: ServiceConnection) {
            this.context = context
            val intent = Intent(context, UpgradeService::class.java)
            context.bindService(intent, connection, Context.BIND_AUTO_CREATE)
        }

        fun unBindService(context: Context) {
            conn?.let { context.unbindService(it) }
        }
    }


    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "onCreate()")
        mNotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    }

    override fun onBind(intent: Intent?): IBinder? {
        Log.d(TAG, "onBind()")
        return UpgradeBinder()
    }

    override fun unbindService(conn: ServiceConnection) {
        Log.d(TAG, "unbindService()")
        super.unbindService(conn)
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy()")
        mNotificationManager = null

        super.onDestroy()
    }

    class UpgradeBinder : Binder() {
        fun checkUpgrade(
            @NonNull provider: IUpgradeProvider?,
            token: String?,
            apkName: String?
        ) {
            if (!TextUtils.isEmpty(token) && !TextUtils.isEmpty(apkName)) {
                provider?.checkUpgrade(token!!, apkName!!)
            }
        }

        /**
         * 是否有新版本
         */
        fun hasNewVersion(@NonNull provider: IUpgradeProvider): Boolean {
            return provider.hasNewVersion()
        }

        fun downloadApk(
            downloadUrl: String?,
            provider: IUpgradeProvider?
        ) {

            if (provider != null) {
                val apkFile = provider.getNewApkFile()

                if (apkFile != null && apkFile.exists()) {
                    UpgradeUtils.installNewApkWithNoRoot(context!!, apkFile)
                } else {
                    if (!TextUtils.isEmpty(downloadUrl)) {
                        setUpNotification()
                        if (!isDownloading) {
                            provider.downloadApk(downloadUrl, object : FileDownloadCallback {
                                override fun onDownloadFailed(msg: String?) {
                                    Log.e(TAG, "文件下载失败：$msg")
                                    isDownloading = false
                                    unBindService(context!!)
                                }

                                override fun inProgress(progress: Float, totalSize: Long) {
                                    isDownloading = true
                                    if (mBuilder != null) {
                                        val rate = (progress * 100).roundToInt()
                                        mBuilder?.setContentTitle(
                                            "正在下载：${UpgradeUtils.getAppName(
                                                context
                                            )}"
                                        )
                                            ?.setContentText("$rate%")
                                            ?.setProgress(100, rate, false)
                                            ?.setWhen(System.currentTimeMillis())

                                        val notification = mBuilder?.build()
                                        notification?.flags =
                                            Notification.FLAG_AUTO_CANCEL or Notification.FLAG_ONLY_ALERT_ONCE

                                        mNotificationManager?.notify(NOTIFY_ID, notification)
                                    }
                                }

                                override fun onDownloadFinished(file: File) {
                                    isDownloading = false
                                    if (UpgradeUtils.isAppOnForeground(context!!)) {
                                        mNotificationManager?.cancel(NOTIFY_ID)

                                        UpgradeUtils.installNewApkWithNoRoot(
                                            context!!,
                                            provider.getNewApkFile()
                                        )
                                    } else {

                                        //App后台运行
                                        //更新参数,注意flags要使用FLAG_UPDATE_CURRENT
                                        val installAppIntent = UpgradeUtils.getInstallIntent(
                                            context!!, provider.getNewApkFile()
                                        )

                                        val contentIntent =
                                            PendingIntent.getActivity(
                                                context!!,
                                                0,
                                                installAppIntent,
                                                PendingIntent.FLAG_UPDATE_CURRENT
                                            )
                                        mBuilder!!.setContentIntent(contentIntent)
                                            .setContentTitle(UpgradeUtils.getAppName(context))
                                            .setContentText("下载完成，请点击安装")
                                            .setProgress(
                                                0,
                                                0,
                                                false
                                            ) //                        .setAutoCancel(true)
                                            .setDefaults(Notification.DEFAULT_ALL)
                                        val notification =
                                            mBuilder!!.build()
                                        notification.flags =
                                            Notification.FLAG_AUTO_CANCEL
                                        mNotificationManager!!.notify(NOTIFY_ID, notification)
                                    }
                                    unBindService(context!!)
                                }


                            })
                        }
                    }
                }
            }
        }

        /**
         * 创建通知
         */
        private fun setUpNotification() {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel =
                    NotificationChannel(
                        CHANNEL_ID,
                        CHANNEL_NAME,
                        NotificationManager.IMPORTANCE_HIGH
                    )

                channel.enableLights(false)
                channel.enableVibration(false)

                mNotificationManager?.createNotificationChannel(channel)
            }

            mBuilder = NotificationCompat.Builder(context!!, CHANNEL_ID)
            val iconDrawable = UpgradeUtils.getAppIcon(context!!)
            mBuilder?.setContentTitle("开始下载")
                ?.setContentText("正在连接服务器")
                ?.setSmallIcon(R.mipmap.lib_update_download_icon)
                ?.setLargeIcon(iconDrawable?.let { UpgradeUtils.drawableToBitmap(it) })
                ?.setOngoing(true)
                ?.setAutoCancel(true)
                ?.setWhen(System.currentTimeMillis())

            mNotificationManager?.notify(NOTIFY_ID, mBuilder!!.build())

        }
    }


}