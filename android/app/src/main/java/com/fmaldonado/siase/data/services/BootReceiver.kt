package com.fmaldonado.siase.data.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.*
import javax.inject.Inject

@AndroidEntryPoint
class BootReceiver : BroadcastReceiver() {

    @Inject
    lateinit var mainCareerRepository: MainCareerRepository


    @OptIn(DelicateCoroutinesApi::class)
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent!!.action
        if (action != null) {
            if (action == android.content.Intent.ACTION_BOOT_COMPLETED
                || action == Intent.ACTION_MY_PACKAGE_REPLACED
            ) {
                GlobalScope.launch {
                    mainCareerRepository.enableNotifications()
                }
            }
        }
    }
}