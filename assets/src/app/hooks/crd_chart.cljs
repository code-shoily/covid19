(ns app.hooks.crd-chart
  [:require [app.hooks.helpers :refer [plotly-instance]]])

(def Plotly (plotly-instance))

(defn make-chart [element-id data-set]
  (let [el (js/document.getElementById element-id)
        layout (clj->js {:margin {:t 0 :b 30 :l 30 :r 10}
                         :showlegend false
                         :yaxis {:type "linear"
                                 :autorange true}})
        config (clj->js {:responsive true
                         :displayModeBar false
                         :scrollZoom true})]
    (.newPlot Plotly el data-set layout config)))

(deftype CRDChart []
  Object
  (mounted [this]
    (let [data (js/JSON.parse (.. this -el -dataset -statistics))
          type (.. this -el -dataset -type)
          color-map {"confirmed" "#2980b9"
                     "deaths" "#e74c3c"
                     "recovered" "#27ae60"}
          data-set-new (clj->js [{:x (->> data (map #(get %1 0)))
                                  :y (->> data (map #(get %1 2)))
                                  :type "bar"
                                  :marker {:line {:color (color-map type)
                                                  :width 1.5}}}])
          data-set-cumulative (clj->js [{:x (->> data (map #(get %1 0)))
                                         :y (->> data (map #(get %1 1)))
                                         :type "lines"
                                         :line {:color (color-map type)
                                                :width 1.5}}])
          new-id (str "new-" type "-chart")
          cumulative-id (str "cumulative-" type "-chart")]
      (make-chart new-id data-set-new)
      (make-chart cumulative-id data-set-cumulative)))

  (updated [this]
    (let [logarithmic? (js/JSON.parse (.. this -el -dataset -logarithmic))
          type (.. this -el -dataset -type)
          layout (clj->js {:margin {:t 0 :b 30 :l 30 :r 10}
                           :showledgend false
                           :yaxis {:type (if (true? logarithmic?) "log" "linear")
                                   :autorange true}})]
      (.relayout Plotly (str "cumulative-" type "-chart") layout))))