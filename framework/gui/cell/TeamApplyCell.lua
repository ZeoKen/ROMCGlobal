local BaseCell = autoImport("BaseCell")
TeamApplyCell = class("TeamApplyCell", BaseCell)
autoImport("PlayerFaceCell")
autoImport("Team_RoleCell")

function TeamApplyCell:Init()
  self.teamApplyRoot = self:FindGO("TeamApplyRoot")
  self.teamGroupApplyRoot = self:FindGO("TeamGroupApplyRoot")
  local portrait = self:FindGO("HeadCell")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self:AddClickEvent(self.portraitCell.headIconCell.clickObj.gameObject, function()
    if self.data then
      local ptdata = PlayerTipData.new()
      ptdata:SetByTeamMemberData(self.data)
      local tipData = {
        playerData = ptdata,
        funckeys = {"ShowDetail"}
      }
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.portraitCell.headIconCell.clickObj, NGUIUtil.AnchorSide.Left, {-600, 100})
      playerTip:SetData(tipData)
      
      function playerTip.clickcallback(funcData)
        if funcData.key == "SendMessage" then
          self.eventType = "CloseUI"
          self:PassEvent(MouseEvent.MouseClick, self)
        end
      end
    end
  end)
  self.name = self:FindComponent("Name", UILabel)
  self.level = self:FindComponent("Level", UILabel)
  self.profession = self:FindComponent("Profession", UILabel)
  self.GroupTeamApplyRoot = self:FindGO("TeamGroupApplyRoot")
  local groupAgreeBtnLab = self:FindComponent("AgreeGroupButtonLab", UILabel)
  groupAgreeBtnLab.text = ZhString.TeamApplyListPopUp_GroupApply
  self.groupTeamMemberNum = self:FindComponent("GroupTeamMemNum", UILabel)
  self:AddButtonEvent("AgreeGroupButton", function(go)
    if Game.MapManager:IsPVPMode_TeamPws() then
      MsgManager.ShowMsgByIDTable(25930)
      return
    end
    if self.data then
      ServiceSessionTeamProxy.Instance:CallProcessGroupApplyTeamCmd(SessionTeam_pb.ETEAMAPPLYTYPE_AGREE, self.data.id)
    end
  end)
  self:AddButtonEvent("SearchBtn", function(go)
    local applyData = self.data
    if applyData then
      ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(applyData.id, nil, ChatCmd_pb.EUSERINFOTYPE_CHAT)
    end
  end)
  self:AddButtonEvent("AgreeBtn", function(go)
    if Game.MapManager:IsPVPMode_TeamPws() then
      MsgManager.ShowMsgByIDTable(25930)
      return
    end
    local applyData = self.data
    if applyData then
      ServiceSessionTeamProxy.Instance:CallProcessTeamApply(SessionTeam_pb.ETEAMAPPLYTYPE_AGREE, applyData.id)
    end
  end)
  self:AddButtonEvent("RefuseBtn", function(go)
    local applyData = self.data
    if applyData then
      ServiceSessionTeamProxy.Instance:CallProcessTeamApply(SessionTeam_pb.ETEAMAPPLYTYPE_DISAGREE, applyData.id)
    end
  end)
  self.zone = self:FindGO("Zone")
  self.zoneid = self:FindComponent("ZoneId", UILabel, self.zone)
  self.zoneIconSp = self:FindComponent("ZoneIcon", UISprite, self.zone)
  self.querytypeImg = self:FindComponent("querytype", UISprite)
  self.diffServerObj = self:FindGO("ServerGO")
  self.diffServerIcon = self:FindGO("ServerIcon", self.diffServerObj)
  self.diffServerId = self:FindComponent("ServerId", UILabel, self.diffServerObj)
  self.groupDiffServer = self:FindGO("GroupDiffServer")
  self.teamRole = self:FindGO("TeamRole")
  self.roleCell = Team_RoleCell.new(self.teamRole)
end

function TeamApplyCell:SetData(data)
  self.data = data
  if data then
    if data.memNum then
      self:Show(self.teamGroupApplyRoot)
      self:Hide(self.teamApplyRoot)
      self.groupTeamMemberNum.text = data.memNum .. "/" .. GameConfig.Team.maxmember
      local isDiffServer = MyselfProxy.Instance:IsSameServer(data.serverid)
      self.groupDiffServer:SetActive(isDiffServer)
    else
      self:Hide(self.teamGroupApplyRoot)
      self:Show(self.teamApplyRoot)
      self.level.text = "Lv." .. data.baselv
      if Table_Class[data.profession] then
        self.profession.text = ProfessionProxy.GetProfessionNameFromSocialData(data)
      end
      local headData = HeadImageData.new()
      headData:TransByTeamMemberData(data)
      self.portraitCell:SetData(headData)
      self.roleCell:SetData(data.role or ProfessionProxy.Instance:GetDefaultTeamRoleByPro(data.profession))
      self.roleCell:SetScale(0.45, 0.5)
      if data:IsSameServer() then
        self.diffServerObj:SetActive(false)
        self.zone:SetActive(true)
        local zone = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid, nil, data.realzoneid)
        self.zone:SetActive(zone ~= "" and not data:IsSameline())
        self.zoneid.text = zone
      else
        self.diffServerObj:SetActive(true)
        self.zone:SetActive(false)
        self.diffServerId.text = tostring(data:GetServerId())
        self.diffServerIcon.transform.localPosition = LuaGeometry.GetTempVector3(-9, 0, 0)
      end
      self.zoneIconSp:MakePixelPerfect()
    end
    self.name.text = data.name
  end
end

local isOpen

function TeamApplyCell:SetOpenInfoFlag(data)
  if data.querytype then
    if data.querytype == SceneUser2_pb.EQUERYTYPE_ALL then
      isOpen = true
    elseif data.querytype == SceneUser2_pb.EQUERYTYPE_FRIEND then
      isOpen = FriendProxy.Instance:IsFriend(data.id)
    else
      isOpen = false
    end
  else
    isOpen = false
  end
  self.querytypeImg.spriteName = isOpen and "" or ""
end
