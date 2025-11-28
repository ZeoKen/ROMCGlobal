local BaseCell = autoImport("BaseCell")
TeamMemberCell = class("TeamMemberCell", BaseCell)
autoImport("SelectRoleCell")
local _ZoneIcon = "main_icon_worldline_jm"
local _ServerIcon = "main_icon_The-server2"

function TeamMemberCell:Init()
  self.leadsymbol1 = self:FindGO("leadsymbol1")
  self.leadsymbol2 = self:FindGO("leadsymbol2")
  self.groupleadsymbol1 = self:FindGO("GroupLeadSymbol1")
  self.groupleadsymbol2 = self:FindGO("GroupLeadSymbol2")
  self.name = self:FindComponent("Name", UILabel)
  self.mapname = self:FindComponent("MapName", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.zoneId = self:FindComponent("ZoneId", UILabel)
  self.zoneIconSp = self:FindComponent("Icon", UISprite, self.zoneId.gameObject)
  self.roleTexture = self:FindComponent("RoleTexture", UITexture)
  self.restTip = self:FindGO("RestTip")
  self.restTime = self:FindComponent("RestTime", UILabel)
  self.following = self:FindGO("Following")
  self.inviteFollow = self:FindGO("InviteFollow")
  self.memberState = self:FindGO("MemberState")
  self.addState = self:FindGO("AddState")
  self.addButton = self:FindGO("AddButton")
  self:AddClickEvent(self.addButton, function()
    self:PassEvent(TeamEvent.TeamInviteBtnClick, self)
  end)
  self:AddClickEvent(self.inviteFollow, function()
    if not self:IsEmpty() and TeamProxy.Instance:IsInMyTeam(self.data.id) then
      FunctionTeam.Me():TryInviteMemberFollow(self.data.id, true)
    end
  end)
  self.cancelInviteFollow = self:FindGO("CancelInviteFollow")
  self:AddClickEvent(self.cancelInviteFollow, function(go)
    if not self:IsEmpty() and TeamProxy.Instance:IsInMyTeam(self.data.id) then
      FunctionTeam.Me():TryInviteMemberFollow(self.data.id, false)
    end
  end)
  self.modelCameraConfig = UIModelCameraTrans.Team
  local portraitFrameBGGO = self:FindGO("PortraitFrameBG")
  if portraitFrameBGGO then
    self.portraitFrame = portraitFrameBGGO:GetComponent(UITexture)
    self.effectContainer = self:FindGO("effectContainerBG")
    if self.effectContainer then
      self:DestroyChildren(self.effectContainer)
    end
    portraitFrameBGGO:SetActive(false)
  end
  self.loaded = false
  self.switchBtn = self:FindGO("switchBtn")
  local roleGO = self:FindGO("RoleCell")
  self.roleCell = Team_RoleCell.new(roleGO)
  self.switchOpen = false
  self.switchList = self:FindGO("switchList")
  self.listBg = self:FindGO("listBg", self.switchList):GetComponent(UISprite)
  self.switchgrid = self:FindGO("Grid", self.switchList):GetComponent(UIGrid)
  self.switchCtrl = UIGridListCtrl.new(self.switchgrid, SelectRoleCell, "PersonalRoleCell")
  self.switchCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSwitchRole, self)
  self:AddClickEvent(self.switchBtn, function()
    self.switchOpen = not self.switchOpen
    self:ShowSwitchList(self.switchOpen)
  end)
  self.professionbg = self:FindGO("professionbg")
  self.colorSp = self.professionbg:GetComponent(UISprite)
  self:AddCellClickEvent()
  self.switchRole = self:FindGO("switchRole")
  self:InitRichLabel()
end

function TeamMemberCell:InitRichLabel()
  self.lv = self:FindComponent("Lv", UIRichLabel)
  self.nameSL = SpriteLabel.new(self.lv, nil, 24, 24, true)
end

local CellHeight = 36

function TeamMemberCell:ShowSwitchList(v)
  self.switchList:SetActive(v)
  if v then
    local roles = MyselfProxy.Instance:GetMyTeamRoles()
    self.switchCtrl:ResetDatas(roles)
    local cells = self.switchCtrl:GetCells()
    if cells then
      for i = 1, #cells do
        cells[i]:SetScale(0.45, 0.4)
      end
    end
    self.listBg.height = CellHeight * #roles
  end
end

