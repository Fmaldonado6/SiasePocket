package com.fmaldonado.siase.ui.screens.mainScheduleSelection.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.databinding.ScheduleItemBinding

class MainScheduleAdapter(
    private val schedules: List<Schedule>,
    val onClick: (schedule: Schedule) -> Unit
) : RecyclerView.Adapter<MainScheduleAdapter.ScheduleViewHolder>() {

    inner class ScheduleViewHolder(val binding: ScheduleItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ScheduleViewHolder {
        val binding =
            ScheduleItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ScheduleViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ScheduleViewHolder, position: Int) {
        val schedule = schedules[position]
        holder.binding.scheduleName.text = schedule.nombre
        holder.binding.card.setOnClickListener {
            onClick(schedule)
        }
    }

    override fun getItemCount(): Int = schedules.size
}