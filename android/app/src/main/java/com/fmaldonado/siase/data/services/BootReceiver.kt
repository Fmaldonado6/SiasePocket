package com.fmaldonado.siase.data.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class BootReceiver : BroadcastReceiver() {

    @Inject
    lateinit var mainCareerRepository: MainCareerRepository
    private val ioScope = CoroutineScope(Dispatchers.IO + Job())

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == "android.intent.action.BOOT_COMPLETED") {
            ioScope.launch {
                mainCareerRepository.enableNotifications()
            }
        }
    }
}