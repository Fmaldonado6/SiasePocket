package com.fmaldonado.siase.ui.screens.mainScheduleSelection

import android.Manifest
import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.annotation.RequiresApi
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.databinding.ActivityMainScheduleSelectionBinding
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.screens.home.HomeActivity
import com.fmaldonado.siase.ui.screens.mainScheduleSelection.adapters.MainScheduleAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainScheduleSelection : BaseActivity() {
    private lateinit var binding: ActivityMainScheduleSelectionBinding
    private lateinit var career: Careers
    override val viewModel: MainScheduleSelectionViewModel by viewModels()
    private val requestPostNotificationsLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) {
        startHomeActivity()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        binding = ActivityMainScheduleSelectionBinding.inflate(layoutInflater)
        val extras = intent.extras ?: return finish()
        career = extras.getParcelable(ParcelKeys.SelectedCareer) ?: return finish()
        viewModel.getSchedules(career)

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getSchedules(career)
        }



        viewModel.status.observe(this) {
            if (it == Status.Completed) {
                if (Build.VERSION.SDK_INT < 33) startHomeActivity()
                else requestNotificationPermission()
                return@observe
            }
            binding.status = it
        }
        viewModel.schedules.observe(this)
        { setupRecycler(it) }


        binding.toolbar.setNavigationOnClickListener { finish() }

        setContentView(binding.root)
    }

    private fun setupRecycler(schedules: List<Schedule>) {
        binding.schedulesList.adapter = MainScheduleAdapter(schedules) {
            viewModel.setMainCareerAndSchedule(career, it)
        }
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    private fun requestNotificationPermission() {
        requestPostNotificationsLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
    }

    private fun startHomeActivity() {
        val intent = Intent(this, HomeActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }
}