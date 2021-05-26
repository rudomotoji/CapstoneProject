import request from '../utils/request'
// import patientHealth from '../assets/data/patient-health.json'
// import patientTracking from '../assets/data/patient-tracking.json'

export default {
  async getContracts () {
    return await request({
      method: 'get',
      url: 'Contracts/GetAllContractByStatus'
    })
  },
  async activeContract (contractID, status) {
    return await request({
      url: `Contracts/UpdateContractToDemo?contractId=${contractID}&status=${status}`,
      method: 'put'
    })
  }
}
