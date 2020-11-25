import LeafletMapHook from './leaflet_map_hook'
import CaseChartHook from './case_chart_hook'
import DeathChartHook from './death_chart_hook'
import RecoveredChartHook from './recovered_chart_hook'
import PieChartHook from './pie_chart_hook'

export default {
    LeafletMap: LeafletMapHook,
    CaseChart: CaseChartHook,
    DeathChart: DeathChartHook,
    RecoveredChart: RecoveredChartHook,
    PieChart: PieChartHook
}