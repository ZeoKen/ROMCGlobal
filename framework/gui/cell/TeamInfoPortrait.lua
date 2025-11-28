autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
TeamInfoPortrait = class("TeamInfoPortrait", baseCell)

function TeamInfoPortrait:Init()
  self:FindObjs()
  self:InitShow()
end

function TeamInfoPortrait:FindObjs()
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.gameObject)
  self.headIcon:SetScale(0.68)
  self.headIcon:SetMinDepth(1)
  self.professionRoot = self:FindGO("profession")
  self.professionColor = self:FindGO("Color", self.professionRoot):GetComponent(UISprite)
  self.professionIcon = self:FindGO("Icon", self.professionRoot):GetComponent(UISprite)
  self.leaderSymbol = self:FindGO("LeaderSymbol")
  self.playerTipInitData = {}
  self.empty = self:FindGO("Empty")
end

function TeamInfoPortrait:InitShow()
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    if self.data and self.data ~= TeamInfoPopup.emptyMD then
      self:OnClickRankMember()
    end
  end)
end

local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "AddBlacklist",
  "InviteMember",
  "InviteEnterGuild",
  "GuildMercenaryInvite",
  "GuildMercenaryApply",
  "Tutor_InviteBeStudent"
}
local playerTip_Offline = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "AddBlacklist",
  "InviteMember",
  "InviteEnterGuild",
  "Tutor_InviteBeStudent"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail",
  "AddBlacklist",
  "InviteMember",
  "InviteEnterGuild",
  "GuildMercenaryInvite",
  "GuildMercenaryApply",
  "Tutor_InviteBeStudent"
}
local playerTipFunc_Friend_Offline = {
  "SendMessage",
  "ShowDetail",
  "AddBlacklist",
  "InviteMember",
  "InviteEnterGuild",
  "Tutor_InviteBeStudent"
}
local playerTipOffset = {-40, 18}

function TeamInfoPortrait:OnClickRankMember()
  if self.data.id == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    return
  end
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByTeamMemberData(self.data)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  local funckeys
  if FriendProxy.Instance:IsFriend(self.data.id) then
    funckeys = self.data and not self.data.offline and playerTipFunc_Friend or playerTipFunc_Friend_Offline
  else
    funckeys = self.data and not self.data.offline and playerTipFunc or playerTip_Offline
  end
  self.playerTipInitData.funckeys = funckeys
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(self.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end
end

function TeamInfoPortrait:SetData(data)
  self.data = data
  if data then
    if TeamInfoPopup.emptyMD == data then
      self.empty:SetActive(true)
      self.leaderSymbol:SetActive(false)
      self.professionRoot:SetActive(false)
      return
    end
    self.empty:SetActive(false)
    self.professionRoot:SetActive(true)
    self.leaderSymbol:SetActive(data.job == SessionTeam_pb.ETEAMJOB_LEADER or data.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER)
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.professionIcon)
      local iconColor = ColorUtil["CareerIconBg" .. config.Type]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professionColor.color = iconColor
    end
    local headData = Table_HeadImage[data.portrait]
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
    else
      local headImageData = HeadImageData.new()
      headImageData:TransByTeamMemberData(data)
      if headImageData.iconData.type == HeadImageIconType.Avatar then
        self.headIcon:SetData(headImageData.iconData)
      elseif headImageData.iconData.type == HeadImageIconType.Simple then
        self.headIcon:SetSimpleIcon(headImageData.iconData.icon, headImageData.iconData.frameType)
      end
      self.headIcon:SetActive(not headImageData.offline, true)
    end
  end
end
