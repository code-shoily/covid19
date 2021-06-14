(ns app.hooks.crd-pie-chart
  [:require [app.hooks.helpers :refer [plotly-instance]]])


(def Plotly (plotly-instance))

(deftype CRDPieChart []
  Object
  (mounted [this]
    (let [data (js->clj (js/JSON.parse (.. this -el -dataset -statistics)))
          colors ["#f1c40f" "#2980b9" "#e74c3c" "#27ae60"]
          layout (clj->js {:margin {:t 0 :b 30 :l 30 :r 10}
                           :showlegend true})
          config (clj->js {:responsive true
                           :displayModeBar false
                           :scrollZoom true})
          chart-config {:hoverinfo "percent+value"
                        :labels ["Active", "Confirmed", "Deaths", "Recovered"]
                        :type "pie"
                        :textinfo "none"
                        :hole 0.4
                        :marker {:colors colors}}
          new-values {:values [(data "new_active")
                               (data "new_confirmed")
                               (data "new_deaths")
                               (data "new_recovered")]}
          total-values {:values [(data "active")
                                 (data "confirmed")
                                 (data "deaths")
                                 (data "recovered")]}
          new (clj->js [(merge new-values chart-config)])
          total (clj->js [(merge total-values chart-config)])]
      (.newPlot Plotly "new-pie-chart" new layout config)
      (.newPlot Plotly "total-pie-chart" total layout config)))
  (updated [this]
    (let [data (js->clj (js/JSON.parse (.. this -el -dataset -statistics)))
          new-values (clj->js {:values [[(data "new_active")
                                         (data "new_confirmed")
                                         (data "new_deaths")
                                         (data "new_recovered")]]})
          total-values (clj->js {:values [[(data "active")
                                           (data "confirmed")
                                           (data "deaths")
                                           (data "recovered")]]})]
      (.restyle Plotly "new-pie-chart" new-values)
      (.restyle Plotly "total-pie-chart" total-values))))