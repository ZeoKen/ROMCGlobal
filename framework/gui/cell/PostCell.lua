PostCell = class("PostCell", BaseCell)

function PostCell:Init()
  PostCell.super.Init(self)
  self:InitCell()
end

function PostCell:InitCell()
  local bg = self:FindGO("bg")
  self:SetEvent(bg, function()
    self:PassEvent(PostView.ClickCell, self)
  end)
  self.postName = self:FindComponent("PostName", UILabel)
  self.time = self:FindGO("Time"):GetComponent(UILabel)
  self.expiretimeTip = self:FindGO("ExpireTime"):GetComponent(UILabel)
  self.chooseFlag = self:FindGO("ChooseFlag")
  self.multiChooseFlag = self:FindGO("MultiChooseFlag")
  self.multiChoosen = self:FindGO("MultiChoosen")
  self.mailIcon = self:FindComponent("MailIcon", UISprite)
  self.mailIconOutLineObj = self:FindGO("MailIconOutLine")
  self.unread = self:FindGO("Unread")
  self.receiveLab = self:FindComponent("ReceiveLab", UILabel)
  self.pos = self:FindGO("Pos")
  self.mailIconOutLineSP = self:FindComponent("MailIconOutLine", UISprite)
  self.spBg = self:FindComponent("Bg", UISprite, self.pos)
end

local iconName
local _mailIcon = {
  "new_email_icon_gift_b",
  "new_email_icon_gift_a",
  "new_email_icon_letter_b",
  "new_email_icon_letter_a",
  "new_email_icon_props"
}
local _mailColor = {
  Color(0.5058823529411764, 0.5686274509803921, 0.6901960784313725, 1),
  Color(1.0, 0.9490196078431372, 0.592156862745098, 1),
  Color(0.5058823529411764, 0.5686274509803921, 0.6901960784313725, 1),
  Color(1.0, 0.9490196078431372, 0.592156862745098, 1),
  Color(0.6039215686274509, 0.6549019607843137, 1.0, 1)
}
local _outLineColor = {
  Color(1.0, 0.5803921568627451, 0.43529411764705883, 1),
  Color(0.6039215686274509, 0.6549019607843137, 1.0, 1)
}
local _bgColor = {
  Color(0.8588235294117647, 0.8784313725490196, 0.9372549019607843, 1),
  Color(0.803921568627451, 0.8470588235294118, 1.0, 1)
}

function PostCell:SetData(data)
  self.pos:SetActive(nil ~= data)
  if data then
    self:Hide(self.mailIconOutLineSP)
    self.postName.text = data.title
    UIUtil.WrapLabel(self.postName)
    local isPackageMail = data.isPackageMail
    self.spBg.color = isPackageMail and _bgColor[2] or _bgColor[1]
    if data:HasPostItems() then
      if data.status == PostProxy.STATUS.ATTACH then
        iconName = _mailIcon[1]
        self.mailIcon.color = _mailColor[1]
        self:Show(self.receiveLab)
        self:Hide(self.time)
        self.receiveLab.text = ZhString.Post_HasReceived
      else
        self:Hide(self.receiveLab)
        iconName = isPackageMail and _mailIcon[5] or _mailIcon[2]
        self:Show(self.mailIconOutLineSP)
        self.mailIconOutLineSP.color = isPackageMail and _outLineColor[2] or _outLineColor[1]
        self.mailIcon.color = isPackageMail and ColorUtil.NGUIWhite or _mailColor[2]
        self:Show(self.time)
        self.time.text = ClientTimeUtil.GetFormatDayTimeStr(data.time)
      end
    elseif data.status == PostProxy.STATUS.READ or data.status == PostProxy.STATUS.ATTACH then
      iconName = _mailIcon[3]
      self.mailIcon.color = _mailColor[3]
      self:Show(self.receiveLab)
      self:Hide(self.time)
      self.receiveLab.text = ZhString.Post_HasChecked
    else
      self:Hide(self.receiveLab)
      self.mailIcon.color = _mailColor[4]
      iconName = _mailIcon[4]
      self:Show(self.time)
      self.time.text = ClientTimeUtil.GetFormatDayTimeStr(data.time)
      self:Show(self.mailIconOutLineSP)
      self.mailIconOutLineSP.color = _outLineColor[1]
    end
    self.unread:SetActive(data.unread)
    self.mailIcon.spriteName = iconName
    self.mailIcon:MakePixelPerfect()
    local isExpire = PostProxy.Instance:IsExpire(data.id)
    if isExpire then
      self.expiretimeTip.text = ZhString.Post_Expired
    elseif self.timeTick == nil then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self, data.id)
    end
  end
  self.data = data
  self:UpdateChoose()
  self:UpdateMultiChoose()
end

function PostCell:UpdateCountdown()
  if not self.data then
    return
  end
  if self:ObjIsNil(self.gameObject) then
    if self.timeTick then
      TimeTickManager.Me():ClearTick(self, self.data.id)
    end
    return
  end
  local IsExpire, leftTime = PostProxy.Instance:IsExpire(self.data.id)
  if IsExpire then
    if self.timeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, self.data.id)
      self.timeTick = nil
    end
    self.expiretimeTip.text = ZhString.Post_Expired
    GameFacade.Instance:sendNotification(PostEvent.PostExpire, self.data.id)
    return
  end
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if day == 0 and hour == 0 then
    self.expiretimeTip.text = string.format(ZhString.Post_Countdowns, min, sec)
  else
    self.expiretimeTip.text = string.format(ZhString.Post_Countdown, day, hour)
  end
end

function PostCell:ShowMultiBox(var)
  self.multiChooseFlag:SetActive(var)
end

function PostCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function PostCell:UpdateMultiChoose()
  self.multiChoosen:SetActive(nil ~= self.data and self.data:IsMultiChoosenPost())
end

local _color = {
  Color(0.2901960784313726, 0.35294117647058826, 0.49019607843137253, 1),
  Color(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1),
  Color(0.9529411764705882, 0.9529411764705882, 0.9647058823529412, 1)
}

function PostCell:UpdateChoose()
  local selected = self.data and self.chooseId and self.data.id == self.chooseId or false
  self.chooseFlag:SetActive(selected)
  self.expiretimeTip.color = _color[selected and 2 or 1]
  self.time.color = _color[selected and 1 or 2]
  self.postName.color = _color[selected and 3 or 2]
end

function PostCell:OnRemove()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, self.data.id)
    self.timeTick = nil
  end
end
