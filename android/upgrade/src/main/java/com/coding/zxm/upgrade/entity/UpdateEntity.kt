package com.coding.zxm.upgrade.entity

import java.io.Serializable

/**
 * Created by ZhangXinmin on 2021/05/14.
 * Copyright (c) 5/14/21 . All rights reserved.
 * 检查更新
 */

class UpdateResult {
    //检查更新状态：-1-未检查；0-检查更新失败；1-检查更新成功
    var code: Int = -1

    var msg: String? = ""

    var updateEntity: UpdateEntity? = null

    constructor(code: Int, msg: String?, updateEntity: UpdateEntity? = null) {
        this.code = code
        this.msg = msg
        this.updateEntity = updateEntity
    }

    override fun toString(): String {
        return "UpdateResult(code=$code, msg=$msg, updateEntity=$updateEntity)"
    }


}

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


    override fun toString(): String {
        return "UpdateEntity(name=$name, version=$version, changelog=$changelog, updated_at=$updated_at, versionShort=$versionShort, build=$build, installUrl=$installUrl, install_url=$install_url, direct_install_url=$direct_install_url, update_url=$update_url, binary=$binary, isForce=$isForce)"
    }

}

class Binary : Serializable {
    //包大小
    var fsize: Long = 0
}