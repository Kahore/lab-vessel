<template>
  <div class="v-snack v-snack--bottom" v-if="error">
    <div class="v-snack__wrapper error">
      <div class="v-snack__content">
        <p>{{error}}</p>
      </div>
      <div @click="closeError()" class="closeContainer">
        <a class="close" href="#"></a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error.vue',
  methods: {
    closeError() {
      this.$store.dispatch('CLEAR_ERROR');
    }
  },
  computed: {
    error() {
      return this.$store.getters.GET_ERROR;
    }
  }
};
</script>
