import Chartist from 'chartist'

import {withK, formatDate} from './helpers'

export default {
    mounted() {
        let statistics = JSON.parse(this.el.dataset.statistics)
        let deaths = statistics.map(s => s.new_deaths)
        let recovered = statistics.map(s => s.new_recovered)
        let dates = statistics.map(s => s.date)

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