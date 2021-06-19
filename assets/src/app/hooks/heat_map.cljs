(ns app.hooks.heat-map
  (:require [app.hooks.helpers :refer [plotly-instance]]))

(def Plotly (plotly-instance))

(defn parse-locations [hook]
  (let [locations (js/JSON.parse (.. hook -el -dataset -locations))]
    (clj->js [(->> locations (map #(get %1 1)))
              (->> locations (map #(get %1 2)))
              (->> locations (map #(js/Math.log (get %1 0))))])))

(deftype HeatMap []
  Object
  (mounted [this]
    (let [locations (parse-locations this)
          data (clj->js [{:lat (get locations 0)
                          :lon (get locations 1)
                          :z (get locations 2)
                          :type "densitymapbox"
                          :colorscale "Jet"
                          :radius 18
                          :hoverinfo "skip"
                          :showscale false}])
          layout (clj->js {:margin {:r 0 :t 0 :b 0 :l 0}
                           :showlegend false
                           :mapbox {:center {:lon 0 :lat 0}
                                    :style "stamen-terrain"}})
          config (clj->js {:responsive true
                           :displayModeBar false
                           :scrollZoom true})]
      (.newPlot Plotly "map" data layout config)))

  (updated [this]
    (let [locations (parse-locations this)
          lat (get locations 0)
          lon (get locations 1)
          z (get locations 2)
          params (clj->js {:lon [lon] :lat [lat] :z [z]})]
      (.restyle Plotly "map" params))))