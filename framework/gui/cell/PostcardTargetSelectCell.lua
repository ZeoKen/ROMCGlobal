autoImport("SocialBaseCell")
PostcardTargetSelectCell = class("PostcardTargetSelectCell", SocialBaseCell)
local BlueColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function PostcardTargetSelectCell:Init()
  self.super.Init(self)
  self:AddButtonEvt()
end

function PostcardTargetSelectCell:FindObjs()
  PostcardTargetSelectCell.super.FindObjs(self)
  self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildIconGO = self.GuildIcon.gameObject
  self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.selectBtn = self:FindGO("SelectBtn")
  self.selectBtnLb = self:FindComponent("Label", UILabel, self.selectBtn)
  self.mask = self:FindGO("Mask")
end

function PostcardTargetSelectCell:AddButtonEvt()
  self:SetEvent(self.selectBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PostcardTargetSelectCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    self.mask:SetActive(data.offlinetime ~= 0)
    if data.guildData then
      self.guid = data.id
    else
      self.guid = data.guid
    end
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      local iconColor = ColorUtil["CareerIconBg" .. config.Type]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professIconBG.color = iconColor
    end
    self.level.text = "Lv." .. (data.level or data.baselevel)
    self:TryInitHeadIcon()
    local headData = Table_HeadImage[data.portrait]
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
      self.headIcon:SetPortraitFrame(data.portraitframe or data.portrait_frame)
      self.headIcon:SetAfkIcon(AfkProxy.ParseIsAfk(data.afk))
    elseif data.guildData then
      local tempData = {}
      tempData.bodyID = data.body
      tempData.eyeID = data:GetEyeID()
      tempData.faceID = data.face
      tempData.frame = data.frame
      tempData.frame = data.frame
      tempData.gender = data.gender
      tempData.hairID = data.hair
      tempData.haircolor = data.haircolor
      tempData.headID = data.head
      tempData.mouthID = data.mouth
      tempData.portraitframe = data.portrait_frame
      tempData.profession = data.profession
      tempData.profession = data.profession
      self.headIcon:SetData(tempData)
    else
      self.headIcon:SetData(data)
    end
    if data.gender == ProtoCommon_pb.EGENDER_MALE then
      self.genderIcon.CurrentState = 0
    elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
      self.genderIcon.CurrentState = 1
    end
    self.name.text = data.name
    self.name.text = AppendSpace2Str(data.name)
    if data.guildname ~= "" then
      self.GuildName.text = data.guildname
      self.GuildName.color = BlueColor
    else
      self.GuildName.text = ZhString.Friend_EmptyGuild
      ColorUtil.GrayUIWidget(self.GuildName)
    end
    self:RefreshSelected()
  else
  end
end

function PostcardTargetSelectCell:RefreshSelected()
  local curSenderData = PostcardProxy.Instance:GetSendPostcardData()
  if curSenderData and curSenderData.targetData and curSenderData.targetData.guid == self.guid then
    self.selectBtnLb.text = ZhString.Postcard_Btn_CurSelect
    UIUtil.TempSetButtonStyle(10, self.selectBtn)
  else
    self.selectBtnLb.text = ZhString.Postcard_Btn_Select
    if self.data.guildData and self.data.baselevel == 0 then
      UIUtil.TempSetButtonStyle(10, self.selectBtn)
    else
      UIUtil.TempSetButtonStyle(12, self.selectBtn)
    end
  end
end
