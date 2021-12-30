package com.zxm.coding.weather.entity

import java.io.Serializable

/**
 * Created by ZhangXinmin on 2021/12/30.
 * Copyright (c) 2021/12/30 . All rights reserved.
 * 天气预警信息
 */
class WeatherWarning : Serializable {
    var code: String? = ""
    var updateTime: String? = ""
    var fxLink: String? = ""
    var warning: List<Warning>? = ArrayList()
}

class Warning : Serializable {
    var id: String? = ""
    var sender: String? = ""
    var pubTime: String? = ""
    var title: String? = ""
    var startTime: String? = ""
    var endTime: String? = ""
    var status: String? = ""
    var level: String? = ""
    var type: String? = ""
    var typeName: String? = ""
    var text: String? = ""
}