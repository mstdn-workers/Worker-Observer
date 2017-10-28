const names = new Vue({
  el: '#app',
  data: {
    names: [],
  },
  mounted() {
    axios.get("http://localhost/api/names").then(response => {
      this.names = response.data;
    })
  }
});
