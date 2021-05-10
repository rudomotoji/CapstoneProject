import request from '../utils/request'
// import patientHealth from '../assets/data/patient-health.json'
// import patientTracking from '../assets/data/patient-tracking.json'

export default {
  async getListPatients() {
    return await request({
      method: 'get',
      url: `Patients/GetAllPatient`
    })
  }
}