function TeamMemberCell:HandleSwitchRole(cell)
  if cell and cell.data and self.roleid ~= cell.data then
    local changeOption = {}
    local Op = {
      type = SessionTeam_pb.EMEMBERDATA_FUNCTION,
      value = cell.data
    }
    table.insert(changeOption, Op)
    self.roleCell:SetData(cell.data)
    self.roleid = cell.data
    self.roleCell:SetScale(0.45, 0.4)
    ServiceSessionTeamProxy.Instance:CallSetMemberOptionTeamCmd(nil, changeOption)
  end
  self.switchOpen = not self.switchOpen
  self:ShowSwitchList(self.switchOpen)
end

function TeamMemberCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function TeamMemberCell:SetTeamLeaderSymbol(jobType, isLeaderTeamInGroup)
  if isLeaderTeamInGroup == nil then
    local myTeamData = TeamProxy.Instance.myTeam
    isLeaderTeamInGroup = myTeamData and myTeamData:IsLeaderTeamInGroup()
  end
  if self.leadsymbol1 then
    local isLeader = jobType == SessionTeam_pb.ETEAMJOB_LEADER
    self.leadsymbol1:SetActive(isLeader)
    if self.groupleadsymbol1 then
      self.groupleadsymbol1:SetActive((isLeaderTeamInGroup and isLeader) == true)
    end
  end
  if self.leadsymbol2 then
    local isTmpLeader = jobType == SessionTeam_pb.ETEAMJOB_TEMPLEADER and not self.data.offline
    self.leadsymbol2:SetActive(isTmpLeader)
    if self.groupleadsymbol2 then
      self.groupleadsymbol2:SetActive((isLeaderTeamInGroup and isTmpLeader) == true)
    end
  end
end

function TeamMemberCell:SetData(data)
  self:ActiveCatRestTip(false)
  self.data = data
  if self:IsEmpty() then
    self.addState:SetActive(true)
    self.memberState:SetActive(false)
    self.switchRole:SetActive(false)
    self.roleCell.gameObject:SetActive(false)
  elseif data ~= nil then
    self.addState:SetActive(false)
    self.memberState:SetActive(true)
    self.name.text = AppendSpace2Str(data:GetName())
    local headData = HeadImageData.new()
    headData:TransByTeamMemberData(data)
    local isCat = data:IsHireMember()
    local isOnline = not data:IsOffline()
    local isSameline = data:IsSameline()
    local isSameServer = data:IsSameServer()
    local isRobot = data:IsRobotMember()
    local isTeamNpc = data:IsTeamNpc()
    if isCat then
      self.mapname.gameObject:SetActive(true)
      self.zoneId.gameObject:SetActive(false)
      self.mapname.text = string.format(ZhString.TeamMemberListPopUp_HireTip, tostring(data.mastername))
      self.switchRole:SetActive(false)
      self.roleCell.gameObject:SetActive(false)
      self.professionbg:SetActive(false)
      self.lv.text = "Lv." .. tostring(data.baselv)
    else
      if isRobot then
        self.mapname.gameObject:SetActive(true)
        self.zoneId.gameObject:SetActive(false)
        local leaderData = TeamProxy.Instance:GetLeaderMemberData()
        if leaderData then
          local data = leaderData.mapid and Table_Map[leaderData.mapid]
          self.mapname.text = data and data.NameZh or ""
        else
          self.mapname.text = ""
        end
      elseif isOnline then
        if isSameServer then
          if isSameline then
            self.mapname.gameObject:SetActive(true)
            self.zoneId.gameObject:SetActive(false)
            local data = data.mapid and Table_Map[data.mapid]
            self.mapname.text = data and data.NameZh or ""
          else
            self.mapname.gameObject:SetActive(false)
            self.zoneId.gameObject:SetActive(true)
            self.zoneIconSp.spriteName = _ZoneIcon
            self.zoneId.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid, nil, data.realzoneid)
          end
        else
          self.mapname.gameObject:SetActive(false)
          self.zoneId.gameObject:SetActive(true)
          self.zoneId.text = data:GetServerId()
          self.zoneIconSp.spriteName = _ServerIcon
        end
      else
        self.mapname.gameObject:SetActive(true)
        self.mapname.text = ZhString.TeamMemberCell_Offline
        self.zoneId.gameObject:SetActive(false)
      end
      local proData = Table_Class[data.profession]
      if proData then
        local colorKey = "CareerIconBg" .. proData.Type
        local proColorSave = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
        self.colorSp.color = proColorSave
        self.professionbg:SetActive(true)
        self.nameSL:SetText(string.format("{professionicon=%s}", data.profession) .. "  Lv." .. tostring(data.baselv), true)
        local sp = self.nameSL:GetSprite(0)
        if sp then
          local x, y, z = LuaGameObject.GetLocalPosition(sp.gameObject.transform)
          self.professionbg.transform.localPosition = LuaGeometry.GetTempVector3(x, 2, 0)
        end
      end
    end
    if (isOnline or AfkProxy.ParseIsAfk(data.afk)) and isCat then
      self:UpdateRestTip()
    end
    self:UpdateRoleTexture()
    local bgID = 0
    if self.data.id == Game.Myself.data.id then
      local userdata = Game.Myself.data.userdata
      bgID = userdata:Get(UDEnum.BACKGROUND)
      self.switchRole:SetActive(true)
      self.roleCell.gameObject:SetActive(true)
      self.roleid = self.data.role ~= 0 and self.data.role or MyselfProxy.Instance:GetMyDefaultTeamRole()
      self.roleCell:SetData(self.roleid)
      self.roleCell:SetScale(0.45, 0.4)
    else
      bgID = self.data.background or 0
      self.switchRole:SetActive(false)
      self.roleCell.gameObject:SetActive(not isCat)
      self.roleid = self.data.role ~= 0 and self.data.role or ProfessionProxy.Instance:GetDefaultTeamRoleByPro(self.data.profession)
      self.roleCell:SetData(self.roleid)
      self.roleCell:SetScale(0.45, 0.4)
    end
    self:SetBackgroundFrame(bgID)
    self:SetTeamLeaderSymbol(self.data.job, self.data.groupTeamIndex == 1)
  end
  self:UpdateFollow()
