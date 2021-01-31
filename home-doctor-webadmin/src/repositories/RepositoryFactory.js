import UserRepository from './UserRepository'
import ContractRepository from './ContractRepository'
import DoctorRepository from './DoctorRepository'
import LicenseRepository from './LicenseRepository'
import DiseaseRepository from './DiseaseRepository';

const repositories = {
  userRepository: UserRepository,
  doctorRepository: DoctorRepository,
  contractRepository: ContractRepository,
  licenseRepository: LicenseRepository,
  diseaseRepository: DiseaseRepository,
}

export const RepositoryFactory = {
  get: name => repositories[name]
}
