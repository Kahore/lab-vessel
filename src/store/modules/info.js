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
        CanIEditVessel: 'true',
      },
    ],
    History: [],
    ChartData: [],
  },
  ChartMultiData: [],
  loadingField: false,
  loadingMultiVesselInfo: false,
  firstInit: true,
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
  },
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
  MUTATE_FIELD_RESET: state => {
    state.VesselInfo = JSON.parse( JSON.stringify( state.DefaultInfo ) );
    window.history.pushState( '', '', './Default?Id=@NavID@' );
  },
  MUTATE_FIELD_HISTORY: ( state, payload ) => {
    state.VesselInfo.History.unshift( payload );
  },
};
const actions = {
  // eslint-disable-next-line no-unused-vars
  LOAD_VESSEL_INFO: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    commit( 'InProgress_Field', true );
    // eslint-disable-next-line no-unused-vars
    return new Promise( function( resolve, reject ) {
      setTimeout( () => {
        let myDataParse = FieldVessel;
        commit( 'loadField', myDataParse );
        resolve( myDataParse );
        commit( 'InProgress_Field', false );
      }, 2000 );
      // const data = {  PARAM2: 'VesselFieldFiller', PARAM3: payload.PARAM3, unid: payload.unid };
      // const result = doAjax( '@Nav_Backend@', data ).then( ( result ) => {
      //   commit( 'loadField', result );
      //   resolve( result );
      //   commit( 'InProgress_Field', false );
      // } );
    } );
  },
  // eslint-disable-next-line no-unused-vars
  LOAD_CHART_MULTI: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    commit( 'InProgress_MultiVesselInfo', true );
    // eslint-disable-next-line no-unused-vars
    return new Promise( function( resolve, reject ) {
      let myDataParse = ChartMulti;
      commit( 'LOAD_CHART_MULTI', myDataParse );
      resolve( myDataParse );
      commit( 'InProgress_MultiVesselInfo', false );
      /* NKReports */
      // commit( 'InProgress_MultiVesselInfo', true );
      // const data = { PARAM2: 'VesselChartData_Multi', Condition: payload.condition, Location: payload.location };
      // const result = doAjax( '@Nav_Backend@', data ).then( ( result ) => {
      //   commit( 'LOAD_CHART_MULTI', result );
      //   resolve( result );
      //   commit( 'InProgress_MultiVesselInfo', false );
      // } );
    } );
  },
  // eslint-disable-next-line no-unused-vars
  Field_Save: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    // eslint-disable-next-line no-unused-vars
    return new Promise( function( resolve, reject ) {
      commit( 'InProgress_Field', true );
      let _resp = FieldAfterSave;
      commit( 'mutateNewUnid', _resp[0].unid );
      commit( 'MUTATE_FIELD_HISTORY', _resp[0].HistoryPart[0] );
      window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + _resp[0].unid );
      resolve( _resp[0].unid );
      commit( 'InProgress_Field', false );
      /* NKReports */
      // commit( 'InProgress_Field', true );
      // let _data = Object.assign( {}, payload, { PARAM2: 'SaveVessel' } );
      // const data = _data;
      // const result = doAjax( '@Nav_Backend@', data ).then( result => {
      //   commit( 'mutateNewUnid', result[0].unid );
      //   if ( result[0].HistoryPart ) {
      //     commit( 'MUTATE_FIELD_HISTORY', result[0].HistoryPart[0] );
      //   }
      //   window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + result[0].unid );
      //   resolve( result[0].unid );
      //   commit( 'InProgress_Field', false );
      // } );
    } );
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
