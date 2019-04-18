// import Vue from 'vue';

const state = {
  VesselInfo: {},
  loadingVesselInfo: false
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
  }
};
const mutations = {};
const actions = {};

export default {
  state,
  getters,
  mutations,
  actions
};
