// import Vue from 'vue';

const state = {
  VesselInfo: {},
  isVesselInfoActive: false,
  loadingVesselInfo: false
};
const getters = {
  vesselInfo: state => {
    return state.VesselInfo;
  },
  GET_IS_VESSELINFO_ACTIVE: state => {
    return state.isVesselInfoActive;
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
  }
};
const mutations = {
  loadField: (state, payload) => {
    state.VesselInfo = payload[0];
  }
};
const actions = {
  loadField: ({ commit }, payload) => {
    let resp =
      '[ {"Btn_Save":"<input class=\\"btn\\" type=\\"button\\" name=\\"save\\" id=\\"save\\" value=\\"Сохранить\\" />","Lists":[ {"Locations":"Киселевск;Новокузнецк;Черногорск,","VesselTypes":"Тип 1 - IKA C5010;Тип 2 - AC500/6200;Тип 3 - AC600;Тип 4 - 5E-C5500;"}],"CanIEditVessel":"true"}]';
    let myDataParse = JSON.parse(resp);
    commit('loadField', myDataParse);
  }
};

export default {
  state,
  getters,
  mutations,
  actions
};
