package com.fmaldonado.siase.ui.screens.auth

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import androidx.annotation.StringRes
import com.fmaldonado.siase.R
import com.fmaldonado.siase.databinding.ActivityMainBinding
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.screens.home.HomeActivity
import com.fmaldonado.siase.ui.screens.mainCareerSelection.MainCareerSelection
import com.fmaldonado.siase.ui.utils.Status
import com.fmaldonado.siase.ui.utils.safeLet
import com.google.android.material.snackbar.Snackbar
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : BaseActivity() {

    private lateinit var binding: ActivityMainBinding

    override val viewModel: MainActivityViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)

        viewModel.checkSession()

        viewModel.needsSelection.observe(this) {
            if (it) {
                val intent = Intent(this, MainCareerSelection::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                return@observe
            }

            val intent = Intent(this, HomeActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }

        viewModel.status.observe(this) {
            if (it == Status.Completed) {
                viewModel.checkIfNeedsSelection()
                return@observe
            }
            binding.status = it
        }

        viewModel.snackBar.observe(this) {
            showSnackBar(it.first, it.second, it.third)
        }
        binding.signInButton.setOnClickListener {
            val username = binding.usernameFieldInput.text
            val password = binding.passwordFieldInput.text

            if (username.isNullOrEmpty() || password.isNullOrEmpty()) {
                showSnackBar(R.string.credentialsError)
                return@setOnClickListener
            }

            viewModel.signIn(username.toString(), password.toString())
        }

        setContentView(binding.root)
    }

    private fun showSnackBar(
        @StringRes id: Int,
        @StringRes actionId: Int? = null,
        action: (() -> Unit)? = null
    ) {
        val string = resources.getString(id)
        val snackbar = Snackbar.make(
            binding.root,
            string,
            Snackbar.LENGTH_LONG
        )

        safeLet(actionId, action) { i: Int, function: () -> Unit? ->
            snackbar.setAction(i) {
                function()
            }
        }

        snackbar.show()
    }

}