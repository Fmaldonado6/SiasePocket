package com.fmaldonado.siase.ui.screens.kardexDetail.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AlphaAnimation
import android.view.animation.DecelerateInterpolator
import androidx.lifecycle.lifecycleScope
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.databinding.FragmentKardexDetailBinding
import com.fmaldonado.siase.ui.screens.kardexDetail.adapters.KardexItemAdapter
import com.fmaldonado.siase.ui.utils.ParcelKeys
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class KardexDetailFragment : Fragment() {
    private var subjects: List<Subject>? = null
    private lateinit var binding: FragmentKardexDetailBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            subjects = it.getParcelableArrayList(ParcelKeys.KardexDetail)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        binding = FragmentKardexDetailBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        lifecycleScope.launch(Dispatchers.Main) {
            delay(300)
            val fadeIn = AlphaAnimation(0f, 1f)
            fadeIn.interpolator = DecelerateInterpolator()
            fadeIn.duration = 300
            subjects?.let {
                binding.subjectList.startAnimation(fadeIn)
                binding.subjectList.adapter = KardexItemAdapter(it)
            }
        }
    }

    companion object {

        @JvmStatic
        fun newInstance(detail: List<Subject>) =
            KardexDetailFragment().apply {
                arguments = Bundle().apply {
                    putParcelableArrayList(ParcelKeys.KardexDetail, ArrayList(detail))
                }
            }
    }
}