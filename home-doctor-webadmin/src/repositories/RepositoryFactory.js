import UserRepository from './UserRepository'
import ContractRepository from './ContractRepository'
import DoctorRepository from './DoctorRepository'
import LicenseRepository from './LicenseRepository'
import SymptomRepository from './SymptomRepository';

const repositories = {
  userRepository: UserRepository,
  doctorRepository: DoctorRepository,
  contractRepository: ContractRepository,
  licenseRepository: LicenseRepository,
  symptomRepository: SymptomRepository,
}

export const RepositoryFactory = {
  get: name => repositories[name]
}
