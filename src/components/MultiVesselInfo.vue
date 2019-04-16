<template>
  <section>
    <div id="containerChartMulti">
      <div id="layer_bg" class="layer_bg" @Click="modalTogglerVM()" v-show="isFormActive"></div>
      <div v-show="isFormActive" class="modal_wrap_container">
        <div class="field-block_full">
          <h2 v-text="chartTitle"></h2>
          <div id="containerChartHlMulti" class="mt-5per"></div>
        </div>
        <!--.field-block_full -->
        <div class="closeContainer" @Click="modalTogglerVM()">
          <a id="closeIModal" class="close" href="#"></a>
        </div>
      </div>
    </div>
    <!-- #containerChartMulti -->
  </section>
</template>

<script>
export default {};
</script>

<style lang="scss" scoped>
</style>