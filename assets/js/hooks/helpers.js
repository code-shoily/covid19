import Plotly from 'plotly.js-dist'

export function formatDate(dateStr) {
  const [year, month, day] = dateStr.split("-")
  return parseInt(month).toString() + "/" + day
}

export function withK(number) {
  if (number >= 1000) {
    return (number / 1000).toString() + "k"
  } else {
    return number
  }
}

export function makeChart(elementID, dataset, layout, config) {
  var el = document.getElementById(elementID);

  layout = layout || {
    margin: { t: 0, b: 30, l: 30, r: 10 },
    showlegend: false,
    yaxis: {
      type: 'linear',
      autorange: true
    }
  }

  config = config || {
    responsive: true,
    displayModeBar: false,
    scrollZoom: true
  }

  Plotly.newPlot(el, dataset, layout, config);
}

function total(list) {
  return list.reduce((a, b) => a + b, 0);
}