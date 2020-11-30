import Plotly from "../plotly-custom";

import { makeChart } from "./helpers";

var colorMap = {
  confirmed: "#2980b9",
  deaths: "#e74c3c",
  recovered: "#27ae60",
};

export default {
  mounted() {
    let data = JSON.parse(this.el.dataset.statistics);
    let type = this.el.dataset.type;

    let datasetNew = [
      {
        x: data.map((x) => x[0]),
        y: data.map((y) => y[2]),
        type: "bar",
        marker: {
          line: {
            color: colorMap[type],
            width: 1.5,
          },
        },
      },
    ];

    makeChart(`new-${type}-chart`, datasetNew);

    let datasetCumulative = [
      {
        x: data.map((x) => x[0]),
        y: data.map((y) => y[1]),
        mode: "lines",
        line: {
          color: colorMap[type],
          width: 3,
        },
      },
    ];

    makeChart(`cumulative-${type}-chart`, datasetCumulative);
  },
  updated() {
    let isLogarithmic = JSON.parse(this.el.dataset.logarithmic);
    let type = this.el.dataset.type;

    var layout = {
      margin: { t: 0, b: 30, l: 30, r: 10 },
      showlegend: false,
      yaxis: {
        type: !!isLogarithmic ? "log" : "linear",
        autorange: true,
      },
    };

    Plotly.relayout(`cumulative-${type}-chart`, layout);
  },
};
