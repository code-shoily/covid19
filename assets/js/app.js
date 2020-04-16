import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

import UIkit from 'uikit'
import Icons from 'uikit/dist/js/uikit-icons'

import css from "../css/app.css"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket