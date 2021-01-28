import UserRepository from './UserRepository'
import ContractRepository from './ContractRepository'
import DoctorRepository from './DoctorRepository'
import LicenseRepository from './LicenseRepository'

const repositories = {
  userRepository: UserRepository,
  doctorRepository: DoctorRepository,
  contractRepository: ContractRepository,
  licenseRepository: LicenseRepository
}

export const RepositoryFactory = {
  get: name => repositories[name]
}
