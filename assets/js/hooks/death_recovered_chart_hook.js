import Chartist from 'chartist'

import {withK, formatDate} from './helpers'

export default {
    mounted() {
        let deaths = JSON.parse(this.el.dataset.deaths)
        let recovered = JSON.parse(this.el.dataset.recovered)
        let dates = JSON.parse(this.el.dataset.dates)

        new Chartist.Line('#death-recovered-chart', {
            labels: dates,
            series: [
              deaths, recovered
            ]
          }, {
            fullWidth: true,
            low: 0,
            showArea: false,
            showPoint: false,
            height: 200,
            axisX: {
                showLabel: true,
                showGrid: true,
                labelInterpolationFnc: function(value, index) {
                    return index % 30 === 0 ? formatDate(value) : null
                }
              },
            axisY: {
                showLabel: true,
                showGrid: true,
                labelInterpolationFnc: function(value, index) {
                    return withK(value)
                }
            },
          });
    }
}