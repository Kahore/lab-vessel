<template>
  <section>
    <div id="wrapper">
      <span class="link_upd" @click="modalTogglerVM()">Добавить сосуд</span>
      <div id="layer_bg" class="layer_bg" @click="modalTogglerVM()" v-show="isBoxVisible"></div>
      <div v-show="isBoxVisible" class="modal_wrap_container">
        <div id="createTable" class="field-table">
          <info-field></info-field>
          <info-chart></info-chart>
        </div>
        <!-- .field-table -->
        <info-history></info-history>
        <div @click="modalTogglerVM()" class="closeContainer">
          <a id="closeIModal" class="close close__ligth" href="#"></a>
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
  data() {
    return {
      isBoxVisible: false,
    };
  },
  components: {
    'info-field': Field,
    'info-chart': Chart,
    'info-history': History,
  },
  methods: {
    modalTogglerVM(vesselID) {
      window.scrollTo(0, 0);
      var self = this;
      self.isBoxVisible = !self.isBoxVisible;
      self.$store.dispatch('LOAD_VESSEL_INFO', vesselID).then(response => {
        self.chartBulder(self);
      });
      console.log('modalTogglerVM');
    },
    chartBulder(self) {
      let chartData = self.$store.getters.vesselInfo.ChartData;
      self.chart = $('#chartContainer').highcharts({
        chart: { type: 'column' },
        colors: ['#ff9900', '#666666', '#333333', '#ff6600', '#ff3300'],
        credits: {
          text: 'Мониторинг состояния сосудов',
          href: '.',
        },
        title: { text: null },
        xAxis: {
          categories: chartData.map(function(e) {
            return e.ItemGroup;
          }),
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
            data: chartData.map(function(e) {
              return parseInt(e.ItemVal);
            }),
          },
          {
            type: 'line',
            name: 'Pre-Lim',
            color: 'red',
            dashStyle: 'longdash',
            data: chartData.map(function(e) {
              return parseInt(e.PreLim);
            }),
          },
          {
            type: 'line',
            name: 'Lim',
            color: 'red',
            dashStyle: 'longdash',
            data: chartData.map(function(e) {
              return parseInt(e.Lim);
            }),
          },
        ],
      });
    },
  },
  mounted() {
    let _unid = this.$store.getters.getCurrentUnid;
    EventBus.$on('FIELD_RISE', payload => {
      this.modalTogglerVM(_unid);
    });
  },
};
</script>
