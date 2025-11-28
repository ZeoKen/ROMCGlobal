MaidDungeonInfo = class("MaidDungeonInfo", SubView)
local raidConfig = GameConfig.JanuaryRaid

function MaidDungeonInfo:Init()
  self:InitUI()
end

function MaidDungeonInfo:InitUI()
  self.toptip = self:FindGO("descriptionTop"):GetComponent(UILabel)
  self.bottip = self:FindGO("descriptionBot"):GetComponent(UILabel)
  self.toptip.text = ""
  self.bottip.text = ""
  self.desPic = self:FindGO("desPic"):GetComponent(UITexture)
  self.textureName = raidConfig.despic
  if self.textureName then
    PictureManager.Instance:SetUI(self.textureName, self.desPic)
  end
end

function MaidDungeonInfo:OnExit()
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.desPic)
    self.textureName = nil
  end
  self.super.OnExit(self)
end

function MaidDungeonInfo:Show(target)
  MaidDungeonInfo.super.Show(self, target)
end

function MaidDungeonInfo:UpdateTimeTick()
  local time = self.endt
  if time == 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(deltaTime)
  if deltaTime <= 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
  elseif deltaTime < 86400 then
    self.timelable.text = string.format(ZhString.EVA_EndInHours, hour, min, sec)
  else
    self.timelable.text = string.format(ZhString.EVA_EndInDays, day)
  end
end
