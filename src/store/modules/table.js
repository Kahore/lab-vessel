import Vue from 'vue';
import VesselData from '../../data/Table_Load_Vessels.json';
import VesselAfterChange from '../../data/Table_Response_AfterChange.json';
import VesselAfterCounter from '../../data/Table_Response_CounterUpd.json';

const state = {
  Vessels: [],
  loadingVesselsTable: false,
  hideUtil: 'false' // '@UtilVesselFilter@',
};
const getters = {
  isLoadingVesselsTable: state => {
    return state.loadingVesselsTable;
  },
  GET_VESSELS_LIST: state => {
    return state.Vessels;
  },
  GET_FILTER_HIDE: state => {
    return state.hideUtil;
  }
};
const mutations = {
  InProgress_VesselTable: ( state, payload ) => {
    state.loadingVesselsTable = payload;
  },
  CLEAR_VESSELS: state => {
    state.Vessels = [];
  },
  loadVessels: ( state, payload ) => {
    state.Vessels = payload;
  },
  MUTATION_TABLE_REMOVE_OLD: ( state, payload ) => {
    if ( document.getElementById( payload ) !== null ) {
      let conditionValOld = document.getElementById( payload ).parentElement.firstElementChild.textContent;
      let locationValOld = document.getElementById( payload ).parentElement.parentElement.firstElementChild.textContent;

      let headerIndex = state.Vessels.findIndex( function ( block ) {
        return block.Location === locationValOld;
      } );

      let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex( function ( block ) {
        return block.Condition === conditionValOld;
      } );
      let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex( function (
        block
      ) {
        return block.ID === payload;
      } );

      state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.splice( vesselIndex, 1 );
      /* MEMO: Удалить заголовок, если больше ничего нет */
      if ( state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.length === 0 ) {
        state.Vessels[headerIndex].ConditionDetails.splice( subHeaderIndex, 1 );
      }
      /* MEMO: Удалить локацию, если больше ничего нет */
      if ( state.Vessels[headerIndex].ConditionDetails.length === 0 ) {
        state.Vessels.splice( headerIndex, 1 );
      }
    }
  },
  MUTATION_TABLE_UPDATE_ROW: ( state, payload ) => {
    let headerIndex = state.Vessels.findIndex( function ( block ) {
      return block.Location === payload.Location;
    } );

    if ( headerIndex !== -1 ) {
      let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex( function ( block ) {
        return block.Condition === payload.ConditionDetails[0].Condition;
      } );

      if ( subHeaderIndex !== -1 ) {
        let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex( function (
          block
        ) {
          return block.ID === payload.ConditionDetails[0].VesselDetails[0].ID;
        } );

        if ( vesselIndex !== -1 ) {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.splice( vesselIndex, 1 );
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } else {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } /* vesselIndex END */
      } else {
        state.Vessels[headerIndex].ConditionDetails.unshift( payload.ConditionDetails[0] );
      } /* subHeaderIndex END */
    } else {
      state.Vessels.unshift( payload );
    } /* headerIndex END */
  },
  MUTATION_TABLE_UPDATE_COUNT: ( state, payload ) => {
    console.log( 'TCL: payload', payload );
    let headerIndex = state.Vessels.findIndex( function ( block ) {
      return block.Location === payload.Location;
    } );
    let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex( function ( block ) {
      return block.Condition === payload.Condition;
    } );
    let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex( function (
      block
    ) {
      return block.ID === payload.unid;
    } );

    let updatedVessel = Object.assign(
      {},
      state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails[vesselIndex],
      payload[0]
    );
    Vue.set( state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails, vesselIndex, updatedVessel );
  },
  MUTATION_TABLE_VESSEL_ONACTION: ( state, payload ) => {
    let headerIndex = state.Vessels.findIndex( function ( block ) {
      return block.Location === payload.Location;
    } );
    let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex( function ( block ) {
      return block.Condition === payload.Condition;
    } );
    let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex( function (
      block
    ) {
      return block.ID === payload.unid;
    } );
    if ( state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails[vesselIndex].onAction === 'false' ) {
      state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails[vesselIndex].onAction = 'true';
    } else {
      state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails[vesselIndex].onAction = 'false';
    }
  },
  MUTATE_FILTER_HIDE: ( state, payload ) => {
    state.hideUtil = payload;
  }
};
const actions = {
  loadVessels: async ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    commit( 'CLEAR_VESSELS' );
    /* NKReports */
    // $.ajax({
    //   url: './GetPageText.ashx?Id=@Nav_Backend@',
    //   type: 'GET',
    //   dataType: 'json',
    //   data: { PARAM2: 'Vessels_GetData', hideMode: payload.hideMode },
    //   success: function(resp) {
    //     var myDataParse = JSON.parse(resp);
    //     commit('loadVessels', myDataParse);
    //   },
    //   error: function(resp) {
    //     commit( 'SET_ERROR', resp.responseText );
    //   },
    // });
    /* TEST */
    commit( 'InProgress_VesselTable', true );
    setTimeout( () => {
      let myDataParse;
      if ( payload.hideMode === 'true' ) {
        let _data = JSON.parse( JSON.stringify( VesselData ) );
        myDataParse = filterUtil( _data );
      } else {
        myDataParse = VesselData;
      }
      //  myDataParse = VesselData;
      commit( 'loadVessels', myDataParse );
      commit( 'InProgress_VesselTable', false );
    }, 5000 );
  },
  MUTATION_TABLE_UPDATE_ROW: ( { commit }, payload ) => {
    commit( 'CLEAR_ERROR' );
    // $.ajax({
    //   url: './GetPageText.ashx?Id=@Nav_Backend@',
    //   type: 'POST',
    //   dataType: 'json',
    //   data: { PARAM2: 'Vessels_GetData', unid: payload.unid },
    //   complete: function(resp) {
    //     var myDataParse = JSON.parse(resp.response);
    //     /* MEMO: Мод на поиск и удаление старого значения, в случае изменения глобальной инфы по сосуду - состояния или локации */
    //     if (typeof payload.mode !== 'undefined') {
    //       if (typeof payload.unid !== 'undefined') {
    //         commit('MUTATION_TABLE_REMOVE_OLD', payload.unid);
    //       }
    //     }
    //     /* MEMO: Берём ответ от сервера чтобы можно было обновлять данные в таблице вне зависимости откуда пришёл запрос - для обновления счётчика или параметров */
    //     if (typeof myDataParse[0] !== 'undefined') {
    //       commit('MUTATION_TABLE_UPDATE_ROW', myDataParse[0]);
    //     }
    //   },
    //   error: function(resp) {
    //     commit('SET_ERROR', resp.statusText);
    //   },
    // });
    if ( typeof payload.mode !== 'undefined' ) {
      if ( typeof payload.unid !== 'undefined' ) {
        commit( 'MUTATION_TABLE_REMOVE_OLD', payload.unid );
      }
    }
    let myDataParse = VesselAfterChange;
    if ( typeof myDataParse[0] !== 'undefined' ) {
      commit( 'MUTATION_TABLE_UPDATE_ROW', myDataParse[0] );
    }
  },
  MUTATION_TABLE_UPDATE_COUNT: async ( { commit }, payload ) => {
    console.log( 'TCL: payload', payload );
    commit( 'MUTATION_TABLE_VESSEL_ONACTION', payload );

    let result;
    result = await VesselAfterCounter;
    let completeData = Object.assign( result, payload );
    setTimeout( () => {
      commit( 'MUTATION_TABLE_UPDATE_COUNT', completeData );
      commit( 'MUTATION_TABLE_VESSEL_ONACTION', payload );
    }, 100000 );

    /* new var */
    // const data = { PARAM2: 'UpdateVesselInfoManually', unid: payload.unid };
    // const result = await doAjax( '@Nav_Backend@', data ).then( ( result ) => {
    //   let completeData = Object.assign( result, payload );
    //   commit( 'MUTATION_TABLE_UPDATE_COUNT', completeData );
    //   commit( 'MUTATION_TABLE_VESSEL_ONACTION', payload );
    // } );
  },
  MUTATE_FILTER_HIDE: ( { commit }, payload ) => {
    commit( 'MUTATE_FILTER_HIDE', payload );
  }
};

// eslint-disable-next-line no-unused-vars
// function doAjax ( url, ajaxData ) {
//   return new Promise( function ( resolve, reject ) {
//     try {
//       $.ajax( {
//         url: './GetPageText.ashx?Id=' + url,
//         type: 'POST',
//         data: ajaxData,
//         complete: function ( resp ) {
//           resolve( JSON.parse( resp ) );
//         },
//         error ( resp ) {
//           commit( 'SET_ERROR', resp.responseText );
//           reject( resp );
//         }
//       } );
//     } catch ( error ) {
//       commit( 'SET_ERROR', error );
//     }
//   } );
// }
export default {
  state,
  getters,
  mutations,
  actions
};
/* Imitate backend filter */
function filterUtil ( data ) {
  let filteredData = data.slice( 0 );
  filteredData = filteredData.filter(
    top =>
      ( top.ConditionDetails = top.ConditionDetails.filter(
        cat =>
          ( cat.VesselDetails = cat.VesselDetails.filter(
            i => i.Status.match( /OK/ ) || i.Status.match( /Требуется проверка/ ) || i.Status.match( /Требуется испытание/ )
          ) ).length
      ) ).length
  );
  return filteredData;
}
