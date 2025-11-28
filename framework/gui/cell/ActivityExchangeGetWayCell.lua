ActivityExchangeGetWayCell = class("ActivityExchangeGetWayCell", BaseCell)

function ActivityExchangeGetWayCell:Init()
  self:FindObjs()
end

function ActivityExchangeGetWayCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UIMultiSprite)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:OnGotoBtnClick()
  end)
end

function ActivityExchangeGetWayCell:SetData(data)
  self.data = data
  if data then
    self.descLabel.text = data:GetDesc()
    IconManager:SetItemIconById(data.itemID, self.icon)
    local config = Table_AddWay[self.data.addWayID]
    local state = config and config.GotoMode and config.GotoMode[1] and true or false
    self:SetState(state)
  end
end

function ActivityExchangeGetWayCell:OnGotoBtnClick()
  if self.data then
    local config = Table_AddWay[self.data.addWayID]
    if config then
      local go = config.GotoMode and config.GotoMode[1]
      FuncShortCutFunc.Me():CallByID(go)
    end
  end
end

function ActivityExchangeGetWayCell:SetState(state)
  self.bg.CurrentState = state and 0 or 1
  self.gotoBtn:SetActive(state)
end
