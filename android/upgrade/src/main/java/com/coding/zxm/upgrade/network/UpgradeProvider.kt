package com.coding.zxm.upgrade.network

import android.os.Environment
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.MutableLiveData
import com.coding.zxm.upgrade.UpdateDialogFragment
import com.coding.zxm.upgrade.callback.FileDownloadCallback
import com.coding.zxm.upgrade.entity.UpdateEntity
import com.coding.zxm.upgrade.utils.SSLSocketFactoryCompat
import com.coding.zxm.upgrade.utils.UpgradeUtils
import okhttp3.OkHttpClient
import okhttp3.ResponseBody
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.*
import java.security.cert.X509Certificate
import java.util.concurrent.TimeUnit
import javax.net.ssl.X509TrustManager

/**
 * Created by ZhangXinmin on 2021/05/20.
 * Copyright (c) 5/20/21 . All rights reserved.
 */
class UpgradeProvider(val activity: FragmentActivity) :
    IUpgradeProvider {

    companion object {
        private const val TAG = "DownloadProvider"
        private var okHttpClient: OkHttpClient? = null
        private var sslSocketFactory: SSLSocketFactoryCompat? = null
        private var loggingInterceptor: HttpLoggingInterceptor? = null

        private var upgradeLivedata: MutableLiveData<UpdateEntity> = MutableLiveData()

        private var apkName: String = ""
        private var apkFile: File? = null
        private var hasNewVersion: Boolean = false
    }

    init {
        init()
    }

    private fun init() {
        val trustAllCert = object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {

            }

            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {

            }

            override fun getAcceptedIssuers(): Array<X509Certificate> {
                return arrayOf<X509Certificate>()
            }

        }

        sslSocketFactory =
            SSLSocketFactoryCompat(trustAllCert)
        loggingInterceptor = HttpLoggingInterceptor { message ->
            Log.d(TAG, "checkUpgrade()..msg:$message")
        }

        okHttpClient = OkHttpClient.Builder()
            .addInterceptor(loggingInterceptor!!)
            .sslSocketFactory(sslSocketFactory!!, trustAllCert)
            .connectTimeout(30, TimeUnit.SECONDS)
            .retryOnConnectionFailure(true)
            .build()
    }

    override fun checkUpgrade(@NonNull token: String, name: String): Boolean {

        if (okHttpClient == null) {
            Log.e(TAG, "OkHttpClient初始化失败")
            return false
        }
        //已经请求过数据
        val entity = upgradeLivedata.value
        if (entity != null) {
            hasNewVersion = UpgradeUtils.hasNewVersion(activity, entity)
            if (hasNewVersion) {
                apkName =
                    name + "_" + entity.versionShort + "_build${entity.build}" + ".apk"

                showUpgradeDialog(entity)
            } else {
                Toast.makeText(activity, "已是最新版本", Toast.LENGTH_SHORT).show()
            }
            return true
        }

        val retrofit = Retrofit.Builder()
            .baseUrl("http://api.bq04.com/apps/")
            .addConverterFactory(GsonConverterFactory.create())
            .client(okHttpClient!!)
            .build()

        retrofit.create(UpgradeAPI::class.java).checkUpdate(token)
            .enqueue(object : Callback<UpdateEntity> {
                override fun onFailure(call: Call<UpdateEntity>, t: Throwable) {
                    //TODO:检查更新失败
                    upgradeLivedata.postValue(null)
                }

                override fun onResponse(
                    call: Call<UpdateEntity>,
                    response: Response<UpdateEntity>
                ) {
                    if (response.isSuccessful) {
                        val entity = response.body()
                        hasNewVersion = UpgradeUtils.hasNewVersion(activity, entity)
                        upgradeLivedata.postValue(entity)
                        if (hasNewVersion) {
                            apkName =
                                name + "_" + entity?.versionShort + "_build${entity?.build}" + ".apk"

                            showUpgradeDialog(entity)
                        } else {
                            Toast.makeText(activity, "已是最新版本", Toast.LENGTH_SHORT).show()
                        }
                    } else {
                        //TODO:检查更新失败
                        upgradeLivedata.postValue(null)
                    }
                }

            })
        return true
    }

    override fun hasNewVersion(): Boolean {
        val entity = upgradeLivedata.value
        if (entity != null) {
            hasNewVersion = UpgradeUtils.hasNewVersion(activity, entity)
        }
        return hasNewVersion
    }

    override fun downloadApk(downloadUrl: String?, callback: FileDownloadCallback?): Boolean {
        if (!TextUtils.isDigitsOnly(downloadUrl)) {

            if (okHttpClient == null) {
                Log.e(TAG, "OkHttpClient初始化失败")
                callback?.onDownloadFailed("OkHttpClient初始化失败")
                return false
            }

            val retrofit = Retrofit.Builder()
                .baseUrl("https://download.jappstore.com/apps/")
                .addConverterFactory(GsonConverterFactory.create())
                .client(okHttpClient!!)
                .build()

            retrofit.create(UpgradeAPI::class.java).downloadApk(downloadUrl!!)
                .enqueue(object : Callback<ResponseBody> {
                    override fun onResponse(
                        call: Call<ResponseBody>,
                        response: Response<ResponseBody>
                    ) {
                        if (response.isSuccessful) {
                            if (response.body() != null) {
                                val body = response.body()
                                body?.let {

                                    var inputStream: InputStream? = null
                                    var fileOutputStream: FileOutputStream? = null
                                    var bufferedInputStream: BufferedInputStream? = null

                                    val apkPathDir: String

                                    try {
                                        inputStream = it.byteStream()

                                        apkPathDir = if (UpgradeUtils.isExternalStorageWritable()) {
                                            Environment.getExternalStoragePublicDirectory(
                                                Environment.DIRECTORY_DOWNLOADS
                                            ).absolutePath
                                        } else {
                                            activity.filesDir.absolutePath
                                        }

                                        apkFile = File(apkPathDir, "$apkName.apk")

                                        fileOutputStream = FileOutputStream(apkFile)
                                        bufferedInputStream = BufferedInputStream(inputStream)


                                        val byte = ByteArray(1024)

                                        var length: Int

                                        while (bufferedInputStream.read(byte)
                                                .also { l -> length = l } != -1
                                        ) {
                                            fileOutputStream.write(byte, 0, length)
                                            fileOutputStream.flush()
                                        }

                                    } catch (e: IOException) {
                                        e.printStackTrace()
                                    } finally {
                                        try {
                                            fileOutputStream?.close()
                                            bufferedInputStream?.close()
                                            inputStream?.close()

                                            //文件下载成功
                                            callback?.onDownloadFinished(apkFile!!)

                                        } catch (e: IOException) {
                                            e.printStackTrace()
                                        }
                                    }
                                }
                            }
                        } else {
                            callback?.onDownloadFailed("网络请求失败！")
                        }
                    }

                    override fun onFailure(call: Call<ResponseBody>, t: Throwable) {
                        callback?.onDownloadFailed(t.message)
                    }
                })
            return true

        } else {
            callback?.onDownloadFailed("下载地址为空")
            return false
        }
    }

    /**
     * 展示弹窗
     */
    override fun showUpgradeDialog(entity: UpdateEntity?) {
        if (entity != null) {
            val fragmentManager = activity.supportFragmentManager
            UpdateDialogFragment.newInstance(
                entity
            )
                .showUpgradeDialog(manager = fragmentManager, provider = this)
        }
    }

    override fun getNewApkFile(): File? {
        return apkFile
    }

    /**
     * Apk文件是否存在
     */
    fun apkFileExit(): Boolean {
        return apkFile != null && apkFile!!.exists()
    }

}