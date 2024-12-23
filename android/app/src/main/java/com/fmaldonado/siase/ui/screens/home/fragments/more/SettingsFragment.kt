package com.fmaldonado.siase.ui.screens.home.fragments.more

import android.Manifest
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.viewModels
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import androidx.preference.SwitchPreference
import com.fmaldonado.siase.BuildConfig
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Themes
import com.fmaldonado.siase.ui.screens.auth.MainActivity
import com.fmaldonado.siase.ui.screens.home.HomeActivity
import com.fmaldonado.siase.ui.screens.mainCareerSelection.MainCareerSelection
import com.fmaldonado.siase.ui.screens.mainScheduleSelection.MainScheduleSelection
import com.fmaldonado.siase.ui.utils.ParcelKeys
import com.fmaldonado.siase.ui.utils.PreferencesKeys
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class SettingsFragment : PreferenceFragmentCompat() {

    private val viewModel: MoreViewModel by viewModels()

    private val requestPostNotificationsLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted ->
            viewModel.setNotificationsPreferences(isGranted)
        }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.mainCareer.observe(viewLifecycleOwner) {
            val careerPref = findPreference(PreferencesKeys.Career.key) as Preference?
            careerPref!!.summary = it.nombre.split("-").last().trim()
        }

        viewModel.mainSchedule.observe(viewLifecycleOwner) {
            val schedulePref = findPreference(PreferencesKeys.Schedule.key) as Preference?
            schedulePref!!.summary = it.nombre
        }

        viewModel.notifications.observe(viewLifecycleOwner) {
            val notifPref =
                findPreference(PreferencesKeys.Notifications.key) as SwitchPreference?
            notifPref?.isChecked = it
        }

        viewModel.currentTheme.observe(viewLifecycleOwner) {
            val themePref =
                findPreference(PreferencesKeys.Theme.key) as SwitchPreference?
            themePref?.isChecked = it == Themes.Dynamic.ordinal
        }

        viewModel.status.observe(viewLifecycleOwner) {
            when (it) {
                Status.SignOut -> {
                    val intent = Intent(context, MainActivity::class.java)
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                }
                else -> Log.d("PreferencesFragment", "Status not implemented")
            }
        }

    }


    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        addPreferencesFromResource(R.xml.preferences)
        val pref = findPreference(PreferencesKeys.Version.key) as Preference?

        viewModel.getCurrentCareer()
        viewModel.getCurrentSchedule()
        viewModel.getNotificationsPreferences()
        viewModel.getThemePreference()

        pref?.let {
            it.summary = BuildConfig.VERSION_NAME
        }
    }

    override fun onPreferenceTreeClick(preference: Preference): Boolean {


        when (preference.key) {
            PreferencesKeys.Career.key -> startIntent(MainCareerSelection::class.java)
            PreferencesKeys.Schedule.key -> {
                val intent = Intent(context, MainScheduleSelection::class.java)
                intent.putExtra(ParcelKeys.SelectedCareer, viewModel.mainCareer.value)
                startActivity(intent)
            }
            PreferencesKeys.SignOut.key -> viewModel.signOut()
            PreferencesKeys.Developer.key -> startURLIntent("https://twitter.com/Fmaldonado4202")
            PreferencesKeys.SourceCode.key -> startURLIntent("https://github.com/Fmaldonado6/SiasePocket")
            PreferencesKeys.Icon.key -> startURLIntent("https://twitter.com/DavidLazaroFern")
            PreferencesKeys.Notifications.key -> {

                val notifPref = findPreference(
                    PreferencesKeys.Notifications.key
                ) as SwitchPreference?

                val isChecked = notifPref!!.isChecked

                Log.d("ISCHECKED", isChecked.toString())

                if (isChecked) requestNotificationPermission()
                else revokeNotificationPermission()

            }
            PreferencesKeys.Theme.key -> {
                val themePref = findPreference(
                    PreferencesKeys.Theme.key
                ) as SwitchPreference?
                viewModel.setThemePreferences(themePref!!.isChecked)

                activity?.recreate()
            }

            else -> Log.d(this.tag, "Unregistered preference")
        }


        return super.onPreferenceTreeClick(preference)
    }

    private fun startURLIntent(url: String) {
        val intent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse(url)
        )
        startActivity(intent)
    }

    private fun <T> startIntent(activity: Class<T>) {
        val intent = Intent(context, activity)
        startActivity(intent)
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT < 33)
            viewModel.setNotificationsPreferences(true)
        else
            requestPostNotificationsLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
    }

    private fun revokeNotificationPermission() {
        viewModel.setNotificationsPreferences(false)
    }
}