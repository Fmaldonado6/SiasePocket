package com.fmaldonado.siase.ui.adapters

import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.databinding.ClassItemBinding

class ScheduleAdapter(
    private val list: List<ClassDetail>
) : RecyclerView.Adapter<ScheduleAdapter.ScheduleViewHolder>() {

    inner class ScheduleViewHolder(val binding: ClassItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ScheduleViewHolder {
        val binding = ClassItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )

        return ScheduleViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ScheduleViewHolder, position: Int) {
        val item = list[position]

        holder.binding.title.text = item.nombre
        holder.binding.subtitle.text = "${item.horaInicio} - ${item.horaFin}"

    }

    override fun getItemCount(): Int {
        Log.d("SIZE",list.size.toString())
        return list.size
    }
}