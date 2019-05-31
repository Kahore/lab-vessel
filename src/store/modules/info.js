// import Vue from 'vue';

import FieldVessel from '../../data/Field_Load_Vessel.json';
import FieldAfterSave from '../../data/Field_Response_AfterSave.json';
import ChartMulti from '../../data/Chart_Load_Multi.json';

const state = {
  VesselInfo: {},
  Lists: [],
  DefaultInfo: {
    Field: [
      {
        CertificationDate: '',
        CommissioningDate: '',
        Condition: '',
        LastCheckDate: '',
        Location: '',
        Score: '',
        Serial: '',
        Status: '',
        VesselType: '',
        ID: '@' + 'unid' + '@',
        CanIEditVessel: 'true'
      }
    ],
    History: [],
    ChartData: []
  },
  ChartMultiData: [],
  loadingField: false,
  loadingMultiVesselInfo: false,
  firstInit: true
};
const getters = {
  isLoadingField: state => {
    return state.loadingField;
  },
  isLoadingMultiVesselInfo: state => {
    return state.loadingMultiVesselInfo;
  },
  vesselInfo: state => {
    return state.VesselInfo;
  },
  isFirstInit: state => {
    return state.firstInit;
  },
  GET_ChartMultiData: state => {
    return state.ChartMultiData;
  },
  GET_DD_Locations: state => {
    if ( state.Lists.length !== 0 ) {
      return state.Lists.Locations;
    }
  },
  GET_DD_VesselTypes: state => {
    if ( state.Lists.length !== 0 ) {
      return state.Lists.VesselTypes;
    }
  }
};
const mutations = {
  InProgress_Field: ( state, payload ) => {
    state.loadingField = payload;
  },
  InProgress_MultiVesselInfo: ( state, payload ) => {
    state.loadingMultiVesselInfo = payload;
  },
  loadField: ( state, payload ) => {
    if ( typeof payload[0].ListData !== 'undefined' ) {
      state.Lists = payload[0].ListData[0];
    }
    if ( typeof payload[0].Vessel !== 'undefined' ) {
      state.VesselInfo = payload[0].Vessel[0];
      window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + payload[0].Vessel[0].Field[0].ID );
    }
  },
  MUTATE_FIRST_INIT: ( state, payload ) => {
    state.firstInit = payload;
  },
  LOAD_CHART_MULTI: ( state, payload ) => {
    state.ChartMultiData = payload;
  },
  MUTATE_FIELD_RESET: ( state, payload ) => {
    state.VesselInfo = Object.assign( {}, state.DefaultInfo );
    window.history.pushState( '', '', './Default?Id=@NavID@' );
  },
  MUTATE_FIELD_HISTORY: ( state, payload ) => {
    state.VesselInfo.History.unshift( payload );
  }
};
const actions = {
  LOAD_VESSEL_INFO: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    commit( 'InProgress_Field', true );
    return new Promise( function ( resolve, reject ) {
      let myDataParse = FieldVessel;
      commit( 'loadField', myDataParse );
      resolve( myDataParse );
      commit( 'InProgress_Field', false );
      // $.ajax( {
      //   url: './GetPageText.ashx?Id=@Nav_Backend@',
      //   type: 'GET',
      //   dataType: 'json',
      //   data: { PARAM2: 'VesselFieldFiller', PARAM3: payload.PARAM3, unid: payload.unid },
      //   success: function ( resp ) {
      //     let myDataParse = resp; /* JSON.parse( resp ) */
      //     commit( 'loadField', myDataParse );
      //     resolve( myDataParse );
      //     commit( 'InProgress_Field', false );
      //   },
      //   error: function ( resp ) {
      //     commit( 'SET_ERROR', resp.responseText );
      //     commit( 'InProgress_Field', false );
      //     reject( resp.responseText );
      //   }
      // } );
    } );
  },
  LOAD_CHART_MULTI: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    return new Promise( function ( resolve, reject ) {
      let myDataParse = ChartMulti;
      commit( 'LOAD_CHART_MULTI', myDataParse );
      resolve( myDataParse );
      commit( 'InProgress_MultiVesselInfo', true );
      //   $.ajax( {
      //     url: './GetPageText.ashx?Id=@Nav_Backend@',
      //     type: 'GET',
      //     dataType: 'json',
      //     data: { PARAM2: 'VesselChartData_Multi', Condition: payload.condition, Location: payload.location },
      //     success: function ( resp ) {
      //       let myDataParse = resp; /* JSON.parse( resp ) */
      //       commit( 'LOAD_CHART_MULTI', myDataParse );
      //       resolve( myDataParse );
      //       commit( 'InProgress_MultiVesselInfo', false );
      //     },
      //     error: function ( resp ) {
      //       commit( 'SET_ERROR', resp.responseText );
      //        commit( 'InProgress_MultiVesselInfo', false );
      //        reject( resp.responseText );
      //     }
      //   } );
    } );
  },
  Field_Save: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    return new Promise( function ( resolve, reject ) {
      commit( 'InProgress_Field', true );
      let _resp = FieldAfterSave;
      commit( 'mutateNewUnid', _resp[0].unid );
      commit( 'MUTATE_FIELD_HISTORY', _resp[0].HistoryPart[0] );
      window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + _resp[0].unid );
      resolve( _resp[0].unid );
      commit( 'InProgress_Field', false );
      // $.ajax( {
      //   url: './GetPageText.ashx?Id=@Nav_Backend@',
      //   type: 'GET',
      //   dataType: 'json',
      //   data: payload,
      //   success: function ( resp ) {
      //     let _resp = resp; /* JSON.parse( resp ) */
      //     commit( 'mutateNewUnid', _resp[0].unid );
      //     if ( _resp[0].HistoryPart ) {
      //       commit( 'MUTATE_FIELD_HISTORY', _resp[0].HistoryPart[0] );
      //     }
      //     window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + _resp[0].unid );
      //     resolve( _resp[0].unid );
      //     commit( 'InProgress_Field', false );
      //   },
      //   error: function ( resp ) {
      //     commit( 'SET_ERROR', resp.responseText );
      //     reject( resp.responseText );
      //     commit( 'InProgress_Field', false );
      //   }
      // } );
    } );
  }
};

export default {
  state,
  getters,
  mutations,
  actions
};
