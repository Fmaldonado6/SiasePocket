package com.fmaldonado.siase.ui.base

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.fmaldonado.siase.ui.utils.ThemeHelper

abstract class BaseActivity : AppCompatActivity() {

    protected abstract  val viewModel: BaseViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyTheme()

    }

    private fun applyTheme() {
        val theme = viewModel.getTheme()
        setTheme(ThemeHelper.getTheme(theme))

    }

}