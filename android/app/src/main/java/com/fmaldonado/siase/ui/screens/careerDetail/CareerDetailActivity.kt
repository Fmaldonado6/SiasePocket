package com.fmaldonado.siase.ui.screens.careerDetail

import android.content.Intent
import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.databinding.ActivityCareerDetailBinding
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.fragments.scheduleBottomSheet.SchedulesBottomSheet
import com.fmaldonado.siase.ui.screens.kardexDetail.KardexDetailActivity
import com.fmaldonado.siase.ui.utils.ParcelKeys
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class CareerDetailActivity : AppCompatActivity() {

    val viewModel: CareerDetailViewModel by viewModels()

    private lateinit var binding: ActivityCareerDetailBinding

    private lateinit var selectedCareer: Careers

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCareerDetailBinding.inflate(layoutInflater)
        val extras = intent.extras ?: return finish()
        selectedCareer = extras.getParcelable(ParcelKeys.SelectedCareer) ?: return finish()
        binding.toolbar.title = selectedCareer.nombre
            .split("-")
            .last()
            .trim()
            .replaceFirstChar { it.titlecase() }

        binding.toolbar.setNavigationOnClickListener { finish() }

        binding.schedules.setOnClickListener {
            val bottomSheet = SchedulesBottomSheet.newInstance(selectedCareer)
            bottomSheet.show(supportFragmentManager, SchedulesBottomSheet.TAG)
        }

        binding.kardex.setOnClickListener {
            val intent = Intent(this, KardexDetailActivity::class.java)
            intent.putExtra(ParcelKeys.SelectedCareer, selectedCareer)
            startActivity(intent)
        }
        setContentView(binding.root)
    }
}