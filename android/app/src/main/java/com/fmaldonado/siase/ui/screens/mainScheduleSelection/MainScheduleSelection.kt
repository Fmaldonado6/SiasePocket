package com.fmaldonado.siase.ui.screens.mainScheduleSelection

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.databinding.ActivityMainScheduleSelectionBinding
import com.fmaldonado.siase.ui.screens.home.HomeActivity
import com.fmaldonado.siase.ui.screens.mainScheduleSelection.adapters.MainScheduleAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainScheduleSelection : AppCompatActivity() {
    private lateinit var binding: ActivityMainScheduleSelectionBinding
    private lateinit var career: Careers
    private val viewModel: MainScheduleSelectionViewModel by viewModels()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainScheduleSelectionBinding.inflate(layoutInflater)
        val extras = intent.extras ?: return finish()
        career = extras.getParcelable(ParcelKeys.SelectedCareer) ?: return finish()
        viewModel.getSchedules(career.claveCarrera)

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getSchedules(career.claveCarrera)
        }



        viewModel.status.observe(this) {
            if (it == Status.Completed) {
                val intent = Intent(this, HomeActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                return@observe
            }
            binding.status = it
        }
        viewModel.schedules.observe(this) { setupRecycler(it) }


        binding.toolbar.setNavigationOnClickListener { finish() }

        setContentView(binding.root)
    }

    private fun setupRecycler(schedules: List<Schedule>) {
        binding.schedulesList.adapter = MainScheduleAdapter(schedules) {
            viewModel.setMainCareerAndSchedule(career, it)
        }
    }
}