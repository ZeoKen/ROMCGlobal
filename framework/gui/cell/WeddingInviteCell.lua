local baseCell = autoImport("BaseCell")
WeddingInviteCell = class("WeddingInviteCell", baseCell)

function WeddingInviteCell:Init()
  self:FindObjs()
  self:InitShow()
end

function WeddingInviteCell:FindObjs()
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.68)
  self.headIcon:SetMinDepth(1)
  self.profession = self:FindGO("Profession"):GetComponent(UISprite)
  self.professionColor = self:FindGO("Color", self.profession.gameObject):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.level = self:FindGO("Level"):GetComponent(UILabel)
  self.professionName = self:FindGO("ProfessionName"):GetComponent(UILabel)
  self.invited = self:FindGO("Invited")
  self.inviteBtn = self:FindGO("InviteBtn"):GetComponent(UIMultiSprite)
  self.inviteBtnLabel = self:FindGO("Label", self.inviteBtn.gameObject):GetComponent(UILabel)
  self.zone = self:FindGO("Zone"):GetComponent(UILabel)
  self.zoneGO = self.zone.gameObject
  self.server = self:FindGO("Server"):GetComponent(UILabel)
  self.serverGO = self.server.gameObject
end

function WeddingInviteCell:InitShow()
  self:AddClickEvent(self.inviteBtn.gameObject, function()
    if self.data ~= nil and not self.data.isInvited then
      local temp = ReusableTable.CreateArray()
      temp[1] = self.data.guid
      WeddingProxy.Instance:CallWeddingInviteCCmd(temp)
      ReusableTable.DestroyArray(temp)
    end
  end)
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(WeddingEvent.Select, self)
  end)
end

function WeddingInviteCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local sb = LuaStringBuilder.CreateAsTable()
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      sb:Append("CareerIconBg")
      sb:Append(config.Type)
      local iconColor = ColorUtil[sb:ToString()]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professionColor.color = iconColor
      self.professionName.text = ProfessionProxy.GetProfessionNameFromSocialData(data)
    end
    local headData = Table_HeadImage[data.portrait]
    data.eyeID = self:GetEyeID(data.eyeID, data.profession, data.gender)
    if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
    else
      self.headIcon:SetData(data)
    end
    self.name.text = data.name
    sb:Clear()
    sb:Append("Lv. ")
    sb:Append(data.level)
    self.level.text = sb:ToString()
    sb:Destroy()
    if data.isInvited then
      self.inviteBtn.CurrentState = 1
      self.inviteBtnLabel.effectStyle = UILabel.Effect.None
      self.inviteBtnLabel.text = ZhString.TeamInviteMembCell_Invited
    else
      self.inviteBtn.CurrentState = 0
      self.inviteBtnLabel.effectStyle = UILabel.Effect.Outline
      self.inviteBtnLabel.text = ZhString.TeamInviteMembCell_Invite
    end
    if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
      self.zoneGO:SetActive(false)
      self.serverGO:SetActive(true)
      self.server.text = data.serverid
    else
      self.serverGO:SetActive(false)
      if data.zoneid and data.zoneid ~= 0 and MyselfProxy.Instance:GetZoneId() ~= data.zoneid then
        self.zoneGO:SetActive(true)
        self.zone.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
      else
        self.zoneGO:SetActive(false)
      end
    end
  end
end

function WeddingInviteCell:GetEyeID(eyeid, profession, gender)
  if 0 == eyeid then
    if PlayerData.CheckRace(profession, ECHARRACE.ECHARRACE_CAT) then
      return 3
    elseif gender == ProtoCommon_pb.EGENDER_MALE then
      return 1
    else
      return 2
    end
  else
    return eyeid
  end
end
