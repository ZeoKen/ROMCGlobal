HighRefineAdditionPreviewCell = class("HighRefineAdditionPreviewCell", ItemCell)

function HighRefineAdditionPreviewCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaVector3.Zero()
  HighRefineAdditionPreviewCell.super.Init(self)
  self:FindObjs()
end

function HighRefineAdditionPreviewCell:FindObjs()
  self.addition = self:FindComponent("Addition", UILabel)
end

function HighRefineAdditionPreviewCell:SetData(data)
  HighRefineAdditionPreviewCell.super.SetData(self, data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local siteConfig = GameConfig.EquipType[data.equipInfo.equipData.EquipType]
  local effectMap = BlackSmithProxy.Instance:GetMyHRefineEffectMap(siteConfig and siteConfig.site[1], data.equipInfo.refinelv)
  local refine, mRefine
  for proKey, proValue in pairs(effectMap) do
    if proKey == "Refine" then
      refine = proValue
    elseif proKey == "MRefine" then
      mRefine = proValue
    end
  end
  refine, mRefine = refine or 0, mRefine or 0
  self.addition.text = string.format(ZhString.PackageHighRefine_AdditionPreviewDescFormat, refine, mRefine)
end
