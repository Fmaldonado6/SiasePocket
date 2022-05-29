package com.fmaldonado.siase.ui.screens.alert

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.MotionEvent
import android.view.ViewConfiguration
import androidx.core.view.InputDeviceCompat
import androidx.core.view.MotionEventCompat
import androidx.core.view.ViewConfigurationCompat
import com.fmaldonado.siase.R
import com.fmaldonado.siase.databinding.ActivityAlertBinding
import kotlin.math.roundToInt

class AlertActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAlertBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAlertBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.retry.setOnClickListener {
            setResult(RESULT_OK)
            finish()
        }
        binding.cancel.setOnClickListener { finish() }
        binding.scrollView.requestFocus()

        binding.scrollView.setOnGenericMotionListener { v, ev ->
            if (ev.action == MotionEvent.ACTION_SCROLL &&
                ev.isFromSource(InputDeviceCompat.SOURCE_ROTARY_ENCODER)
            ) {
                val delta = -ev.getAxisValue(MotionEventCompat.AXIS_SCROLL) *
                        ViewConfigurationCompat.getScaledVerticalScrollFactor(
                            ViewConfiguration.get(this), this
                        )
                v.scrollBy(0, delta.roundToInt())
                true
            } else {
                false
            }
        }

    }
}