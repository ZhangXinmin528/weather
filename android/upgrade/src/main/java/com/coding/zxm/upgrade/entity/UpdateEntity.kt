package com.coding.zxm.upgrade.entity

import java.io.Serializable

/**
 * Created by ZhangXinmin on 2021/05/14.
 * Copyright (c) 5/14/21 . All rights reserved.
 * 检查更新
 */
class UpdateEntity : Serializable {
    //应用名称
    var name: String? = ""

    //版本
    var version: String? = ""

    //更新日志
    var changelog: String? = ""

    //发布更新时间
    var updated_at: Long = 0

    //版本编号(兼容旧版字段)
    var versionShort: String? = ""

    //编译号
    var build: String? = ""

    //安装地址（兼容旧版字段）
    var installUrl: String? = ""

    //安装地址(新增字段)
    var install_url: String? = ""
    var direct_install_url: String? = ""

    //更新地址(新增字段)
    var update_url: String? = ""

    //更新文件的对象
    var binary: Binary? = null

    //强制更新
    var isForce: Boolean = false
}

class Binary : Serializable {
    //包大小
    var fsize: Long = 0
}