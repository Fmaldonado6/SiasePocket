package com.fmaldonado.siase.ui.screens.home.fragments.afis.adapters

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.history.AfisHistoryFragment
import com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.next.NextAfisFragment

class AfisViewPagerAdapter(
    fa: FragmentActivity,
) : FragmentStateAdapter(fa) {
    override fun getItemCount(): Int = 2

    override fun createFragment(position: Int): Fragment =
        when (position) {
            0 -> NextAfisFragment()
            1 -> AfisHistoryFragment()
            else -> NextAfisFragment()
        }
}