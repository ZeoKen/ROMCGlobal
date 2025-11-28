autoImport("ItemCell")
ActivityIntegrationBriefCell = class("ActivityIntegrationBriefCell", ItemCell)

function ActivityIntegrationBriefCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  ActivityIntegrationBriefCell.super.Init(self)
  self:FindObjs()
  self:SetEvent(self.gameObject, function()
    if not self.lockStatus then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function ActivityIntegrationBriefCell:FindObjs()
  self.itemRoot = self:FindGO("ItemRoot"):GetComponent(UIWidget)
  self.descLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
end

function ActivityIntegrationBriefCell:SetData(data)
  self.data = data
  self.shortCutPowerID = self.data.GoToMode
  self.descLabel.text = self.data.desc
  if self.data.item then
    local itemData = ItemData.new("Brief", self.data.item)
    ActivityIntegrationBriefCell.super.SetData(self, itemData)
  end
end

function ActivityIntegrationBriefCell:SetLockStatus(bool)
  self.lockStatus = bool
  self.lockSymbol:SetActive(bool)
  self.itemRoot.alpha = bool and 0.5 or 1
end
