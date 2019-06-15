<template>
  <section>
    <div v-if="isFieldLoading">
      <div class="noEdit"/>
      <lds-loader :external="'centered'"/>
    </div>
    <div class="field-container">
      <div class="field-row">
        <div class="field-block field-block_huge">
          <fld-input
            v-model="vesselInfo.Condition"
            :required="true"
            rus-desc="Статус"
            input-id="Condition"
          />
        </div>
        <!-- .field-block -->
        <div class="field-block">
          <fld-input
            v-model="vesselInfo.Serial"
            :required="true"
            rus-desc="Серийный номер"
            input-id="Serial"
          />
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->

      <div class="field-row">
        <div class="field-block">
          <date-picker
            v-model="vesselInfo.CommissioningDate"
            :required="true"
            rus-desc="Дата создания"
            input-id="CommissioningDate"
            date-format="dd/mm/yy"
            @update-date="updateDate($event)"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            v-model="vesselInfo.CertificationDate"
            rus-desc="Испытание в ЦСМ"
            date-format="dd/mm/yy"
            input-id="CertificationDate"
            @update-date="updateDate($event)"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <date-picker
            v-model="vesselInfo.LastCheckDate"
            rus-desc="Дата проверки"
            date-format="dd/mm/yy"
            input-id="LastCheckDate"
            @update-date="updateDate($event)"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <select-block
            v-model="vesselInfo.Location"
            :item-types="Locations"
            :required="true"
            rus-desc="Локация"
            select-id="Location"
          />
        </div>
        <!-- .field-block -->
      </div>
      <!-- .field-row -->

      <div class="field-row">
        <div class="field-block">
          <fld-input
            v-model="vesselInfo.Status"
            :is-readonly="true"
            rus-desc="Состояние"
            input-id="Status"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <fld-input
            v-model="vesselInfo.Score"
            :required="true"
            rus-desc="Оценка"
            input-id="Score"
          />
        </div>
        <!-- .field-block -->

        <div class="field-block">
          <div class="field-block__wrapper">
            <select-block
              v-model="vesselInfo.VesselType"
              :item-types="VesselTypes"
              :required="true"
              rus-desc="Тип сосуда"
              select-id="VesselType"
            />
          </div>
        </div>
        <!-- .field-block -->

        <div 
          v-if="!isFieldLoading" 
          class="field-block" >
          <template v-if="canIEditVessel==='true'">
            <div class="field-block__wrapper floatRContainer">
              <span 
                name="btnSaveContainer" 
                @click="saveAction()">
                <input 
                  id="save"
                  class="button"
                  type="button"
                  name="save"
                  value="Сохранить">
              </span>
            </div>
          </template>
          <template v-else>
            <div class="field-block__wrapper floatRContainer">
              <span name="btnSaveContainer">
                <span class="error">У вас нет прав на редактирование</span>
              </span>
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
import LDSLoaded from '../LDSLoaded';
export default {
    components: {
    'lds-loader': LDSLoaded,
  },
    computed: {
    vesselInfo() {
      // Default does not contain any value in field
      // TODO: Check with default(no) data - it can be smth bad there
      if ( typeof this.$store.getters.vesselInfo.Field !== 'undefined' ) {
        return this.$store.getters.vesselInfo.Field[0];
      } else {
        return {};
      }
    },
    Locations() {
      if ( typeof this.$store.getters.vesselInfo !== 'undefined' ) {
        return this.$store.getters.GET_DD_Locations;
      }
    },
    VesselTypes() {
      if ( typeof this.$store.getters.vesselInfo !== 'undefined' ) {
        return this.$store.getters.GET_DD_VesselTypes;
      }
    },
    canIEditVessel() {
      /* TODO: Fix it */
      return 'true';
    },
    isFieldLoading() {
      return this.$store.getters.isLoadingField;
    },
  },
  methods: {
    saveAction() {
      let _unid = this.$store.getters.getCurrentUnid;
      let _fldData = this.$store.getters.vesselInfo.Field[0];
      let _data = Object.assign( _fldData, {
        // PARAM2: 'SaveVessel',
        unid: _unid,
      } );
      //  console.log('TCL: saveAction -> _unid', _data);
      this.$store.dispatch( 'Field_Save', _data ).then( response => {
        this.$store.dispatch( 'MUTATION_TABLE_UPDATE_ROW', { unid: response, mode: 'udpRow' } );
      } );
    },
  },
};
</script>
