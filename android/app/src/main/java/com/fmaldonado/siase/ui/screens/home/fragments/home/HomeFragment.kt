package com.fmaldonado.siase.ui.screens.home.fragments.home

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.RelativeLayout
import androidx.core.view.children
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.ScheduleDetail
import com.fmaldonado.siase.databinding.ClassItemBinding
import com.fmaldonado.siase.databinding.HomeFragmentBinding
import com.fmaldonado.siase.databinding.HourItemBinding
import com.fmaldonado.siase.ui.fragments.classDetail.ClassDetailFragment
import com.fmaldonado.siase.ui.fragments.scheduleDetail.ScheduleDetailFragment
import com.fmaldonado.siase.ui.screens.auth.MainActivity
import com.fmaldonado.siase.ui.screens.scheduleDetail.ScheduleDetailActivity
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.Status
import com.fmaldonado.siase.ui.utils.parseTime
import dagger.hilt.android.AndroidEntryPoint
import java.time.LocalTime
import java.time.temporal.ChronoUnit

@AndroidEntryPoint
class HomeFragment : Fragment() {
    private lateinit var binding: HomeFragmentBinding
    private val viewModel: HomeFragmentViewModel by viewModels()

    companion object {
        fun newInstance() = HomeFragment()
    }


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = HomeFragmentBinding.inflate(layoutInflater)

        return binding.root
    }

    override fun onResume() {
        super.onResume()
        if (viewModel.status.value == Status.Loaded)
            viewModel.getTodaySchedule()
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.userInfo ?: viewModel.signOut()

        val name = viewModel.userInfo!!.nombre.split(" ").first()
        binding.collapsingToolbar.title = resources.getString(R.string.welcomeText, name)

        viewModel.getTodaySchedule()

        binding.errorLayout.retry.setOnClickListener {
            viewModel.getTodaySchedule()
        }

        binding.completeScheduleButton.setOnClickListener {
            val fullSchedule = viewModel.getFullSchedule() ?: return@setOnClickListener
            val intent = Intent(requireContext(), ScheduleDetailActivity::class.java)
            intent.putExtra(ParcelKeys.ScheduleDetail, fullSchedule)
            startActivity(intent)
        }

        binding.nextClass.setOnClickListener {
            val classDetail = ClassDetailFragment.newInstance(viewModel.nextClass.value)
            classDetail.show(childFragmentManager, ClassDetailFragment.TAG)
        }

        viewModel.nextClass.observe(viewLifecycleOwner) {
            binding.classDetail = it
            it?.let {
                binding.title.text = it.getNombreCapitalized()
                binding.subtitle.text = resources.getString(
                    R.string.hourRange,
                    it.horaInicio,
                    it.horaFin
                )
            }
        }

        viewModel.status.observe(viewLifecycleOwner) {
            binding.status = it
            when (it) {
                Status.SignOut -> {
                    val intent = Intent(context, MainActivity::class.java)
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                }
                else -> Log.d("HomeFragment", "Status not implemented")
            }
        }

        viewModel.todaySchedule.observe(viewLifecycleOwner) {
            val fragment = ScheduleDetailFragment.newInstance(it)
            childFragmentManager.beginTransaction().replace(binding.scheduleDetail.id, fragment)
                .commit()
        }


    }


}