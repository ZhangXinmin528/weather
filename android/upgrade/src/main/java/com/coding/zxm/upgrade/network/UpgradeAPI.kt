package com.coding.zxm.upgrade.network

import com.coding.zxm.upgrade.entity.UpdateEntity
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query
import retrofit2.http.Streaming
import retrofit2.http.Url

/**
 * Created by ZhangXinmin on 2021/05/14.
 * Copyright (c) 5/14/21 . All rights reserved.
 */
interface UpgradeAPI {

    /**
     * 检查版本更新
     */
    @GET("latest/6197459523389f28bd6c376c")
    fun checkUpdate(@Query("api_token") token: String): Call<UpdateEntity>

    /**
     * 下载更新APK
     */
    @Streaming
    @GET
    fun downloadApk(@Url downloadUrl: String): Call<ResponseBody>
}