package com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.next.Adapters

import android.text.format.DateUtils
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Afi
import com.fmaldonado.siase.databinding.AfiItemBinding
import com.fmaldonado.siase.databinding.KardexItemBinding
import com.fmaldonado.siase.ui.utils.WeekDays
import com.fmaldonado.siase.ui.utils.parseDate
import com.fmaldonado.siase.ui.utils.parseTime
import java.util.*

class NextAfisAdapter(
    private val afis: List<Afi>
) :
    RecyclerView.Adapter<NextAfisAdapter.NextAfisItemViewHolder>() {

    inner class NextAfisItemViewHolder(val binding: AfiItemBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): NextAfisItemViewHolder {
        val binding = AfiItemBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )

        return NextAfisItemViewHolder(binding)
    }

    override fun getItemCount(): Int = afis.size

    override fun onBindViewHolder(holder: NextAfisItemViewHolder, position: Int) {
        val afi = afis[position]
        val context = holder.binding.root.context
        holder.binding.title.text = afi.evento
        holder.binding.subtitle.text = context.resources.getString(
            R.string.availableSpace,
            afi.disponibles
        )

        val date = parseDate(afi.fechaInicio)
        holder.binding.weekdayLabel.setText(WeekDays.daysShort[date.dayOfWeek.value])
        holder.binding.dayLabel.text = date.dayOfMonth.toString()


    }
}