end

local partIndex = Asset_Role.PartIndex
local maskBitIndex = {
  [partIndex.Face] = 0,
  [partIndex.Hair] = 1,
  [partIndex.Mouth] = 2,
  [partIndex.Eye] = 3,
  [partIndex.Head] = 4
}
local helpSet = function(parts, index, dataValue, usedebug)
  if parts == nil or index == nil then
    return false
  end
  local bodyID = parts[partIndex.Body]
  local maskBit = maskBitIndex[index]
  if nil ~= maskBit and bodyID and 0 < bodyID then
    local display = Game.Config_BodyDisplay[bodyID]
    if display and 0 ~= BitUtil.band(display, maskBit) then
      dataValue = 0
    end
  end
  if parts[index] == dataValue then
    return false
  end
  parts[index] = dataValue
  return true
end

function TeamMemberCell:UpdateRoleTexture()
  if self.parts == nil then
    self.parts = Asset_Role.CreatePartArray()
  end
  local dirty = 0
  local partIndexEx = Asset_Role.PartIndexEx
  local class
  if self.data.id == Game.Myself.data.id then
    class = MyselfProxy.Instance:GetMyProfession()
    local userdata = Game.Myself.data.userdata
    if Game.Myself.data:IsAnonymous() then
      local parts = Asset_Role.CreatePartArray()
      local gender = userdata:Get(UDEnum.SEX)
      FunctionAnonymous.Me():GetAnonymousModelParts(class, gender, parts)
      if helpSet(self.parts, partIndex.Body, parts[partIndex.Body] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Hair, parts[partIndex.Hair] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.RightWeapon, parts[partIndex.RightWeapon] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Head, parts[partIndex.Head] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Eye, parts[partIndex.Eye] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mount, 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.Gender, gender or 0) then
        dirty = dirty + 1
      end
      Asset_Role.DestroyPartArray(parts)
    else
      if helpSet(self.parts, partIndex.Body, userdata:Get(UDEnum.BODY) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Hair, userdata:Get(UDEnum.HAIR) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.LeftWeapon, userdata:Get(UDEnum.LEFTHAND) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.RightWeapon, userdata:Get(UDEnum.RIGHTHAND) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Head, userdata:Get(UDEnum.HEAD) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Wing, userdata:Get(UDEnum.BACK) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Face, userdata:Get(UDEnum.FACE) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Tail, userdata:Get(UDEnum.TAIL) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Eye, userdata:Get(UDEnum.EYE) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mount, 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mouth, userdata:Get(UDEnum.MOUTH) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.Gender, userdata:Get(UDEnum.SEX) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.HairColorIndex, userdata:Get(UDEnum.HAIRCOLOR) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.EyeColorIndex, userdata:Get(UDEnum.EYECOLOR) or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.BodyColorIndex, userdata:Get(UDEnum.CLOTHCOLOR) or 0) then
        dirty = dirty + 1
      end
    end
  else
    class = self.data.profession
    if self.data:IsAnonymous() then
      local parts = Asset_Role.CreatePartArray()
      local gender = self.data.gender
      FunctionAnonymous.Me():GetAnonymousModelParts(class, gender, parts)
      if helpSet(self.parts, partIndex.Body, parts[partIndex.Body] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Hair, parts[partIndex.Hair] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.RightWeapon, parts[partIndex.RightWeapon] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Head, parts[partIndex.Head] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Eye, parts[partIndex.Eye] or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mount, 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.Gender, gender or 0) then
        dirty = dirty + 1
      end
      Asset_Role.DestroyPartArray(parts)
    else
      if helpSet(self.parts, partIndex.Body, self.data.body or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Hair, self.data.hair or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.LeftWeapon, self.data.rightWeapon or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.RightWeapon, self.data.leftWeapon or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Head, self.data.head or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Wing, self.data.back or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Face, self.data.face or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Tail, self.data.tail or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Eye, self.data.eye or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mount, 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndex.Mouth, self.data.mouth or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.Gender, self.data.gender or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.HairColorIndex, self.data.haircolor or 0) then
        dirty = dirty + 1
      end
      if helpSet(self.parts, partIndexEx.BodyColorIndex, self.data.bodycolor or 0) then
        dirty = dirty + 1
      end
    end
  end
  if helpSet(self.parts, partIndexEx.LoadFirst, true) then
    dirty = dirty + 1
  end
  if dirty == 0 and not TeamMemberListPopUp.ShowStaticPicture then
    return
  end
  UIModelUtil.Instance:ResetTexture(self.roleTexture)
  local suffixMap = class and Table_Class[class] and Table_Class[class].ActionSuffixMap
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, self.parts, self.modelCameraConfig, nil, nil, TeamMemberListPopUp.ShowStaticPicture, suffixMap, function(obj)
    self.model = obj
    self.uiModelCell = UIModelUtil.Instance:GetUIModelCell(self.roleTexture)
    self:RefreshBuffState()
  end)
