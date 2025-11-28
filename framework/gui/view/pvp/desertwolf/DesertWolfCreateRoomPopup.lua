autoImport("UIToggleGroup")
DesertWolfCreateRoomPopup = class("DesertWolfCreateRoomPopup", BaseView)
DesertWolfCreateRoomPopup.ViewType = UIViewType.PopUpLayer
autoImport("BanCardCombineCell")
PvpCustomRoomProxy.CreateRoomMode = {EnterPreview = 1, InRoomPreview = 2}

function DesertWolfCreateRoomPopup:Init()
  self.roomNameLabel = self:FindComponent("RoomNameLabel", UILabel)
  self.roomNameLabel.text = string.format(ZhString.TeamPws_RoomName, Game.Myself.data.name)
  self.raidOptionGO = self:FindGO("RaidTabs")
  self.raidOptionCollider = self.raidOptionGO:GetComponent(BoxCollider)
  self.raidOptionPopup = PopupGridList.new(self.raidOptionGO, function(self, data)
    self.selectedRaidData = data
  end, self, self.roomNameLabel.depth + 2)
  self.raidModes = PvpCustomRoomProxy.Instance:GetRaidConfigs(PvpProxy.Type.DesertWolf)
  self.raidOptionPopup:SetData(self.raidModes)
  self.selectedRaidData = self.raidModes[1]
  local contentContainer = self:FindGO("ContentTable")
  self.contentTable = contentContainer:GetComponent(UITable)
  self.passwordContainer = self:FindGO("RoomPasswd")
  self.passwordInputGO = self:FindGO("PasswdInput", self.passwordContainer)
  self.passwordInput = self.passwordInputGO:GetComponent(UIInput)
  if self.passwordInput then
    UIUtil.LimitInputCharacter(self.passwordInput, GameConfig.ChatRoom.PwdSize)
    EventDelegate.Set(self.passwordInput.onChange, function()
      self.passwordInput.value = self.passwordInput.value:gsub("-", "")
      self.passwordInput.characterLimit = GameConfig.ChatRoom.PwdSize
    end)
    self.passwordInput.value = ""
  end
  local optContainer = self:FindGO("OptContainer", contentContainer)
  local innerOptContainer = self:FindGO("Container", optContainer)
  local toggleGroupNames = {"OptOn", "OptOff"}
  local professionOptRoot = self:FindGO("ProfessionOpt", innerOptContainer)
  self.professionToggleGroup = UIToggleGroup.new(professionOptRoot, toggleGroupNames, 1, self:GetNextToggleGroupId())
  local relicsOptRoot = self:FindGO("RelicsOpt", innerOptContainer)
  self.relicsToggleGroup = UIToggleGroup.new(relicsOptRoot, toggleGroupNames, 1, self:GetNextToggleGroupId())
  local foodOptRoot = self:FindGO("FoodOpt", innerOptContainer)
  self.foodToggleGroup = UIToggleGroup.new(foodOptRoot, toggleGroupNames, 1, self:GetNextToggleGroupId())
  local artifactOptRoot = self:FindGO("ArtifactOpt", innerOptContainer)
  self.artifactToggleGroup = UIToggleGroup.new(artifactOptRoot, toggleGroupNames, 1, self:GetNextToggleGroupId())
  local optionNames = GameConfig.ReserveRoom and GameConfig.ReserveRoom.DesertWolfOptionNames
  if optionNames then
    if optionNames.profession then
      local professionLab = self:FindComponent("Label", UILabel, professionOptRoot)
      professionLab.text = optionNames.profession
    end
    if optionNames.relics then
      local relicsLab = self:FindComponent("Label", UILabel, relicsOptRoot)
      relicsLab.text = optionNames.relics
    end
    if optionNames.food then
      local foodLab = self:FindComponent("Label", UILabel, foodOptRoot)
      foodLab.text = optionNames.food
    end
    if optionNames.artifact then
      local artifactLab = self:FindComponent("Label", UILabel, artifactOptRoot)
      artifactLab.text = optionNames.artifact
    end
  end
  local freeFireContainer = self:FindGO("FreeFireOpt")
  self.freeFireToggleGO = self:FindGO("NoticeToggle", freeFireContainer)
  self.freeFireToggle = self.freeFireToggleGO:GetComponent(UIToggle)
  self.freeFireToggleCollider = self.freeFireToggle:GetComponent(BoxCollider)
  self.freeFireToggleWidget = self:FindComponent("Container", UIWidget, self.freeFireToggleGO)
  self.freeFireHelpGO = self:FindGO("RuleBtn", freeFireContainer)
  if self.freeFireHelpGO then
    self:RegistShowGeneralHelpByHelpID(32599, self.freeFireHelpGO)
  end
  self.banCardSwitchGO = self:FindGO("BanCardOption")
  self.banCardSwitch = self:FindGO("NoticeToggle", self.banCardSwitchGO):GetComponent(UIToggle)
  self.banCardSwitchCollider = self:FindGO("NoticeToggle", self.banCardSwitchGO):GetComponent(BoxCollider)
  self.banCardGO = self:FindGO("BanCardCombineCell")
  if self.banCardGO then
    self.banCardCell = BanCardCombineCell.new(self.banCardGO)
    self.banCardCell:SetOptionEnable(true)
  end
  self:AddClickEvent(self.banCardSwitch.gameObject, function()
    self.banCardGO:SetActive(self.banCardSwitch.value)
  end)
  self.banCardGO:SetActive(self.banCardSwitch.value)
  self.leaveButtonGO = self:FindGO("LeaveBtn")
  self:AddClickEvent(self.leaveButtonGO, function()
    self:OnLeaveClicked()
  end)
  self.joinButtonGO = self:FindGO("JoinBtn")
  self:AddClickEvent(self.joinButtonGO, function()
    self:OnJoinClicked()
  end)
  self.confirmButtonGO = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmButtonGO, function()
    self:OnConfirmClicked()
  end)
  self.comfirmLabel = self:FindComponent("Label", UILabel, self.confirmButtonGO)
  self.closeButtonGO = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButtonGO, function()
    self:OnCloseClicked()
  end)
  self.helpGO = self:FindGO("HelpButton")
  local help_id = PanelConfig.DesertWolfCreateRoomPopup.id
  self:RegistShowGeneralHelpByHelpID(help_id, self.helpGO)
  self:LoadRoomData()
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.OnCurrentRoomChanged)
end

