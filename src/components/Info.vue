<template>
  <div class="v-snack v-snack--top" v-if="info">
    <div class="v-snack__wrapper info">
      <div class="v-snack__content">
        <p>{{info}}</p>
      </div>
      <div @click="closeInfo()" class="closeContainer">
        <a class="close" href="#"></a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Info.vue',
  methods: {
    closeInfo() {
      this.$store.dispatch('CLEAR_INFO');
    }
  },
  computed: {
    info() {
      return this.$store.getters.GET_INFO;
    }
  }
};
</script>