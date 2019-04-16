<template>
  <div id="app">
    <img src="./assets/logo.png">
    <HelloWorld/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld';

export default {
  name: 'App',
  components: {
    HelloWorld
  }
};
</script>

<style>
@import './style/CorpStyle/CorpV2.css';
@import './style/CorpStyle/SGSRapidFramework.css';
@import './style/CorpStyle/jq_ui_1.8.6.css';
@import './style/MyExtStyle.css';
</style>
