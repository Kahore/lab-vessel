import Vue from 'vue';
import Vuex from 'vuex';

import info from './modules/info';
import table from './modules/table';
import shared from './modules/shared';

Vue.use( Vuex );

export const store = new Vuex.Store( {
  state: {},
  getters: {},
  mutations: {},
  actions: {},
  modules: {
    shared,
    info,
    table,
  },
} );