function DesertWolfCreateRoomPopup:GetNextToggleGroupId()
  if not self.nextToggleGroupId then
    self.nextToggleGroupId = 11
  else
    self.nextToggleGroupId = self.nextToggleGroupId + 1
  end
  return self.nextToggleGroupId
end

function DesertWolfCreateRoomPopup:SetMode(mode)
  local isInBattle = PvpCustomRoomProxy.Instance:IsInBattle()
  local b = mode == PvpCustomRoomProxy.CreateRoomMode.EnterPreview or mode == PvpCustomRoomProxy.CreateRoomMode.InRoomPreview or isInBattle
  self.raidOptionCollider.enabled = not b
  self.passwordContainer:SetActive(not b)
  self.professionToggleGroup:SetEnabled(not b)
  self.relicsToggleGroup:SetEnabled(not b)
  self.foodToggleGroup:SetEnabled(not b)
  self.artifactToggleGroup:SetEnabled(not b)
  self.contentTable:Reposition()
  self.freeFireToggleCollider.enabled = not b
  local alpha = b and 0.2 or 1
  self.freeFireToggleWidget.alpha = alpha
  self.banCardSwitchCollider.enabled = not b
  self.banCardCell:SetOptionEnable(not b)
  if mode == PvpCustomRoomProxy.CreateRoomMode.EnterPreview then
    self.leaveButtonGO:SetActive(true)
    self.joinButtonGO:SetActive(true)
    self.confirmButtonGO:SetActive(false)
  else
    self.leaveButtonGO:SetActive(false)
    self.joinButtonGO:SetActive(false)
    self.confirmButtonGO:SetActive(true)
    if mode == PvpCustomRoomProxy.CreateRoomMode.InRoomPreview or isInBattle then
      self.comfirmLabel.text = ZhString.PvpCustomRoom_Confirm
    end
  end
end

