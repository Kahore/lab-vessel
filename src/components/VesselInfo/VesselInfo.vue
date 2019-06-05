<template>
  <section>
    <div id="wrapper">
      <span 
        class="link_upd"
        @click="modalTogglerVM()">Добавить сосуд</span>
      <div 
        v-show="isBoxVisible"
        class="layer_bg"
        @click="modalTogglerVM()" />
      <div 
        v-show="isBoxVisible"
        class="modal_wrap_container">
        <div 
          id="createTable"
          class="field-table">
          <info-field/>
          <info-chart-single/>
        </div>
        <!-- .field-table -->
        <info-history/>
        <div 
          class="closeContainer"
          @click="modalTogglerVM()" >
          <a 
            id="closeIModal"
            class="close close__ligth"
            href="#"/>
        </div>
      </div>
      <!-- .modal_wrap_container -->
    </div>
    <!-- #wrapper -->
  </section>
</template>

<script>
import EventBus from '../../EventBus';

import Field from './Field';
import Chart from './Chart';
import History from './History';

export default {
  name: 'VesselInfo',
  components: {
    'info-field': Field,
    'info-chart-single': Chart,
    'info-history': History,
  },
  data() {
    return {
      isBoxVisible: false,
    };
  },
  created() {
    let unid = this.$store.getters.getCurrentUnid;
    if ( unid !== '@' + 'unid' + '@' ) {
      this.modalTogglerVM();
    }
  },
  mounted() {
    EventBus.$on( 'FIELD_RISE', payload => {
      this.$store.dispatch ( 'mutateNewUnid', payload.unid );
      this.modalTogglerVM();
    } );
  },
  methods: { 
    modalTogglerVM() {
      window.scrollTo( 0, 0 );
      var self = this;
      var firstInit = self.$store.getters.isFirstInit;
      if ( self.isBoxVisible && !firstInit ) {
        self.$store.commit( 'MUTATE_FIELD_RESET' );
        // eslint-disable-next-line no-undef 
        if ( Highcharts.charts[0] ) {
        // eslint-disable-next-line no-undef   
          Highcharts.charts[0].destroy();
          /* MEMO: reset charts array */
        // eslint-disable-next-line no-undef   
          Highcharts.charts.shift();
        }
        self.$store.dispatch( 'mutateNewUnid', '@' + 'unid' + '@' );
      } else {
        let ajaxDefault;

        if ( firstInit ) {
          ajaxDefault = { PARAM3: 'VesselFieldFiller_Default' };
          self.$store.commit( 'MUTATE_FIRST_INIT', !firstInit );
        }
        let ajaxUNID;
        let _unid = self.$store.getters.getCurrentUnid;
        if ( _unid !== '@' + 'unid' + '@' ) {
          ajaxUNID = { unid: _unid };
        } else {
          self.$store.commit( 'MUTATE_FIELD_RESET' );
        }
        if ( typeof ajaxDefault !== 'undefined' || typeof ajaxUNID !== 'undefined' ) {
          let ajaxExtend = Object.assign( {}, ajaxDefault, ajaxUNID );
          // eslint-disable-next-line no-unused-vars
          self.$store.dispatch( 'LOAD_VESSEL_INFO', ajaxExtend ).then( response => {
            self.chartBulder( self );
          } );
        }
      }
      self.isBoxVisible = !self.isBoxVisible;
    },
    chartBulder( self ) {
      let chartData = self.$store.getters.vesselInfo.ChartData;
      // eslint-disable-next-line no-undef 
      self.chart = $( '#chartContainer' ).highcharts( {
        chart: { type: 'column' },
        colors: ['#ff9900', '#666666', '#333333', '#ff6600', '#ff3300'],
        credits: {
          text: 'Мониторинг состояния сосудов',
          href: '.',
        },
        title: { text: null },
        xAxis: {
          categories: chartData.map( function( e ) {
            return e.ItemGroup;
          } ),
          title: { text: null },
        },
        yAxis: {
          min: 0,
          title: {
            text: 'Накопительное количество поджигов',
            align: 'high',
          },
          labels: { overflow: 'justify' },
        },
        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true,
            },
          },
        },
        marker: { enabled: false },
        creditsNA: { enabled: false },
        series: [
          {
            name: 'fired',
            data: chartData.map( function( e ) {
              return parseInt( e.ItemVal );
            } ),
          },
          {
            type: 'line',
            name: 'Pre-Lim',
            color: 'red',
            dashStyle: 'longdash',
            data: chartData.map( function( e ) {
              return parseInt( e.PreLim );
            } ),
          },
          {
            type: 'line',
            name: 'Lim',
            color: 'red',
            dashStyle: 'longdash',
            data: chartData.map( function( e ) {
              return parseInt( e.Lim );
            } ),
          },
        ],
      } );
    },
  },
};
</script>
