autoImport("BaseTip")
autoImport("UIEmojiCell")
PlayerTip = class("PlayerTip", BaseTip)
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.Zero()

function PlayerTip:Init()
  self:InitTip()
  self:AddListener()
end

function PlayerTip:InitTip()
  local cellObj = self:FindGO("HeadFace")
  self.faceCell = PlayerFaceCell.new(cellObj)
  self.faceCell:HideHpMp()
  self.idObj = self:FindGO("Id")
  self.bg = self:FindComponent("Bg", UISprite)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.guildName = self:FindComponent("GuildName", UILabel)
  self.guildIcon = self:FindComponent("GuildIcon", UISprite)
  self.birthdayTip = self:FindGO("BirthDayTip")
  self.constellationIcon = self:FindGO("ConstellationIcon"):GetComponent(UISprite)
  self.constellationIcon.gameObject:SetActive(false)
  self.id = self.idObj:GetComponent(UILabel)
  self.idlabel = self:FindComponent("Label", UILabel, self.idObj)
  self.labExpireTime = self:FindComponent("labExpireTime", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.m_funcBtnRoot = self:FindGO("FuncBtnPart")
  self.m_scrollView = self:FindGO("funcBtn/uiScrollView"):GetComponent(UIScrollView)
  self.grid = self:FindComponent("funcBtn/uiScrollView/FuncGrid", UIGrid)
  self.funcCtl = UIGridListCtrl.new(self.grid, RClickFuncCell, "PlayerTipFuncCell")
  self.funcCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self.socialPart = self:FindGO("SocialPart")
  self.sgrid = self:FindComponent("SocialGrid", UIGrid)
  self.socialCtl = UIGridListCtrl.new(self.sgrid, SocialIconCell, "SocialIconCell")
  self.socialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self:InitChildBord()
  self.favoriteTip = self:FindGO("FavoriteTip")
  if self.favoriteTip then
    self.favoriteSp = self.favoriteTip:GetComponent(UISprite)
    self:AddClickEvent(self.favoriteTip, function()
      self:OnFavoriteClick()
    end)
  end
  self.server = self:FindGO("Server")
  self.serverLabel = self:FindGO("ServerLabel", self.server):GetComponent(UILabel)
  self.m_scrollView:ResetPosition()
  self.infoTable = self:FindGO("InfoTable"):GetComponent(UITable)
  self.profilePart = self:FindGO("ProfilePart")
  self.tagsPart = self:FindGO("Tags")
  self.tags = {}
  for i = 1, 3 do
    self.tags[i] = {}
    self.tags[i].go = self:FindGO("Tag" .. i)
    self.tags[i].label = self.tags[i].go:GetComponent(UILabel)
    self.tags[i].go:SetActive(false)
  end
  self.tagsPart:SetActive(false)
  self.signLabel = self:FindGO("SignLabel", self.profilePart):GetComponent(UILabel)
  self.fatePart = self:FindGO("FatePart")
  self.fateIcon = self:FindGO("FateIcon", self.fatePart):GetComponent(UISprite)
  self.fateLabel = self:FindGO("FateLabel", self.fatePart):GetComponent(UILabel)
  self.friendApplyPart = self:FindGO("FriendApplyPart", self.profilePart)
  self.talkBtn = self:FindGO("TalkBtn", self.profilePart)
  self.friendApplyTip = self:FindGO("FriendApplyTip"):GetComponent(UILabel)
  self:AddClickEvent(self.talkBtn, function()
    local tempArray = ReusableTable.CreateArray()
    tempArray[1] = self.playerTipData.id
    ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
    ReusableTable.DestroyArray(tempArray)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatRoomPage,
      viewdata = {
        key = "PrivateChat"
      }
    })
    GameFacade.Instance:sendNotification(ChatRoomEvent.UpdateSelectChat, self.playerTipData)
    if self.profileData and self.profileData.needpartner then
      local dialogID = GameConfig.FriendApplyMessage and GameConfig.FriendApplyMessage[self.profileData.needpartner].DialogID
      if dialogID and 0 < #dialogID then
        local targetDialogID = dialogID[math.random(1, #dialogID)]
        local dialogData = DialogUtil.GetDialogData(targetDialogID)
        GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendMessageEvent, dialogData.Text)
      end
    end
  end)
  self.GMEPart = self:FindGO("voice")
  self.GMEState1 = self:FindGO("voice/state1")
  self.GMEState2 = self:FindGO("voice/state2")
  self.GMEState3 = self:FindGO("voice/state3")
  self.m_gmeSpeaker = self:FindGO("voice/state1/Sprite"):GetComponent(UISprite)
