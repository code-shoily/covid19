import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"
import L from 'leaflet'
import HeatOverlay from 'leaflet-heatmap'

import css from "../css/app.scss"

// Hooks -----------------------------------------
let Hooks = {}

Hooks.LeafletMap = {
    initMap() {
        var map = L.map('map').setView([40, 0], 2)

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map)

        return map
    },
    mounted() {
        const locations = JSON.parse(this.el.dataset.locations)
        this.map = this.initMap()
        this.heatLayer = this.buildHeatLayer(this.map)
        this.addHeatLayer(locations)
    },
    updated() {
        const locations = JSON.parse(this.el.dataset.locations)
        this.heatLayer.remove()
        this.addHeatLayer(locations)
    },
    buildHeatLayer() {
        var cfg = {
            radius: 3,
            maxOpacity: .8,
            scaleRadius: true,
            useLocalExtrema: false,
            latField: 'latitude',
            lngField: 'longitude',
            valueField: 'count'
          }
        return new HeatOverlay(cfg)
    },
    addHeatLayer(locations) {
        this.heatLayer.setData({
            max: locations.length,
            data: locations
        });
        this.heatLayer.addTo(this.map)
    }
}
// /Hooks -----------------------------------------

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket