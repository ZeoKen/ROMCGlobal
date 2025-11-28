autoImport("UIEmojiCombineCell")
UIEmojiView = class("UIEmojiView", ContainerView)
UIEmojiView.ViewType = UIViewType.ChatLayer
UIEmojiView.TabNames = {
  [1] = ZhString.UIEmojiView_FavoriteTabName,
  [2] = ZhString.UIEmojiView_EmojiTabName,
  [3] = ZhString.UIEmojiView_ActionTabName
}
local maxEmojiCountOfOnePage, doubleActionWaitTimeOut = 18, 3000
local emojiClickCdTime, emojiClickCdTimeInEditMode = 1000, 200
local chatRoomProxy, isSendExpressionAvailable
local ExpressionType = ChatRoomProxy.ExpressionType

function UIEmojiView:Init()
  self.BlockEmojiClick = false
  self.BlockEmojiClickTwId = nil
  if not chatRoomProxy then
    chatRoomProxy = ChatRoomProxy.Instance
  end
  isSendExpressionAvailable = not GameConfig.SystemForbid.ChatText
  self.favoriteData = chatRoomProxy.favoriteExpressions
  self.tempFavoriteData = {}
  self:InitView()
  self:MapViewInterest()
end

function UIEmojiView:InitView()
  self.bord = self:FindGO("Bord")
  self:InitEmojiCtl()
  self:InitTabs()
  self:InitEditModeCtrls()
end

function UIEmojiView:InitEmojiCtl()
  local wrapConfig = {
    wrapObj = self:FindGO("EmojiContainer"),
    pfbNum = 13,
    control = UIEmojiCombineCell,
    cellName = "UIEmojiCombineCell",
    dir = 2,
    disableDragIfFit = true
  }
  self.emojiCtl = WrapCellHelper.new(wrapConfig)
  self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self.emojiCtl:AddEventListener(EmojiEvent.SwapEmoji, self.SwapEmoji, self)
  self.emojiCtl:AddEventListener(EmojiEvent.DeleteEmoji, self.DeleteEmoji, self)
  self:_ForEachEmojiCell(function(cell)
    cell:SetTogglePredicate(function()
      return TableUtility.TableFindByPredicate(self.tempFavoriteData, function(pos, data)
        return cell.id == data.id and cell.type == data.type
      end)
    end)
  end)
  self.emojiWrapTrans = self.emojiCtl.wrap.transform
end

function UIEmojiView:InitTabs()
  self.tabGrid = self:FindComponent("Tabs", UIGrid)
  self.favoriteTabToggle = self:FindTabToggle("FavoriteTab")
  self.emojiTabToggle = self:FindTabToggle("EmojiTab")
  self.actionTabToggle = self:FindTabToggle("ActionTab")
  self.roleExpressionToggle = self:FindTabToggle("RoleExpressionTab")
  self.tabToggles = {
    self.favoriteTabToggle,
    self.emojiTabToggle,
    self.actionTabToggle,
    self.roleExpressionToggle
  }
  self.tabIconSps = {}
  local tabGO, longPress, iconSp
  for i = 1, #self.tabToggles do
    tabGO = self.tabToggles[i].transform.parent.gameObject
    self:AddClickEvent(tabGO, function()
      self:SelectTab(i)
    end)
    longPress = tabGO:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.UIEmojiView, {state, i})
    end
    
    iconSp = self:FindComponent("Icon", GradientUISprite, tabGO)
    if iconSp then
      self.tabIconSps[i] = iconSp
    end
  end
end

function UIEmojiView:InitEditModeCtrls()
  self.editModeBtn = self:FindGO("EditModeBtn")
  self:AddClickEvent(self.editModeBtn, function()
    self:SetEditMode(not self.isEditMode)
  end)
  self.editModeCtrl = self:FindGO("EditModeCtrl")
  local confirm = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirm, function()
    self:TryUpdateFavoriteExpression()
  end)
  self.favoriteCountLabel = self:FindComponent("FavoriteCount", UILabel)
end

