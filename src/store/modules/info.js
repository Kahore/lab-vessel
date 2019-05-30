// import Vue from 'vue';
import FieldDefault from '../../data/Field_Load_Default.json';
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
  loadingVesselInfo: false,
  firstInit: true
};
const getters = {
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
  loadField: ( { commit }, payload ) => {
    /* NKReports */
    // $.ajax( {
    //   url: './GetPageText.ashx?Id=@Nav_Backend@',
    //   type: 'GET',
    //   dataType: 'json',
    //   data: { PARAM2: 'Vessels_GetData_Default' },
    //   success: function ( resp ) {
    //     let myDataParse = resp; /* JSON.parse( resp ) */
    //     commit( 'loadField', myDataParse );
    //   }
    // } );
    /* TEST */
    let myDataParse = FieldDefault;
    commit( 'loadField', myDataParse );
  },
  LOAD_VESSEL_INFO: ( { commit }, payload ) => {
    return new Promise( function ( resolve, reject ) {
      let myDataParse = FieldVessel;
      commit( 'loadField', myDataParse );
      resolve( myDataParse );
      // $.ajax( {
      //   url: './GetPageText.ashx?Id=@Nav_Backend@',
      //   type: 'GET',
      //   dataType: 'json',
      //   data: { PARAM2: 'VesselFieldFiller', PARAM3:payload.PARAM3, unid: payload.unid },
      //   success: function ( resp ) {
      //     let myDataParse = resp; /* JSON.parse( resp ) */
      //     commit( 'loadField', myDataParse );
      //     resolve( myDataParse );
      //   }
      // } );
    } );
  },
  LOAD_CHART_MULTI: ( { commit }, payload ) => {
    return new Promise( function ( resolve, reject ) {
      let myDataParse = ChartMulti;
      commit( 'LOAD_CHART_MULTI', myDataParse );
      resolve( myDataParse );
      // $.ajax( {
      //   url: './GetPageText.ashx?Id=@Nav_Backend@',
      //   type: 'GET',
      //   dataType: 'json',
      //   data: { PARAM2: 'VesselChartData_Multi', Condition: payload.condition, Location: payload.location },
      //   success: function ( resp ) {
      //     let myDataParse = resp; /* JSON.parse( resp ) */
      //     commit( 'LOAD_CHART_MULTI', myDataParse );
      //     resolve( myDataParse );
      //   }
      // } );
    } );
  },
  Field_Save: ( { commit }, payload ) => {
    return new Promise( function ( resolve, reject ) {
      let _resp = FieldAfterSave;
      commit( 'mutateNewUnid', _resp[0].unid );
      commit( 'MUTATE_FIELD_HISTORY', _resp[0].HistoryPart[0] );
      window.history.pushState( '', '', './Default?Id=@NavID@&unid=' + _resp[0].unid );
      resolve( _resp[0].unid );
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
