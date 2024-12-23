package com.fmaldonado.siase.ui.fragments.classDetail

import androidx.lifecycle.ViewModelProvider
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.databinding.ClassDetailFragmentBinding
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ClassDetailFragment : BottomSheetDialogFragment() {

    private val viewModel: ClassDetailViewModel by viewModels()
    private lateinit var binding: ClassDetailFragmentBinding

    companion object {
        const val TAG = "ClassDetailFragment"

        fun newInstance(classDetail: ClassDetail?) =
            ClassDetailFragment().apply {
                val bundle = Bundle()
                if (classDetail != null)
                    bundle.putParcelable(
                        ParcelKeys.ClassDetail,
                        classDetail
                    )
                arguments = bundle
            }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = ClassDetailFragmentBinding.inflate(
            layoutInflater,
            container,
            false
        )
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val classDetail =
            arguments?.getParcelable<ClassDetail>(ParcelKeys.ClassDetail) ?: return dismiss()

        binding.title.text = classDetail.getNombreCapitalized()
        binding.classroom.text = classDetail.salon
        binding.group.text = classDetail.grupo
        binding.modality.text = classDetail.getModalidadCapitalized()
        binding.opportunity.text = resources.getString(
            R.string.opportunityText,
            classDetail.oportunidad
        )
        binding.classKey.text = classDetail.claveMateria
        binding.schedule.text = resources.getString(
            R.string.hourRange,
            classDetail.horaInicio,
            classDetail.horaFin
        )
    }

}