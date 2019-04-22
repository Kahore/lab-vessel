<template>
  <section>
    <div class="history-block">
      <h2>История по сосуду</h2>
      <div class="history-container">
        <div class="history-table__header-row">
          <div class="history-table">Параметр</div>
          <div class="history-table">Значение</div>
          <div class="history-table">Изменения</div>
        </div>
        <!-- .history-table__header-row -->
        <div>
          <div
            class="history-table__row"
            :id="history.ID"
            v-for="history in histories"
            :key="history.ID"
          >
            <div class="history-table">{{ history.Item }}</div>
            <div class="history-table">{{ history.ItemVal }}</div>
            <div class="history-table">
              <p>{{ history.CreatedBy }}</p>
              <p>{{ history.Created }}</p>
            </div>
          </div>
          <!-- .history-table__row -->
        </div>
      </div>
      <!-- .history-container -->
    </div>
    <!-- .history-block -->
  </section>
</template>

<script>
export default {
  computed: {
    histories() {
      if (typeof this.$store.getters.vesselInfo !== 'undefined') {
        return this.$store.getters.vesselInfo.History;
      } else {
        return [];
      }
    },
  },
};
</script>
