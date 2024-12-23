package com.fmaldonado.siase.data.repositories

import com.fmaldonado.siase.data.models.Afi
import com.fmaldonado.siase.data.models.AfiHistorial
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.network.NetworkDataSource
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AfisRepository
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val networkDataSource: NetworkDataSource,
) {

    suspend fun getAfis(
        career: Careers,
        month: Int,
        cacheEnabled: Boolean = true
    ): MutableList<Afi> {

        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == career.claveCarrera &&
                    it.claveDependencia == career.claveDependencia
        }
        return networkDataSource.getAfis(
            index,
            month,
            if (cacheEnabled)
                NetworkDataSource.EnableCache
            else
                NetworkDataSource.DisableCache
        )

    }

    suspend fun getAfisHistory(
        career: Careers,
        cacheEnabled: Boolean = true
    ): AfiHistorial {

        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == career.claveCarrera &&
                    it.claveDependencia == career.claveDependencia
        }
        return networkDataSource.getAfisHistory(
            index,
            if (cacheEnabled)
                NetworkDataSource.EnableCache
            else
                NetworkDataSource.DisableCache
        )

    }

}
