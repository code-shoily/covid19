import Chartist from 'chartist'
import {withK, formatDate} from './helpers'

export default {
    mounted() {
        let statistics = JSON.parse(this.el.dataset.statistics)

        let newCases = statistics.map(data => data.new_confirmed)
        let dates = statistics.map(data => data.date)

        new Chartist.Line('#new-case-chart', {
            labels: dates,
            series: [
              newCases
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