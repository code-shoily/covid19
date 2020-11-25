import Plotly from 'plotly.js-dist'

import { makeChart } from './helpers';

export default {
    datasetNew: [],
    datasetCumulative: [],
    mounted() {
      let data = JSON.parse(this.el.dataset.statistics);

      this.datasetNew.push({
        x: data.map(x => x.date),
        y: data.map(y => y.new_recovered).filter(y => y > 0),
        type: 'bar',
        marker: {
          line: {
            color: 'lightgreen',
            width: 1.5
          }
        }
      });

      makeChart('new-recovered-chart', this.datasetNew);

      this.datasetCumulative.push({
        x: data.map(x => x.date),
        y: data.map(y => y.recovered).filter(y => y > 0),
        mode: 'lines',
        line: {
          color: 'lightgreen',
          width: 3
        }
      });

      makeChart('cumulative-recovered-chart', this.datasetCumulative);
    },
    updated() {
      let isLog = JSON.parse(this.el.dataset.log);

      var layout = {
        margin: { t: 0, b: 30, l: 30, r: 10 },
        showlegend: false,
        yaxis: {
          type: !!isLog ? 'log' : 'linear',
          autorange: true
        }
      };

      Plotly.relayout('cumulative-recovered-chart', layout);
    }
}