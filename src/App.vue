<template>
  <div id="container" class="container">
    <div id="center">
      <div id="content">
        <span id="ctl00_Content_ctl00_PageText">
          <vessel-use-info></vessel-use-info>
          <br>
          <app-info></app-info>
          <vessel-single-info/>
          <vessel-multi-info></vessel-multi-info>
          <vessel-table></vessel-table>
          <app-error></app-error>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import UseInfo from './components/HowToUse';
import VesselInfo from './components/VesselInfo/VesselInfo';
import VesselMultiInfo from './components/MultiVesselInfo';
import VesselTable from './components/VesselTable/VesselTable';

import Error from './components/Error';
import Info from './components/Info';
export default {
  name: 'VesselMonitoring',
  components: {
    'vessel-use-info': UseInfo,
    'vessel-single-info': VesselInfo,
    'vessel-multi-info': VesselMultiInfo,
    'vessel-table': VesselTable,
    'app-error': Error,
    'app-info': Info,
  },
  created() {
    let unid = this.$store.getters.getCurrentUnid;
    this.$store.dispatch('loadVessels', { unid: unid });
  },
};
</script>

<style>
@import './style/CorpStyle/CorpV2.css';
@import './style/CorpStyle/SGSRapidFramework.css';
@import './style/CorpStyle/jq_ui_1.8.6.css';
@import './style/MyExtStyle.css';
</style>
