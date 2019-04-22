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
      '[ {"Status":"OK","ID":"30005D94-8D64-4B8D-926A-8EC7644C071C","Condition":"IKA_C2000 (ЛИМИТ 30000)","CommissioningDate":"01/03/2016","CertificationDate":"25/06/2018","Serial":100006814,"LastCheckDate":"25/06/2018","Score":4,"Location":"Новокузнецк","VesselType":"Тип 1 - IKA C5010","btn_Save":"<input class=\\"btn\\" type=\\"button\\" name=\\"save\\" id=\\"save\\" value=\\"Сохранить\\" />","CanIEditVessel":"true","Lists":[ {"Locations":"Киселевск;Новокузнецк;Черногорск;","VesselTypes":"Тип 1 - IKA C5010;Тип 2 - AC500/6200;Тип 3 - AC600;Тип 4 - 5E-C5500;"}]}]';
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
