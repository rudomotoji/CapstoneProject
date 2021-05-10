// import UserRepository from './UserRepository'
import DoctorRepository from './DoctorRepository'
import PatientRepository from './PatientRepository'
import ContractRepository from './ContractRepository'
import TimeRepository from './TimeRepository'
import LicenceRepository from './LicenceRepository'

const repositories = {
    // userRepository: UserRepository,
    doctorRepository: DoctorRepository,
    patientRepository: PatientRepository,
    timeRepository: TimeRepository,
    contractRepository: ContractRepository,
    licenceRepository: LicenceRepository,
}

export const RepositoryFactory = {
    get: name => repositories[name]
}
