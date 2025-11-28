local baseCell = autoImport("BaseCell")
ServantWeekActivityCell = class("ServantWeekActivityCell", baseCell)
local spriteName_Unbook = "calendar_bg_icon"
local spriteName_booked = "calendar_bg_icon_booked"

function ServantWeekActivityCell:Init()
  self.icon = self:FindComponent("ActIcon", UISprite)
  self.iconTex = self:FindComponent("ActTex", UITexture)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.startTimeLab = self:FindComponent("StartTime", UILabel)
  self.duringTimeLab = self:FindComponent("DuringTime", UILabel)
  self.servantImg = self:FindComponent("bg", UISprite)
  EventManager.Me():AddEventListener(LotteryEvent.MagicPictureComplete, self.HdPicture, self)
end

local FORMAT = "%sh"

function ServantWeekActivityCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    self.gameObject:SetActive(true)
    self:SetActIcon()
    self.nameLab.text = staticData.Name
    UIUtil.WrapLabel(self.nameLab)
    self.startTimeLab.text = staticData.StartTime
    self.duringTimeLab.text = string.format(FORMAT, data:GetDuringHour())
    self.servantImg.spriteName = data:IsBooked() and spriteName_booked or spriteName_Unbook
  else
    self.gameObject:SetActive(false)
  end
end

function ServantWeekActivityCell:OnCellDestroy()
  EventManager.Me():RemoveEventListener(LotteryEvent.MagicPictureComplete, self.HdPicture, self)
  self:DestroyPicture()
end

function ServantWeekActivityCell:HdPicture(data)
  if self.data and self.data.iconurl and self.data.iconurl.url == data.picUrl and data.bytes then
    self:UpdatePicture(data.bytes)
  end
end

function ServantWeekActivityCell:SetActIcon()
  local data = self.data
  if not data then
    return
  end
  if data.isConsoleData and data.iconurl and nil ~= data.iconurl.url then
    self:Show(self.iconTex)
    self:Hide(self.icon)
    local localBytes = LotteryProxy.Instance:LoadFromLocal(data.iconurl.url)
    if localBytes then
      self:UpdatePicture(localBytes)
    elseif ServantCalendarProxy.Instance:AddQueryArray(data.iconurl.url) then
      local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(data.iconurl.url)
      if bytes then
        self:UpdatePicture(bytes)
      end
    end
  else
    local exitIcon = IconManager:SetUIIcon(data.staticData.Icon, self.icon)
    exitIcon = exitIcon or IconManager:SetItemIcon(data.staticData.Icon, self.icon)
    self:Hide(self.iconTex)
    self:Show(self.icon)
    self.icon:MakePixelPerfect()
  end
end

function ServantWeekActivityCell:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self:DestroyPicture()
    self.iconTex.mainTexture = texture
  else
    Object.DestroyImmediate(texture)
  end
end

function ServantWeekActivityCell:DestroyPicture()
  local texture = self.iconTex.mainTexture
  if nil ~= texture then
    self.iconTex.mainTexture = nil
    Object.DestroyImmediate(texture)
  end
end
