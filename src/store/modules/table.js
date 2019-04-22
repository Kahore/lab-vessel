// import Vue from 'vue';

const state = {
  Vessels: [],
  loadingVesselsTable: false,
  hideUtil: 'true', // '@UtilVesselFilter@',
};
const getters = {
  loadingVesselsTable: state => {
    return state.loadingVesselsTable;
  },
  GET_VESSELS_LIST: state => {
    return state.Vessels;
  },
  GET_FILTER_HIDE: state => {
    return state.hideUtil;
  },
};
const mutations = {};
const actions = {};

export default {
  state,
  getters,
  mutations,
  actions,
};
