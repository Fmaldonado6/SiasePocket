package com.fmaldonado.siase.ui.utils

import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.*

fun parseTime(time: String): LocalTime {
    val format = DateTimeFormatter.ofPattern("h:mm a", Locale.US)
    return LocalTime.parse(time.uppercase(Locale.getDefault()), format)

}

inline fun <T1 : Any, T2 : Any, R : Any> safeLet(
    p1: T1?,
    p2: T2?,
    block: (p1: T1, p2: T2) -> R?
): R? {
    return if (p1 != null && p2 != null) block(p1, p2) else null
}