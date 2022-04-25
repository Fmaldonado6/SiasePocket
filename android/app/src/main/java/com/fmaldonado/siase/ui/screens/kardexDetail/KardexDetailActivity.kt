package com.fmaldonado.siase.ui.screens.kardexDetail

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.databinding.ActivityKardexDetailBinding
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.screens.kardexDetail.adapters.KardexViewPagerAdapter
import com.fmaldonado.siase.ui.screens.scheduleDetail.adapters.ScheduleViewPagerAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.WeekDays
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint


@AndroidEntryPoint
class KardexDetailActivity : BaseActivity() {
    private lateinit var binding: ActivityKardexDetailBinding
    override val viewModel: KardexDetailViewModel by viewModels()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityKardexDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val extras = intent.extras ?: return finish()
        val career = extras.getParcelable<Careers>(ParcelKeys.SelectedCareer) ?: return finish()

        viewModel.getKardex(career)

        binding.toolbar.setNavigationOnClickListener { finish() }

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getKardex(career)
        }

        viewModel.status.observe(this) { binding.status = it }

        viewModel.kardexList.observe(this) {
            setupTabs(it)
        }
    }

    private fun setupTabs(detail: List<List<Subject>>) {
        val tabs = binding.tabs

        for ((i, subject) in detail.withIndex()) {
            val newTab = tabs.newTab()
            newTab.text = "Semestre ${subject.first().semestreMateria}"
            tabs.addTab(newTab)
        }

        binding.viewPager.adapter = KardexViewPagerAdapter(this, detail)

        TabLayoutMediator(binding.tabs, binding.viewPager) { tab: TabLayout.Tab, i: Int ->
            val item = detail[i].first()
            tab.text = "Semestre ${item.semestreMateria}"
        }.attach()
    }
}