function UIEmojiView:ClickCell(cellctl)
  if not cellctl.content.activeSelf then
    return
  end
  if self.BlockEmojiClick then
    MsgManager.ShowMsgByID(49)
    return
  end
  local downID = Game.Myself.data:GetDownID()
  if downID and downID ~= 0 then
    MsgManager.ShowMsgByID(43538)
    return
  end
  self:StartBlockEmojiClick()
  if self.isEditMode then
    if cellctl.editMode == UIEmojiEditMode.Toggle then
      if cellctl.toggle.value then
        TableUtility.ArrayRemoveByPredicate(self.tempFavoriteData, function(data)
          return cellctl.type == data.type and cellctl.id == data.id
        end)
      elseif #self.tempFavoriteData < maxEmojiCountOfOnePage then
        if cellctl.type ~= ExpressionType.RoleExpression then
          ChatRoomProxy._InsertNewExpressionData(self.tempFavoriteData, cellctl.type, cellctl.id)
        end
      else
        MsgManager.ShowMsgByID(38258)
        return
      end
      self:UpdateTab()
    end
  else
    local myself = Game.Myself
    if cellctl.type == UIEmojiType.Action and cellctl.forbidState ~= 1 then
      if myself.data:IsTransformed() then
        MsgManager.ShowMsgByIDTable(830)
        return
      end
      local sdata = UIEmojiCell.TryReplaceMyProfessionAction(cellctl.id)
      if string.find(sdata.Name, "ride_") and not myself.assetRole:HasActionRaw(sdata.Name) then
        local _BagProxy = BagProxy.Instance
        local mount = _BagProxy.roleEquip:GetMount()
        if mount then
          local sites = mount.equipInfo:GetEquipSite()
          ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFF, sites[1], mount.id, false)
        end
        local fmount = _BagProxy.fashionEquipBag:GetMount()
        if fmount then
          local sites = fmount.equipInfo:GetEquipSite()
          ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, sites[1], fmount.staticData.id, false)
        end
      end
      if sdata.Condition == 1 and not myself:IsOnSceneSeat() then
        MsgManager.ShowMsgByIDTable(925)
        return
      end
      if sdata.DoubleAction then
        self.doubleActionWaitDeadline = ServerTime.CurClientTime() + doubleActionWaitTimeOut
        ServiceUserEventProxy.Instance:CallDoubleAcionEvent(0, sdata.id)
        return
      end
      local once = 0 < TableUtility.ArrayFindIndex(GameConfig.OnlyOnceAction.action_id, sdata.id) and true or false
      myself:Client_PlayMotionAction(sdata.id, once)
      if self:CheckSendExpressionAvailable() then
        FunctionSecurity.Me():TryDoRealNameCentify(function()
          local target = Game.Myself:GetLockTarget()
          chatRoomProxy:CallExpressionChatCmd(ChatChannelEnum.Current, cellctl.type, cellctl.id, target and target.data)
        end)
      end
    elseif cellctl.type == UIEmojiType.Emoji and cellctl.forbidState ~= 2 then
      local roleid = Game.Myself.data.id
      self:sendNotification(EmojiEvent.PlayEmoji, {
        roleid = roleid,
        emoji = cellctl.id
      })
      ServiceNUserProxy.Instance:CallUserActionNtf(roleid, cellctl.id, SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION)
      if self:CheckSendExpressionAvailable() then
        FunctionSecurity.Me():TryDoRealNameCentify(function()
          local expression = ReusableTable.CreateTable()
          expression.type = cellctl.type
          expression.id = cellctl.id
          local target = Game.Myself:GetLockTarget()
          local targetData = target and target.data
          local msgId = chatRoomProxy:GetRandomExpressionTextId(cellctl.type, cellctl.id, targetData)
          ServiceChatCmdProxy.Instance:CallChatCmd(ChatChannelEnum.Current, msgId and Table_ExpressionText[msgId].Msg or "", targetData and targetData.id, nil, nil, nil, nil, nil, expression)
          ReusableTable.DestroyAndClearTable(expression)
        end)
      end
    elseif cellctl.type == UIEmojiType.RoleExpression then
      if myself.assetRole:CurBodySupportExpression() then
        myself.assetRole:SetExpression(cellctl.id, true)
      else
        MsgManager.ShowMsgByID(41141)
      end
    end
  end
end

