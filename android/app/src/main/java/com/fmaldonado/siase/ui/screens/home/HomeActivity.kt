package com.fmaldonado.siase.ui.screens.home

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.fmaldonado.siase.databinding.ActivityHomeBinding

import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.fmaldonado.siase.R
import dagger.hilt.android.AndroidEntryPoint


@AndroidEntryPoint
class HomeActivity : AppCompatActivity() {
    private lateinit var binding: ActivityHomeBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)


        val navController =
            supportFragmentManager.findFragmentById(R.id.fragment) as NavHostFragment

        binding.bottomNavigation.setupWithNavController(navController.navController)

    }


}