function DesertWolfCreateRoomPopup:LoadRoomData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local roomData = viewdata and viewdata.roomdata
  self.comfirmLabel.text = not roomData and ZhString.PvpCustomRoom_Create or ZhString.PvpCustomRoom_Modify
  local banCardIds = {}
  if roomData then
    if self.raidModes then
      for _, v in ipairs(self.raidModes) do
        if v.raidid == roomData.raidid then
          self.raidOptionPopup:SetValue(v.name)
          break
        end
      end
    end
    local roomName = roomData.roomname or ""
    self.roomNameLabel.text = Game.simpleReplace(roomName)
    self.professionToggleGroup:SelectToggle(roomData.profession and 2 or 1)
    self.relicsToggleGroup:SelectToggle(roomData.relics and 1 or 2)
    self.foodToggleGroup:SelectToggle(roomData.food and 1 or 2)
    self.artifactToggleGroup:SelectToggle(roomData.artifact and 1 or 2)
    self.freeFireToggle.value = roomData:IsFreeFire()
    local proxy = PvpCustomRoomProxy.Instance
    local raidConfig = proxy:GetRaidConfigByRaidId(roomData.raidid, roomData.pvpType)
    if raidConfig then
      self.raidOptionPopup:SetValue(raidConfig.name)
    end
    if roomData.password then
      self.passwordInput.value = roomData.password
    end
    self.banCardSwitch.value = roomData.isforbidcard or false
    if self.banCardGO then
      self.banCardGO:SetActive(self.banCardSwitch.value)
    end
    TableUtility.ArrayShallowCopy(banCardIds, roomData:GetBanCardList())
  else
    local pvpType = self.selectedRaidData.etype
    local eType = 0
    if pvpType == MatchCCmd_pb.EPVPTYPE_SMZL then
      eType = 3
    end
    xdlog("pvpType", pvpType, eType)
    banCardIds = PvpCustomRoomProxy.Instance:GetSavedForbidCards(eType)
  end
  self.banCardCell:SetData(banCardIds)
  local mode = viewdata and viewdata.mode
  self:SetMode(mode)
end

function DesertWolfCreateRoomPopup:OnCloseClicked(go)
  if self.viewdata.viewdata and self.viewdata.viewdata.roomdata and self.viewdata.viewdata.mode ~= PvpCustomRoomProxy.CreateRoomMode.EnterPreview then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DesertWolfRoomInfoPopup
    })
  end
  self:CloseSelf()
end

function DesertWolfCreateRoomPopup:OnConfirmClicked(go)
  local isInBattle = PvpCustomRoomProxy.Instance:IsInBattle()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local mode = viewdata and viewdata.mode
  if mode == PvpCustomRoomProxy.CreateRoomMode.InRoomPreview or isInBattle then
    self:OnCloseClicked()
    return
  end
  if not self.selectedRaidData then
    return
  end
  if string.len(self.passwordInput.value) ~= GameConfig.ChatRoom.PwdSize and string.len(self.passwordInput.value) ~= 0 then
    MsgManager.ShowMsgByID(805)
    return
  end
  local eType = self.selectedRaidData.etype
  local raidId = self.selectedRaidData.raidid
  local roomName = Game.Myself.data.name
  local password = self.passwordInput.value
  local freeFire = self.freeFireToggle.value
  local profession = self.professionToggleGroup:GetSelectedToggleIndex() ~= 1
  local relics = self.relicsToggleGroup:GetSelectedToggleIndex() == 1
  local food = self.foodToggleGroup:GetSelectedToggleIndex() == 1
  local artifact = self.artifactToggleGroup:GetSelectedToggleIndex() == 1
  local banCards = self.banCardCell:GetID()
  local isforbidcard = self.banCardSwitch.value
  if PvpCustomRoomProxy.Instance:SendCreateRoomReq(eType, raidId, freeFire, password, profession, relics, food, artifact, banCards, isforbidcard) then
    self:CloseSelf()
  end
end

function DesertWolfCreateRoomPopup:OnLeaveClicked()
  self:CloseSelf()
end

function DesertWolfCreateRoomPopup:OnJoinClicked()
  local proxy = PvpCustomRoomProxy.Instance
  if proxy:GetCurrentRoomData() ~= nil then
    MsgManager.ShowMsgByID(475)
    return
  end
  local viewdata = self.viewdata and self.viewdata.viewdata
  local roomData = viewdata and viewdata.roomdata
  if not roomData then
    return
  end
  if roomData.iscode then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PasswordPopup",
      confirmCallback = function(target, pwd)
        proxy:SendEnterRoomReq(roomData.roomid, pwd)
      end,
      callbackTarget = self,
      title = roomData:GetRoomName()
    })
  else
    proxy:SendEnterRoomReq(roomData.roomid)
  end
end

function DesertWolfCreateRoomPopup:OnCurrentRoomChanged(evt)
  local data = evt and evt.data
  if data and data.pvptype == PvpProxy.Type.DesertWolf and data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Enter then
    self:CloseSelf()
  end
end
