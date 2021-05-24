import Plotly from "../plotly-custom";

const dataConfig = {
  type: "densitymapbox",
  colorscale: "Jet",
  radius: 18,
  hoverinfo: "skip",
  showscale: false,
};

const layout = {
  margin: { r: 0, t: 0, b: 0, l: 0 },
  showlegend: false,
  mapbox: { center: { lon: 0, lat: 30 }, style: "stamen-terrain" },
};

const domID = "map";

const config = {
  responsive: true,
  displayModeBar: false,
  scrollZoom: true,
};

const HeatMap = {
  mounted() {
    const locations = this.parseLocations();
    const data = [
      { lat: locations[0], lon: locations[1], z: locations[2], ...dataConfig },
    ];
    Plotly.newPlot(domID, data, layout, config);
  },
  updated() {
    const locations = this.parseLocations();
    const lat = locations[0],
      lon = locations[1],
      z = locations[2];
    Plotly.restyle(domID, { lon: [lon], lat: [lat], z: [z] });
  },
  parseLocations() {
    const locations = JSON.parse(this.el.dataset.locations);
    return [
      locations.map((d) => d[1]),
      locations.map((d) => d[2]),
      locations.map((d) => Math.log(d[0])),
    ];
  },
};

export { HeatMap }