function UIEmojiView:SwapEmoji(param)
  local source, target = param[1], param[2]
  if not self.isEditMode then
    return
  end
  self.tempFavoriteData[source.pos], self.tempFavoriteData[target.pos] = self.tempFavoriteData[target.pos], self.tempFavoriteData[source.pos]
  self:UpdateTab()
end

function UIEmojiView:DeleteEmoji(cellctl)
  if not self.isEditMode then
    return
  end
  TableUtility.ArrayRemoveByPredicate(self.tempFavoriteData, function(data)
    return cellctl.type == data.type and cellctl.id == data.id
  end)
  self:UpdateTab()
end

function UIEmojiView:StartBlockEmojiClick()
  if self.BlockEmojiClickTwId then
    TimeTickManager.Me():ClearTick(self, self.BlockEmojiClickTwId)
    self.BlockEmojiClickTwId = nil
  end
  self.BlockEmojiClick = true
  local delayTime = self.isEditMode and emojiClickCdTimeInEditMode or emojiClickCdTime
  local ret = TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(self)
    self.BlockEmojiClick = false
    self.BlockEmojiClickTwId = nil
  end, self, 2)
  self.BlockEmojiClickTwId = ret.id
end

function UIEmojiView:OnEnter()
  UIEmojiView.super.OnEnter(self)
  self:sendNotification(MainViewEvent.EmojiViewShow, true)
  self:UpdateFavorite()
  local viewdata = self.viewdata.viewdata
  local state = viewdata and viewdata.state
  local tabForbid = viewdata and viewdata.tabForbid
  if tabForbid and type(tabForbid) == "table" then
    for i = 1, #tabForbid do
      if self.tabToggles[tabForbid[i]] then
        self.tabToggles[tabForbid[i]].transform.parent.gameObject:SetActive(false)
      end
    end
    self.tabGrid:Reposition()
    for i = 1, #self.tabToggles do
      if TableUtility.ArrayFindIndex(tabForbid, i) == 0 then
        self:SelectTab(i)
        break
      end
    end
  end
  if state then
    self:Forbid(state)
  end
  if Game.Myself:IsDead() then
    self:Forbid(1)
  end
  self:FindGO("RoleExpressionTab"):SetActive(FunctionUnLockFunc.Me():CheckCanOpen(10015) == true)
  Asset_Role.ExpressionSwitch = true
  self.doubleActionWaitDeadline = ServerTime.CurClientTime()
end

function UIEmojiView:Forbid(state)
  if self.isEditMode then
    return
  end
  self:_ForEachEmojiCell(function(cell)
    cell:Forbid(state)
  end)
end

function UIEmojiView:MapViewInterest()
  self:AddListenEvt(EmojiEvent.ShowBord, self.RecvShowBord)
  self:AddListenEvt(EmojiEvent.HideBord, self.RecvHideBord)
  self:AddListenEvt(PhotographModeChangeEvent.ModeChangeEvent, self.RecvForbid)
  self:AddListenEvt(MyselfEvent.DeathBegin, self.HandleDeathBegin)
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
  self:AddListenEvt(ServiceEvent.ChatCmdUpdateFavoriteExpressionChatCmd, self.UpdateFavorite)
  self:AddListenEvt(MyselfEvent.DoubleAction_Ready, self.HandleDoubleActionReady)
end

function UIEmojiView:HandleDeathBegin(note)
  self:Forbid(1)
end

function UIEmojiView:HandleReliveStatus(note)
  self:Forbid(0)
end

function UIEmojiView:HandleDoubleActionReady(note)
  local nameCfg, id = GameConfig.TwinsAction.name_ch, note.body
  local isTimeOut = self.doubleActionWaitDeadline < ServerTime.CurClientTime()
  if nameCfg and id and not isTimeOut then
    MsgManager.ShowMsgByIDTable(42113, nameCfg[Game.Config_DoubleActionBuff[id]])
  end
end

function UIEmojiView:RecvForbid(note)
  self:Forbid(note.body or 0)
end

function UIEmojiView:RecvShowBord(note)
  self.bord:SetActive(true)
end

function UIEmojiView:RecvHideBord(note)
  self.bord:SetActive(false)
end

