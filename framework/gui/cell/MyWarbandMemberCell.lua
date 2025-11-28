autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
MyWarbandMemberCell = class("MyWarbandMemberCell", BaseCell)

function MyWarbandMemberCell:Init()
  local portrait = self:FindGO("Portrait")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self.portraitCell:AddEventListener(MouseEvent.MouseClick, self.OnClickPortrait, self)
  self.portraitCell:SetMinDepth(4)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.leader = self:FindGO("Leader")
  self.memberState = self:FindGO("MemberState")
  self.addState = self:FindGO("AddState")
  self.inviteBtn = self:FindGO("InviteButton")
  self.inviteLab = self:FindComponent("InviteLab", UILabel, self.inviteBtn)
  self.inviteLab.text = ZhString.Warband_Member_Invite
  self.readyFlag = self:FindGO("Ready")
  self.kickBtn = self:FindGO("Kick")
  self.genderSp = self:FindComponent("Gender", UISprite)
  self.proxy = WarbandProxy.Instance
  self:AddClickEvent(self.kickBtn, function()
    self.proxy:DoKickMember(self.data.id, self.data.name)
  end)
  self:AddCellClickEvent()
end

function MyWarbandMemberCell:OnClickPortrait()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function MyWarbandMemberCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.kickBtn:SetActive(false)
  if self:IsEmpty() then
    self.memberState:SetActive(false)
    self.inviteBtn:SetActive(true)
    self.leader:SetActive(false)
    self.bg.atlas = RO.AtlasMap.GetAtlas("NewCom")
    self.bg.spriteName = "com_bg_bottom5"
  elseif nil ~= data then
    self.inviteBtn:SetActive(false)
    self.memberState:SetActive(true)
    self.lv.text = "Lv." .. tostring(data.level)
    self.name.text = data.name
    local headData = HeadImageData.new()
    headData:TransByWarbandData(data)
    self.portraitCell:SetData(headData)
    self.portraitCell:SetIconActive(not data:IsOffline(), true)
    self.readyFlag:SetActive(data.prepare)
    self.genderSp.spriteName = data.gender == ProtoCommon_pb.EGENDER_MALE and "friend_icon_man" or "friend_icon_woman"
    local isMe = data:IsMe()
    self.bg.atlas = isMe and RO.AtlasMap.GetAtlas("NewUI5") or RO.AtlasMap.GetAtlas("NewCom")
    self.bg.spriteName = isMe and "12pvp_CupMatch_bg" or "com_bg_bottom5"
    self.leader:SetActive(data.isCaptial == true)
  end
end

function MyWarbandMemberCell:SetEditorMode(enterDelModel, proxyIns)
  self.kickBtn:SetActive(enterDelModel and self.data.id ~= Game.Myself.data.id)
  self.proxy = proxyIns or self.proxy
end

function MyWarbandMemberCell:IsEmpty()
  return self.data == MyWarbandTeamData.EMPTY
end

function MyWarbandMemberCell:AddIconEvent()
  if self.portraitCell then
    self.portraitCell:AddIconEvent()
  end
end

function MyWarbandMemberCell:RemoveIconEvent()
  if self.portraitCell then
    self.portraitCell:RemoveIconEvent()
  end
end

function MyWarbandMemberCell:OnRemove()
  self:RemoveIconEvent()
end
