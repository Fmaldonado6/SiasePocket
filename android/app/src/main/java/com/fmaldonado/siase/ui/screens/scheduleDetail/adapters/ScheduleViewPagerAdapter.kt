package com.fmaldonado.siase.ui.screens.scheduleDetail.adapters

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.ui.fragments.scheduleDetail.ScheduleDetailFragment

class ScheduleViewPagerAdapter(
    fa: FragmentActivity,
    private val detail: List<List<ClassDetail>>
) :
    FragmentStateAdapter(fa) {

    private val detailMap = HashMap<Int, List<ClassDetail>>()

    override fun getItemCount(): Int {
        var size = 0
        for ((i, classDetail) in detail.withIndex()) {
            if (classDetail.isNotEmpty()) {
                detailMap[size] = classDetail
                size++
            }
        }

        return size
    }

    override fun createFragment(position: Int): Fragment =
        ScheduleDetailFragment.newInstance(detailMap[position])

}