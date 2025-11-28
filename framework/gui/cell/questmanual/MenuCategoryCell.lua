local baseCell = autoImport("BaseCell")
MenuCategoryCell = class("MenuCategoryCell", baseCell)
local CategoryConfig = GameConfig.FunctionOpening

function MenuCategoryCell:Init()
  self.funcName = self.gameObject:GetComponent(UILabel)
  self.reddotcell = self:FindGO("reddotcell")
  self:AddCellClickEvent()
end

function MenuCategoryCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.funcName.color = QuestManualView.ColorTheme[6].color
    elseif self.isStop then
      self.funcName.color = QuestManualView.ColorTheme[9].color
    else
      self.funcName.color = QuestManualView.ColorTheme[8].color
    end
  end
end

local strFormat = "(%d/%d)"

function MenuCategoryCell:SetData(data)
  self.index = data
  local current, total, isStop = QuestManualProxy.Instance:CheckProgress(self.index)
  self.isStop = isStop
  if isStop then
    self.funcName.color = QuestManualView.ColorTheme[9].color
  else
    self.funcName.color = QuestManualView.ColorTheme[8].color
  end
  local myconfig = CategoryConfig[self.index]
  self.funcName.text = myconfig.name .. string.format(strFormat, current, total)
  self.isSelected = false
  local ERedSys = SceneTip_pb.EREDSYS_FUNCTION_OPENING
  local isNew = RedTipProxy.Instance:IsNew(ERedSys, self.index)
  self.reddotcell:SetActive(isNew)
end
