// import Vue from 'vue';
import VesselData from '../../data/Table_Load_Vessels.json';
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
const mutations = {
  loadVessels: (state, payload) => {
    state.Vessels = payload;
  },
  MUTATION_TABLE_REMOVE_OLD: (state, payload) => {
    let conditionValOld = document.getElementById(payload).parentElement.firstElementChild.textContent;
    let locationValOld = document.getElementById(payload).parentElement.parentElement.firstElementChild.textContent;

    let headerIndex = state.Vessels.findIndex(function(block) {
      return block.Location === locationValOld;
    });

    let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex(function(block) {
      return block.Condition === conditionValOld;
    });
    let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex(function(
      block
    ) {
      return block.ID === payload;
    });

    state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.splice(vesselIndex, 1);
    /* MEMO: Удалить заголовок, если больше ничего нет */
    if (state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.length === 0) {
      state.Vessels[headerIndex].ConditionDetails.splice(subHeaderIndex, 1);
    }
    /* MEMO: Удалить локацию, если больше ничего нет */
    if (state.Vessels[headerIndex].ConditionDetails.length === 0) {
      state.Vessels.splice(headerIndex, 1);
    }
  },
  MUTATION_TABLE_UPDATE: (state, payload) => {
    let headerIndex = state.Vessels.findIndex(function(block) {
      return block.Location === payload.Location;
    });

    if (headerIndex !== -1) {
      let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex(function(block) {
        return block.Condition === payload.ConditionDetails[0].Condition;
      });

      if (subHeaderIndex !== -1) {
        let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex(function(
          block
        ) {
          return block.ID === payload.ConditionDetails[0].VesselDetails[0].ID;
        });

        if (vesselIndex !== -1) {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.splice(vesselIndex, 1);
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } else {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } /* vesselIndex END */
      } else {
        state.Vessels[headerIndex].ConditionDetails.unshift(payload.ConditionDetails[0]);
      } /* subHeaderIndex END */
    } else {
      state.Vessels.unshift(payload);
    } /* headerIndex END */
  },
};
const actions = {
  loadVessels: async ({ commit }, payload) => {
    const myDataParse = VesselData;
    commit('loadVessels', myDataParse);
  },
  Table_UpdateVessel: ({ commit }, payload) => {
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
    //       commit('MUTATION_TABLE_UPDATE', myDataParse[0]);
    //     }
    //   },
    //   error: function(resp) {
    //     commit('SET_ERROR', resp.statusText);
    //   },
    // });
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
