import L from 'leaflet'
import HeatOverlay from 'leaflet-heatmap'

const cfg = {
    radius: 4,
    maxOpacity: .8,
    scaleRadius: true,
    useLocalExtrema: false,
    latField: 'latitude',
    lngField: 'longitude',
    valueField: 'count'
  }

export default {
    initMap() {
        var map = L.map('map').setView([40, 0], 2)

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map)

        return map
    },
    mounted() {
        let locations = this.parseLocations()
        this.map = this.initMap()
        this.heatLayer = new HeatOverlay(cfg)
        this.updateHeatLayer(locations, true)
    },
    updated() {
        let locations = this.parseLocations()
        this.updateHeatLayer(locations, false)
    },
    updateHeatLayer(locations, create) {
        this.heatLayer.setData({max: 100, data: locations});
        create ? this.heatLayer.addTo(this.map) : null
    },
    parseLocations() {
        return JSON.parse(this.el.dataset.locations)
            .map(([count, latitude, longitude]) => ({count, latitude, longitude}))
    }
}
