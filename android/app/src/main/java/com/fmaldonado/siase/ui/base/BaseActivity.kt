package com.fmaldonado.siase.ui.base

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.fmaldonado.siase.ui.utils.ThemeHelper

abstract class BaseActivity : AppCompatActivity() {

    protected abstract val viewModel: BaseViewModel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        applyTheme()

    }

    private fun applyTheme() {
        val theme = viewModel.getTheme()
        setTheme(ThemeHelper.getTheme(theme))

    }



}