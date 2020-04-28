import Plotly from 'plotly.js-dist'

export default {
    mounted() {
      var el = document.getElementById('death-recovered-chart');

      let data = JSON.parse(this.el.dataset.statistics)
      let dataset_deaths = {
        x: data.map(x => x.date),
        y: data.map(y => y.new_deaths),
        type: 'line',
        name: 'Deaths'
      }

      let dataset_recovered = {
        x: data.map(x => x.date),
        y: data.map(y => y.new_recovered),
        type: 'line',
        name: 'Recoveries'
      }

      let dataset = [dataset_deaths, dataset_recovered]
      
      let layout = {
        margin: { t: 0, b: 30, l: 30, r: 10 },
        showlegend: false
      }

      let config = {
        responsive: true,
        displayModeBar: false,
        scrollZoom: true
      }

      Plotly.newPlot(el, dataset, layout, config);
    }
}