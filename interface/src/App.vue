<template>
  <div id="app">
    <Demo/>
  </div>
</template>

<script>
import Demo from './components/Demo.vue'

export default {
  name: 'App',
  components: {
    Demo
  }
}
</script>

<style>

  html, body {
    padding: 0;
    margin: 0;
    background-color: #202527;
  }

  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    background-color: #202527;
    color: white;
  }

  /*button {*/
  /*  background-color: red !important;*/
  /*}*/


  button.outline {
    border-radius: 0.5rem;
    background-color: transparent;
    font-size: 1rem;
    padding: .5rem 3rem;
    color: white;
    border: solid 1px transparent;
    background-image: linear-gradient(rgba(0, 240, 255, 0), rgba(255, 28, 247, 0)), linear-gradient(90deg, #00F0FF, #FF1CF7);
    background-origin: border-box;
    background-clip: content-box, border-box;
    box-shadow: 2px 1000px 1px #202527 inset;
    transition: 1s;
    font-weight: bolder;
  }

  button.outline:hover {
    box-shadow: 2px 1000px 1px #20252700 inset;
    transition: 1s;
  }

  input {
    background-color: #202527 !important;
    color: white !important;
  }

  a {
    color: #00F0FF !important;
    text-decoration: none !important;
  }

  .modal-content {
    background-color: #202527 !important;
    color: white !important;
  }

  .popover-header::before {
    display: none !important;
  }

  .popover, .popover-header {
    background-color: #263238 !important;
    border-color: #636363 !important;
    border-width: 1px !important;
  }

  .popover * {
    color: white !important;
  }

  button.close {
    background-color: transparent;
    border: 1px solid white;
    border-radius: 100%;
    padding: 0 8px 2px 8px;
    color: white;
  }

  .gradient-text {
    background: linear-gradient(90deg, #00F0FF, #FF1CF7);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

</style>
