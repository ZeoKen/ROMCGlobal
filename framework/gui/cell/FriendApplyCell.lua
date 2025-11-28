autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
FriendApplyCell = class("FriendApplyCell", baseCell)

function FriendApplyCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:AddCellClickEvent()
end

function FriendApplyCell:FindObjs()
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(1)
  self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
  self.Level = self:FindGO("Level"):GetComponent(UILabel)
  self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UIMultiSprite)
  self.FriendName = self:FindGO("FriendName"):GetComponent(UILabel)
  self.Bg = self:FindGO("Bg")
  self.serverGO = self:FindGO("ServerGO")
  self.serverID = self:FindGO("ServerId"):GetComponent(UILabel)
  self.zoneGo = self:FindGO("ZoneGO")
  self.zoneId = self:FindGO("ZoneId"):GetComponent(UILabel)
  self.cheatMark = self:FindGO("CheatMark")
end

function FriendApplyCell:AddButtonEvt()
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(FriendEvent.SelectHead, self)
  end)
  local searchFriendBtn = self:FindGO("SearchFriendBtn")
  self:AddClickEvent(searchFriendBtn, function(g)
    self:SearchFriend(g)
  end)
  local addFriendBtn = self:FindGO("AddFriendBtn")
  self:AddClickEvent(addFriendBtn, function(g)
    self:AddFriend(g)
  end)
  local ignoreFriendBtn = self:FindGO("IgnoreFriendBtn")
  self:AddClickEvent(ignoreFriendBtn, function(g)
    self:IgnoreFriend(g)
  end)
end

local friend = {}

function FriendApplyCell:AddFriend()
  FunctionPlayerTip.CallAddFriend(self.data.guid, self.data.name)
end

function FriendApplyCell:IgnoreFriend()
  ServiceSessionSocialityProxy.Instance:CallRemoveRelation(self.data.guid, SocialManager.PbRelation.Apply)
end

function FriendApplyCell:SearchFriend()
  ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(self.data.guid, nil, ChatCmd_pb.EUSERINFOTYPE_CHAT)
end

function FriendApplyCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.Profession)
      local iconColor = ColorUtil["CareerIconBg" .. config.Type]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professIconBG.color = iconColor
    end
    self.Level.text = "Lv." .. data.level
    if data.portrait and data.portrait ~= 0 then
      local headData = Table_HeadImage[data.portrait]
      if headData and headData.Picture then
        self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
        self.headIcon:SetPortraitFrame(data.portraitframe)
      end
    else
      self.headIcon:SetData(data)
    end
    if data.gender == ProtoCommon_pb.EGENDER_MALE then
      self.GenderIcon.CurrentState = 0
    elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
      self.GenderIcon.CurrentState = 1
    end
    self.GenderIcon:MakePixelPerfect()
    self.FriendName.text = data.name
    self.FriendName.text = AppendSpace2Str(data.name)
    local ERedSys = SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY
    local isNew = RedTipProxy.Instance:IsNew(ERedSys, data.guid)
    if isNew then
      self:RegisterRedTip(ERedSys)
    end
    if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
      self.zoneGo:SetActive(false)
      self.serverGO:SetActive(true)
      self.serverID.text = data.serverid
    elseif data.zoneid and data.zoneid ~= 0 and data.zoneid ~= MyselfProxy.Instance:GetZoneId() then
      self.serverGO:SetActive(false)
      self.zoneGo:SetActive(true)
      self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
    else
      self.serverGO:SetActive(false)
      self.zoneGo:SetActive(false)
    end
    self.cheatMark:SetActive(data.cheatMark)
  end
end

function FriendApplyCell:RegisterRedTip(key)
  RedTipProxy.Instance:RegisterUI(key, self.Bg, 10, {-2, -6})
end
