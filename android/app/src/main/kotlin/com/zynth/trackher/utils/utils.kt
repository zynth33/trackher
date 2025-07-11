package com.zynth.trackher.utils

fun getAndroidOsName(sdkInt: Int): String {
    return when (sdkInt) {
        14, 15 -> "Ice Cream Sandwich"
        16, 17, 18 -> "Jelly Bean"
        19, 20 -> "KitKat"
        21, 22 -> "Lollipop"
        23 -> "Marshmallow"
        24, 25 -> "Nougat"
        26, 27 -> "Oreo"
        28 -> "Pie"
        29 -> "Android 10"
        30 -> "Android 11"
        31, 32 -> "Android 12"
        33 -> "Android 13"
        34 -> "Android 14"
        else -> "Android $sdkInt"
    }
}