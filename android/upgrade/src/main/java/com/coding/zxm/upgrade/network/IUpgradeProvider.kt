package com.coding.zxm.upgrade.network

import androidx.annotation.NonNull
import com.coding.zxm.upgrade.callback.FileDownloadCallback
import com.coding.zxm.upgrade.entity.UpdateEntity
import java.io.File

/**
 * Created by ZhangXinmin on 2021/05/20.
 * Copyright (c) 5/20/21 . All rights reserved.
 */
interface IUpgradeProvider {
    /**
     * 检查更新
     */
    fun checkUpgrade(@NonNull token: String, apkName: String): Boolean

    /**
     * 是否有新版本
     */
    fun hasNewVersion(): Boolean

    /**
     * 下载apk
     */
    fun downloadApk(downloadUrl: String?, callback: FileDownloadCallback?): Boolean

    /**
     * 展示更新弹窗
     */
    fun showUpgradeDialog(entity: UpdateEntity?)

    /**
     * 获取下载的安装包文件
     */
    fun getNewApkFile(): File?

}