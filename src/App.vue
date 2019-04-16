<template>
  <div id="container" class="container">
    <div id="center">
      <div id="content">
        <span id="ctl00_Content_ctl00_PageText">
          <vessel-info/>
          <vessel-table></vessel-table>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import VesselInfo from './components/VesselInfo/VesselInfo';
import VesselTable from './components/VesselTable/VesselTable';

export default {
  name: 'VesselMonitoring',
  components: {
    'vessel-info': VesselInfo,
    'vessel-table': VesselTable
  }
};
</script>

<style>
@import './style/CorpStyle/CorpV2.css';
@import './style/CorpStyle/SGSRapidFramework.css';
@import './style/CorpStyle/jq_ui_1.8.6.css';
@import './style/MyExtStyle.css';
</style>
