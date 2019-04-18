<template>
  <section>
    <div id="wrapper">
      <span class="linkUpd" @Click="modalTogglerVM()">Добавить сосуд</span>
      <div id="layer_bg" class="layer_bg" @Click="modalTogglerVM()" v-show="isFormActive"></div>
      <div v-show="isFormActive" class="modal_wrap_container">
        <div id="createTable" class="field-table">
          <info-field></info-field>
          <info-chart></info-chart>
        </div>
        <!-- .field-table -->
        <info-history></info-history>
        <div @click="modalTogglerVM()" class="closeContainer">
          <a id="closeIModal" class="close" href="#"></a>
        </div>
      </div>
      <!-- .modal_wrap_container -->
    </div>
    <!-- #wrapper -->
  </section>
</template>

<script>
import EventBus from '../../../EventBus';

import Field from './Field';
import Chart from './Chart';
import History from './History';

export default {
  name: 'VesselInfo',
  components: {
    'info-field': Field,
    'info-chart': Chart,
    'info-history': History
  },
  mounted() {
    let _unid = this.$store.getters.getCurrentUnid;
    EventBus.$emit('LOAD_VESSEL_INFO', _unid);
  }
};
</script>
