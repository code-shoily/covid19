(ns app.main
  [:require ["nprogress" :as nprogress]
            ["phoenix" :as phoenix]
            ["phoenix_live_view" :as LiveSocket]])

(def csrf-token (.getAttribute (js/document.querySelector "meta[name='csrf-token']") "content"))
(def live-socket-params
  #js {
    "params" #js {"_csrf_token" csrf-token}
    "hooks" #js {
      "HeatMap" nil
      "CRDChart" nil
      "CRDPieChart" nil
    }})

(set! 
  (.. js/window -liveSocket) 
  (LiveSocket/LiveSocket. "/live" phoenix/Socket live-socket-params))

(def live-socket (.. js/window -liveSocket))

(defn initialize []
    (js/window.addEventListener "phx:page-loading-start" (fn [_] (.start nprogress)))
    (js/window.addEventListener "phx:page-loading-stop" (fn [_] (.done nprogress))))

(defn main! []
  (initialize)
  (.connect live-socket))

(defn reload! [] (initialize))