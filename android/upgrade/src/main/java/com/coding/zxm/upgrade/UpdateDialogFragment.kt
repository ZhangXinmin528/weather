package com.coding.zxm.upgrade

import android.Manifest
import android.content.ComponentName
import android.content.Context
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Bundle
import android.os.IBinder
import android.text.TextUtils
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import com.coding.zxm.upgrade.entity.UpdateEntity
import com.coding.zxm.upgrade.network.IUpgradeProvider
import com.coding.zxm.upgrade.utils.ColorUtil
import com.coding.zxm.upgrade.utils.DrawableUtil
import com.coding.zxm.upgrade.widget.NumberProgressBar
import kotlinx.android.synthetic.main.layout_update_app_dialog.*
import java.util.*

/**
 * Created by ZhangXinmin on 2021/05/19.
 * Copyright (c) 5/19/21 . All rights reserved.
 * 应用更新Dialog
 * TODO:1.强制更新功能；2.忽略此版本；
 */
class UpdateDialogFragment : DialogFragment(), View.OnClickListener {

    private var mContentTextView: TextView? = null
    private var mUpdateOkButton: Button? = null
    private var mNumberProgressBar: NumberProgressBar? = null
    private var mIvClose: ImageView? = null
    private var mTitleTextView: TextView? = null

    //默认色
    private val mDefaultColor = -0x16bcc7
    private val mDefaultPicResId = R.mipmap.lib_update_top_bg0
    private var mTopIv: ImageView? = null
    private var mIgnore: TextView? = null

    //参数
    private lateinit var mEntity: UpdateEntity
    private lateinit var mProvider: IUpgradeProvider

    companion object {
        private const val PARAMS_UPDATE_INFO = "params_update_info"

        fun newInstance(@NonNull entity: UpdateEntity): UpdateDialogFragment {
            val fragment = UpdateDialogFragment()
            val args = Bundle()
            args.putSerializable(PARAMS_UPDATE_INFO, entity)
            fragment.arguments = args
            return fragment
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setStyle(STYLE_NO_TITLE, R.style.DialogTheme_Upgrade)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.layout_update_app_dialog, container)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initView(view)
    }

    private fun initView(view: View) {

        //提示内容
        mContentTextView = view.findViewById(R.id.tv_update_info)
        //标题
        mTitleTextView = view.findViewById(R.id.tv_title)
        //更新按钮
        mUpdateOkButton = view.findViewById(R.id.btn_ok)
        mUpdateOkButton?.setOnClickListener(this)

        //进度条
        mNumberProgressBar = view.findViewById(R.id.npb)
        //关闭按钮
        mIvClose = view.findViewById(R.id.iv_close)
        mIvClose?.setOnClickListener(this)

        //顶部图片
        mTopIv = view.findViewById<ImageView>(R.id.iv_top)
        //忽略
        mIgnore = view.findViewById<TextView>(R.id.tv_ignore)
        mIgnore?.setOnClickListener(this)

    }

    override fun onStart() {
        super.onStart()

        dialog?.setCanceledOnTouchOutside(false)

        val window = dialog?.window
        window?.setGravity(Gravity.CENTER)
        val displayMetrics = context?.resources?.displayMetrics
        displayMetrics?.let {
            val lp = window?.attributes
            lp?.height = (it.heightPixels * 0.8f).toInt()
            window?.attributes = lp
        }

    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        initData()
    }

    private fun initData() {
        arguments?.let {
            if (it.containsKey(PARAMS_UPDATE_INFO)) {
                mEntity = it.getSerializable(PARAMS_UPDATE_INFO) as UpdateEntity
            }
        }

        initTheme()

        if (mEntity != null) {
            //弹出对话框
            val newVersion = mEntity.versionShort
            val targetSize = byte2FitMemorySize(mEntity.binary!!.fsize)
            val updateLog = mEntity.changelog

            var msg: String? = ""

            if (!TextUtils.isEmpty(targetSize)) {
                msg = "新版本大小：$targetSize\n\n"
            }

            if (!TextUtils.isEmpty(updateLog)) {
                msg += updateLog
            }

            //更新内容

            //更新内容
            mContentTextView!!.text = msg
            //标题
            //标题
            mTitleTextView!!.text = String.format("是否升级到%s版本？", newVersion)

            if (mEntity.isForce) {
                iv_close!!.visibility = View.GONE
            } else {
                iv_close!!.visibility = View.VISIBLE
                //不是强制更新时，才生效
//                if (mUpdateApp.isShowIgnoreVersion()) {
//                    mIgnore!!.visibility = View.VISIBLE
//                }
            }

        }
    }

