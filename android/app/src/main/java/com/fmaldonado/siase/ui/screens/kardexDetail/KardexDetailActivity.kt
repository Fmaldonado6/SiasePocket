package com.fmaldonado.siase.ui.screens.kardexDetail

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import androidx.core.view.ViewCompat
import androidx.viewpager2.widget.ViewPager2
import androidx.viewpager2.widget.ViewPager2.SCROLL_STATE_IDLE
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.databinding.ActivityKardexDetailBinding
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.screens.kardexDetail.adapters.KardexViewPagerAdapter
import com.fmaldonado.siase.ui.screens.scheduleDetail.adapters.ScheduleViewPagerAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.Status
import com.fmaldonado.siase.ui.utils.WeekDays
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint


@AndroidEntryPoint
class KardexDetailActivity : BaseActivity() {
    private lateinit var binding: ActivityKardexDetailBinding
    private var currentPage = 0;
    override val viewModel: KardexDetailViewModel by viewModels()
    private var appBarExpanded = true;
    private var viewPagerState = SCROLL_STATE_IDLE
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

        binding.swipeToRefresh.setOnRefreshListener {
            viewModel.getKardex(career, false)
        }

        viewModel.status.observe(this) {
            if (!binding.swipeToRefresh.isRefreshing) {
                binding.status = it
                return@observe
            }


            when (it) {
                Status.Loading -> {
                    binding.swipeToRefresh.isRefreshing = true
                }
                else -> {
                    binding.swipeToRefresh.isRefreshing = false
                }
            }
        }

        viewModel.kardexList.observe(this) {
            setupTabs(it)
        }

        binding.viewPager.registerOnPageChangeCallback(object : ViewPager2.OnPageChangeCallback() {
            override fun onPageScrollStateChanged(state: Int) {
                super.onPageScrollStateChanged(state)
                viewPagerState = state
                toggleRefreshing()
            }

            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)
                currentPage = position

            }
        })

        binding.appbar.addOnOffsetChangedListener { appBarLayout, verticalOffset ->
            appBarExpanded = (verticalOffset == 0);
            toggleRefreshing()
        }


    }


    private fun toggleRefreshing() {
        if(binding.swipeToRefresh.isRefreshing) return
        binding.swipeToRefresh.isEnabled = appBarExpanded && viewPagerState == SCROLL_STATE_IDLE
    }

    private fun setupTabs(detail: List<List<Subject>>) {
        val tabs = binding.tabs

        for ((i, subject) in detail.withIndex()) {
            val newTab = tabs.newTab()
            newTab.text = "Semestre ${subject.first().semestreMateria}"
            tabs.addTab(newTab)
        }

        binding.viewPager.adapter = KardexViewPagerAdapter(this, detail)
        binding.viewPager.currentItem = currentPage
        TabLayoutMediator(binding.tabs, binding.viewPager) { tab: TabLayout.Tab, i: Int ->
            val item = detail[i].first()
            tab.text = "Semestre ${item.semestreMateria}"
        }.attach()
    }
}