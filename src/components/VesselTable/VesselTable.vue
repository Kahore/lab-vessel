<template>
  <section>
    <div
      id="vesselContainer"
      class="vessel-container" >
      <div class="vessel-container__chb">
        <input
          id="hideUtil"
          v-model="hideUtil"
          type="checkbox"
          true-value="true"
          false-value="false"
          @click="filterUtil(hideUtil)"
        >
        <label
          for="hideUtil"
          title="Значение может быть задано через Мои настройки"
        >Скрыть утилизированные сосуды</label>
      </div>
      <div
        v-if="isTableLoading"
        class="bar-wrapper" >
        <div class="bar"/>
        <p>Информация по сосудам загружается...</p>
      </div>
      <div 
        v-for="(vessel, index) in vessels"
        :key="index">
        <h3 v-text="vessel.Location"/>

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

        <div 
          v-for="(sub, index) in vessel.ConditionDetails"
          :key="index">
          <div
            class="vessel-header vessel-header_line link_string"
            @click="clickOnCondition(sub.Condition, vessel.Location )"
            v-text="sub.Condition" 
          />
          <div
            v-for="(vd, index) in sub.VesselDetails"
            :key="index"
            :id="vd.ID"
            class="vessel-block__row"
          >
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <span>{{ vd.Serial }}</span>
              </div>
            </template>
            <template v-else>
              <div class="vessel-block link_string">
                <span @click="clickOnVessel(vd.ID)">{{ vd.Serial }}</span>
              </div>
            </template>

            <template v-if="vd.Status === 'Требуется проверка'">
              <div 
                class="vessel-block errorMsg"
                v-text="vd.Status"/>
            </template>

            <template v-else-if="vd.Status === 'Требуется испытание'">
              <div
                class="vessel-block errorMsg"
                v-text="vd.Status"/>
            </template>

            <template v-else>
              <div
                class="vessel-block"
                v-text="vd.Status"/>
            </template>

            <div
              :class="vd.CommissioningDate === 'Нет данных' ? 'warning' : '' "
              class="vessel-block"
              v-text="vd.CommissioningDate"
            />
            <template v-if="vd.Status === 'Требуется испытание'">
              <div class="vessel-block">
                <div 
                  class="errorMsg" 
                  v-text="vd.CertificationDate"/>
                <strong>
                  <div v-text="vd.CertificationCount"/>
                </strong>
              </div>
            </template>
            <template v-else>
              <div class="vessel-block">
                <div
                  :class="vd.CertificationDate === 'Нет данных' ? 'warning' : '' "
                  v-text="vd.CertificationDate"
                />
                <strong>
                  <div v-text="vd.CertificationCount"/>
                </strong>
              </div>
            </template>

            <div
              :class="vd.LastCheckDate === 'Нет данных' ? 'warning' : '' "
              class="vessel-block"
              v-text="vd.LastCheckDate"
            />

            <template v-if="vd.Score == 5">
              <div 
                class="vessel-block ok"
                v-text="vd.Score"
              />
            </template>

            <template v-else-if="vd.Score == 4">
              <div 
                class="vessel-block normal"
                v-text="vd.Score" 
              />
            </template>

            <template v-else-if="vd.Score == 3">
              <div 
                class="vessel-block warning"
                v-text="vd.Score"/>
            </template>

            <template v-else-if="vd.Score == 2">
              <div
                class="vessel-block errorMsg"
                v-text="vd.Score"/>
            </template>
            <template v-else>
              <div
                class="vessel-block"
                v-text="vd.Score" />
            </template>
            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <lds-loader/>
              </div>
            </template>
            <template v-else>
              <div 
                class="vessel-block"
                v-text="vd.CommissioningCount"/>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vessel-block">
                <lds-loader/>
              </div>
            </template>
            <template v-else>
              <div 
                class="vessel-block" 
                v-text="vd.LastCheckCount" />
            </template>
            <template v-if="vd.onAction==='true'">
              <div 
                class="vessel-block">
                <lds-loader/>
              </div>
            </template>
            <template v-else>
              <div 
                class="vessel-block" 
                v-text="vd.LastChangedBy" />
            </template>

            <template v-if="vd.Status === 'Util'">
              <div 
                class="vessel-block" 
                v-text="vd.LastAutoCounterDate"/>
            </template>
            <template v-else>
              <template v-if="vd.onAction==='true'">
                <div class="vessel-block">
                  <lds-loader/>
                </div>
              </template>
              <template v-else>
                <div
                  class="vessel-block link_upd"
                  @click="VMUpdateInfoManually( vd.ID ,sub,vessel,index)"
                  v-text="vd.LastAutoCounterDate"
                />
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
import LDSLoaded from '../LDSLoaded';
export default {
  // data() {
  //   return {
  //     hideUtil: 'true',
  //   };
  // },
  components: {
    'lds-loader': LDSLoaded,
  },
  computed: {
    isTableLoading() {
      return this.$store.getters.isLoadingVesselsTable;
    },
    vessels() {
      return this.$store.getters.GET_VESSELS_LIST;
    },
    hideUtil: {
      get() {
        return this.$store.getters.GET_FILTER_HIDE;
      },
      set( value ) {
        this.$store.dispatch( 'MUTATE_FILTER_HIDE', value );
      },
    },
  },
  methods: {
    filterUtil( filterState ) {
      /* MEMO: set in computed prop not fineshed in this monent */
      let isFiltered;
      filterState === 'true' ? ( isFiltered = 'false' ) : ( isFiltered = 'true' );
      this.$store.dispatch( 'loadVessels', { hideMode: isFiltered } );
    },
    clickOnVessel( vesselId ) {
      EventBus.$emit( 'FIELD_RISE', { unid: vesselId } );
      //  console.log( "TCL: clickOnVessel -> EventBus.$emit('FIELD_RISE', vesselId);", vesselId );
    },
    clickOnCondition( condition, location ) {
      EventBus.$emit( 'MILTI_CHART_RISE', { condition: condition, location: location } );
    },
    VMUpdateInfoManually( id, sub, vessel, index ) {
     // console.log( 'TCL: VMUpdateInfoManually -> id,sub,vessel,index', id, sub, vessel, index);
      this.$store.dispatch( 'MUTATION_TABLE_UPDATE_COUNT', {
        unid: id,
        Condition: sub.Condition,
        Location: vessel.Location,
        index,
      } );
    },
  },
};
</script>
