package com.coding.zxm.upgrade.network

import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.MutableLiveData
import com.coding.zxm.upgrade.callback.FileDownloadCallback
import com.coding.zxm.upgrade.entity.UpdateEntity
import com.coding.zxm.upgrade.entity.UpdateResult
import java.io.File

/**
 * Created by ZhangXinmin on 2021/05/20.
 * Copyright (c) 5/20/21 . All rights reserved.
 */
abstract class IUpgradeProvider(val activity: FragmentActivity) {
    /**
     * 检查更新
     */
    abstract fun checkUpgrade(
        @NonNull token: String,
        apkName: String
    ): MutableLiveData<UpdateResult>

    /**
     * 下载apk
     */
    abstract fun downloadApk(downloadUrl: String?, callback: FileDownloadCallback?): Boolean

    /**
     * 展示更新弹窗
     */
    abstract fun showUpgradeDialog(entity: UpdateEntity?)

    /**
     * 获取下载的安装包文件
     */
    abstract fun getNewApkFile(): File?

}