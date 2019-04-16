<template>
  <section>
    <div class="riContainer">
      <h2>История по сосуду</h2>
      <div class="historyContainer">
        <div class="historyTableHeaderRow">
          <div class="historyTable">Параметр</div>
          <div class="historyTable">Значение</div>
          <div class="historyTable">Изменения</div>
        </div>
        <!-- historyTableHeaderRow -->

        <!--  <div id="historyTableRowContainer" > -->
        <div>
          <!-- <div class="awaitLoad" id="myAwaitLoad" v-show="loading" > Some text </div> -->
          <div
            class="historyTableRow"
            :id="history.ID"
            v-for="history in histories"
            :key="history.ID"
          >
            <div class="historyTable">{{ history.Item }}</div>
            <div class="historyTable">{{ history.ItemVal }}</div>
            <div class="historyTable">
              <p>{{ history.CreatedBy }}</p>
              <p>{{ history.Created }}</p>
            </div>
          </div>
          <!-- historyTableRow -->
        </div>
      </div>
      <!-- historyContainer -->
    </div>
    <!-- riContainer -->
  </section>
</template>

<script>
export default {};
</script>
