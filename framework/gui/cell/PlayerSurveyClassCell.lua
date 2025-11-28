local BaseCell = autoImport("BaseCell")
PlayerSurveyClassCell = class("PlayerSurveyClassCell", BaseCell)

function PlayerSurveyClassCell:Init()
  PlayerSurveyClassCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function PlayerSurveyClassCell:FindObjs()
  self.classIcon = self:FindGO("ClassIcon"):GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseStatus = false
  self.chooseSymbol:SetActive(false)
end

function PlayerSurveyClassCell:SetData(data)
  local data = data
  local classID = data
  local config = Table_Class[classID]
  if config then
    if IconManager:SetProfessionIcon(config.icon, self.classIcon) then
      self.classIcon.gameObject:SetActive(true)
    else
      self.classIcon.gameObject:SetActive(true)
    end
  end
end

function PlayerSurveyClassCell:AddEvts()
  self:SetEvent(self.gameObject, function()
    self:PassEvent(PlayerSurveyEvent.ClickClassTog, self)
  end)
end

function PlayerSurveyClassCell:SetChoose(bool)
  self.chooseStatus = bool
  self.chooseSymbol:SetActive(bool)
end

function PlayerSurveyClassCell:SwitchStatus()
  self.chooseStatus = not self.chooseStatus
  self.chooseSymbol:SetActive(self.chooseStatus)
end
