autoImport("FriendBaseCell")
autoImport("TeamInvitee")
FriendInfoCell = class("FriendInfoCell", FriendBaseCell)
local BlueColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function FriendInfoCell:Init()
  self.invitee = TeamInvitee.new()
  self:FindObjs()
  self:AddButtonEvt()
  self:InitShow()
  self:AddCellClickEvent()
  self:AddEvents()
end

function FriendInfoCell:FindObjs()
  FriendInfoCell.super.FindObjs(self)
  self.cellContainer = self:FindGO("CellContainer")
  self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildIconGO = self.GuildIcon.gameObject
  self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.recallBtn = self:FindGO("RecallBtn"):GetComponent(UISprite)
  self.recallBtnGO = self.recallBtn.gameObject
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.maskSP = self:FindGO("FavoriteMask"):GetComponent(UISprite)
  self.BtnContainer = self:FindGO("BtnContainer")
end

function FriendInfoCell:OnDestroy()
  FriendInfoCell.super.OnDestroy(self)
  self:RemoveEvents()
end

function FriendInfoCell:AddEvents()
  EventManager.Me():AddEventListener(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, self.HandleQueryUserTeamInfo, self)
end

function FriendInfoCell:RemoveEvents()
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, self.HandleQueryUserTeamInfo, self)
end

function FriendInfoCell:HandleQueryUserTeamInfo(evt)
  if not self.fromCellInviteBtn then
    return
  end
  local data = evt.data
  if data.charid ~= self.guid then
    return
  end
  self.fromCellInviteBtn = nil
  self.invitee:SetId(data.charid, nil)
  self.invitee:SetTeamInfo(data)
  FunctionTeamInvite.Me():InviteMember(self.invitee)
end

function FriendInfoCell:AddButtonEvt()
  self:AddClickEvent(self.recallBtnGO, function()
    self:Recall()
  end)
  local teamBtn = self:FindGO("teamBtn")
  self:AddClickEvent(teamBtn, function()
    self:CheckInviteMember()
  end)
  local chatBtn = self:FindGO("chatBtn")
  self:AddClickEvent(chatBtn, function()
    self:SendMessage()
  end)
end

function FriendInfoCell:SetData(data)
  if data and data.guid then
    self.guid = data.guid
    self.invitee:SetId(self.guid, nil)
    FriendInfoCell.super.SetData(self, data)
    if self.maskSP then
      self.maskSP.enabled = false
    end
    self.cellContainer:SetActive(true)
    if data.guildname ~= "" then
      self.guildIconGO:SetActive(true)
      self.GuildName.text = data.guildname
      self.GuildName.color = BlueColor
      local guildportrait = tonumber(data.guildportrait) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.GuildIcon)
    else
      self.guildIconGO:SetActive(false)
      self.GuildName.text = ZhString.Friend_EmptyGuild
      ColorUtil.GrayUIWidget(self.GuildName)
    end
    local canRecall = data:CheckCanRecall()
    self.recallBtnGO:SetActive(canRecall)
    if canRecall then
      self:SetRecall(data.recall)
    end
    self:UpdateFavoriteTip()
    self.BtnContainer:SetActive(data.offlinetime == 0 or AfkProxy.ParseIsAfk(data.afk))
    if self.offlineTip then
      self.offlineTip.gameObject:SetActive(data.offlinetime ~= 0 and not AfkProxy.ParseIsAfk(data.afk))
    end
  else
    self.cellContainer:SetActive(false)
  end
end

function FriendInfoCell:SetRecall(bRecall)
  if bRecall then
    ColorUtil.DeepGrayUIWidget(self.recallBtn)
  else
    ColorUtil.WhiteUIWidget(self.recallBtn)
  end
end

function FriendInfoCell:Recall()
  if self.data ~= nil then
    if self.data.recall then
      MsgManager.ShowMsgByID(3620)
      return
    end
    if #FriendProxy.Instance:GetContractData() > GameConfig.Recall.max_recall_count then
      MsgManager.ConfirmMsgByID(3621, function()
        self:JumpShareView()
      end)
    else
      self:JumpShareView()
    end
  end
end

function FriendInfoCell:JumpShareView()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RecallShareView,
    viewdata = self.data
  })
end

function FriendInfoCell:UpdateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  if FriendProxy.Instance:CheckIsFavorite(self.guid) then
    self.favoriteTip:SetActive(true)
  else
    self.favoriteTip:SetActive(false)
  end
end

function FriendInfoCell:SetFavoriteTipActive(isActive)
  if not self.favoriteTip then
    return
  end
  isActive = isActive and true or false
  self.favoriteTip:SetActive(isActive)
end

function FriendInfoCell:GetFavoriteTipActive()
  if not self.favoriteTip then
    return nil
  end
  return self.favoriteTip.activeSelf
end

function FriendInfoCell:NegateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self:SetFavoriteTipActive(not self:GetFavoriteTipActive())
end

function FriendInfoCell:ShowMask()
  if self.maskSP then
    self.maskSP.enabled = true
  end
end

function FriendInfoCell:HideMask()
  if self.maskSP then
    self.maskSP.enabled = false
  end
end

function FriendInfoCell:CheckInviteMember()
  if TeamProxy.Instance:IsInMyGroup(self.guid) then
    MsgManager.ShowMsgByIDTable(333)
    return false
  else
    self.fromCellInviteBtn = true
    ServiceSessionTeamProxy.Instance:CallQueryUserTeamInfoTeamCmd(self.guid)
    return true
  end
end

function FriendInfoCell:SendMessage()
  local tempArray = ReusableTable.CreateArray()
  tempArray[1] = self.guid
  ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
  ReusableTable.DestroyArray(tempArray)
  local ptdata = PlayerTipData.new()
  ptdata:SetByFriendData(self.data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    viewdata = {
      key = "PrivateChat"
    }
  })
  GameFacade.Instance:sendNotification(ChatRoomEvent.UpdateSelectChat, ptdata)
end
