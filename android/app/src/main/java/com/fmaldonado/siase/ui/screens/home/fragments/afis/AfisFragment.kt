package com.fmaldonado.siase.ui.screens.home.fragments.afis

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.databinding.AfisFragmentBinding
import com.fmaldonado.siase.databinding.CareersFragmentBinding
import com.fmaldonado.siase.ui.screens.home.fragments.afis.adapters.AfisViewPagerAdapter
import com.fmaldonado.siase.ui.screens.home.fragments.careers.CareersViewModel
import com.fmaldonado.siase.ui.screens.home.fragments.careers.adapters.CareerAdapter
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class AfisFragment : Fragment() {
    private lateinit var binding: AfisFragmentBinding

    companion object {
        fun newInstance() = AfisFragment()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = AfisFragmentBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.viewPager.adapter = AfisViewPagerAdapter(requireActivity())

        TabLayoutMediator(binding.tabs, binding.viewPager) { tab: TabLayout.Tab, i: Int ->
            when (i) {
                0 -> tab.text = "Proximas"
                1 -> tab.text = "Historial"
            }

        }.attach()


    }

}