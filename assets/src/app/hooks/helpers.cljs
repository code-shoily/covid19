(ns app.hooks.helpers
  [:require
   [clojure.string :as str]
   ["plotly.js/lib/core" :as Plotly]
   ["plotly.js/lib/bar" :as Bar]
   ["plotly.js/lib/densitymapbox" :as DensityMapBox]
   ["plotly.js/lib/pie" :as Pie]])

(.register Plotly #js [Bar DensityMapBox Pie])

(defn plotly-instance [] Plotly)

(defn with-k [number]
  (if (>= number 1000) (str (/ number 1000) "k") number))

(defn total [lst] (apply + lst))

(defn format-date
  [date-str]
  (let [[_ month day] (str/split date-str "-")]
    (str month "/" day)))

(defn make-chart [element data-set]
  (let [el (js/document.getElementById element)
        layout (clj->js {
                :margin { :t 0, :b 30, :l 30, :r 10 }
                :showlegend false
                :yaxis {
                        :type "linear"
                        :autorange true
                }
        })
        config (clj->js {
                         :responsive true
                         :displayModeBar false
                         :scrollZoom true
        })]
    (.newPlot Plotly el data-set layout config)))
