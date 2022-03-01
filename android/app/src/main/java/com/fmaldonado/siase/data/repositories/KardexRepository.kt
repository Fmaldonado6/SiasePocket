package com.fmaldonado.siase.data.repositories

import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Kardex
import com.fmaldonado.siase.data.network.NetworkDataSource
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class KardexRepository
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val networkDataSource: NetworkDataSource,
) {

    suspend fun getKardex(career: Careers): Kardex {
        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == career.claveCarrera &&
                    it.claveDependencia == career.claveDependencia
        }

        return networkDataSource.getKardex(index)
    }
}