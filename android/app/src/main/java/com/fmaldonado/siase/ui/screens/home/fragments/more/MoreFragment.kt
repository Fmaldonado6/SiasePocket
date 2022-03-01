package com.fmaldonado.siase.ui.screens.home.fragments.more

import androidx.lifecycle.ViewModelProvider
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.databinding.MoreFragmentBinding
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MoreFragment : Fragment() {

    private val viewModel: MoreViewModel by viewModels()
    private lateinit var binding: MoreFragmentBinding

    companion object {
        fun newInstance() = MoreFragment()
    }


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = MoreFragmentBinding.inflate(layoutInflater, container, false)
        return binding.root
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        requireActivity().supportFragmentManager.beginTransaction()
            .replace(binding.containerSettings.id, SettingsFragment()).commit()
    }

}