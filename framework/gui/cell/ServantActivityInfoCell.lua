local BaseCell = autoImport("BaseCell")
ServantActivityInfoCell = class("ServantActivityInfoCell", BaseCell)
local btnStatus = {
  [1] = {
    "com_btn_2s",
    ZhString.Servant_Recommend_Go,
    Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  },
  [2] = {
    "com_btn_3s",
    ZhString.Servant_Calendar_Book,
    Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  },
  [3] = {
    "com_btn_3s",
    ZhString.Servant_Calendar_CancelBook,
    Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  }
}
ServantActivityInfoCellEvent = {
  ClickBtn = "ServantActivityInfoCellEvent_ClickBtn"
}

function ServantActivityInfoCell:Init()
  ServantActivityInfoCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
  EventManager.Me():AddEventListener(LotteryEvent.MagicPictureComplete, self.HdPicture, self)
end

function ServantActivityInfoCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.iconTexture = self:FindComponent("IconTexture", UITexture)
  self.name = self:FindComponent("Name", UILabel)
  self.timeLab = self:FindComponent("Time", UILabel)
  self.duringTimeLab = self:FindComponent("DuringTime", UILabel)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.chooseFlag = self:FindGO("ChooseFlag")
end

function ServantActivityInfoCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    self:OnClickBtn()
  end)
  self:AddClickEvent(self.bg, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ServantActivityInfoCell:OnClickBtn()
  if self.status ~= self.data:GetStatus() then
    MsgManager.ShowMsgByID(34004)
    return
  end
  self:PassEvent(ServantActivityInfoCellEvent.ClickBtn, self)
end

local TIME_FORMAT = "%s-%s"
local DURINGTIME = "%sh"

function ServantActivityInfoCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    self.bg:SetActive(true)
    self.timeLab.text = string.format(DURINGTIME, data:GetDuringHour())
    self.name.text = staticData.Name
    self:setBtnStatue(data:GetStatus())
    self.status = data:GetStatus()
    self.duringTimeLab.text = string.format(TIME_FORMAT, staticData.StartTime, staticData.EndTime)
    if not data.isConsoleData then
      self.gotoMode = staticData.GotoMode
      self:Show(self.icon)
      self:Hide(self.iconTexture)
      local exitIcon = IconManager:SetUIIcon(staticData.Icon, self.icon)
      if not exitIcon then
        exitIcon = IconManager:SetItemIcon(staticData.Icon, self.icon)
      end
    else
      self:Hide(self.icon)
      self:Show(self.iconTexture)
      if data.iconurl then
        local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(data.iconurl.url)
        if bytes then
          self:UpdatePicture(bytes)
        else
          self.iconTexture.mainTexture = nil
        end
      end
    end
  else
    self.bg:SetActive(false)
  end
end

function ServantActivityInfoCell:HdPicture(data)
  if self.data and self.data.iconurl and self.data.iconurl.url == data.picUrl and data.bytes then
    self:UpdatePicture(data.bytes)
  else
  end
end

function ServantActivityInfoCell:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self.iconTexture.mainTexture = texture
  end
end

function ServantActivityInfoCell:setBtnStatue(BTNCFG)
  BTNCFG = btnStatus[BTNCFG]
  self.btn.spriteName = BTNCFG[1]
  self.btnLab.text = BTNCFG[2]
  self.btnLab.effectColor = BTNCFG[3]
end

function ServantActivityInfoCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function ServantActivityInfoCell:OnDestroy()
  EventManager.Me():RemoveEventListener(LotteryEvent.MagicPictureComplete, self.HdPicture, self)
  GameObject.DestroyImmediate(self.iconTexture.mainTexture)
end

function ServantActivityInfoCell:UpdateChoose()
  if self.data and self.chooseId and self.data.staticData.id == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
