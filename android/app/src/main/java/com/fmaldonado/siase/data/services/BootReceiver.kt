package com.fmaldonado.siase.data.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
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

    private val bootCompleted = "android.intent.action.BOOT_COMPLETED"
    private val packageReplaced = "android.intent.action.MY_PACKAGE_REPLACED"

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == bootCompleted ||
            intent?.action == packageReplaced
        ) {
            ioScope.launch {
                mainCareerRepository.enableNotifications()
            }
        }
    }
}