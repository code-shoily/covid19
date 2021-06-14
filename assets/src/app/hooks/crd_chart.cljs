(ns app.hooks.crd-chart
  [:require [app.hooks.helpers :refer [plotly-instance make-chart]]])

(def Plotly (plotly-instance))

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
                                                :width 1.5}}])]
      (make-chart (str "new-" type "-chart") data-set-new)
      (make-chart (str "cumulative-" type "-chart") data-set-cumulative)))
  (updated [this]
    (let [logarithmic? (js/JSON.parse (.. this -el -dataset -logarithmic))
          type (.. this -el -dataset -type)
          layout (clj->js {:margin {:t 0 :b 30 :l 30 :r 10}
                           :showledgend false
                           :yaxis {:type (if (true? logarithmic?) "log" "linear")
                                   :autorange true}})]
      (.relayout Plotly (str "cumulative-" type "-chart") layout))))