package com.fmaldonado.siase.ui.screens.mainCareerSelection

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.databinding.ActivityMainCareerSelectionBinding
import com.fmaldonado.siase.ui.screens.mainCareerSelection.adapters.MainCareerAdapter
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainCareerSelection : AppCompatActivity() {

    private lateinit var binding: ActivityMainCareerSelectionBinding

    private val viewModel: MainCareerSelectionViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainCareerSelectionBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupRecycler(viewModel.careers)
    }

    private fun setupRecycler(careers: List<Careers>) {
        binding.careersList.adapter = MainCareerAdapter(careers)
    }
}