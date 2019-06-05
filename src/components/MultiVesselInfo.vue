<template>
  <section>
    <div id="containerChartMulti">
      <div
        v-show="isMultiBoxVisible"
        class="layer_bg"
        @click="modalTogglerVM()"/>
      <div 
        v-show="isMultiBoxVisible" 
        class="modal_wrap_container">
        <div v-if="isMultiVesselInfoLoading">
          <lds-loader :external="'centered'"/>
        </div>
        <div class="field-block_full">
          <h2 v-text="chartTitle"/>
          <div 
            id="containerChartHlMulti" 
            class="mt-5per"/>
        </div>
        <!--.field-block_full -->
        <div 
          class="closeContainer"
          @click="modalTogglerVM()">
          <a 
            id="closeIModal"
            class="close close__ligth"
            href="#"/>
        </div>
      </div>
    </div>
    <!-- #containerChartMulti -->
  </section>
</template>

<script>
import EventBus from '../EventBus';
export default {
  data() {
    return {
      isMultiBoxVisible: false,
      chartTitle: '',
    };
  },
  computed: {
    isMultiVesselInfoLoading() {
      return this.$store.getters.isLoadingMultiVesselInfo;
    },
  },
  mounted() {
    EventBus.$on( 'MILTI_CHART_RISE', payload => {
      this.modalTogglerVM( payload );
    } );
  },
  methods: {
    modalTogglerVM( payload ) {
      window.scrollTo( 0, 0 );
      var self = this;
      if ( self.isMultiBoxVisible ) {
        self.chartTitle = '';
        let resetChartMultiData = [];
        self.$store.commit( 'LOAD_CHART_MULTI', resetChartMultiData );
        // eslint-disable-next-line no-undef
        Highcharts.charts[0].destroy();
        /* MEMO: reset charts array */
        // eslint-disable-next-line no-undef 
        Highcharts.charts.shift();
      } else {
        self.chartTitle = payload.condition + ' ' + payload.location;
        // eslint-disable-next-line no-unused-vars
        self.$store.dispatch( 'LOAD_CHART_MULTI', payload ).then( response => {
          self.groupChartBulder( self );
        } );
      }
      self.isMultiBoxVisible = !self.isMultiBoxVisible;
    },
    groupChartBulder( self ) {
      const options = self._prep_GroupChart_option();
      var chartData = self.$store.getters.GET_ChartMultiData;

      for ( let i = 0; i < chartData[0].Category.length; i++ ) {
        options.xAxis.categories.push( chartData[0].Category[i].ItemGroup );
      }

      for ( var i = 0; i < chartData.length; i++ ) {
        var arr = [];
        var limitSeriesArr = [];
        var preLimitSeriesArr = [];

        for ( let x = 0; x < options.xAxis.categories.length; x++ ) {
          arr.push( null );
          preLimitSeriesArr.push ( 5000 );
          limitSeriesArr.push( 10000 );
        }

        for ( let j = 0; j < chartData[i].vd.length; j++ ) {
          for ( let x = 0; x < options.xAxis.categories.length; x++ ) {
            var lol = options.xAxis.categories.indexOf( chartData[i].vd[j].ItemGroup );
            if ( lol !== -1 ) {
              arr[lol] = chartData[i].vd[j].ItemVal;
            }
          }
        }
        options.series.push( {
          name: chartData[i].SERIAL,
          data: arr,
        } );
      }
      options.series.push( {
        type: 'line',
        name: 'Lim',
        color: 'red',
        dashStyle: 'longdash',
        data: limitSeriesArr,
      } );
      options.series.push( {
        type: 'line',
        name: 'Pre-Lim',
        color: 'red',
        dashStyle: 'longdash',
        data: preLimitSeriesArr,
      } );
      // eslint-disable-next-line no-undef 
       $( '#containerChartHlMulti' ).highcharts( options );
    },
    _prep_GroupChart_option() {
      let options = {
        chart: { type: 'column' },
        colors: ['#ff9900', '#666666', '#333333', '#ff6600', '#ff3300'],
        credits: {
          text: 'Мониторинг состояния сосудов по статусу',
          href: '.',
        },
        title: { text: null },
        xAxis: {
          categories: [],
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
        series: [],
      };
      return options;
    },
  },
};
</script>