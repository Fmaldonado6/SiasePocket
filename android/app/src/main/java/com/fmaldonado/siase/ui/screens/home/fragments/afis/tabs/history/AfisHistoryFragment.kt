package com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.history

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.fmaldonado.siase.R
import com.fmaldonado.siase.databinding.FragmentAfisHistoryBinding
import com.fmaldonado.siase.databinding.FragmentNextAfisBinding


class AfisHistoryFragment : Fragment() {
    private lateinit var binding: FragmentAfisHistoryBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentAfisHistoryBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }

}