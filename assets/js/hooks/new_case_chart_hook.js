import Chartist from 'chartist'

import {withK, formatDate} from './helpers'

export default {
    mounted() {
        let newCases = JSON.parse(this.el.dataset.newCases)
        let dates = JSON.parse(this.el.dataset.dates)

        new Chartist.Line('#new-case-chart', {
            labels: dates,
            series: [
              newCases
              //newCases.map((data) => Math.log(data))
            ]
          }, {
            fullWidth: true,
            low: 0,
            showArea: true,
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