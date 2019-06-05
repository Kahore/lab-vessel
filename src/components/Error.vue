<template>
  <div
    v-if="error"
    class="v-snack v-snack--bottom" 
  >
    <div class="v-snack__wrapper error">
      <div class="v-snack__content">
        <p>{{ error }}</p>
      </div>
      <div
        class="closeContainer"
        @click="closeError()" >
        <a 
          class="close" 
          href="#"/>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ErrorMsg',
  computed: {
    error() {
      return this.$store.getters.GET_ERROR;
    }
  },
  methods: {
    closeError() {
      this.$store.dispatch( 'CLEAR_ERROR' );
    }
  },
};
</script>
