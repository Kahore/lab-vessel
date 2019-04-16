<template>
  <section>
    <div class="vesselContainer" id="vesselContainer">
      <div class="chbContainer">
        <input type="checkbox" id="checkbox" v-model="hideUtil" true-value="true" @click="load">
        <label
          for="checkbox"
          title="Значение может быть задано через Мои настройки"
        >Скрыть утилизированные сосуды</label>
      </div>

      <div v-for="(vessel, index) in vessels" :key="index">
        <h3 v-text="vessel.Location"></h3>

        <div class="vesselHeader">
          <div class="vesselBlock">Серийный номер</div>
          <div class="vesselBlock">Состояние</div>
          <div class="vesselBlock">Дата ввода</div>
          <div class="vesselBlock">Испытание в ЦСМ</div>
          <div class="vesselBlock">Дата проверки</div>
          <div class="vesselBlock">Оценка</div>
          <div class="vesselBlock">Всего пожигов</div>
          <div class="vesselBlock">С последней проверки</div>
          <div class="vesselBlock">Обновлено</div>
          <div class="vesselBlock">Последнее обновление</div>
        </div>

        <div v-for="(sub, index) in vessel.ConditionDetails" :key="index">
          <div
            v-text="sub.Condition"
            class="vesselHeader vesselHeaderL linkStrg"
            @click="clickOnCondition(sub.Condition, vessel.Location )"
          ></div>
          <div
            v-for="(vd, index) in sub.VesselDetails"
            class="vesselBlockRow"
            :id="vd.ID"
            :key="index"
          >
            <div class="vesselBlock linkStrg">
              <span @click="clickOnVessel(vd.ID)">{{vd.Serial}}</span>
            </div>

            <template v-if="vd.Status === 'Требуется проверка'">
              <div v-text="vd.Status" class="vesselBlock errorMsg"></div>
            </template>

            <template v-else-if="vd.Status === 'Требуется испытание'">
              <div v-text="vd.Status" class="vesselBlock errorMsg"></div>
            </template>

            <template v-else>
              <div v-text="vd.Status" class="vesselBlock"></div>
            </template>

            <div
              v-text="vd.CommissioningDate"
              class="vesselBlock"
              :class="vd.CommissioningDate === 'Нет данных' ? 'warning' : '' "
            ></div>
            <template v-if="vd.Status === 'Требуется испытание'">
              <div class="vesselBlock">
                <div v-text="vd.CertificationDate" class="errorMsg"></div>
                <strong>
                  <div v-text="vd.CertificationCount"></div>
                </strong>
              </div>
            </template>
            <template v-else>
              <div class="vesselBlock">
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
              class="vesselBlock"
              :class="vd.LastCheckDate === 'Нет данных' ? 'warning' : '' "
            ></div>

            <template v-if="vd.Score == 5">
              <div v-text="vd.Score" class="vesselBlock ok"></div>
            </template>

            <template v-else-if="vd.Score == 4">
              <div v-text="vd.Score" class="vesselBlock normal"></div>
            </template>

            <template v-else-if="vd.Score == 3">
              <div v-text="vd.Score" class="vesselBlock warning"></div>
            </template>

            <template v-else-if="vd.Score == 2">
              <div v-text="vd.Score" class="vesselBlock errorMsg"></div>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vesselBlock">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.CommissioningCount" class="vesselBlock"></div>
            </template>

            <template v-if="vd.onAction==='true'">
              <div class="vesselBlock">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.LastCheckCount" class="vesselBlock"></div>
            </template>
            <template v-if="vd.onAction==='true'">
              <div class="vesselBlock">
                <span class="awaitWhenLoad">SomeText</span>
              </div>
            </template>
            <template v-else>
              <div v-text="vd.LastChangedBy" class="vesselBlock"></div>
            </template>

            <template v-if="vd.Status === 'Util'">
              <div v-text="vd.LastAutoCounterDate" class="vesselBlock"></div>
            </template>
            <template v-else>
              <template v-if="vd.onAction==='true'">
                <div class="vesselBlock">
                  <span class="awaitWhenLoad">SomeText</span>
                </div>
              </template>
              <template v-else>
                <div
                  v-text="vd.LastAutoCounterDate"
                  class="vesselBlock linkUpd"
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
export default {};
</script>