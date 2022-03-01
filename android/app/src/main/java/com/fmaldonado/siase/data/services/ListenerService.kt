package com.fmaldonado.siase.data.services

import android.util.Log
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.persistence.dao.TodayScheduleDao
import com.fmaldonado.siase.data.persistence.mappers.TodayClassesToEntityMapper
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService
import com.google.gson.Gson
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.*
import kotlinx.coroutines.tasks.await
import javax.inject.Inject

@AndroidEntryPoint
class ListenerService : WearableListenerService() {

    @Inject
    lateinit var todayScheduleDao: TodayScheduleDao

    @Inject
    lateinit var scheduleRepository: ScheduleRepository

    @Inject
    lateinit var authRepository: AuthRepository
    private val ioScope = CoroutineScope(Dispatchers.IO + Job())


    private suspend fun getTodaySchedule(): List<ClassDetail> {
        val schedule = scheduleRepository.getTodaySchedule()
        return schedule ?: listOf()
    }

    private fun sendCredentials() {
        ioScope.launch {
            val schedule = getTodaySchedule()
            val nodes = Wearable.getNodeClient(applicationContext).connectedNodes
            val nodesList = nodes.await()
            for (node in nodesList) {
                val json = Gson().toJson(schedule)
                val task = Wearable.getMessageClient(applicationContext)
                    .sendMessage(
                        node.id, "/message_path", json
                            .encodeToByteArray()
                    )
                task.await()
                Log.d("Message", "sent")
            }
        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        if (messageEvent.path == "/message_path") sendCredentials()
        super.onMessageReceived(messageEvent)

    }
}