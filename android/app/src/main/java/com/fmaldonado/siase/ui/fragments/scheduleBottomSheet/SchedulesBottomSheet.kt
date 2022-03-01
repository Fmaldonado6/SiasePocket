package com.fmaldonado.siase.ui.fragments.scheduleBottomSheet

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.databinding.ScheduleBottomSheetBinding
import com.fmaldonado.siase.ui.fragments.scheduleBottomSheet.adapters.SchedulesAdapter
import com.fmaldonado.siase.ui.screens.scheduleDetail.ScheduleDetailActivity
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class SchedulesBottomSheet : BottomSheetDialogFragment() {

    private lateinit var binding: ScheduleBottomSheetBinding
    private lateinit var career: Careers
    private val viewModel: SchedulesBottomSheetViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = ScheduleBottomSheetBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        career = arguments?.getParcelable(ParcelKeys.SelectedCareer)!!
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        viewModel.status.observe(this) { binding.status = it }

        viewModel.getSchedules(career)

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getSchedules(career)
        }

        viewModel.schedules.observe(this) {
            setupList(it)
        }
    }

    private fun setupList(schedules: List<Schedule>) {

        binding.schedulesList.adapter = SchedulesAdapter(schedules) {
            val intent = Intent(requireContext(), ScheduleDetailActivity::class.java)
            intent.putExtra(ParcelKeys.SelectedCareer, career)
            intent.putExtra(ParcelKeys.SelectedSchedule, it)
            startActivity(intent)
        }

    }

    companion object {
        const val TAG = "SchedulesBottomSheet"
        fun newInstance(career: Careers): SchedulesBottomSheet {
            val instance = SchedulesBottomSheet()
            val args = Bundle()
            args.putParcelable(ParcelKeys.SelectedCareer, career)
            instance.arguments = args
            return instance
        }

    }


}