ImproveShortCutView = class("ImproveShortCutView", ContainerView)
ImproveShortCutView.ViewType = UIViewType.PerformanceLayer
local ImproveTips = {
  [1] = {
    icon = "tab_icon_87",
    name = ZhString.ImproveMethod_MercenaryCat,
    checkFunc = "MerceneryCat"
  },
  [2] = {
    icon = "tab_icon_91",
    name = ZhString.ImproveMethod_Food
  },
  [3] = {
    icon = "tab_icon_89",
    name = ZhString.ImproveMethod_TechTree,
    checkFunc = "TechTree"
  },
  [4] = {
    icon = "tab_icon_90",
    name = ZhString.ImproveMethod_Equip
  }
}

function ImproveShortCutView:Init()
  self:FindObjs()
  self:AddButtonEvents()
  self:InitShow()
end

function ImproveShortCutView:FindObjs()
  self.backBtn = self:FindGO("BackBtn")
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
end

function ImproveShortCutView:AddButtonEvents()
  self:AddClickEvent(self.backBtn, function()
    self:CloseSelf()
  end)
end

function ImproveShortCutView:InitShow()
  self.btnList = {}
  for i = 1, 4 do
    self.btnList[i] = self:FindGO("Btn" .. i)
    local spriteIcon = self:FindGO("Icon", self.btnList[i]):GetComponent(UISprite)
    IconManager:SetUIIcon(ImproveTips[i].icon, spriteIcon)
    local label = self:FindGO("WayName", self.btnList[i]):GetComponent(UILabel)
    label.text = ImproveTips[i].name
    if ImproveTips[i].checkFunc and self["check" .. ImproveTips[i].checkFunc] then
      local checkResult = self["check" .. ImproveTips[i].checkFunc](self)
      self.btnList[i]:SetActive(checkResult)
    end
  end
  self.grid:Reposition()
end

function ImproveShortCutView:checkMerceneryCat()
  local level = MercenaryCatProxy.Instance:GetMercenaryLv()
  if level ~= 0 then
    return false
  end
  return true
end

function ImproveShortCutView:checkTechTree()
  return FunctionUnLockFunc.Me():CheckCanOpen(10003)
end

function ImproveShortCutView:CloseSelf()
  MyselfProxy.Instance.failPassPersonalEndlessTower = false
  self.super.CloseSelf(self)
end
