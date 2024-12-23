package com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.next

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.data.models.Afi
import com.fmaldonado.siase.databinding.FragmentNextAfisBinding
import com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.next.Adapters.NextAfisAdapter
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class NextAfisFragment : Fragment() {
    private lateinit var binding: FragmentNextAfisBinding
    private val viewModel: NextAfisViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentNextAfisBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.getAfis(12)


        viewModel.status.observe(viewLifecycleOwner) {
            binding.status = it
        }

        viewModel.afis.observe(viewLifecycleOwner) {
            setupList(it)
        }
    }

    private fun setupList(afis: List<Afi>) {
        binding.list.adapter = NextAfisAdapter(afis)
    }


}