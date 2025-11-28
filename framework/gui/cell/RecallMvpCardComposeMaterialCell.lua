autoImport("MvpCardComposeMaterialCell")
RecallMvpCardComposeMaterialCell = class("RecallMvpCardComposeMaterialCell", MvpCardComposeMaterialCell)

function RecallMvpCardComposeMaterialCell:Init()
  local obj = self:LoadPreferb("cell/ActivityBattlePassItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  CardMakeMaterialCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("UI_Lottery"), "mall_twistedegg_bg_09")
end
