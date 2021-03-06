(ns app.hooks.crd-pie-chart
  (:require [app.hooks.helpers :refer [plotly-instance]]))

(def Plotly (plotly-instance))

(defn parse-statistics [hook] (js->clj (js/JSON.parse (.. hook -el -dataset -statistics))))

(deftype CRDPieChart []
  Object
  (mounted [this]
    (let [data (parse-statistics this)
          colors ["#f1c40f" "#e74c3c" "#27ae60"]
          layout (clj->js {:margin {:t 0 :b 30 :l 30 :r 10}
                           :showlegend true})
          config (clj->js {:responsive true
                           :displayModeBar false
                           :scrollZoom true})
          chart-config {:hoverinfo "percent+value"
                        :labels ["Active" "Deaths" "Recovered"]
                        :type "pie"
                        :textinfo "none"
                        :hole 0.4
                        :marker {:colors colors}}
          new-values {:values [(data "new_active")
                               (data "new_deaths")
                               (data "new_recovered")]}
          total-values {:values [(data "active")
                                 (data "deaths")
                                 (data "recovered")]}
          new (clj->js [(merge new-values chart-config)])
          total (clj->js [(merge total-values chart-config)])]
      (.newPlot Plotly "new-pie-chart" new layout config)
      (.newPlot Plotly "total-pie-chart" total layout config)))

  (updated [this]
    (let [data (parse-statistics this)
          new-values (clj->js {:values [[(data "new_active")
                                         (data "new_deaths")
                                         (data "new_recovered")]]})
          total-values (clj->js {:values [[(data "active")
                                           (data "deaths")
                                           (data "recovered")]]})]
      (.restyle Plotly "new-pie-chart" new-values)
      (.restyle Plotly "total-pie-chart" total-values))))