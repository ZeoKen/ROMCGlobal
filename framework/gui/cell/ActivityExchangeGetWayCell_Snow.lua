autoImport("ActivityExchangeGetWayCell")
ActivityExchangeGetWayCell_Snow = class("ActivityExchangeGetWayCell_Snow", ActivityExchangeGetWayCell)

function ActivityExchangeGetWayCell_Snow:FindObjs()
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:OnGotoBtnClick()
  end)
end

function ActivityExchangeGetWayCell_Snow:SetState(state)
  self.gotoBtn:SetActive(state)
end
