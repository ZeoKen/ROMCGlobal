autoImport("NpcRefinePanel")
NpcRefineSubView = class("NpcRefineSubView", NpcRefinePanel)
NpcRefineSubView.ViewType = UIViewType.NormalLayer
autoImport("RefineIntegerCombineView")
NpcRefineSubView.BrotherView = RefineIntegerCombineView
NpcRefineSubView.RefineBordPath = "part/EquipRefineBordForSubView"
NpcRefineSubView.BatchRefineBordPath = "part/EquipBatchRefineBordForSubView"
NpcRefineSubView.isCombineSize = true
local TabName = {
  RefineTab = ZhString.NpcRefinePanel_RefineTabName,
  OneClickTab = ZhString.NpcRefinePanel_OneClickTabName
}
local npcRefineAction = "functional_action"
local blackSmith
local tempVector3 = LuaVector3()
local CHOOSECOLOR = LuaColor(0.3607843137254902, 0.3843137254901961, 0.5647058823529412, 1)
local UNCHOOSECOLOR = LuaColor.White()
