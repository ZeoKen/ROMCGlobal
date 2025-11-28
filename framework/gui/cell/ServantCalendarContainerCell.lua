autoImport("BaseCell")
ServantCalendarContainerCell = class("ServantCalendarContainerCell", ItemCell)
local spriteName_Unbook = "calendar_bg_icon"
local spriteName_booked = "calendar_bg_icon_booked"

function ServantCalendarContainerCell:Init()
  self:FindObj()
  self:AddCellClickEvent()
  self:AddEvts()
end

function ServantCalendarContainerCell:FindObj()
  self.dayLab = self:FindComponent("Day", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.iconPfb = self:FindGO("ActPfb")
  self.actIconGrid = self:FindComponent("ActGrid", UIGrid)
  self.symbol = self:FindGO("Symbol")
  self.todayFlag = self:FindGO("TodayFlag")
end

function ServantCalendarContainerCell:AddEvts()
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ServantCalendarContainerCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    self.dayLab.text = data:GetUIDisplayDay()
    self:SetActivityIcon()
    self.todayFlag:SetActive(data:IsToday())
    self.bg.alpha = data:CheckTransparent() and 0.5 or 0.9
  else
    self:Hide(self.gameObject)
  end
end

function ServantCalendarContainerCell:SetActivityIcon()
  local actDatas = self.data:GetActiveData(true)
  if not actDatas then
    return
  end
  local childcount = self.actIconGrid.gameObject.transform.childCount
  if 0 < childcount - #actDatas then
    for i = #actDatas, childcount - 1 do
      local trans = self.actIconGrid.gameObject.transform:GetChild(i)
      self:Hide(trans.gameObject)
    end
  end
  for i = 1, math.min(#actDatas, 6) do
    local iconObj = self:FindGO("activity" .. i)
    iconObj = iconObj or self:CopyGameObject(self.iconPfb)
    iconObj:SetActive(true)
    iconObj.transform:SetParent(self.actIconGrid.gameObject.transform)
    iconObj.name = "activity" .. i
    local iconBg = self:FindComponent("ActBg", UISprite, iconObj)
    iconBg.spriteName = actDatas[i]:IsBooked() and spriteName_booked or spriteName_Unbook
    local actFather = self:FindGO("ActFather", iconObj)
    local iconTxt = self:FindComponent("ActTexture", UITexture, actFather)
    iconObj = self:FindComponent("Act", UISprite, actFather)
    iconObj.gameObject:SetActive(true)
    iconTxt.gameObject:SetActive(false)
    local exitIcon = IconManager:SetUIIcon(actDatas[i].staticData.Icon, iconObj)
    exitIcon = exitIcon or IconManager:SetItemIcon(actDatas[i].staticData.Icon, iconObj)
    iconObj:MakePixelPerfect()
    if actDatas[i].isConsoleData then
      iconObj.gameObject:SetActive(false)
      iconTxt.gameObject:SetActive(true)
      if actDatas[i].iconurl then
        local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(actDatas[i].iconurl.url)
        if bytes then
          local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
          local ret = ImageConversion.LoadImage(texture, bytes)
          if ret then
            iconTxt.mainTexture = texture
          end
        else
          iconTxt.mainTexture = nil
        end
      end
    end
  end
  self.symbol:SetActive(6 < #actDatas)
  self.actIconGrid:Reposition()
end
