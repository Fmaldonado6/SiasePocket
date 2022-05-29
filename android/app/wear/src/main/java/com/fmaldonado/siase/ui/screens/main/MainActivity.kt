package com.fmaldonado.siase.ui.screens.main

import android.app.Activity
import android.content.*
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.view.ViewConfiguration
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.InputDeviceCompat
import androidx.core.view.MotionEventCompat
import androidx.core.view.ViewConfigurationCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import androidx.wear.widget.WearableLinearLayoutManager
import androidx.wear.widget.WearableRecyclerView
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.Preferences
import com.fmaldonado.siase.databinding.ActivityMainBinding
import com.fmaldonado.siase.ui.adapters.ScheduleAdapter
import com.fmaldonado.siase.ui.screens.alert.AlertActivity
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.Status
import com.google.android.gms.wearable.Wearable
import com.google.gson.Gson
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import java.lang.Exception
import kotlin.math.roundToInt

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    private val viewModel: MainActivityViewModel by viewModels()

    private val getRetryResult =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            if (it.resultCode != Activity.RESULT_OK) return@registerForActivityResult
            viewModel.setStatus(Status.Loading)
            sendMessage()
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val messageFilter = IntentFilter(Intent.ACTION_SEND)
        val messageReceiver = MessageReceiver()
        LocalBroadcastManager.getInstance(this).registerReceiver(messageReceiver, messageFilter)

        viewModel.getStatus().observe(this) {
            binding.status = it
        }

        viewModel.getTodayClass().observe(this) {
            binding.classDetail = it
            it?.let { detail ->
                binding.title.text = detail.nombre
                binding.subtitle.text = "${detail.horaInicio} - ${detail.horaFin}"
            }
        }

        viewModel.getIsPhoneConnected().observe(this) {
            binding.phoneConnected = it
            Log.d("IsConnected", it.toString())
        }

        binding.nestedScrollView.setOnGenericMotionListener { v, ev ->
            if (ev.action == MotionEvent.ACTION_SCROLL &&
                ev.isFromSource(InputDeviceCompat.SOURCE_ROTARY_ENCODER)
            ) {
                val delta = -ev.getAxisValue(MotionEventCompat.AXIS_SCROLL) *
                        ViewConfigurationCompat.getScaledVerticalScrollFactor(
                            ViewConfiguration.get(this), this
                        )
                v.scrollBy(0, delta.roundToInt())
                true
            } else {
                false
            }
        }

        binding.phoneDisabled.setOnClickListener {
            val intent = Intent(this, AlertActivity::class.java)
            getRetryResult.launch(intent)
        }

        viewModel.getIsAppInstalled().observe(this) {
            if (it) return@observe
            val intent = Intent(this, AlertActivity::class.java)
            getRetryResult.launch(intent)
            viewModel.setIsAppInstalled(true)
        }

        viewModel.getTodaySchedule().observe(this) {
            binding.list.adapter = ScheduleAdapter(it)
            binding.nestedScrollView.requestFocus()

        }

    }

    override fun onResume() {
        super.onResume()
        sendMessage()
    }

    private fun sendMessage() {
        CoroutineScope(Dispatchers.IO).launch {


            try {
                val nodes = Wearable.getNodeClient(applicationContext).connectedNodes
                val nodesList = nodes.await()
                if (nodesList.isEmpty()) {
                    viewModel.setIsPhoneConnected(false)
                    viewModel.loadCacheSchedule()
                    return@launch
                }

                val nearbyDevices = nodesList.filter { it.isNearby }

                if (nearbyDevices.isEmpty()) {
                    viewModel.setIsPhoneConnected(false)
                    viewModel.loadCacheSchedule()
                    return@launch
                }

                viewModel.setIsPhoneConnected(true)
                viewModel.startMessageTimer()
                for (node in nearbyDevices) {
                    val task = Wearable.getMessageClient(applicationContext)
                        .sendMessage(node.id, "/message_path", "asd".encodeToByteArray())
                    task.await()
                }
            } catch (e: Exception) {
                viewModel.setIsPhoneConnected(false)
                viewModel.loadCacheSchedule()
            }
        }
    }

    inner class MessageReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            val message = intent.getStringExtra(ParcelKeys.ServiceMessage)
            val todaySchedule = Gson().fromJson(message, Array<ClassDetail>::class.java).toList()
            viewModel.setTodaySchedule(todaySchedule)
            viewModel.stopTimer()

        }
    }
}