package com.fmaldonado.siase.ui.screens.kardexDetail.adapters

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.ui.screens.kardexDetail.fragments.KardexDetailFragment

class KardexViewPagerAdapter(
    fa: FragmentActivity,
    private val detail: List<List<Subject>>
) : FragmentStateAdapter(fa) {
    override fun getItemCount(): Int = detail.size

    override fun createFragment(position: Int): Fragment =
        KardexDetailFragment.newInstance(detail[position])
}