<template>
  <section>
    <div class="field-container">
      <div class="field-row">
        <div class="field-block field-block_huge">
          <fld-input rus-desc="Статус" input-id="Condition" v-model="vesselInfo.Condition"/>
        </div>
        <!-- .field-block -->
        <div class="field-block">
          <fld-input rus-desc="Серийный номер" input-id="Serial" v-model="vesselInfo.Serial"/>
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
            v-model="vesselInfo.CommissioningDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Испытание в ЦСМ"
            input-id="CertificationDate"
            v-model="vesselInfo.CertificationDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            @update-date="updateDate($event)"
            date-format="dd/mm/yy"
            rus-desc="Дата проверки"
            input-id="LastCheckDate"
            v-model="vesselInfo.LastCheckDate"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <select-block
            rus-desc="Локация"
            select-id="Location"
            v-model="vesselInfo.Location"
            :item-types="Locations"
            :isRequired="true"
          />
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->

      <div class="field-row">
        <div class="field-block">
          <fld-input rus-desc="Состояние" input-id="Status" v-model="vesselInfo.Status" readonly/>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <fld-input rus-desc="Оценка" input-id="Score" v-model="vesselInfo.Score"/>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <div class="FiCon">
            <select-block
              rus-desc="Тип сосуда"
              select-id="VesselType"
              v-model="vesselInfo.VesselType"
              :item-types="VesselTypes"
              :isRequired="true"
            />
          </div>
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <template v-if="canIEditVessel==='true'">
            <div class="FiCon floatRContainer">
              <span name="btnSaveContainer" @click="saveAction()" v-html="vesselInfo.Btn_save"></span>
            </div>
          </template>
          <template v-else>
            <div class="FiCon floatRContainer">
              <span name="btnSaveContainer" v-html="vesselInfo.Btn_save"></span>
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
export default {
  methods: {
    saveAction() {
      let _unid = this.$store.getters.getCurrentUnid;
      console.log('TCL: saveAction -> _unid', _unid);
    }
  },
  computed: {
    vesselInfo() {
      if (typeof this.$store.getters.vesselInfo !== 'undefined') {
        return this.$store.getters.vesselInfo;
      } else {
        return {};
      }
    },
    Locations() {
      if (typeof this.$store.getters.vesselInfo !== 'undefined') {
        return this.$store.getters.GET_DD_Locations;
      }
    },
    VesselTypes() {
      if (typeof this.$store.getters.vesselInfo !== 'undefined') {
        return this.$store.getters.GET_DD_VesselTypes;
      }
    },
    canIEditVessel() {
      /* TODO: Fix it */
      return true;
    }
  }
};
</script>
