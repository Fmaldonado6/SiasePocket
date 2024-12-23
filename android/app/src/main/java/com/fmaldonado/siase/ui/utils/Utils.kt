package com.fmaldonado.siase.ui.utils

import com.fmaldonado.siase.R
import java.time.LocalDate
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.*

fun parseTime(time: String): LocalTime {
    val format = DateTimeFormatter.ofPattern("h:mm a", Locale.US)
    return LocalTime.parse(time.uppercase(Locale.getDefault()), format)
}

fun parseDate(time: String): LocalDate {
    val format = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.US)
    return LocalDate.parse(time.uppercase(Locale.getDefault()), format)
}

inline fun <T1 : Any, T2 : Any, R : Any> safeLet(
    p1: T1?,
    p2: T2?,
    block: (p1: T1, p2: T2) -> R?
): R? {
    return if (p1 != null && p2 != null) block(p1, p2) else null
}

object ThemeHelper {

    private val themes = listOf(
        R.style.Theme_Siase,
        R.style.Theme_Siase_Dynamic
    )

    fun getTheme(theme:Int) = themes[theme]

}