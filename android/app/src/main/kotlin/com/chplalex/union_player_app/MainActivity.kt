package com.chplalex.union_player_app

import android.os.Bundle
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity : AudioServiceActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        if (BuildConfig.DEBUG) {
            FirebaseApp.initializeApp(this)
            val firebaseAppCheck = FirebaseAppCheck.getInstance()
            val appCheckProvider = DebugAppCheckProviderFactory.getInstance()
            firebaseAppCheck.installAppCheckProviderFactory(appCheckProvider)
        }
        super.onCreate(savedInstanceState)
    }
}
