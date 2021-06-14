(ns app.main
  [:require
   ["nprogress" :as nprogress]
   ["phoenix" :refer [Socket]]
   ["phoenix_live_view" :refer [LiveSocket]]
   [app.hooks.heat-map :refer [HeatMap]]
   [app.hooks.crd-chart :refer [CRDChart]]
   [app.hooks.crd-pie-chart :refer [CRDPieChart]]])

(def csrf-token (-> "meta[name='csrf-token']"
                    (js/document.querySelector)
                    (.getAttribute "content")))

(def live-socket-params
  (clj->js {"params" {"_csrf_token" csrf-token}
            "hooks" {"HeatMap" (HeatMap.)
                     "CRDChart" (CRDChart.)
                     "CRDPieChart" (CRDPieChart.)}}))

(set!
 (.. js/window -liveSocket)
 (LiveSocket. "/live" Socket live-socket-params))

(def live-socket (.. js/window -liveSocket))

(defn init-progress-bar []
  (js/window.addEventListener "phx:page-loading-start" (fn [_] (.start nprogress)))
  (js/window.addEventListener "phx:page-loading-stop" (fn [_] (.done nprogress))))

(defn main! []
  (init-progress-bar)
  (.connect live-socket))

(defn reload! []
  (init-progress-bar)
  (.connect live-socket))