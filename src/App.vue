<template>
  <div id="container" class="container">
    <div id="center">
      <div id="content">
        <span id="ctl00_Content_ctl00_PageText">
          <vessel-info></vessel-info>
          <vessel-single-info/>
          <vessel-multi-info></vessel-multi-info>
          <vessel-table></vessel-table>
          <vessel-error></vessel-error>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import VesselInfo from './components/VesselInfo/VesselInfo';
import VesselMultiInfo from './components/MultiVesselInfo';
import VesselTable from './components/VesselTable/VesselTable';

import Error from './components/Error';
import Info from './components/Info';
export default {
  name: 'VesselMonitoring',
  components: {
    'vessel-single-info': VesselInfo,
    'vessel-multi-info': VesselMultiInfo,
    'vessel-table': VesselTable,
    'vessel-error': Error,
    'vessel-info': Info
  }
};
</script>

<style>
@import './style/CorpStyle/CorpV2.css';
@import './style/CorpStyle/SGSRapidFramework.css';
@import './style/CorpStyle/jq_ui_1.8.6.css';
@import './style/MyExtStyle.css';
</style>
