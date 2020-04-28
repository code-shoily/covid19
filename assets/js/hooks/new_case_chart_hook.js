import Plotly from 'plotly.js-dist'

export default {
    mounted() {
      var el = document.getElementById('new-case-chart');

      let data = JSON.parse(this.el.dataset.statistics)
      let dataset = [{
        x: data.map(x => x.date),
        y: data.map(y => y.new_confirmed),
        type: 'line',
      }]

      let layout = {
        margin: { t: 0, b: 30, l: 30, r: 10 } 
      }

      let config = {
        responsive: true,
        displayModeBar: false,
        scrollZoom: true
      }

      Plotly.newPlot(el, dataset, layout, config);
    }
}