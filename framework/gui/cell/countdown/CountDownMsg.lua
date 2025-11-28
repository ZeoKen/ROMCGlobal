autoImport("SpriteLabel")
autoImport("CoreView")
CountDownMsg = class("CountDownMsg", CoreView)
CountDownMsg.resID = ResourcePathHelper.UICell("CountDownMsg")

function CountDownMsg:ctor(parent)
  self.gameObject = self:CreateObj(parent)
  self:Init()
end

function CountDownMsg:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(CountDownMsg.resID, parent)
end

function CountDownMsg:Init()
  self.tick = TimeTickManager.Me():CreateTick(0, 33, self.RefreshTime, self, 1, true)
  self.label = SpriteLabel.new(self:FindGO("Msg"):GetComponent("UILabel"))
  self.widgetBG = self:FindComponent("Bg", UIWidget)
  
  function self.label.onChange()
    if self.widgetBG then
      self.widgetBG:ResetAndUpdateAnchors()
    end
  end
end

function CountDownMsg:SetData(text, data)
  self.data = data
  self.tick:StartTick()
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
  self.label:Reset()
  self:UpdateUI()
end

function CountDownMsg:DecimalTime(time)
  return math.floor(time * self.factor) / self.factor
end

function CountDownMsg:RefreshTime(delta)
  local countTime = math.max(0, (self.countTime - ServerTime.CurServerTime()) / 1000)
  if countTime == 0 then
    self.tick:ClearTick()
    self:DestroySelf()
    return
  end
  local time = math.floor(self:DecimalTime(countTime))
  if time ~= self.time then
    if not self.isHideTime then
      self:UpdateUI()
    end
    self.time = time
  end
end

function CountDownMsg:UpdateUI()
  self.label:SetText(string.format(self.text, self.time), false)
  if self.widgetBG then
    self.widgetBG:ResetAndUpdateAnchors()
  end
end

function CountDownMsg:DestroySelf()
  if self.tick then
    self.tick:ClearTick()
  end
  if self.gameObject ~= nil then
    GameObject.Destroy(self.gameObject)
  end
  self.hasBeenDestroyed = true
  self.gameObject = nil
  self.label = nil
  self.widgetBG = nil
end
