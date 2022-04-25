package com.fmaldonado.siase.ui.screens.scheduleDetail

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.data.models.ScheduleDetail
import com.fmaldonado.siase.databinding.ActivityScheduleDetailBinding
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.screens.scheduleDetail.adapters.ScheduleViewPagerAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.WeekDays
import com.fmaldonado.siase.ui.utils.safeLet
import com.google.android.material.tabs.TabItem
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ScheduleDetailActivity : BaseActivity() {

    private lateinit var binding: ActivityScheduleDetailBinding
    override val viewModel: ScheduleDetailViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityScheduleDetailBinding.inflate(layoutInflater)
        val extras = intent?.extras ?: return finish()
        val detail = extras.getParcelable<ScheduleDetail?>(ParcelKeys.ScheduleDetail)
        val career = extras.getParcelable<Careers?>(ParcelKeys.SelectedCareer)
        val schedule = extras.getParcelable<Schedule?>(ParcelKeys.SelectedSchedule)

        detail?.let {
            viewModel.getScheduleList(it)
        }

        safeLet(career, schedule) { car, sch ->
            viewModel.getSchedule(car, sch.periodo)
        }

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getSchedule(career!!, schedule!!.periodo)
        }

        viewModel.status.observe(this) { binding.status = it }
        viewModel.schedule.observe(this) {
            setupTabs(it)
        }
        binding.toolbar.setNavigationOnClickListener { finish() }
        setContentView(binding.root)
    }

    private fun setupTabs(detail: List<List<ClassDetail>>) {
        val tabs = binding.tabs

        for ((i, classDetail) in detail.withIndex()) {

            if (classDetail.isEmpty()) continue
            val newTab = tabs.newTab()
            newTab.text = resources.getString(WeekDays.days[i])
            tabs.addTab(newTab)
        }

        binding.viewPager.adapter = ScheduleViewPagerAdapter(this, detail)

        TabLayoutMediator(binding.tabs, binding.viewPager) { tab: TabLayout.Tab, i: Int ->
            tab.text = resources.getString(WeekDays.days[i])
        }.attach()

    }
}