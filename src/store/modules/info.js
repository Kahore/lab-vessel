// import Vue from 'vue';
import FieldDefault from '../../data/Field_Load_Default.json';
import FieldVessel from '../../data/Field_Load_Vessel.json';
import FieldAfterSave from '../../data/Field_Response_AfterSave.json';
import ChartMulti from '../../data/Chart_Load_Multi.json';

const state = {
  VesselInfo: {},
  ChartMultiData: [],
  loadingVesselInfo: false,
};
const getters = {
  vesselInfo: state => {
    return state.VesselInfo;
  },
  GET_ChartMultiData: state => {
    return state.ChartMultiData;
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
  LOAD_CHART_MULTI: (state, payload) => {
    state.ChartMultiData = payload;
  },
  MUTATE_FIELD_HISTORY: (state, payload) => {
    state.VesselInfo.History.unshift(payload);
  },
};
const actions = {
  loadField: ({ commit }, payload) => {
    /* NKReports */
    // $.ajax({
    //   url: './GetPageText.ashx?Id=@Nav_Backend@',
    //   type: 'GET',
    //   dataType: 'json',
    //   data: { PARAM2: 'Vessels_GetData_Default' },
    //   success: function(resp) {
    //     let myDataParse = resp; /* JSON.parse( resp ) */
    //     commit('loadField', myDataParse);
    //   },
    // });
    /* TEST */
    let myDataParse = FieldDefault;
    commit('loadField', myDataParse);
  },
  LOAD_VESSEL_INFO: ({ commit }, payload) => {
    return new Promise(function(resolve, reject) {
      let myDataParse = FieldVessel;
      commit('loadField', myDataParse);
      resolve(myDataParse);
    });
  },
  LOAD_CHART_MULTI: ({ commit }, payload) => {
    return new Promise(function(resolve, reject) {
      let myDataParse = ChartMulti;
      commit('LOAD_CHART_MULTI', myDataParse);
      resolve(myDataParse);
    });
  },
  Field_Save: ({ commit }, payload) => {
    return new Promise(function(resolve, reject) {
      let _resp = FieldAfterSave;
      commit('mutateNewUnid', _resp[0].unid);
      commit('MUTATE_FIELD_HISTORY', _resp[0].HistoryPart[0]);
      window.history.pushState('', '', './Default?Id=@NavID@&unid=' + _resp[0].unid);
      resolve(_resp[0].unid);
    });
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
