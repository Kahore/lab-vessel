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
      <div class="bar-wrapper" v-if="isTableLoading">
        <div class="bar"></div>
        <p>Информация по сосудам загружается...</p>
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
            class="vessel-header vessel-header_line link_string"
            @click="clickOnCondition(sub.Condition, vessel.Location )"
          ></div>
          <div
            v-for="(vd, index) in sub.VesselDetails"
            class="vessel-block__row"
            :id="vd.ID"
            :key="index"
          >
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <span>{{vd.Serial}}</span>
              </div>
            </template>
            <template v-else>
              <div class="vessel-block link_string">
                <span @click="clickOnVessel(vd.ID)">{{vd.Serial}}</span>
              </div>
            </template>

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
            <template v-else>
              <div v-text="vd.Score" class="vessel-block"></div>
            </template>
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <row-loader/>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.CommissioningCount" class="vessel-block"></div>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <row-loader/>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.LastCheckCount" class="vessel-block"></div>
            </template>
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <row-loader/>
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
                  <row-loader/>
                </div>
              </template>
              <template v-else>
                <div
                  v-text="vd.LastAutoCounterDate"
                  class="vessel-block link_upd"
                  @click="VMUpdateInfoManually( vd.ID ,sub,vessel,index)"
                ></div>
              </template>
            </template>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import EventBus from '../../EventBus';
import LDSLoaded from './VesselTableRowLoader';
export default {
  components: {
    'row-loader': LDSLoaded,
  },
  methods: {
    clickOnVessel(vesselId) {
      EventBus.$emit('FIELD_RISE', { unid: vesselId });
      console.log("TCL: clickOnVessel -> EventBus.$emit('FIELD_RISE', vesselId);", vesselId);
    },
    clickOnCondition(condition, location) {
      EventBus.$emit('MILTI_CHART_RISE', { condition: condition, location: location });
    },
    VMUpdateInfoManually(id, sub, vessel, index) {
      console.log('TCL: VMUpdateInfoManually -> id,sub,vessel,index', id, sub, vessel, index);
      this.$store.dispatch('MUTATION_TABLE_UPDATE_COUNT', {
        unid: id,
        Condition: sub.Condition,
        Location: vessel.Location,
        index,
      });
    },
  },
  computed: {
    isTableLoading() {
      return this.$store.getters.isLoadingVesselsTable;
    },
    vessels() {
      return this.$store.getters.GET_VESSELS_LIST;
    },
    hideUtil() {
      return this.$store.getters.GET_FILTER_HIDE;
    },
  },
};
</script>
