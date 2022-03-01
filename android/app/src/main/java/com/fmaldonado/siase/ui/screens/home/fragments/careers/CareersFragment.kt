package com.fmaldonado.siase.ui.screens.home.fragments.careers

import androidx.lifecycle.ViewModelProvider
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.databinding.CareersFragmentBinding
import com.fmaldonado.siase.ui.screens.home.fragments.careers.adapters.CareerAdapter
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class CareersFragment : Fragment() {
    private lateinit var binding: CareersFragmentBinding
    private val viewModel: CareersViewModel by viewModels()

    companion object {
        fun newInstance() = CareersFragment()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = CareersFragmentBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.carreras?.let {
            setUpList(it)
        }
    }

    private fun setUpList(careers: List<Careers>) {
        binding.careersList.adapter = CareerAdapter(careers)
    }

}