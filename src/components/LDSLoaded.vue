<template>
  <div 
    :class="external"
    class="lds-ring">
    <div/>
    <div/>
    <div/>
    <div/>
  </div>
</template>

<script>
export default {
  props: {
    external: {
      type: String,
      default: 'list-ring'
    }
  }
  //  name: 'rowLoader',
};
</script>
