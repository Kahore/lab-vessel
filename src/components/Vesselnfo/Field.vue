<template>
  <section>
    <div class="field-container">
      <div class="field-row">
        <div class="field-block field-block_huge">
          <fld-input rus-desc="Статус" input-id="Condition" v-model="condition"/>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <fld-input rus-desc="Серийный номер" input-id="Serial" v-model="serial"/>
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->

      <div class="field-row">
        <div class="field-block">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Дата создания"
            input-id="CommissioningDate"
            v-model="commissioningDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Испытание в ЦСМ"
            input-id="CertificationDate"
            v-model="certificationDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Дата проверки"
            input-id="LastCheckDate"
            v-model="lastCheckDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <select-block
            rus-desc="Локация"
            select-id="Location"
            v-model="currentLocation"
            :item-types="locations"
          />
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->

      <div class="field-row">
        <div class="field-block">
          <fld-input rus-desc="Состояние" input-id="Status" v-model="status" readonly/>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <fld-input rus-desc="Оценка" input-id="Score" v-model="score"/>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <div class="FiCon">
            <select-block
              rus-desc="Тип сосуда"
              select-id="VesselType"
              v-model="currentVesselType"
              :item-types="vesselTypes"
            />
          </div>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <template v-if="canIEditVessel==='true'">
            <div class="FiCon floatRContainer">
              <span name="btnSaveContainer" @click="saveAction(id)" v-html="btn_save"></span>
            </div>
          </template>
          <template v-else-if="loading">
            <div class="FiCon">
              <span class="awaitWhenLoad">SomeText</span>
            </div>
          </template>
          <template v-else>
            <div class="FiCon floatRContainer">
              <span name="btnSaveContainer" v-html="btn_save"></span>
            </div>
          </template>
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->
    </div>
    <!-- .field-container -->
  </section>
</template>

<script>
export default {};
</script>