end

function TeamMemberCell:UpdateRestTip()
  local resttime, expiretime = 0, 0
  if self.data then
    resttime = self.data.resttime or 0
    expiretime = self.data.expiretime or 0
  end
  local curtime = ServerTime.CurServerTime() / 1000
  if expiretime ~= 0 and expiretime <= curtime then
    self.restTip:SetActive(true)
    self.restTime.text = ZhString.TeamMemberCell_Expire
  else
    self:ActiveCatRestTip(resttime ~= 0 and resttime > curtime)
  end
end

function TeamMemberCell:ActiveCatRestTip(b)
  if b then
    self.restTip:SetActive(true)
    if not self.restTimeTick then
      self.restTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRestTime, self)
    end
  else
    self.restTip:SetActive(false)
    self:RemoveRestTimeTick()
  end
end

function TeamMemberCell:UpdateRestTime()
  local resttime = self.data and self.data.resttime
  resttime = resttime or 0
  local restSec = resttime - ServerTime.CurServerTime() / 1000
  if 0 < restSec then
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restSec)
    self.restTime.text = ZhString.TeamMemberCell_CatRest .. string.format("%02d:%02d", min, sec)
  else
    self:ActiveCatRestTip(false)
  end
end

function TeamMemberCell:RemoveRestTimeTick()
  if self.restTimeTick then
    TimeTickManager.Me():ClearTick(self)
    self.restTimeTick = nil
  end
end

function TeamMemberCell:UpdateFollow()
  if self:IsEmpty() or not TeamProxy.Instance:IsInMyTeam(self.data.id) then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  if self.data:IsHireMember() or self.data:IsRobotMember() or self.data:IsTeamNpc() then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  if self.data.id == Game.Myself.data.id then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  if self.data:IsOffline() then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  local followers = Game.Myself:Client_GetAllFollowers()
  if followers == nil then
    self.following:SetActive(false)
    self.inviteFollow:SetActive(false)
    return
  end
  if not followers[self.data.id] then
    self.inviteFollow:SetActive(true)
    self.following:SetActive(false)
  else
    self.inviteFollow:SetActive(false)
    self.following:SetActive(true)
  end
