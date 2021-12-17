package com.coding.zxm.upgrade.utils

import android.app.ActivityManager
import android.app.ActivityManager.RunningAppProcessInfo
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.PixelFormat
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.text.TextUtils
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import com.coding.zxm.upgrade.entity.UpdateEntity
import java.io.File

/**
 * Created by ZhangXinmin on 2021/05/20.
 * Copyright (c) 5/20/21 . All rights reserved.
 */
class UpgradeUtils private constructor() {
    companion object {
        /**
         * Get app version code
         */
        fun getAppVersionCode(context: Context): Int {
            val packageManager = context.packageManager
            if (packageManager != null) {
                val packageInfo = packageManager.getPackageInfo(context.packageName, 0)
                return packageInfo.versionCode
            }
            return -1
        }

        /**
         * Get app name
         */
        fun getAppName(context: Context?): String {
            val packageManager = context?.packageManager
            if (packageManager != null) {
                val packageInfo = packageManager.getPackageInfo(context.packageName, 0)
                return packageInfo.applicationInfo.loadLabel(context.packageManager).toString()
            }
            return ""
        }

        /**
         * 是否存在新版本
         */
        fun hasNewVersion(@NonNull context: Context, @NonNull entity: UpdateEntity?): Boolean {
            if (entity != null) {
                val currVersion = getAppVersionCode(context)
                val newVersion = entity.version
                if (!TextUtils.isEmpty(newVersion) && currVersion != -1) {
                    return newVersion!!.toInt() > currVersion
                }
            }
            return false
        }

        /**
         * Checks if external storage is available for read and write
         */
        fun isExternalStorageWritable(): Boolean {
            val state: String = Environment.getExternalStorageState()
            return Environment.MEDIA_MOUNTED == state
        }

        /**
         * 获取AppIcon
         */
        fun getAppIcon(context: Context): Drawable? {
            try {
                return context.packageManager.getApplicationIcon(context.packageName)
            } catch (e: PackageManager.NameNotFoundException) {
                e.printStackTrace()
            }
            return null
        }

        fun drawableToBitmap(drawable: Drawable): Bitmap {
            val bitmap = Bitmap.createBitmap(
                drawable.intrinsicWidth,
                drawable.intrinsicHeight,
                if (drawable.opacity != PixelFormat.OPAQUE) Bitmap.Config.ARGB_8888 else Bitmap.Config.RGB_565
            )
            val canvas = Canvas(bitmap)

            //canvas.setBitmap(bitmap);
            drawable.setBounds(0, 0, drawable.intrinsicWidth, drawable.intrinsicHeight)
            drawable.draw(canvas)
            return bitmap
        }

        /**
         * 是否前台
         */
        fun isAppOnForeground(context: Context): Boolean {
            val activityManager =
                context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val packageName = context.packageName
            val appProcesses =
                activityManager.runningAppProcesses ?: return false
            for (appProcess in appProcesses) {
                if (appProcess.processName == packageName && appProcess.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                    return true
                }
            }
            return false
        }

        /**
         * install new version apk
         *
         * @param file
         */
        fun installNewApkWithNoRoot(context: Context, file: File?) {
            if (file != null && file.exists()) {
                Toast.makeText(context, "正在安装更新...", Toast.LENGTH_SHORT).show()
                val intent = getInstallIntent(context, file)
                context.startActivity(intent)
            }
        }

        /**
         * install new version apk
         *
         * @param file
         */
        fun getInstallIntent(context: Context, file: File?): Intent? {
            if (file != null && file.exists()) {
                val intent = Intent(Intent.ACTION_VIEW)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    intent.flags =
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                    val contentUri: Uri = FileProvider
                        .getUriForFile(
                            context,
                            context.applicationContext.packageName + ".fileProvider",
                            file
                        )
                    intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
                } else {
                    intent.setDataAndType(
                        Uri.fromFile(file),
                        "application/vnd.android.package-archive"
                    )
                }
                return intent
            }
            return null
        }
    }
}