end

function PlayerTip:AddListener()
  EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryProfileUserEvent, self.HandleQueryUserInfo, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventSyncFateRelationEvent, self.HandleFateRelation, self)
end

function PlayerTip:AcitiveIdObj(b)
  self.idObj:SetActive(b)
end

function PlayerTip:ActiveCatExpireTimeObj(b)
  self.labExpireTime.gameObject:SetActive(b)
end

function PlayerTip:ClickCell(cellCtl)
  local funcData = cellCtl.data
  if funcData == nil then
    self:CloseSelf()
    return
  end
  local key = funcData.key
  local func = FunctionPlayerTip.Me():GetFuncByKey(key)
  if func then
    func(self.playerTipData)
  end
  if self.clickcallback then
    self.clickcallback(funcData)
  end
  local cfg = PlayerTipFuncConfig[key]
  if not cfg or not cfg.noCloseTip then
    self:CloseSelf()
  end
end

function PlayerTip:CloseSelf()
  FunctionPlayerTip.Me():CloseTip()
end

function PlayerTip:OnEnter()
end

function PlayerTip:SetData(data)
  self.closecomp:ClearTarget()
  self:RemoveExpireTimeCheck()
  self.profileId = nil
  self:HideSocialityPart()
  if data then
    local playerTipData = data.playerData
    if playerTipData then
      local headData = playerTipData.headData
      self.faceCell:SetData(headData)
      local level = playerTipData.level or 0
      local levelStr = ""
      if 0 < level then
        levelStr = string.format("Lv.%s ", level)
      end
      self.name.text = levelStr .. OverSea.LangManager.Instance():GetLangByKey(playerTipData.name)
      self.guildName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-57, 20.6, 0)
      if data.isskada then
        self.name.text = OverSea.LangManager.Instance():GetLangByKey(playerTipData.name)
        self.guildName.text = string.format("Lv.%s", level)
        self.guildIcon.gameObject:SetActive(false)
      elseif playerTipData.cat and playerTipData.cat ~= 0 then
        self:AcitiveIdObj(false)
        self.expiretime = playerTipData.expiretime or 0
        self:AddExpireTimeCheck()
        self.guildName.text = string.format(ZhString.PlayerTip_MasterTip, playerTipData.mastername)
        self.guildIcon.gameObject:SetActive(false)
        self.guildName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-82, 20.6, 0)
      elseif playerTipData.robot ~= nil and playerTipData.robot ~= 0 then
        self.guildIcon.gameObject:SetActive(true)
        self.guildIcon.color = LuaGeometry.GetTempVector4(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
        if playerTipData.guildname and playerTipData.guildname ~= "" then
          self.guildName.text = string.format(ZhString.PlayerTip_GuildTip, playerTipData.guildname)
          self.guildIcon.color = LuaGeometry.GetTempVector4(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
        else
          self.guildName.text = ZhString.PlayerTip_NoGuildTip
          self.guildIcon.color = LuaGeometry.GetTempVector4(0.4666666666666667, 0.4666666666666667, 0.4666666666666667, 1)
        end
      else
        local showId = playerTipData.id
        if type(showId) ~= "number" then
          showId = tonumber(showId)
        end
        if type(showId) == "number" then
          self:AcitiveIdObj(true)
          local limitNum = math.floor(math.pow(10, 12))
          self.idlabel.text = string.format("%s", math.floor(showId % limitNum))
        else
          self:AcitiveIdObj(false)
        end
        if not data.ispet and not data.isServant and not data.isBoki and not data.isBeing then
          self.guildIcon.gameObject:SetActive(false)
          self.tagsPart:SetActive(true)
          if showId and showId ~= 0 then
            self.profileId = showId
            ServiceUserEventProxy.Instance:CallQueryFateRelationEvent(showId)
            ServiceUserEventProxy.Instance:CallQueryProfileUserEvent(showId)
            if playerTipData.id and playerTipData.id ~= 0 then
              if not data.funckeys then
                data.funckeys = {}
              end
              if TableUtility.ArrayFindIndex(data.funckeys, "ShowGUID") == 0 then
                local showDetailIndex = TableUtility.ArrayFindIndex(data.funckeys, "ShowDetail")
                table.insert(data.funckeys, showDetailIndex + 1, "ShowGUID")
              end
            end
          end
        end
        if playerTipData.guildname and playerTipData.guildname ~= "" then
          self.guildName.text = string.format(ZhString.PlayerTip_GuildTip, playerTipData.guildname)
          self.guildIcon.color = LuaGeometry.GetTempVector4(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
        else
          self.guildName.text = ZhString.PlayerTip_NoGuildTip
          self.guildIcon.color = LuaGeometry.GetTempVector4(0.4666666666666667, 0.4666666666666667, 0.4666666666666667, 1)
        end
        self.guildIcon.gameObject:SetActive(true)
      end
      if data.isPippi then
        self.guildIcon.gameObject:SetActive(false)
      end
      if playerTipData.serverid and playerTipData.serverid ~= 0 and playerTipData.serverid ~= MyselfProxy.Instance:GetServerId() then
        self.server:SetActive(true)
        self.serverLabel.text = playerTipData.serverid
      else
        self.server:SetActive(false)
      end
      self:UpdateTipFunc(data.funckeys, playerTipData)
      self.playerTipData = playerTipData
      self:UpdateFavoriteTip(playerTipData.id)
      self:UpdateGMEStatus(playerTipData.id)
      self:ResizeBg()
    end
    self.closecallback = data.closecallback
  end
end

function PlayerTip:UpdateTipFunc(funckeys, playerTipData)
  funckeys = funckeys or FunctionPlayerTip.Me():GetPlayerFunckey(playerTipData.id)
  local tempFunclist = {}
  local pushbackList = {}
  for i = 1, #funckeys do
    if PlayerTipFuncConfig[funckeys[i]] and PlayerTipFuncConfig[funckeys[i]].pushBackInArray then
      table.insert(pushbackList, funckeys[i])
    else
      table.insert(tempFunclist, funckeys[i])
    end
  end
  if pushbackList and 0 < #pushbackList then
    for i = 1, #pushbackList do
      table.insert(tempFunclist, pushbackList[i])
    end
  end
  funckeys = tempFunclist
  if funckeys then
    local funcDatas = {}
    local socialDatas = {}
    FunctionPlayerTip.Me():SetWhereIClickThisIcon(self:GetWhereIClickThisIcon())
    for i = 1, #funckeys do
      local state, otherName, isCancel = FunctionPlayerTip.Me():CheckTipFuncStateByKey(funckeys[i], playerTipData)
      local socialState = FunctionPlayerTip.Me():CheckTipSocialStateByKey(funckeys[i], playerTipData)
      if state ~= PlayerTipFuncState.InActive and socialState == 0 then
        local tempData = {}
        tempData.key = funckeys[i]
        tempData.state = state
        tempData.playerTipData = playerTipData
        tempData.otherName = otherName
        tempData.isCancel = isCancel
        table.insert(funcDatas, tempData)
      elseif state ~= PlayerTipFuncState.InActive and socialState ~= 0 then
        local singleData = {}
        singleData.key = funckeys[i]
        singleData.socialState = socialState
        singleData.playerTipData = playerTipData
        singleData.otherName = otherName
        table.insert(socialDatas, singleData)
        table.sort(socialDatas, function(l, r)
          local lstate = math.modf(l.socialState / 10)
          local rstate = math.modf(r.socialState / 10)
          return lstate < rstate
        end)
      end
    end
    self.socialCtl:ResetDatas(socialDatas)
    self.funcCtl:ResetDatas(funcDatas)
    self.grid:Reposition()
    self.sgrid:Reposition()
    local count = #funcDatas
    local height
    local scrollPanel = self:FindGO("uiScrollView"):GetComponent(UIPanel)
    if 4 < count then
      height = 136
    else
      height = 60 * math.floor((count + 1) / 2)
    end
    scrollPanel:SetRect(scrollPanel.baseClipRegion.x, scrollPanel.baseClipRegion.y, scrollPanel.baseClipRegion.z, height)
    self.m_scrollView:ResetPosition()
  else
  end
  self:ResizeChildBord()
  TipsView.Me():ConstrainCurrentTip()
end

function PlayerTip:UpdateFuncState(funcKey, state, newName)
  local keyCell = self:GetFuncCell(funcKey)
  if keyCell then
    keyCell:SetState(state)
    if newName then
      keyCell:SetName(newName)
    end
  end
end

function PlayerTip:HandleQueryUserTeamCmd()
  local _TeamProxy = TeamProxy.Instance
  if not _TeamProxy:IHaveTeam() then
  elseif not _TeamProxy:IHaveGroup() and not GameConfig.SystemForbid.Group and _TeamProxy:CheckIHaveLeaderAuthority() and self:IsTeam() then
    self:ChangeSocialFunc("InviteMember", "InviteGroup")
  else
    self:UpdateSocialState("InviteMember")
  end
end

function PlayerTip:UpdateSocialState(funcKey)
  local keyCell = self:GetSocialCell(funcKey)
  if keyCell then
    local socialState = FunctionPlayerTip.Me():CheckTipSocialStateByKey(funcKey, self.playerTipData)
    keyCell:SetSocialState(socialState)
  end
end

function PlayerTip:ChangeFunc(changeKey, toKey)
  if changeKey == toKey then
    return
  end
  local keyCell = self:GetFuncCell(changeKey)
  if keyCell then
    local playerTipData = self.playerTipData
    if not playerTipData then
      return
    end
    local state = FunctionPlayerTip.Me():CheckTipFuncStateByKey(toKey, playerTipData)
    if state ~= PlayerTipFuncState.InActive then
      local tempData = {}
      tempData.key = toKey
      tempData.state = state
      tempData.playerTipData = playerTipData
      keyCell:SetData(tempData)
    end
  end
end

function PlayerTip:ChangeSocialFunc(changeKey, toKey)
  if changeKey == toKey then
    return
  end
  local keyCell = self:GetSocialCell(changeKey)
  if keyCell then
    local playerTipData = self.playerTipData
    if not playerTipData then
      return
    end
    local state = FunctionPlayerTip.Me():CheckTipFuncStateByKey(toKey, playerTipData)
    local socialState = FunctionPlayerTip.Me():CheckTipSocialStateByKey(toKey, playerTipData)
    if state ~= PlayerTipFuncState.InActive then
      local tempData = {}
      tempData.key = toKey
      tempData.socialState = socialState
      tempData.playerTipData = playerTipData
      keyCell:SetData(tempData)
    end
  end
end

function PlayerTip:GetFuncCell(key)
  local keyCell
  local cells = self.funcCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell and cell.data
    if data and data.key == key then
      keyCell = cell
      break
    end
  end
  return keyCell
end

function PlayerTip:GetSocialCell(key)
  local keyCell
  local cells = self.socialCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell and cell.data
    if data and data.key == key then
      keyCell = cell
      break
    end
  end
  return keyCell
end

function PlayerTip:UpdateAddFriendBtn(playerTipData)
  local funcKey = "AddFriend"
  local state, otherName = FunctionPlayerTip.Me():CheckTipFuncStateByKey(funcKey, playerTipData)
  local tempData = {}
  local playerid = playerTipData.id
  if FriendProxy.Instance:IsFriend(playerid) then
    tempData.socialState = 11
  else
    tempData.socialState = 10
  end
  tempData.key = funcKey
  tempData.state = state
  tempData.playerTipData = playerTipData
  tempData.otherName = otherName
  self.addFriendBtn:SetData(tempData)
end

function PlayerTip:OnExit()
  self:RemoveExpireTimeCheck()
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryProfileUserEvent, self.HandleQueryUserInfo, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventSyncFateRelationEvent, self.HandleFateRelation, self)
  if self.closecallback then
    self.closecallback()
  end
  return true
end

function PlayerTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end

function PlayerTip:AddIgnoreBound(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function PlayerTip:SetDesc(s1, s2, s3)
  self.name.text = s1
  self.guildName.text = s2
  self.guildName.color = LuaGeometry.GetTempVector4(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  self.guildName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-82, 20.6, 0)
  self.guildIcon.gameObject:SetActive(false)
  self.id.overflowMethod = 2
  self.id.text = s3
  self.idlabel.text = ""
end

function PlayerTip:InitChildBord()
  self.childBord = self:FindGO("ChildBord")
  self.child_Bg = self:FindComponent("CBg", UISprite, self.childBord)
  self.child_actionGrid = self:FindComponent("ActionGrid", UIGrid, self.childBord)
  self.childCtl = UIGridListCtrl.new(self.child_actionGrid, UIEmojiCell, "UIEmojiCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickActionCell, self)
end

function PlayerTip:ClickActionCell(cell)
  local data = Table_ActionAnime[cell.id]
  local d_action = data and data.DoubleAction
  if not d_action then
    return
  end
  local player = FindCreature(self.playerTipData.id)
  if player == nil then
    MsgManager.ShowMsgByIDTable(27101)
    return
  end
  if player:IsInBooth() then
    MsgManager.ShowMsgByIDTable(407)
    return
  end
  local cfg = GameConfig.TwinsAction
  if cfg.race and TableUtility.ArrayFindIndex(cfg.race, cell.id) > 0 and not PlayerData.CheckRace(player.data:GetProfesstion(), MyselfProxy.Instance:GetMyRace()) then
    MsgManager.ShowMsgByID(42114)
    return
  end
  if cfg.body and 0 < TableUtility.ArrayFindIndex(cfg.body, cell.id) and Asset_Role.CheckBodyGender(Game.Myself.assetRole, player.assetRole) then
    MsgManager.ShowMsgByIDTable(27104)
    return
  end
  local followId = Game.Myself:Client_GetFollowLeaderID()
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if handTargetId and handTargetId ~= 0 then
    MsgManager.ShowMsgByIDTable(832)
    return
  end
  ServiceNUserProxy.Instance:CallTwinsActionUserCmd(self.playerTipData.id, cell.id, SceneUser2_pb.ETWINS_OPERATION_REQUEST)
  self:HideChildBord()
end

function PlayerTip:IsTeam()
  if self.playerTipData then
    return self.playerTipData:IsTeam()
  end
  return false
end

function PlayerTip:ResizeChildBord()
  self.child_Bg.height = self.bg.height
end

function PlayerTip:UpdateChildBordData()
  local actionDatas, actionCellData = ReusableTable.CreateArray()
  for _, actionData in pairs(Table_ActionAnime) do
    if actionData.DoubleAction and not UIEmojiCell.CheckIsPassiveActionByName(actionData.Name) and UIEmojiCell.CheckDoubleActionValid(actionData.id) then
      actionCellData = {}
      actionCellData.type = UIEmojiType.Action
      actionCellData.id = actionData.id
      actionCellData.name = actionData.Name
      table.insert(actionDatas, actionCellData)
    end
  end
  self.childCtl:ResetDatas(actionDatas)
  ReusableTable.DestroyAndClearArray(actionDatas)
end

function PlayerTip:ShowChildBord()
  self.childBord:SetActive(true)
  self:UpdateChildBordData()
  self.closecomp:ReCalculateBound()
end

function PlayerTip:HideChildBord()
  self.childBord:SetActive(false)
end

function PlayerTip:HideGuildInfo()
  self.guildName.gameObject:SetActive(false)
end

function PlayerTip:AddExpireTimeCheck()
  local leftTime
  if self.masterid ~= nil and self.masterid ~= Game.Myself.data.id then
    leftTime = 0
  else
    leftTime = self.expiretime - ServerTime.CurServerTime() / 1000
  end
  if 0 < leftTime then
    self:ActiveCatExpireTimeObj(true)
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._Tick, self)
  else
    self:ActiveCatExpireTimeObj(false)
  end
end

function PlayerTip:_Tick(deltatime)
  local leftTime = self.expiretime - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    self:UpdateLeftTime(leftTime)
  else
    self:RemoveExpireTimeCheck()
  end
end

function PlayerTip:UpdateLeftTime(leftTime)
  local timeText = ""
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if 0 < day then
    timeText = string.format(ZhString.PlayerTip_ExpireTime, day + 1)
    self.labExpireTime.text = timeText .. ZhString.PlayerTip_Day
  else
    timeText = string.format("%02d:%02d:%02d", hour, min, sec)
    self.labExpireTime.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
  end
end

function PlayerTip:RemoveExpireTimeCheck()
  self.expiretime = 0
  self:ActiveCatExpireTimeObj(false)
  if self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
end

PlayerTipSource = {FromTeam = 1, FromGuild = 2}

function PlayerTip:SetWhereIClickThisIcon(where)
  self.whereClick = where
end

function PlayerTip:GetWhereIClickThisIcon()
  return self.whereClick or PlayerTipSource.FromTeam
end

function PlayerTip:UpdateFavoriteTip(guid)
  if not self.favoriteTip then
    return
  end
  if not FriendProxy.Instance:IsFriend(guid) then
    self.favoriteTip:SetActive(false)
  else
    self.favoriteTip:SetActive(true)
  end
  if FriendProxy.Instance:CheckIsFavorite(guid) then
    self.favoriteSp.color = ColorUtil.NGUIWhite
  else
    self.favoriteSp.color = ColorUtil.NGUIGray
  end
end

function PlayerTip:OnFavoriteClick()
  local guid = self.playerTipData.id
  if not FriendProxy.Instance:CheckIsFavorite(guid) then
    ServiceUserEventProxy.Instance:CallActionFavoriteFriendUserEvent({guid})
    self.favoriteSp.color = ColorUtil.NGUIWhite
  else
    ServiceUserEventProxy.Instance:CallActionFavoriteFriendUserEvent(nil, {guid})
    self.favoriteSp.color = ColorUtil.NGUIGray
  end
end

function PlayerTip:UpdateGMEStatus(id)
  if not GmeVoiceProxy.Instance:IsInRoom() then
    self.GMEPart:SetActive(false)
    return
  end
  if not TeamProxy.Instance:IsInMyTeam(id) then
    self.GMEPart:SetActive(false)
    return
  else
    self.GMEPart:SetActive(true)
  end
  self.GMEState1:SetActive(false)
  self.GMEState2:SetActive(false)
  self.GMEState3:SetActive(false)
  local teamMemberGMEInfo = GmeVoiceProxy.Instance:GetMemberById(id)
  if teamMemberGMEInfo ~= nil and teamMemberGMEInfo.IsSpeaking then
    self.GMEState1:SetActive(true)
  else
    self.GMEState3:SetActive(true)
  end
end

function PlayerTip:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if not self.lock_lt then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function PlayerTip:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function PlayerTip:HandleUpdateFavoriteTip()
  self:CancelLockCall()
end

function PlayerTip:switchPage()
  self.showFuncs = not self.showFuncs
  self.profilePart:SetActive(not self.showFuncs)
  self.m_funcBtnRoot:SetActive(self.showFuncs)
  self.grid:Reposition()
end

function PlayerTip:HandleQueryUserInfo(note)
  local data = note.data
  if data then
    if not self.profileId or self.profileId ~= data.charid then
      return
    end
    if not self.profileData then
      self.profileData = {}
    end
    local profileData = data.profile
    TableUtility.TableShallowCopy(self.profileData, profileData)
    if not profileData then
      redlog("no profileData")
      return
    end
    self.profilePart:SetActive(true)
    local showTags = profileData.label
    for i = 1, 3 do
      if showTags and showTags[i] then
        local tagName = Table_PlayerTag[showTags[i]] and Table_PlayerTag[showTags[i]].Name or "-"
        self.tags[i].go:SetActive(true)
        self.tags[i].label.text = tagName
      else
        self.tags[i].go:SetActive(false)
      end
    end
    local constellationIndex = DateUtil.GetConstellation(profileData.birthmonth, profileData.birthday)
    local config = GameConfig.Constellation[constellationIndex]
    self.id.text = config and config.name
    self.id.overflowMethod = 0
    self.id.width = 62
    self.constellationIcon.spriteName = config and config.icon
    self.constellationIcon.gameObject:SetActive(true)
    self.idlabel.text = ""
    local timeInfo = os.date("*t", ServerTime.CurServerTime() / 1000)
    if timeInfo.month == profileData.birthmonth and timeInfo.day == profileData.birthday then
      self.birthdayTip:SetActive(true)
      self.constellationIcon.gameObject:SetActive(false)
    else
      self.birthdayTip:SetActive(false)
    end
    local showSign = profileData.signtext
    if showSign and showSign == "" then
      local initMessage = GameConfig.PlayerTagGroup.init_Message and GameConfig.PlayerTagGroup.init_Message[1] or 168119
      if initMessage then
        local dialogData = DialogUtil.GetDialogData(initMessage)
        self.signLabel.text = dialogData.Text
      end
    else
      self.signLabel.text = showSign
    end
    local friendApplyType = profileData.needpartner or 1
    if not friendApplyType or friendApplyType == 0 or friendApplyType == 1 then
      self.friendApplyTip.text = ""
      self.friendApplyTip.gameObject:SetActive(false)
      self.friendApplyPart:SetActive(false)
    else
      self.friendApplyTip.gameObject:SetActive(true)
      self.friendApplyPart:SetActive(true)
      local config = GameConfig.FriendApplyMessage and GameConfig.FriendApplyMessage[friendApplyType]
      self.friendApplyTip.text = config and config.TipText
    end
    self:ResizeBg()
  end
end

function PlayerTip:ResizeBg()
  self.infoTable:Reposition()
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.infoTable.gameObject.transform)
  local height = size.size.y
  self.bg.height = height + 150
end

function PlayerTip:HandleFateRelation(note)
  if not self.profileId then
    return
  end
  local data = note.data
  if data then
    local fateid = data.fateid
    local eventConfig = Table_FateValue and Table_FateValue[fateid]
    self.fateLabel.text = eventConfig and eventConfig.text
    self.fatePart:SetActive(true)
    self:ResizeBg()
  end
end

function PlayerTip:HideSocialityPart()
  self.tagsPart:SetActive(false)
  self.profilePart:SetActive(false)
  self.constellationIcon.gameObject:SetActive(false)
  self.birthdayTip:SetActive(false)
  self.friendApplyTip.gameObject:SetActive(false)
  self.friendApplyPart:SetActive(false)
  self.fatePart:SetActive(false)
end

function PlayerTip:HandleFollowSelectMember()
  local cells = self.socialCtl:GetCells()
  if cells then
    for i = 1, #cells do
      local cell = cells[i]
      if cell.data and (cell.data.key == "FollowMember" or cell.data.key == "CancelFollowMember") then
        self:ClickCell(cell)
        break
      end
    end
  end
end