end

function TeamMemberCell:UpdateMemberPos()
end

function TeamMemberCell:IsEmpty()
  return self.data == nil or self.data == MyselfTeamData.EMPTY_STATE or self.data == MyselfTeamData.EMPTY_STATE_GROUP
end

function TeamMemberCell:OnRemove()
  if self.parts then
    Asset_Role.DestroyPartArray(self.parts)
    self.parts = nil
  end
  self:RemoveRestTimeTick()
end

function TeamMemberCell:SetBackgroundFrame(id)
  if not self.portraitFrame then
    return
  end
  self:SetBackground(id)
  if id then
    local data = Table_UserBackground[id]
    if data then
      PictureManager.Instance:SetPVP(data.Icon, self.portraitFrame)
      if not self.portraitFrame.gameObject.activeInHierarchy then
        self.portraitFrame.gameObject:SetActive(true)
      end
      if not self.loaded then
        self:PlayEffectByFullPath("UI/" .. data.Effect, self.effectContainer)
        self.loaded = true
      end
      if not self.effectContainer.activeInHierarchy then
        self.effectContainer:SetActive(true)
      end
      return
    end
  end
  self.portraitFrame.gameObject:SetActive(false)
  self.effectContainer:SetActive(false)
  IconManager:SetUIIcon("", self.portraitFrame)
end

function TeamMemberCell:DestroyChildren(obj)
  local objNil = Game.GameObjectUtil:ObjectIsNULL(obj)
  if not objNil then
    local childCount = obj.transform.childCount
    if 0 < childCount then
      for i = 0, childCount - 1 do
        GameObject.DestroyImmediate(obj.transform:GetChild(i).gameObject)
      end
    end
  end
  return not objNil
end

function TeamMemberCell:SetBackground(id)
  local frameBG = Table_UserBackground[id] and Table_UserBackground[id].Background
  if frameBG then
    UIModelUtil.Instance:ChangeBGMeshRenderer(frameBG, self.roleTexture)
  else
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTexture)
  end
end

function TeamMemberCell:OnDestroy()
  if self.roleTexture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.roleTexture)
  end
  EventManager.Me():RemoveEventListener(TeamEvent.TeamOption_SelectRole, self.HandleSwitchRole, self)
  self:RemoveRestTimeTick()
  self.buffEffects = nil
end

function TeamMemberCell:RefreshBuffState()
  if not self.buffEffects then
    self.buffEffects = {}
  end
  if not self.containBuffPart then
    self.containBuffPart = {}
  end
  local hasBuffEffect = false
  local parts = self.parts
  for _partType, _index in pairs(Asset_Role.PartIndex) do
    local _id = parts and parts[_index] or 0
    if _id and self.containBuffPart[_index] and self.containBuffPart[_index] ~= _id then
      xdlog("移除特效")
      local effList = self.buffEffects[_index] or {}
      for i = #effList, 1, -1 do
        effList[i]:Destroy()
        effList[i] = nil
      end
    end
    if 0 < _id and (not self.containBuffPart[_index] or self.containBuffPart[_index] ~= _id) then
      hasBuffEffect = true
      local equipData = Table_Equip[_id]
      local fashionBuff = equipData and equipData.FashionBuff
      if fashionBuff and 0 < #fashionBuff then
        self.containBuffPart[_index] = _id
        for i = 1, #fashionBuff do
          local buffData = Table_Buffer[fashionBuff[i]]
          local buffStateID = buffData and buffData.BuffStateID
          if buffStateID then
            local buffStateData = Table_BuffState[buffStateID]
            local path = buffStateData.Effect
            local eff = self.model:PlayEffectOn(path, buffStateData.EP)
            if not self.buffEffects[_index] then
              self.buffEffects[_index] = {}
            end
            xdlog("添加特效", _index, path)
            table.insert(self.buffEffects[_index], eff)
          end
        end
      end
    end
  end
  if hasBuffEffect then
    self.uiModelCell:SetCameraCulling({
      LayerMask.NameToLayer("UIModel"),
      LayerMask.NameToLayer("UIModelOutline"),
      LayerMask.NameToLayer("Outline"),
      LayerMask.NameToLayer("Default")
    })
  end
end
