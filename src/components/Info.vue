<template>
  <div
    v-if="info"
    class="v-snack v-snack--top" 
  >
    <div class="v-snack__wrapper info">
      <div class="v-snack__content">
        <p>{{ info }}</p>
      </div>
      <div 
        class="closeContainer"
        @click="closeInfo()" >
        <a
          class="close"
          href="#"/>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Info',
    computed: {
    info() {
      return this.$store.getters.GET_INFO;
    }
  },
  methods: {
    closeInfo() {
      this.$store.dispatch( 'CLEAR_INFO' );
    }
  },
};
</script>