package com.fmaldonado.siase.ui.fragments.scheduleBottomSheet.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.databinding.SchedulesSheetItemBinding

class SchedulesAdapter(
    private val schedules: List<Schedule>,
    val onClick: (schedule: Schedule) -> Unit
) :
    RecyclerView.Adapter<SchedulesAdapter.SchedulesViewHolder>() {

    inner class SchedulesViewHolder(val binding: SchedulesSheetItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SchedulesViewHolder {
        val binding =
            SchedulesSheetItemBinding.inflate(
                LayoutInflater.from(parent.context),
                parent,
                false
            )

        return SchedulesViewHolder(binding)
    }

    override fun onBindViewHolder(holder: SchedulesViewHolder, position: Int) {
        val schedule = schedules[position]
        holder.binding.scheduleName.text = schedule.nombre
        holder.binding.scheduleCard.setOnClickListener { onClick(schedule) }
    }

    override fun getItemCount(): Int = schedules.size

}