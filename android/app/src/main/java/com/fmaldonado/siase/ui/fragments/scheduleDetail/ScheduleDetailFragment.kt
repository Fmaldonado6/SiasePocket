package com.fmaldonado.siase.ui.fragments.scheduleDetail

import android.os.Bundle
import android.util.TypedValue
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AlphaAnimation
import android.view.animation.DecelerateInterpolator
import android.widget.LinearLayout
import android.widget.RelativeLayout
import androidx.lifecycle.lifecycleScope
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.databinding.ClassItemBinding
import com.fmaldonado.siase.databinding.FragmentScheduleDetailBinding
import com.fmaldonado.siase.databinding.HourItemBinding
import com.fmaldonado.siase.ui.fragments.classDetail.ClassDetailFragment
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.parseTime
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.time.LocalTime
import java.time.temporal.ChronoUnit


class ScheduleDetailFragment : Fragment() {
    private var detail: List<ClassDetail>? = null
    private lateinit var binding: FragmentScheduleDetailBinding
    private val hourHeight = 78f


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            detail = it.getParcelableArrayList(ParcelKeys.ScheduleDetail)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentScheduleDetailBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        resetViews()
    }

    companion object {

        @JvmStatic
        fun newInstance(detail: List<ClassDetail>?) =
            ScheduleDetailFragment().apply {
                val bundle = Bundle()
                if (detail != null)
                    bundle.putParcelableArrayList(
                        ParcelKeys.ScheduleDetail,
                        ArrayList(detail)
                    )
                arguments = bundle
            }
    }

    private fun resetViews() {
        binding.timeLayout.removeAllViews()
        binding.eventLayout.removeAllViews()
        lifecycleScope.launch(Dispatchers.Main) {
            delay(175)
            setupHours()
            setUpDividers()
            detail?.let { setupSchedule(it) }
        }
    }

    private fun setupHours() {
        val root = binding.timeLayout
        val size = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            hourHeight,
            resources.displayMetrics
        )
        var i = 7f
        var initialDuration = 100L
        while (i < 22.5f) {
            val fadeIn = AlphaAnimation(0f, 1f)
            fadeIn.interpolator = DecelerateInterpolator()
            fadeIn.duration = initialDuration
            val view = LayoutInflater.from(context).inflate(
                R.layout.hour_item,
                root,
                false
            )
            val params = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                size.toInt()
            )
            view.startAnimation(fadeIn)
            initialDuration += 100
            root.addView(view, params)
            val binding = HourItemBinding.bind(view)
            var dayOrNight = "a.m."
            var realHour = i.toInt()

            if (i > 12.5) {
                realHour -= 12
                dayOrNight = "p.m."
            }

            val hour = if (i.rem(1) != 0f)
                "$realHour:30 $dayOrNight"
            else
                "$realHour:00 $dayOrNight"

            binding.hour.text = hour
            i += .5f
        }

    }

    private fun setUpDividers() {
        val eventLayout = binding.eventLayout
        val size = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            hourHeight,
            resources.displayMetrics
        ).toInt()
        var initialDuration = 100L
        for (i in 0..30) {
            val fadeIn = AlphaAnimation(0f, 1f)
            fadeIn.interpolator = DecelerateInterpolator()
            fadeIn.duration = initialDuration
            val divider = LayoutInflater.from(context).inflate(
                R.layout.divider,
                eventLayout,
                false
            )
            val params = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, size)
            params.topMargin = i * size
            divider.animation = fadeIn
            initialDuration += 100
            eventLayout.addView(divider, params)

        }
    }

    private fun setupSchedule(schedule: List<ClassDetail>) {
        val size = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            hourHeight * 2,
            resources.displayMetrics
        )
        val eventLayout = binding.eventLayout
        val initialTime = LocalTime.of(7, 0)
        var initialDuration = 50L
        for (classDetail in schedule) {
            val fadeIn = AlphaAnimation(0f, 1f)

            fadeIn.interpolator = DecelerateInterpolator()
            fadeIn.duration = initialDuration
            val classView = LayoutInflater.from(context).inflate(
                R.layout.class_item,
                eventLayout,
                false
            )
            val params = RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                size.toInt()
            )

            val startTime = parseTime(classDetail.horaInicio)
            val endTime = parseTime(classDetail.horaFin)

            val minuteDifference = ChronoUnit.MINUTES.between(initialTime, startTime)
            val duration = ChronoUnit.MINUTES.between(startTime, endTime)
            val margin = (minuteDifference / 60f) * size
            val height = (duration / 60f) * size
            params.topMargin = margin.toInt()
            params.height = height.toInt()
            val binding = ClassItemBinding.bind(classView)
            binding.title.text = classDetail.getNombreCapitalized()
            binding.subtitle.text = resources.getString(
                R.string.hourRange,
                classDetail.horaInicio,
                classDetail.horaFin
            )
            classView.startAnimation(fadeIn)
            binding.card.setOnClickListener {
                val bottomSheet = ClassDetailFragment.newInstance(classDetail)
                bottomSheet.show(childFragmentManager, ClassDetailFragment.TAG)
            }
            initialDuration += 100
            eventLayout.addView(classView, params)
        }
    }
}