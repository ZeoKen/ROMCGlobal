local BaseCell = autoImport("BaseCell")
TeamPwsCustomRoomMemberCell = class("TeamPwsCustomRoomMemberCell", BaseCell)

function TeamPwsCustomRoomMemberCell:Init()
  self.bgGO = self:FindGO("Bg")
  self:AddClickEvent(self.bgGO, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self.emptyGO = self:FindGO("Empty")
  self.memberGO = self:FindGO("MemberInfo")
  self.leaderGO = self:FindGO("Leader", self.memberGO)
  self.headGO = self:FindGO("HeadIcon", self.memberGO)
  self.portraitCell = PlayerFaceCell.new(self.headGO)
  self.portraitCell:SetMinDepth(4)
  self.portraitCell.headIconCell:SetScale(0.48)
  self.portraitCell.headIconCell:DisableBoxCollider(false)
  self.nameLabel = self:FindComponent("Name", UILabel, self.memberGO)
  self.levelLabel = self:FindComponent("Lv", UILabel, self.memberGO)
  self.guildGO = self:FindGO("GuildInfo", self.memberGO)
  self.guildIcon = self:FindComponent("GuildIcon", UISprite, self.guildGO)
  self.guildTexture = self:FindComponent("GuildTexture", UITexture, self.guildGO)
  self.guildNameLabel = self:FindComponent("GuildTitle", UILabel, self.guildGO)
  self.btnGroupGO = self:FindGO("BtnGroup", self.memberGO)
  self.playTween = self.btnGroupGO:GetComponent(UIPlayTween)
  self.tweens = self.btnGroupGO:GetComponentsInChildren(UITweener, true)
  self.btnGroupBg = self:FindComponent("Bg", UISprite, self.btnGroupGO)
  self.btnGroupTable = self:FindComponent("Table", UITable, self.btnGroupGO)
  self.infoGO = self:FindGO("Info", self.btnGroupGO)
  self:AddClickEvent(self.infoGO, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
  self.kickGO = self:FindGO("Kick", self.btnGroupGO)
  self:AddClickEvent(self.kickGO, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self.lineGO = self:FindGO("Line", self.btnGroupGO)
  self.isBtnGroupShown = false
  self.guildHeadData = GuildHeadData.new()
end

function TeamPwsCustomRoomMemberCell:ToggleBtnGroup(show)
  if self.isBtnGroupShown == show then
    return
  end
  self.isBtnGroupShown = show
  self.playTween:Play(not not show)
end

function TeamPwsCustomRoomMemberCell:SetData(data)
  local lastId = self.data and self.data.id
  self.data = data
  local isEmpty = self:IsEmpty()
  self.memberGO:SetActive(true)
  if not isEmpty then
    self.leaderGO:SetActive(not not data.iscaptial)
    self.portraitCell:SetData(data.portrait)
    local myId = Game.Myself.data.id
    local isHost = PvpCustomRoomProxy.Instance:IsCurrentRoomHost(myId)
    local showKick = isHost and myId ~= data.id
    self.kickGO:SetActive(showKick)
    self.lineGO:SetActive(showKick)
    self.btnGroupTable:Reposition()
    self.btnGroupBg:UpdateAnchors()
    self.nameLabel.text = data.name or ""
    self.levelLabel.text = string.format("Lv.%d", data.level or 0)
    self.guildNameLabel.text = data.guildname or ""
    local showGuild = data.guildname and data.guildname ~= ""
    if showGuild then
      self.guildNameLabel.gameObject:SetActive(true)
      self.guildIcon.gameObject:SetActive(true)
      self:UpdateGuildIcon()
    else
      self.guildNameLabel.gameObject:SetActive(false)
      self.guildIcon.gameObject:SetActive(false)
      self.guildTexture.gameObject:SetActive(false)
    end
  end
  local curId = self.data and self.data.id
  if not curId or curId ~= lastId then
    if self.tweens then
      for _, tween in ipairs(self.tweens) do
        tween:Play(true)
        tween:ResetToBeginning()
        tween.enabled = false
      end
    end
    self.isBtnGroupShown = false
  end
  self.memberGO:SetActive(not isEmpty)
  self:SetEmpty()
end

function TeamPwsCustomRoomMemberCell:SetEmpty()
  self.emptyGO:SetActive(self:IsEmpty())
end

function TeamPwsCustomRoomMemberCell:IsEmpty()
  return not self.data or not self.data.id
end

function TeamPwsCustomRoomMemberCell:UpdateGuildIcon()
  if not self.data then
    return
  end
  local guildPortrait = tonumber(self.data.guildportrait)
  if not guildPortrait or guildPortrait <= 0 then
    self.guildIcon.gameObject:SetActive(false)
    self.guildTexture.gameObject:SetActive(false)
  else
    local guildId = self.data.guildid or 0
    local guildHeadData = self.guildHeadData
    guildHeadData:SetGuildId(guildId)
    guildHeadData:SetBy_InfoId(guildPortrait)
    local guildIndex = guildHeadData.index
    local isConfig = guildHeadData.type == GuildHeadData_Type.Config
    if isConfig then
      self.guildIcon.gameObject:SetActive(true)
      self.guildTexture.gameObject:SetActive(false)
      local iconName = guildHeadData.staticData and guildHeadData.staticData.Icon or ""
      IconManager:SetGuildIcon(iconName, self.guildIcon)
    else
      self.guildIcon.gameObject:SetActive(false)
      self.guildTexture.gameObject:SetActive(true)
      local pic = FunctionGuild.Me():GetCustomPicCache(guildId, guildHeadData.index)
      if pic then
        if tonumber(pic.name) == guildHeadData.time then
          self.guildTexture.mainTexture = pic
        else
          self:SetGuildCustomIcon(guildHeadData, self.guildTexture, guildIndex)
        end
      else
        self:SetGuildCustomIcon(guildHeadData, self.guildTexture, guildIndex)
      end
    end
  end
end

function TeamPwsCustomRoomMemberCell:SetGuildCustomIcon(data, texture, index)
  if not data or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(50, 50, TextureFormat.RGB24, false)
    pic.name = data.time
    local bRet = ImageConversion.LoadImage(pic, bytes)
    if not FunctionGuild.Me():GetCustomPicCache(data.guildid, data.index) then
      FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic)
    end
    if index == data.index and texture then
      texture.mainTexture = pic
    end
  end
  local pic_type = data.pic_type
  if StringUtil.IsEmpty(pic_type) then
    pic_type = PhotoFileInfo.PictureFormat.JPG
  end
  UnionLogo.Ins():SetUnionID(data.guildid)
  UnionLogo.Ins():GetOriginImage(UnionLogo.CallerIndex.LogoEditor, data.index, data.time, pic_type, nil, success_callback, nil, nil, nil)
end

function TeamPwsCustomRoomMemberCell:OnCellDestroy()
  self.portraitCell:RemoveIconEvent()
end