function UIEmojiView:OnExit()
  self:sendNotification(MainViewEvent.EmojiViewShow, false)
  self.emojiCtl:Destroy()
  Asset_Role.ExpressionSwitch = false
  UIEmojiView.super.OnExit(self)
end

function UIEmojiView:UpdateFavorite()
  self:SetEditMode(false)
  self:SelectTab(1)
end

function UIEmojiView:FindTabToggle(tabName)
  local tab = self:FindGO(tabName)
  if not tab then
    return
  end
  return self:FindComponent("Tog", UIToggle, tab)
end

function UIEmojiView:SelectTab(index)
  index = math.clamp(math.floor(index), 1, #self.tabToggles)
  if index == self.currentTabIndex then
    return
  end
  self.tabToggles[index].value = true
  local scaleFactor
  for i = 1, #self.tabIconSps do
    scaleFactor = i == index and 1 or 0.8
    self.tabIconSps[i].transform.localScale = LuaGeometry.GetTempVector3(scaleFactor, scaleFactor, scaleFactor)
    self.tabIconSps[i].gradientTop = i == index and LuaGeometry.GetTempVector4(0.8509803921568627, 1, 0.9882352941176471, 1) or LuaGeometry.GetTempVector4(0.7215686274509804, 0.7411764705882353, 0.8627450980392157, 1)
    self.tabIconSps[i].gradientBottom = i == index and LuaGeometry.GetTempColor() or LuaGeometry.GetTempVector4(0.7215686274509804, 0.7411764705882353, 0.8627450980392157, 1)
  end
  self.currentTabIndex = index
  self:UpdateTab(index)
  local wrapPosY = self.emojiWrapTrans.localPosition.y
  self.emojiCtl:ResetPosition()
  local wrapPosX, _, wrapPosZ = LuaGameObject.GetLocalPosition(self.emojiWrapTrans)
  self.emojiWrapTrans.localPosition = LuaGeometry.GetTempVector3(wrapPosX, wrapPosY, wrapPosZ)
end

function UIEmojiView:UpdateTab(index)
  index = index or self.currentTabIndex
  if not index then
    return
  end
  self.editModeBtn:SetActive(not self.isEditMode)
  self.editModeCtrl:SetActive(self.isEditMode)
  local datas
  if index == 1 then
    datas = self.isEditMode and self.tempFavoriteData or self.favoriteData
    local posI = 1
    for k, v in pairs(datas) do
      v.pos = posI
      posI = posI + 1
    end
  elseif index == 2 then
    datas = chatRoomProxy:GetEmojiExpressions()
  elseif index == 3 then
    self.actionDatas = self.actionDatas or {}
    TableUtility.ArrayClear(self.actionDatas)
    for _, d in pairs(Table_ActionAnime) do
      if d.DoubleAction and not UIEmojiCell.CheckIsPassiveActionByName(d.Name) and UIEmojiCell.CheckDoubleActionValid(d.id) then
        ChatRoomProxy._InsertNewExpressionData(self.actionDatas, UIEmojiType.Action, d.id)
      end
    end
    local remoteDatas = chatRoomProxy:GetActionExpressions()
    for i = 1, #remoteDatas do
      TableUtility.ArrayPushBack(self.actionDatas, remoteDatas[i])
    end
    datas = self.actionDatas
  elseif index == 4 then
    datas = chatRoomProxy:GetRoleExpressions()
  end
  self.emojiCtl:ResetDatas(self:ReUnitData(datas, 2))
  self.favoriteCountLabel.text = string.format("%s/%s", #self.tempFavoriteData, maxEmojiCountOfOnePage)
  self:_ForEachEmojiCell(function(cell)
    local isEditMode = self.isEditMode and cell.type ~= ExpressionType.RoleExpression
    cell:SetDragEnable(isEditMode and index == 1 and cell.content.activeSelf)
    cell:SetEditMode(isEditMode and (index == 1 and UIEmojiEditMode.Delete or UIEmojiEditMode.Toggle) or UIEmojiEditMode.None)
  end)
end

function UIEmojiView:SetEditMode(isEditMode)
  if isEditMode and self.currentTabIndex == 4 then
    MsgManager.ShowMsgByID(41240)
    return
  end
  self.isEditMode = isEditMode and true or false
  if isEditMode then
    TableUtility.TableClear(self.tempFavoriteData)
    TableUtility.ArrayShallowCopy(self.tempFavoriteData, self.favoriteData)
  end
  self:UpdateTab()
end

function UIEmojiView:CloseSelf()
  local realCloseFunc = function()
    UIEmojiView.super.CloseSelf(self)
  end
  if self.isEditMode then
    UIUtil.PopUpConfirmYesNoView("", ZhString.UIEmojiView_ExitEditMode, function()
      self:TryUpdateFavoriteExpression()
      realCloseFunc()
    end, realCloseFunc, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
  else
    realCloseFunc()
  end
end

function UIEmojiView:TryUpdateFavoriteExpression()
  if #self.tempFavoriteData == #self.favoriteData then
    local allSame = TableUtility.TableFindByPredicate(self.tempFavoriteData, function(pos, data)
      local element = self.favoriteData[pos]
      return element ~= nil and (element.id ~= data.id or element.type ~= data.type)
    end) == nil
    if allSame then
      self:SetEditMode(false)
      return
    end
  end
  chatRoomProxy:CallUpdateFavoriteExpression(self.tempFavoriteData)
end

function UIEmojiView:ReUnitData(datas, rowNum)
  self.unitData = self.unitData or {}
  TableUtility.ArrayClear(self.unitData)
  if datas and next(datas) then
    local i1, i2
    local index = 1
    for k, v in pairs(datas) do
      i1 = math.floor((index - 1) / rowNum) + 1
      i2 = math.floor((index - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = v
      index = index + 1
    end
  end
  return self.unitData
end

function UIEmojiView:_ForEachEmojiCell(action, ...)
  if not self.emojiCtl then
    return
  end
  local combineCells = self.emojiCtl:GetCellCtls()
  local cells
  for i = 1, #combineCells do
    cells = combineCells[i].childCells
    for j = 1, #cells do
      action(cells[j], ...)
    end
  end
end

function UIEmojiView:CheckSendExpressionAvailable()
  local isGuest = BranchMgr.IsChina() and tonumber(FunctionLogin.Me():get_IsTmp()) == 1 or OverseaHostHelper.isGuest == 1
  return not isGuest and isSendExpressionAvailable
end

function UIEmojiView.PlayActionTypeEmoji(id)
  local myself = Game.Myself
  if myself.data:IsTransformed() then
    MsgManager.ShowMsgByIDTable(830)
    return
  end
  local sdata = UIEmojiCell.TryReplaceMyProfessionAction(id)
  if sdata.SkillAction then
    Game.Myself:Client_UseSkill(sdata.SkillAction, target, nil, nil, true)
    return
  end
  if string.find(sdata.Name, "ride_") and not myself.assetRole:HasActionRaw(sdata.Name) then
    local _BagProxy = BagProxy.Instance
    local mount = _BagProxy.roleEquip:GetMount()
    if mount then
      local sites = mount.equipInfo:GetEquipSite()
      ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFF, sites[1], mount.id, false)
    end
    local fmount = _BagProxy.fashionEquipBag:GetMount()
    if fmount then
      local sites = fmount.equipInfo:GetEquipSite()
      ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, sites[1], fmount.staticData.id, false)
    end
  end
  if sdata.Condition == 1 and not myself:IsOnSceneSeat() then
    MsgManager.ShowMsgByIDTable(925)
    return
  end
  if sdata.DoubleAction then
    return
  end
  local once = TableUtility.ArrayFindIndex(GameConfig.OnlyOnceAction.action_id, sdata.id) > 0 and true or false
  myself:Client_PlayMotionAction(sdata.id, once)
  local isGuest = BranchMgr.IsChina() and tonumber(FunctionLogin.Me():get_IsTmp()) == 1 or OverseaHostHelper.isGuest == 1
  local _CheckSendExpressionAvailable = not isGuest and not GameConfig.SystemForbid.ChatText
  if _CheckSendExpressionAvailable then
    FunctionSecurity.Me():TryDoRealNameCentify(function()
      local target = Game.Myself:GetLockTarget()
      ChatRoomProxy.Instance:CallExpressionChatCmd(ChatChannelEnum.Current, UIEmojiType.Action, id, target and target.data)
    end)
  end
end
