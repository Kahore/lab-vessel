// import Vue from 'vue';

const state = {
  VesselInfo: {},
  loadingVesselInfo: false,
};
const getters = {
  vesselInfo: state => {
    return state.VesselInfo;
  },

  GET_DD_Locations: state => {
    if (typeof state.VesselInfo.Lists !== 'undefined') {
      return state.VesselInfo.Lists[0].Locations;
    }
  },
  GET_DD_VesselTypes: state => {
    if (typeof state.VesselInfo.Lists !== 'undefined') {
      return state.VesselInfo.Lists[0].VesselTypes;
    }
  },
};
const mutations = {
  loadField: (state, payload) => {
    state.VesselInfo = payload[0];
  },
};
const actions = {
  loadField: ({ commit }, payload) => {
    let resp =
      '[ {"Btn_Save":"<input class=\\"btn\\" type=\\"button\\" name=\\"save\\" id=\\"save\\" value=\\"Сохранить\\" />","Lists":[ {"Locations":"Киселевск;Новокузнецк;Черногорск,","VesselTypes":"Тип 1 - IKA C5010;Тип 2 - AC500/6200;Тип 3 - AC600;Тип 4 - 5E-C5500;"}],"CanIEditVessel":"true"}]';
    let myDataParse = JSON.parse(resp);
    commit('loadField', myDataParse);
  },
  LOAD_VESSEL_INFO: ({ commit }, payload) => {
    let resp =
      '[ {"Status":"OK","ID":"30005D94-8D64-4B8D-926A-8EC7644C071C","Condition":"IKA_C2000 (ЛИМИТ 30000)","CommissioningDate":"01/03/2016","CertificationDate":"25/06/2018","Serial":100006814,"LastCheckDate":"25/06/2018","Score":4,"Location":"Новокузнецк","VesselType":"Тип 1 - IKA C5010","btn_Save":"<input class=\\"btn\\" type=\\"button\\" name=\\"save\\" id=\\"save\\" value=\\"Сохранить\\" />","CanIEditVessel":"true","Lists":[ {"Locations":"Киселевск;Новокузнецк;Черногорск;","VesselTypes":"Тип 1 - IKA C5010;Тип 2 - AC500/6200;Тип 3 - AC600;Тип 4 - 5E-C5500;"}],"History":[ {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-04-22 08:31:00"}, {"Item":"Поджиги","ItemVal":424,"CreatedBy":"Auto_Procedure","Created":"2019-04-22 08:30:00"}, {"Item":"Поджиги","ItemVal":519,"CreatedBy":"Auto_Procedure","Created":"2019-04-15 08:30:00"}, {"Item":"Поджиги","ItemVal":616,"CreatedBy":"Auto_Procedure","Created":"2019-04-08 08:30:00"}, {"Item":"Поджиги","ItemVal":616,"CreatedBy":"Auto_Procedure","Created":"2019-03-31 23:59:00"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-03-25 08:31:00"}, {"Item":"Поджиги","ItemVal":589,"CreatedBy":"Auto_Procedure","Created":"2019-03-25 08:30:00"}, {"Item":"Поджиги","ItemVal":573,"CreatedBy":"Auto_Procedure","Created":"2019-03-18 08:30:00"}, {"Item":"Поджиги","ItemVal":621,"CreatedBy":"Auto_Procedure","Created":"2019-03-11 08:30:00"}, {"Item":"Смена статуса","ItemVal":"IKA_C2000 (ЛИМИТ 30000)","CreatedBy":"Marina_Gorodetskaya","Created":"2019-03-04 08:32:00"}, {"Item":"Поджиги","ItemVal":154,"CreatedBy":"Auto_Procedure","Created":"2019-03-04 08:30:00"}, {"Item":"Поджиги","ItemVal":256,"CreatedBy":"rucoalsu","Created":"2019-03-02 17:19:00"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-02-25 08:31:00"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-02-25 08:30:00"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-02-18 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-02-11 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-02-04 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-01-31 23:59:59"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-01-28 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-01-21 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-01-14 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2019-01-07 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-31 23:59:59"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-31 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-24 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-17 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-10 14:43:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-12-10 14:43:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"rucoalsu","Created":"2018-12-10 13:00:03"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"rucoalsu","Created":"2018-12-03 11:15:06"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-11-26 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-11-19 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-11-12 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-11-05 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-31 23:59:59"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-29 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-22 08:30:23"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-15 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-08 12:01:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"Auto_Procedure","Created":"2018-10-08 08:30:22"}, {"Item":"Поджиги","ItemVal":0,"CreatedBy":"rucoalsu","Created":"2018-10-02 16:11:34"}]}]';
    let myDataParse = JSON.parse(resp);
    commit('loadField', myDataParse);
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
