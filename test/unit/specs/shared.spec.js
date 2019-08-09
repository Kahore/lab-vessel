import shared, { _defUNID } from '../../src/store/modules/shared';
import Vue from 'vue';
import Vuex from 'vuex';
Vue.use( Vuex );
const state = {
  id: '@unid@',
  error_Msg: 'error_Msg',
  info_Msg: 'info_Msg',
};

/*
 * Shared getters tests
 */

it( '"getCurrentUnid" returns default "@id@" value of state id', () => {
  expect( shared.getters.getCurrentUnid( state ) ).toBe( state.id );
} );

it( '"isANewDoc" returns true if default id value is "@id@"', () => {
  expect( shared.getters.isANewDoc( state ) ).toBe( true );
  expect( shared.getters.isANewDoc( { id: 'someID' } ) ).toBe( false );
} );

it( '"GET_ERROR" returns value if "state.error_Msg" has value', () => {
  expect( shared.getters.GET_ERROR( state ) ).toBe( state.error_Msg );
  expect( shared.getters.GET_ERROR( { error_Msg: null } ) ).toBe( '' );
} );

it( '"GET_INFO" returns value if "state.info_Msg" has value', () => {
  expect( shared.getters.GET_INFO( state ) ).toBe( state.info_Msg );
  expect( shared.getters.GET_INFO( { info_Msg: '' } ) ).toBe( '' );
} );

/*
 * Shared mutations tests
 */
const mutateState = {
  id: '@newid@',
  error_Msg: 'new error_Msg',
  info_Msg: 'new info_Msg',
};
it( 'mutateNewUnid set new value to state.id', () => {
  shared.mutations.mutateNewUnid( mutateState );
  expect( mutateState.id ).toBe( mutateState.id );
} );

it( 'SET_ERROR set new error to state.error_Msg', () => {
  shared.mutations.SET_ERROR( mutateState );
  expect( mutateState.error_Msg ).toBe( mutateState.error_Msg );
} );

it( 'CLEAR_ERROR reset error state', () => {
  shared.mutations.CLEAR_ERROR( mutateState );
  expect( mutateState.error_Msg ).toBe( null );
} );

it( 'SET_INFO set new info to state.info_Msg', () => {
  shared.mutations.SET_INFO( mutateState );
  expect( mutateState.info_Msg ).toBe( mutateState.info_Msg );
} );

it( 'CLEAR_INFO reset info state', () => {
  shared.mutations.CLEAR_INFO( mutateState );
  expect( mutateState.info_Msg ).toBe( null );
} );

/*
 * Shared actions tests
 */
describe( 'actions', () => {
  let store;
  beforeEach( () => {
    store = new Vuex.Store( {
      state: {
        id: '',
        error_Msg: '',
        info_Msg: '',
      },
      mutations: {
        mutateNewUnid: shared.mutations.mutateNewUnid,
        SET_ERROR: shared.mutations.SET_ERROR,
        CLEAR_ERROR: shared.mutations.CLEAR_ERROR,
        SET_INFO: shared.mutations.SET_INFO,
        CLEAR_INFO: shared.mutations.CLEAR_INFO,
      },
      actions: {
        mutateNewUnid: shared.actions.mutateNewUnid,
        SET_ERROR: shared.actions.SET_ERROR,
        CLEAR_ERROR: shared.actions.CLEAR_ERROR,
        SET_INFO: shared.actions.SET_INFO,
        CLEAR_INFO: shared.actions.CLEAR_INFO,
      },
    } );
  } );
  it( 'test mutateNewUnid using a mock mutation but real store', () => {
    store.dispatch( 'mutateNewUnid', 'newid' );
    expect( store.state.id ).toBe( 'newid' );
  } );
  it( 'test SET_ERROR using a mock mutation but real store', () => {
    store.dispatch( 'SET_ERROR', 'some error' );
    expect( store.state.error_Msg ).toBe( 'some error' );
  } );
  it( 'test CLEAR_ERROR using a mock mutation but real store', () => {
    store.dispatch( 'CLEAR_ERROR' );
    expect( store.state.error_Msg ).toBe( null );
  } );
  it( 'test SET_INFO using a mock mutation but real store', () => {
    store.dispatch( 'SET_INFO', 'some info' );
    expect( store.state.info_Msg ).toBe( 'some info' );
  } );
  it( 'test CLEAR_INFO using a mock mutation but real store', () => {
    store.dispatch( 'CLEAR_INFO' );
    expect( store.state.info_Msg ).toBe( null );
  } );
} );

describe( '_defUNID test', () => {
  it( 'should be a default value', () => {
    expect( _defUNID() ).toBe( '@id@' );
  } );
} );
