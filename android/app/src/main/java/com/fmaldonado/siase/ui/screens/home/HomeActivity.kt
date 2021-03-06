package com.fmaldonado.siase.ui.screens.home

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.fmaldonado.siase.databinding.ActivityHomeBinding

import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Notifications
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.fragments.classDetail.ClassDetailFragment
import com.fmaldonado.siase.ui.utils.ParcelKeys
import dagger.hilt.android.AndroidEntryPoint


@AndroidEntryPoint
class HomeActivity : BaseActivity() {
    private lateinit var binding: ActivityHomeBinding
    override val viewModel: HomeActivityViewModel by viewModels()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val extras = intent.extras

        extras?.let {

            val notification =
                it.getParcelable<Notifications?>(ParcelKeys.ClassDetail) ?: return@let
            viewModel.openFragment(notification.claveMateria)
            intent.removeExtra(ParcelKeys.ClassDetail)
        }

        viewModel.classDetail.observe(this) {
            val classDetail = ClassDetailFragment.newInstance(it)
            classDetail.show(supportFragmentManager, ClassDetailFragment.TAG)
        }


        val navController =
            supportFragmentManager.findFragmentById(R.id.fragment) as NavHostFragment

        binding.bottomNavigation.setupWithNavController(navController.navController)

    }


}