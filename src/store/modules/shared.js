const state = {
  unid: '@unid@',
  error_Msg: '',
  info_Msg: 'инфо',
};
const getters = {
  getCurrentUnid: state => {
    return state.unid;
  },
  GET_ERROR(state) {
    if (state.error_Msg === null) {
      return '';
    } else {
      return state.error_Msg;
    }
  },
  GET_INFO(state) {
    return state.info_Msg;
  },
};
const mutations = {
  mutateNewUnid: (state, payload) => {
    state.unid = payload;
  },
  SET_ERROR: (state, payload) => {
    state.error_Msg = payload;
  },
  CLEAR_ERROR: state => {
    state.error_Msg = null;
  },
  SET_INFO: (state, payload) => {
    state.info_Msg = payload;
    setTimeout(() => {
      state.info_Msg = '';
    }, 5000);
  },
  CLEAR_INFO: state => {
    state.info_Msg = null;
  },
};
const actions = {
  mutateNewUnid: ({ commit }, payload) => {
    commit('mutateNewUnid', payload);
  },
  SET_ERROR({ commit }, payload) {
    commit('SET_ERROR', payload);
  },
  CLEAR_ERROR({ commit }) {
    commit('CLEAR_ERROR');
  },
  SET_INFO({ commit }, payload) {
    commit('SET_INFO', payload);
  },
  CLEAR_INFO({ commit }) {
    commit('CLEAR_INFO');
  },
};
export default {
  state,
  getters,
  mutations,
  actions,
};
