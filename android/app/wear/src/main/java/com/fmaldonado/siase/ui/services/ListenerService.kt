package com.fmaldonado.siase.ui.services

import android.content.Intent
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService

class ListenerService : WearableListenerService() {

    override fun onMessageReceived(messageEvent: MessageEvent) {
        if (messageEvent.path == "/message_path") {
            val message = String(messageEvent.data)
            val messageIntent = Intent()
            messageIntent.action = Intent.ACTION_SEND
            messageIntent.putExtra(ParcelKeys.ServiceMessage, message)
            LocalBroadcastManager.getInstance(this).sendBroadcast(messageIntent)
        } else {
            super.onMessageReceived(messageEvent)
        }
    }
}