package com.fmaldonado.siase.data.network

import okhttp3.ResponseBody
import java.io.IOException

open class AppError(val error: String?) : IOException()

class BadInput(error: String?) : AppError(error)

class Unauthorized(error: String?) : AppError(error)

class EmptySearch(error: String?) : AppError(error)

class NotFoundError(error: String?) : AppError(error)