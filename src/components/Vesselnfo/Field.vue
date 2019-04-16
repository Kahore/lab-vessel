<template>
  <section>
    <div class="fieldContainer">
      <div class="fieldRow">
        <div class="fieldBlock fieldBlock_Huge">
          <fld-input rus-desc="Статус" input-id="Condition" v-model="condition"/>
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <fld-input rus-desc="Серийный номер" input-id="Serial" v-model="serial"/>
        </div>
        <!--fieldBlock -->
      </div>
      <!--fieldRow -->

      <div class="fieldRow">
        <div class="fieldBlock">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Дата создания"
            input-id="CommissioningDate"
            v-model="commissioningDate"
          />
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Испытание в ЦСМ"
            input-id="CertificationDate"
            v-model="certificationDate"
          />
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Дата проверки"
            input-id="LastCheckDate"
            v-model="lastCheckDate"
          />
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <select-block
            rus-desc="Локация"
            select-id="Location"
            v-model="currentLocation"
            :item-types="locations"
          />
        </div>
        <!--fieldBlock -->
      </div>
      <!--fieldRow -->

      <div class="fieldRow">
        <div class="fieldBlock">
          <fld-input rus-desc="Состояние" input-id="Status" v-model="status" readonly/>
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <fld-input rus-desc="Оценка" input-id="Score" v-model="score"/>
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
          <div class="FiCon">
            <select-block
              rus-desc="Тип сосуда"
              select-id="VesselType"
              v-model="currentVesselType"
              :item-types="vesselTypes"
            />
          </div>
        </div>
        <!--fieldBlock -->

        <div class="fieldBlock">
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
        <!--fieldBlock -->
      </div>
      <!--fieldRow -->
    </div>
    <!--fieldContainer -->
  </section>
</template>

<script>
export default {};
</script>
