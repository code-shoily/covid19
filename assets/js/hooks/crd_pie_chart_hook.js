import Plotly from 'plotly.js-dist'
import { makeChart } from './helpers';

export default {
    newCases: [],
    recoveries: [],
    deaths: [],
    mounted() {
      let data = JSON.parse(this.el.dataset.statistics);

      var layout = {
        margin: { t: 0, b: 30, l: 30, r: 10 },
        showlegend: false,
      };

      var config = config || {
        responsive: true,
        displayModeBar: false,
        scrollZoom: true
      }

      this.newCases.push({
        values: [data.new_active, data.new_confirmed, data.new_deaths, data.new_recovered],
        labels: ["Active", "Confirmed", "Deaths", "Recovered"],
        type: 'pie',
        textinfo: 'label+percent',
        hole: 0.4,
      });

      Plotly.newPlot('new-pie-chart', this.newCases, layout, config);

      this.recoveries.push({
        values: [data.active, data.confirmed, data.deaths, data.recovered],
        labels: ["Active", "Confirmed", "Deaths", "Recovered"],
        type: 'pie',
        textinfo: 'label+percent',
        hole: 0.4,
      });

      Plotly.newPlot('total-pie-chart', this.recoveries, layout, config);
    },
    updated() {
      let data = JSON.parse(this.el.dataset.statistics);
      
      var update = {
        values: [[data.new_active, data.new_confirmed, data.new_deaths, data.new_recovered]]
      }
      Plotly.restyle('new-pie-chart', update)

      var update = {
        values: [[data.active, data.confirmed, data.deaths, data.recovered]]
      }
      Plotly.restyle('total-pie-chart', update)
    }
}