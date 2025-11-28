local baseCell = autoImport("BaseCell")
ComodoBuildingSendAreaCell = class("ComodoBuildingSendAreaCell", baseCell)
local bgSpPrefix = "Disney_yhqd_bg_landmark"
ComodoBuildingSendAreaCellState = {
  Normal = 1,
  Sent = 2,
  Complete = 3,
  Locked = 4
}

function ComodoBuildingSendAreaCell:ctor(obj, areaId)
  self.areaId = areaId
  ComodoBuildingSendAreaCell.super.ctor(self, obj)
end

function ComodoBuildingSendAreaCell:Init()
  self.bg = self:FindComponent("AreaBg", UISprite)
  self.bg2 = self:FindComponent("AreaBg2", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.lock = self:FindGO("Lock")
  self.sent = self:FindGO("Sent")
  self.complete = self:FindGO("Complete")
  self.choose = self:FindGO("Choose")
  IconManager:SetUIIcon(Table_ManorAreaReward[self.areaId].Icon, self.icon)
  self:SwitchToState(ComodoBuildingSendAreaCellState.Normal)
end

function ComodoBuildingSendAreaCell:SwitchToState(state)
  self.state = state
  self.bg2.spriteName = bgSpPrefix .. string.format("0%s", state)
  self.icon.color = LuaGeometry.GetTempColor(1, 1, 1, state == ComodoBuildingSendAreaCellState.Locked and 0.3 or 1)
  self.lock:SetActive(state == ComodoBuildingSendAreaCellState.Locked)
  self.sent:SetActive(state == ComodoBuildingSendAreaCellState.Sent)
  self.complete:SetActive(state == ComodoBuildingSendAreaCellState.Complete)
end

function ComodoBuildingSendAreaCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function ComodoBuildingSendAreaCell:UpdateChoose()
  self.choose:SetActive(self.chooseId == self.areaId)
end
