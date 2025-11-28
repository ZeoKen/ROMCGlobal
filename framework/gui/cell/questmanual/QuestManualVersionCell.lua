local baseCell = autoImport("BaseCell")
QuestManualVersionCell = class("QuestManualVersionCell", baseCell)

function QuestManualVersionCell:Init()
  self:initView()
end

function QuestManualVersionCell:initView()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.iconShadow = self:FindGO("iconShadow"):GetComponent(UISprite)
  self.tabName = self:FindComponent("TabName", UILabel)
  self.redtip = self:FindGO("RedTip")
end

function QuestManualVersionCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.iconShadow.color = QuestManualView.ColorTheme[6].color
      self.tabName.effectColor = QuestManualView.ColorTheme[6].color
    else
      self.iconShadow.color = QuestManualView.ColorTheme[7].color
      self.tabName.effectColor = QuestManualView.ColorTheme[7].color
    end
  end
end

function QuestManualVersionCell:SetData(data)
  self.data = data
  self.tabName.text = data.name
  IconManager:SetUIIcon(data.icon, self.icon)
  IconManager:SetUIIcon(data.icon, self.iconShadow)
end

function QuestManualVersionCell:UpdateRedtips(type)
  local ERedSys = SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK
  local ERedTypeProcess = SceneTip_pb.EREDSYS_MANUAL_GOAL
  local _RedTipProxy = RedTipProxy.Instance
  _RedTipProxy:UnRegisterUI(ERedSys, self.gameObject)
  _RedTipProxy:UnRegisterUI(ERedTypeProcess, self.gameObject, 8, {84, 15})
  if type == 2 then
    local isNew = _RedTipProxy:IsNew(ERedSys, tonumber(self.data.version) * 1000) or false
    if isNew then
      _RedTipProxy:RegisterUI(ERedSys, self.gameObject, 8, {84, 15})
    end
  elseif type == 1 then
    local isNew = _RedTipProxy:IsNew(ERedTypeProcess, tonumber(self.data.version) * 1000) or false
    if isNew then
      _RedTipProxy:RegisterUI(ERedTypeProcess, self.gameObject, 8, {84, 15})
    end
  end
end
