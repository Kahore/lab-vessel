<template>
  <section>
    <div id="containerChartMulti">
      <div class="layer_bg" @click="modalTogglerVM()" v-show="isMultiBoxVisible"></div>
      <div v-show="isMultiBoxVisible" class="modal_wrap_container">
        <div class="field-block_full">
          <h2 v-text="chartTitle"></h2>
          <div id="containerChartHlMulti" class="mt-5per"></div>
        </div>
        <!--.field-block_full -->
        <div class="closeContainer" @click="modalTogglerVM()">
          <a id="closeIModal" class="close close__ligth" href="#"></a>
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
  methods: {
    modalTogglerVM(payload) {
      window.scrollTo(0, 0);
      var self = this;
      if (self.isMultiBoxVisible) {
        self.chartTitle = '';
        let resetChartMultiData = [];
        self.$store.commit('LOAD_CHART_MULTI', resetChartMultiData);
        Highcharts.charts[0].destroy();
      } else {
        self.chartTitle = payload.condition + ' ' + payload.location;
        self.$store.dispatch('LOAD_CHART_MULTI', payload).then(response => {
          self.groupChartBulder(self);
        });
      }
      self.isMultiBoxVisible = !self.isMultiBoxVisible;
    },
    groupChartBulder(self) {
      const options = self._prep_GroupChart_option();
      var chartData = self.$store.getters.GET_ChartMultiData;
      var newseries = { name: '', data: [] };

      for (let i = 0; i < chartData[0].Category.length; i++) {
        options.xAxis.categories.push(chartData[0].Category[i].ItemGroup);
      }

      for (var i = 0; i < chartData.length; i++) {
        var arr = [];
        var limitSeriesArr = [];
        var preLimitSeriesArr = [];

        for (let x = 0; x < options.xAxis.categories.length; x++) {
          arr.push(null);
          preLimitSeriesArr.push(5000);
          limitSeriesArr.push(10000);
        }

        for (var j = 0; j < chartData[i].vd.length; j++) {
          for (let x = 0; x < options.xAxis.categories.length; x++) {
            var lol = options.xAxis.categories.indexOf(chartData[i].vd[j].ItemGroup);
            if (lol !== -1) {
              arr[lol] = chartData[i].vd[j].ItemVal;
            }
          }
        }
        options.series.push({
          name: chartData[i].SERIAL,
          data: arr,
        });
      }
      options.series.push({
        type: 'line',
        name: 'Lim',
        color: 'red',
        dashStyle: 'longdash',
        data: limitSeriesArr,
      });
      options.series.push({
        type: 'line',
        name: 'Pre-Lim',
        color: 'red',
        dashStyle: 'longdash',
        data: preLimitSeriesArr,
      });

      var chart = $('#containerChartHlMulti').highcharts(options);
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
  mounted() {
    EventBus.$on('MILTI_CHART_RISE', payload => {
      this.modalTogglerVM(payload);
    });
  },
};
</script>