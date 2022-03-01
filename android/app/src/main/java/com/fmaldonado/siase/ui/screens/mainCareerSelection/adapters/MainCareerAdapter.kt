package com.fmaldonado.siase.ui.screens.mainCareerSelection.adapters

import android.content.Intent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.databinding.CareerItemBinding
import com.fmaldonado.siase.ui.screens.mainScheduleSelection.MainScheduleSelection
import com.fmaldonado.siase.ui.utils.ParcelKeys

class MainCareerAdapter(
    private val careers: List<Careers>
) : RecyclerView.Adapter<MainCareerAdapter.CareerViewHolder>() {

    inner class CareerViewHolder(val binding: CareerItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CareerViewHolder {
        val binding = CareerItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return CareerViewHolder(binding)
    }

    override fun onBindViewHolder(holder: CareerViewHolder, position: Int) {
        val career = careers[position]
        val careerNameSplit = career.nombre.split("-")
        val careerName = careerNameSplit.last().trim()
        val dependencyName = careerNameSplit.first().trim()
        holder.binding.careerName.text = careerName.replaceFirstChar { it.uppercaseChar() }
        holder.binding.careerSubtitle.text = dependencyName

        holder.binding.card.setOnClickListener {
            val context = holder.binding.root.context
            val intent = Intent(context, MainScheduleSelection::class.java)
            intent.putExtra(ParcelKeys.SelectedCareer, career)
            context.startActivity(intent)
        }
    }

    override fun getItemCount(): Int = careers.size
}