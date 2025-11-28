local baseCell = autoImport("BaseCell")
AdventureSmallCategoryCell = class("AdventureSmallCategoryCell", baseCell)
local iconWidth = {
  bag_icon_14 = 40,
  prestige_icon_organization2 = 36,
  ["120"] = 55
}
local iconHeight = {
  bag_icon_14 = 42,
  prestige_icon_organization2 = 38,
  ["120"] = 55
}
local iconPosY = {bag_icon_14 = 8}

function AdventureSmallCategoryCell:Init()
  self.redTipIDs = {}
  self:FindObjs()
  self:InitCellView()
  self:AddCellClickEvent()
end

function AdventureSmallCategoryCell:FindObjs()
  self.sprIcon = self:FindComponent("icon", UISprite)
  self.objSelect = self:FindGO("Select")
  self.sprSelect = self:FindComponent("SelectIcon", UISprite)
end

function AdventureSmallCategoryCell:InitCellView()
  self:Select(false)
end

function AdventureSmallCategoryCell:SetData(data)
  self.data = data
  self.id = data.staticData.id
  IconManager:SetUIIcon(data.staticData.icon, self.sprIcon)
  IconManager:SetUIIcon(data.staticData.icon, self.sprSelect)
  local width = iconWidth[data.staticData.icon]
  if width then
    self.sprIcon.width = width
    self.sprSelect.width = width
  end
  local height = iconHeight[data.staticData.icon]
  if height then
    self.sprIcon.height = height
    self.sprSelect.height = height
  end
  local posY = iconPosY[data.staticData.icon]
  if posY then
    local vecPos = self.sprIcon.transform.localPosition
    vecPos.y = posY
    self.sprIcon.transform.localPosition = vecPos
    vecPos = self.sprSelect.transform.localPosition
    vecPos.y = posY
    self.sprSelect.transform.localPosition = vecPos
  end
  self:CheckRedTip()
end

function AdventureSmallCategoryCell:CheckRedTip()
  self:UnRegisterRedTipChecks()
  TableUtility.TableClear(self.redTipIDs)
  if self.id == 7 or self.id == 21 then
    return
  end
  local categorys = AdventureDataProxy.Instance:getTabsByCategory(self.id)
  if categorys and categorys.childs then
    for k, v in pairs(categorys.childs) do
      local redId = v.staticData.RidTip
      if redId and type(redId) == "number" then
        table.insert(self.redTipIDs, redId)
      elseif redId and type(redId) == "table" then
        for i = 1, #redId do
          table.insert(self.redTipIDs, redId[i])
        end
      end
    end
  end
  self:RegisterRedTipCheck()
end

function AdventureSmallCategoryCell:Select(isSelect)
  if self.isSelect ~= isSelect then
    TweenAlpha.Begin(self.objSelect, 0.2, isSelect and 1 or 0)
    self.isSelect = isSelect
  end
end

function AdventureSmallCategoryCell:RegisterRedTipCheck()
  for i = 1, #self.redTipIDs do
    RedTipProxy.Instance:RegisterUI(self.redTipIDs[i], self.sprIcon, 4)
  end
end

function AdventureSmallCategoryCell:UnRegisterRedTipChecks()
  for i = 1, #self.redTipIDs do
    RedTipProxy.Instance:UnRegisterUI(self.redTipIDs[i], self.sprIcon)
  end
end
