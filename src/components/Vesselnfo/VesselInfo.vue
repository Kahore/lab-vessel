<template>
  <section>
    <info-field></info-field>
    <info-chart></info-chart>
    <info-history></info-history>
  </section>
</template>

<script>
import Field from './Field';
import Chart from './Chart';
import History from './History';

export default {
  name: 'VesselInfo',
  components: {
    'info-field': Field,
    'info-chart': Chart,
    'info-history': History
  }
};
</script>
