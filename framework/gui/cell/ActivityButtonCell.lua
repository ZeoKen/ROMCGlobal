local baseCell = autoImport("BaseCell")
ActivityButtonCell = class("ActivityButtonCell", baseCell)

function ActivityButtonCell:Init()
  self:initView()
  self.iconWidth = 80
  self.iconHeight = 80
end

function ActivityButtonCell:initView()
  self.activity_texture = self:FindComponent("activity_texture", UITexture)
  self.activity_label = self:FindComponent("activity_label", UILabel)
  self.holderSp = self:FindGO("holderSp")
  self.activity_holderSp = self.holderSp:GetComponent(UISprite)
  self:ResetDepth()
  self:AddCellClickEvent()
end

function ActivityButtonCell:ResetDepth()
  local sp = self.gameObject:GetComponent(UISprite)
  sp.depth = sp.depth + 30
  self.activity_texture.depth = self.activity_texture.depth + 30
  self.activity_label.depth = self.activity_label.depth + 30
  self.activity_holderSp.depth = self.activity_holderSp.depth + 30
end

function ActivityButtonCell:SetData(data)
  self:Show(self.holderSp)
  local texture = self.activity_texture.mainTexture
  self.activity_texture.mainTexture = nil
  Object.DestroyImmediate(texture)
  self.data = data
  self:updateTime()
  self:PassEvent(MainViewEvent.GetIconTexture, self)
end

function ActivityButtonCell:updateTime()
  local data = self.data
  if data.countdown then
    local subActs = data.sub_activity
    if subActs and 0 < #subActs then
      local subAct = data.sub_activity
      local currentTime = ServerTime.CurServerTime()
      currentTime = math.floor(currentTime / 1000)
      local time = subAct[1].begintime
      local leftTime = time - currentTime
      local preText = ZhString.ActivityData_Start
      if leftTime < 0 then
        leftTime = subAct[1].endtime - currentTime
        preText = ZhString.ActivityData_Finish
      end
      if 86400 <= leftTime then
        local day = math.floor(leftTime / 86400)
        local h = math.floor((leftTime - day * 3600 * 24) / 3600)
        self.activity_label.text = string.format(ZhString.ActivityData_HourDes, data.name, day, h, preText)
      else
        local h = math.floor(leftTime / 3600)
        local m = math.floor((leftTime - h * 3600) / 60)
        local s = leftTime - h * 3600 - m * 60
        self.activity_label.text = string.format(ZhString.ActivityData_TimeLineDes, data.name, h, m, s, preText)
      end
    else
      self.activity_label.text = data.name
    end
  else
    self.activity_label.text = data.name
  end
end

function ActivityButtonCell:OnRemove()
  Object.DestroyImmediate(self.activity_texture.mainTexture)
end

function ActivityButtonCell:setTextureByBytes(bytes)
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:setTexture(texture)
  else
    Object.DestroyImmediate(texture)
  end
end

function ActivityButtonCell:setTexture(texture)
  if texture then
    self:Hide(self.holderSp)
    Object.DestroyImmediate(self.activity_texture.mainTexture)
    self.activity_texture.mainTexture = texture
    self.activity_texture:MakePixelPerfect()
  end
end

function ActivityButtonCell:UpdateLabel(text)
  if self.activity_label then
    self.activity_label.text = text
  end
end

function ActivityButtonCell:UpdateAuction(totalSec, hour, min, sec)
  if self.data and totalSec ~= nil and hour ~= nil then
    if 24 <= hour then
      self.activity_label.text = string.format(ZhString.Auction_CountdownDayName, hour / 24)
    else
      self.activity_label.text = string.format(ZhString.Auction_CountdownName, hour, min, sec)
    end
  end
end

local LogMap = {}
local _defaultOrder = 500
local DefaultOrder = function()
  _defaultOrder = _defaultOrder + 1
  return _defaultOrder
end
local HotEntranceOrder = GameConfig.HotEntrance and GameConfig.HotEntrance.Order

function ActivityButtonCell:GetOrder()
  local icon, name, order
  if self.data then
    icon, name = self.data.icon, self.data.name
    if HotEntranceOrder then
      local index = ArrayFindIndex(HotEntranceOrder, icon)
      if 0 < index then
        order = index
      end
    end
  end
  order = order or DefaultOrder()
  if icon and not LogMap[icon] then
    LogMap[icon] = 1
    redlog("热点按钮顺序", name, icon, order)
  end
  return order
end

function ActivityButtonCell:UpdateOrder()
  self.trans:SetSiblingIndex(self:GetOrder())
end
