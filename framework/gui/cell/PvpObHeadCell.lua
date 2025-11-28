autoImport("TwelvePvpObserverHeadCell")
PvpObHeadCell = class("PvpObHeadCell", TwelvePvpObserverHeadCell)
local lowHpPercent = GameConfig.PvpTeamRaidPublic and GameConfig.PvpTeamRaidPublic.LowHpPercent or 0.5
local lowHpBlinkDuration = GameConfig.PvpTeamRaidPublic and GameConfig.PvpTeamRaidPublic.LowHpBlinkDuration or 3
local lowHpBlinkInterval = GameConfig.PvpTeamRaidPublic and GameConfig.PvpTeamRaidPublic.LowHpBlinkInterval or 10
if lowHpBlinkDuration > lowHpBlinkInterval then
  lowHpBlinkInterval = lowHpBlinkDuration
end
local blinkAnimHash = Animator.StringToHash("blink")

function PvpObHeadCell:Init()
  self.lvmat = "%s"
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  self.name = self:FindComponent("name", UILabel)
  if self.name then
    self.nameObj = self.name.gameObject
  end
  self.level = self:FindComponent("level", UILabel)
  self.vip = self:FindComponent("vip", UILabel)
  self.hp = self:FindComponent("hp", UISlider)
  self.mp = self:FindComponent("mp", UISlider)
  self.choosen = self:FindGO("ChoosenGO")
  self.attachGO = self:FindGO("AttachGO")
  self.dangerGO = self:FindGO("DangerGO")
  self.headRootSp = self:FindComponent("HeadRootSp", UISprite)
  self:InitHeadIconCell()
  self.headIconCell:HideFrame()
  self:AddCellClickEvent()
  self.animator = self.gameObject:GetComponent(Animator)
end

function PvpObHeadCell:SetPlayerPro(data)
  PvpObHeadCell.super.SetPlayerPro(self, data)
  self.proIcon.width = 32
end

function PvpObHeadCell:UpdateLowerHp()
  local hpDanger = self.data and not self.data.offline and self.data.hp / 100 < lowHpPercent or false
  if hpDanger == self.cacheDanger then
    return
  end
  self.cacheDanger = hpDanger
  self.dangerGO:SetActive(hpDanger)
  if hpDanger then
    self:StartBlink()
  else
    self:StopBlink()
  end
end

function PvpObHeadCell:UpdateHpSp(hp, sp)
  PvpObHeadCell.super.UpdateHpSp(self, hp, sp)
  self:UpdateLowerHp()
end

function PvpObHeadCell:StartBlinkAnimation()
  self.dangerGO:SetActive(true)
  if not self:ObjIsNil(self.animator) then
    self.animator.enabled = true
  end
end

function PvpObHeadCell:StopBlinkAnimation()
  if not self:ObjIsNil(self.animator) then
    self.animator.enabled = false
  end
  if not self:ObjIsNil(self.dangerGO) then
    self.dangerGO:SetActive(false)
  end
end

function PvpObHeadCell:StartBlink()
  if self.blinkTicker then
    return
  end
  self.blinkTicker = TimeTickManager.Me():CreateTick(0, lowHpBlinkInterval * 1000, self.BlinkJob, self, 901)
end

function PvpObHeadCell:BlinkJob()
  self:StartBlinkAnimation()
  self.stopBlinkTicker = TimeTickManager.Me():CreateOnceDelayTick(lowHpBlinkDuration * 1000, self.StopBlinkAnimation, self, 902)
end

function PvpObHeadCell:StopBlink()
  self:ClearBlinkTicker()
  self:StopBlinkAnimation()
end

function PvpObHeadCell:OnCellDestroy()
  PvpObHeadCell.super.OnCellDestroy(self)
  self:StopBlink()
end

function PvpObHeadCell:ClearBlinkTicker()
  if self.blinkTicker then
    self.blinkTicker:Destroy()
    self.blinkTicker = nil
  end
  if self.stopBlinkTicker then
    self.stopBlinkTicker:Destroy()
    self.stopBlinkTicker = nil
  end
end

function PvpObHeadCell:UpdateOffline()
  PvpObHeadCell.super.UpdateOffline(self)
  if self.data then
    self.data.offline = true
  end
  self:StopBlink()
end
