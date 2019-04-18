<template>
  <section>
    <div class="vessel-container" id="vesselContainer">
      <div class="vessel-container__chb">
        <input type="checkbox" id="checkbox" v-model="hideUtil" true-value="true" @click="load()">
        <label
          for="checkbox"
          title="Значение может быть задано через Мои настройки"
        >Скрыть утилизированные сосуды</label>
      </div>

      <div v-for="(vessel, index) in vessels" :key="index">
        <h3 v-text="vessel.Location"></h3>

        <div class="vessel-header">
          <div class="vessel-block">Серийный номер</div>
          <div class="vessel-block">Состояние</div>
          <div class="vessel-block">Дата ввода</div>
          <div class="vessel-block">Испытание в ЦСМ</div>
          <div class="vessel-block">Дата проверки</div>
          <div class="vessel-block">Оценка</div>
          <div class="vessel-block">Всего пожигов</div>
          <div class="vessel-block">С последней проверки</div>
          <div class="vessel-block">Обновлено</div>
          <div class="vessel-block">Последнее обновление</div>
        </div>

        <div v-for="(sub, index) in vessel.ConditionDetails" :key="index">
          <div
            v-text="sub.Condition"
            class="vessel-header vessel-header_line linkStrg"
            @click="clickOnCondition(sub.Condition, vessel.Location )"
          ></div>
          <div
            v-for="(vd, index) in sub.VesselDetails"
            class="vessel-block__row"
            :id="vd.ID"
            :key="index"
          >
            <div class="vessel-block linkStrg">
              <span @click="clickOnVessel(vd.ID)">{{vd.Serial}}</span>
            </div>

            <template v-if="vd.Status === 'Требуется проверка'">
              <div v-text="vd.Status" class="vessel-block errorMsg"></div>
            </template>

            <template v-else-if="vd.Status === 'Требуется испытание'">
              <div v-text="vd.Status" class="vessel-block errorMsg"></div>
            </template>

            <template v-else>
              <div v-text="vd.Status" class="vessel-block"></div>
            </template>

            <div
              v-text="vd.CommissioningDate"
              class="vessel-block"
              :class="vd.CommissioningDate === 'Нет данных' ? 'warning' : '' "
            ></div>
            <template v-if="vd.Status === 'Требуется испытание'">
              <div class="vessel-block">
                <div v-text="vd.CertificationDate" class="errorMsg"></div>
                <strong>
                  <div v-text="vd.CertificationCount"></div>
                </strong>
              </div>
            </template>
            <template v-else>
              <div class="vessel-block">
                <div
                  v-text="vd.CertificationDate"
                  :class="vd.CertificationDate === 'Нет данных' ? 'warning' : '' "
                ></div>
                <strong>
                  <div v-text="vd.CertificationCount"></div>
                </strong>
              </div>
            </template>

            <div
              v-text="vd.LastCheckDate"
              class="vessel-block"
              :class="vd.LastCheckDate === 'Нет данных' ? 'warning' : '' "
            ></div>

            <template v-if="vd.Score == 5">
              <div v-text="vd.Score" class="vessel-block ok"></div>
            </template>

            <template v-else-if="vd.Score == 4">
              <div v-text="vd.Score" class="vessel-block normal"></div>
            </template>

            <template v-else-if="vd.Score == 3">
              <div v-text="vd.Score" class="vessel-block warning"></div>
            </template>

            <template v-else-if="vd.Score == 2">
              <div v-text="vd.Score" class="vessel-block errorMsg"></div>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.CommissioningCount" class="vessel-block"></div>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.LastCheckCount" class="vessel-block"></div>
            </template>
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.LastChangedBy" class="vessel-block"></div>
            </template>

            <template v-if="vd.Status === 'Util'">
              <div v-text="vd.LastAutoCounterDate" class="vessel-block"></div>
            </template>
            <template v-else>
              <template v-if="vd.onAction==='true'">
                <div class="vessel-block">
                  <span class="awaitWhenLoad">SomeText</span>
                </div>
              </template>
              <template v-else>
                <div
                  v-text="vd.LastAutoCounterDate"
                  class="vessel-block linkUpd"
                  @click="VMUpdateInfoManually( vd.ID ,sub,vessel)"
                ></div>
              </template>
            </template>
          </div>
        </div>
      </div>
      <div class="awaitLoad" id="myAwaitLoad" v-show="loading">Some text</div>
    </div>
  </section>
</template>

<script>
import EventBus from '../../EventBus';
export default {
  methods: {
    loadVessel(orderId) {
      console.log('TCL: loadVessel -> orderId', orderId);
    }
  },
  computed: {
    loading() {
      return this.$store.getters.loadingVesselsTable;
    },
    vessels() {
      return this.$store.getters.GET_VESSELS_LIST;
    },
    hideUtil() {
      return this.$store.getters.GET_FILTER_HIDE;
    }
  },
  mounted() {
    EventBus.$on('LOAD_VESSEL_INFO', payload => {
      this.loadVessel(payload);
    });
  }
};
</script>
