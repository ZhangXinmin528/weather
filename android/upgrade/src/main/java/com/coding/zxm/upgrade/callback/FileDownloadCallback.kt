package com.coding.zxm.upgrade.callback

import java.io.File

/**
 * Created by ZhangXinmin on 2021/05/20.
 * Copyright (c) 5/20/21 . All rights reserved.
 */
interface FileDownloadCallback {

    fun onDownloadFailed(msg: String?)

    fun inProgress(progress: Float, totalSize: Long)

    fun onDownloadFinished(file: File)
}