local BaseCell = autoImport("BaseCell")
PetAdventureQuestCell = class("PetAdventureQuestCell", BaseCell)
local specialColor = Color(0.8901960784313725, 0.8588235294117647, 0.9882352941176471, 1)
local nameLabColor = Color(0.15294117647058825, 0.15294117647058825, 0.15294117647058825, 1)
local lvLabColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
local activeNameLabColor = Color(1.0, 0.596078431372549, 0.16470588235294117, 1)
local activeBgColor = Color(1.0, 0.9882352941176471, 0.7215686274509804, 1)
PetQuestEvent = {
  OnClickMonster = "PetQuestEvent_OnClickMonster"
}
local EStatusImg = {
  FINISHED = "pet_icon_finish",
  UNDERWAY = "pvp_icon_fighting"
}
local allMonster = "pet_icon_all"

function PetAdventureQuestCell:Init()
  self:FindObjs()
  self:AddEvt()
  self:AddCellClickEvent()
end

function PetAdventureQuestCell:FindObjs()
  self.bgImg = self:FindGO("bg"):GetComponent(UISprite)
  self.level = self:FindGO("lv"):GetComponent(UILabel)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.mapLab = self:FindComponent("mapLab", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.stateImg = self:FindComponent("stateImg", UISprite)
  self.monsterIcon = self:FindComponent("monsterIcon", UISprite)
  self.content = self:FindGO("Content")
  self.activeTimeLab = self:FindComponent("activieTimeLab", UILabel)
  self.activeFlag = self:FindGO("activeFlag")
end

function PetAdventureQuestCell:AddEvt()
  self:AddClickEvent(self.monsterIcon.gameObject, function()
    self:PassEvent(PetQuestEvent.OnClickMonster, self)
  end)
end

function PetAdventureQuestCell:SetData(data)
  self.data = data
  if data then
    self.state = data.status
    self.content:SetActive(true)
    self:UpdateUI()
    self:UpdateChoose()
    if self.data.statusSortID ~= PetAdventureProxy.QuestPhase.Activity then
      self.activeTimeLab.gameObject:SetActive(false)
      self.activeFlag:SetActive(false)
    else
      self:ClearTick()
      self.timeTick = TimeTickManager.Me():CreateTick(0, 330, self.UpdateActiveQuest, self, 1)
    end
  else
    self.content:SetActive(false)
  end
end

function PetAdventureQuestCell:UpdateActiveQuest()
  local totalSec = self.data.activityEndTime - ServerTime.CurServerTime() / 1000
  if 0 < totalSec then
    self.activeFlag:SetActive(true)
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
    if 0 < day then
      self.activeTimeLab.text = string.format(ZhString.PetAdventure_CDDayTime, (0 < hour or 0 < min or 0 < sec) and day + 1 or day)
    else
      self.activeTimeLab.text = string.format(ZhString.PetAdventure_CDTime, hour, min)
    end
    self.activeTimeLab.gameObject:SetActive(true)
  else
    self:ClearTick()
    self.activeTimeLab.gameObject:SetActive(false)
  end
end

function PetAdventureQuestCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end

function PetAdventureQuestCell:UpdateUI()
  local state = self.state
  local staticData = self.data.staticData
  self.name.text = staticData.NameZh
  local isActive = self.data.statusSortID == PetAdventureProxy.QuestPhase.Activity
  self.name.color = isActive and activeNameLabColor or nameLabColor
  self.monsterId = self.data.specid
  if nil == self.monsterId or 0 == self.monsterId then
    self.mapLab.text = staticData.SmallArea
  else
    self.mapLab.text = Table_Monster[self.monsterId] and Table_Monster[self.monsterId].NameZh
  end
  self.level.text = string.format(ZhString.PetAdventure_Lv, staticData.Level)
  self.level.color = self.data.statusSortID == PetAdventureProxy.QuestPhase.Activity and activeNameLabColor or lvLabColor
  local bgColor
  if isActive then
    bgColor = activeBgColor
  elseif staticData.QuestType == 1 then
    bgColor = specialColor
  else
    bgColor = ColorUtil.NGUIWhite
  end
  self.bgImg.color = bgColor
  self:_setStatus(state)
  if staticData.QuestType == 1 or isActive then
    self:Hide(self.monsterIcon)
  else
    self:Show(self.monsterIcon)
    self:_setFaceIcon(self.monsterId)
  end
end

function PetAdventureQuestCell:_setFaceIcon(id)
  if id == nil or id == 0 then
    IconManager:SetUIIcon(allMonster, self.monsterIcon)
  else
    IconManager:SetFaceIcon(Table_Monster[id].Icon, self.monsterIcon)
  end
end

function PetAdventureQuestCell:_setStatus(state)
  if state == PetAdventureProxy.QuestPhase.UNDERWAY then
    IconManager:SetUIIcon(EStatusImg.UNDERWAY, self.stateImg)
    self:Show(self.stateImg)
  elseif state == PetAdventureProxy.QuestPhase.FINISHED then
    IconManager:SetUIIcon(EStatusImg.FINISHED, self.stateImg)
    self:Show(self.stateImg)
  elseif state == PetAdventureProxy.QuestPhase.MATCH then
    self:Hide(self.stateImg)
  end
end

function PetAdventureQuestCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function PetAdventureQuestCell:SetChooseSpecial(monsterId)
  if nil == monsterId then
    self:_setFaceIcon(self.monsterId)
  else
    self.monsterId = monsterId
    self:_setFaceIcon(monsterId)
  end
end

function PetAdventureQuestCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end

function PetAdventureQuestCell:OnCellDestroy()
  self:ClearTick()
end
