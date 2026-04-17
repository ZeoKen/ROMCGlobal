autoImport("CountDownMsg")
RaidResetCountDownMsg = class("RaidResetCountDownMsg", CountDownMsg)
local resID = ResourcePathHelper.UICell("RaidResetCountDownMsg")
local LogoTexName = "magic_defeat_04"

function RaidResetCountDownMsg:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(resID, parent)
end

function RaidResetCountDownMsg:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.logoTex = self:FindComponent("LogoTex", UITexture)
  PictureManager.Instance:SetGeffenMagicTexture(LogoTexName, self.logoTex)
  self.effectContainer = self:FindGO("EffectContainer")
  self:PlayUIEffect(EffectMap.UI.AsyncPvpRaid_Lose, self.effectContainer)
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTime, self)
end

function RaidResetCountDownMsg:SetData(text, data)
  self.data = data
  self.text = text
  self.decimal = data.decimal
  self.isHideTime = data.isHideTime
  self.factor = math.pow(10, data.decimal)
  self.useTimeStamp = data.time > ServerTime.CurServerTime() / 1000
  if self.useTimeStamp then
    self.countTime = data.time * 1000
    self.time = math.floor(self:DecimalTime(data.time - ServerTime.CurServerTime() / 1000))
  else
    self.countTime = data.time * 1000 + ServerTime.CurServerTime()
    self.time = math.floor(self:DecimalTime(data.time))
  end
  self:UpdateUI()
end

function RaidResetCountDownMsg:RefreshTime()
  if self.time then
    if self.time <= 0 then
      self.tick:ClearTick()
      self:DestroySelf()
      return
    end
    self:UpdateUI()
    self.time = self.time - 1
  end
end

function RaidResetCountDownMsg:UpdateUI()
  if not self.isHideTime then
    self.label.text = string.format(self.text, self.time)
  else
    self.label.text = ""
  end
end

function RaidResetCountDownMsg:DestroySelf()
  PictureManager.Instance:UnloadGeffenMagicTexture(LogoTexName, self.logoTex)
  self.logoTex = nil
  RaidResetCountDownMsg.super.DestroySelf(self)
end