    /**
     * 格式化文件大小
     */
    private fun byte2FitMemorySize(byteNum: Long): String? {
        return if (byteNum < 0) {
            "shouldn't be less than zero!"
        } else if (byteNum < 1000) {
            String.format(
                Locale.getDefault(),
                "%.3fB",
                byteNum.toDouble()
            )
        } else if (byteNum < 1000000) {
            String.format(
                Locale.getDefault(),
                "%.3fKB",
                byteNum.toDouble() / 1000
            )
        } else if (byteNum < 1000000000) {
            String.format(
                Locale.getDefault(),
                "%.3fMB",
                byteNum.toDouble() / 1000000
            )
        } else {
            String.format(
                Locale.getDefault(),
                "%.3fGB",
                byteNum.toDouble() / 1000000000
            )
        }
    }

    /**
     * 初始化主题风格
     */
    private fun initTheme() {
        val color = -1
        val topResId = -1
        if (-1 == topResId) {
            if (-1 == color) {
                //默认红色
                setDialogTheme(mDefaultColor, mDefaultPicResId)
            } else {
                setDialogTheme(color, mDefaultPicResId)
            }
        } else {
            if (-1 == color) {
                setDialogTheme(mDefaultColor, topResId)
            } else {
                //更加指定的上色
                setDialogTheme(color, topResId)
            }
        }
    }

    /**
     * 设置
     *
     * @param color    主色
     * @param topResId 图片
     */
    private fun setDialogTheme(color: Int, topResId: Int) {
        mTopIv!!.setImageResource(topResId)
        mUpdateOkButton!!.setBackgroundDrawable(
            DrawableUtil.getDrawable(dip2px(4, context!!), color)
        )
        mNumberProgressBar!!.setProgressTextColor(color)
        mNumberProgressBar!!.reachedBarColor = color
        //随背景颜色变化
        mUpdateOkButton!!.setTextColor(if (ColorUtil.isTextColorDark(color)) Color.BLACK else Color.WHITE)
    }

    /**
     * 展示弹窗
     */
    fun showUpgradeDialog(
        @NonNull manager: FragmentManager,
        @NonNull provider: IUpgradeProvider
    ) {
        mProvider = provider
        show(manager, "dialog")
    }

    private fun dip2px(dip: Int, context: Context): Int {
        return (dip * context.resources.displayMetrics.density + 0.5f).toInt()
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.btn_ok -> {
                if (ActivityCompat.checkSelfPermission(
                        context!!,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    if (ActivityCompat.shouldShowRequestPermissionRationale(
                            activity!!,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE
                        )
                    ) {
                        Toast.makeText(
                            context,
                            getString(R.string.all_upgrade_tips_need_permissions),
                            Toast.LENGTH_SHORT
                        ).show()
                    } else {
                        requestPermissions(
                            arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                            1001
                        )
                    }

                } else {
                    upgradeApp()
                }
            }
            R.id.iv_close -> {
                dismiss()
            }
        }
    }

    /**
     * APK下载&&升级
     */
    private fun upgradeApp() {
        if (mProvider != null) {
            UpgradeService.bindService(context!!, object : ServiceConnection {
                override fun onServiceDisconnected(name: ComponentName?) {

                }

                override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                    (service as UpgradeService.UpgradeBinder).downloadApk(
                        mEntity.installUrl,
                        mProvider
                    )
                }

            })
            dismiss()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1001) {
            if (grantResults.isNotEmpty()
                && grantResults[0] == PackageManager.PERMISSION_GRANTED
            ) {
                upgradeApp()
            } else {
                Toast.makeText(
                    context,
                    getString(R.string.all_upgrade_tips_need_permissions),
                    Toast.LENGTH_SHORT
                ).show()
                dismiss()
            }
        }
    }

}