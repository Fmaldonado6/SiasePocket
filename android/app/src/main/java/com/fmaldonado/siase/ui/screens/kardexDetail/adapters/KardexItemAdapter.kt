package com.fmaldonado.siase.ui.screens.kardexDetail.adapters

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.databinding.KardexItemBinding

class KardexItemAdapter(
    private val subjects: List<Subject>
) :
    RecyclerView.Adapter<KardexItemAdapter.KardexItemViewHolder>() {

    inner class KardexItemViewHolder(val binding: KardexItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): KardexItemViewHolder {
        val binding = KardexItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )

        return KardexItemViewHolder(binding)
    }

    override fun onBindViewHolder(holder: KardexItemViewHolder, position: Int) {
        val item = subjects[position]
        holder.binding.title.text = item.nombre
        var opportunity = item.calificaciones.size
        if (opportunity == 0) opportunity = 1
        holder.binding.subtitle.text = holder.binding.root.context.getString(
            R.string.opportunityText,
            opportunity.toString()
        )
        holder.binding.grades.text = item.calificaciones.lastOrNull()?.toInt()?.toString() ?: "?"
    }

    override fun getItemCount(): Int = subjects.size
}