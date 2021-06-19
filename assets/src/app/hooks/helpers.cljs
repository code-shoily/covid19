(ns app.hooks.helpers
  (:require
   ["plotly.js/lib/core" :as Plotly]
   ["plotly.js/lib/bar" :as Bar]
   ["plotly.js/lib/densitymapbox" :as DensityMapBox]
   ["plotly.js/lib/pie" :as Pie]))

(.register Plotly #js [Bar DensityMapBox Pie])

(defn plotly-instance [] Plotly)
