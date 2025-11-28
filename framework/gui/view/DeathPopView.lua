DeathPopView = class("DeathPopView", ContainerView)
DeathPopView.ViewType = UIViewType.ReviveLayer
DeathPopView.TextureBg = "persona_bg_npc"
autoImport("DeathQuickUsePopup")
local resurrectionItemId, resurrectionItemIds
local deltatime = 0
local LeaveMsgID = 105

function DeathPopView:Init()
  self:initData()
  self:initView()
  self:handleDelay()
  self:addEventListener()
  self:AddViewEvts()
end

function DeathPopView:handleDelay()
  if not self.mapMng:IsPveMode_PveCard() then
    return
  end
  self:Hide()
  if self.blockID then
    self.blockID:Destroy()
    self.blockID = nil
  end
  local delay = GameConfig.CardRaid.deathview_delay or 10
  self.blockID = TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
    self:Show()
  end, self)
end

function DeathPopView:initData()
  self.isPvpMap = SceneProxy.Instance:IsPvPScene()
  self.totalTime = GameConfig.DeathPopViewShowTime.showTime
  self.leftTime = self.totalTime
  self.costItem = GameConfig.UserRelive.deathcost2[1].id
  self.reliveCostCount = GameConfig.UserRelive.deathcost2[1].num
  self.isDaoChangMap = DojoProxy.Instance:IsSelfInDojo()
  self.currentMap = SceneProxy.Instance.currentScene
  self.mapMng = Game.MapManager
  self.isOthelloMap = Game.MapManager:IsPVPMode_TeamPwsOthello()
  self.isTransferFight = Game.MapManager:IsPVPMode_TransferFight()
end

function DeathPopView:initView()
  self.goldIcon = self:FindGO("gold"):GetComponent(UISprite)
  self.title = self:FindGO("deathTitle"):GetComponent(UILabel)
  self.title.text = ZhString.DeathPopView_Title
  local ReliveInSituLabel = self:FindComponent("ReliveInSituLabel", UILabel)
  ReliveInSituLabel.text = ZhString.DeathPopView_ReliveInSitu
  self.ReliveInRelivePointLabel = self:FindComponent("ReliveInRelivePointLabel", UILabel)
  self.ReliveInRelivePointLabel.text = ZhString.DeathPopView_ReliveInRelivePoint
  self.ReliveInSavePointLabel = self:FindComponent("ReliveInSavePointLabel", UILabel)
  self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInSavePoint
  local ReliveInRelivePointBtn = self:FindGO("ReliveInRelivePointBtn")
  self.timeCt = self:FindGO("timeCt")
  self.timeThumnail = self:FindGO("timeThumnail")
  self.timeSlider = self:FindComponent("timeSlider", UISlider)
  self.itemData = Table_Item[self.costItem]
  if self.itemData then
    IconManager:SetItemIcon(self.itemData.Icon, self.goldIcon)
  end
  local totalCount = BagProxy.Instance:GetItemNumByStaticID(self.costItem)
  self.ReliveInRelivePointBtnBox = self:FindComponent("ReliveInRelivePointBtn", BoxCollider)
  self.ReliveInRelivePointBtnSp = self:FindComponent("ReliveInRelivePointBtn", UISprite)
  self.ReliveInRelivePointBtnCt = self:FindGO("ReliveInRelivePointBtnCt")
  self.ReliveInSavePointBtn = self:FindGO("ReliveInSavePointBtn")
  local ReliveInSavePointBtnCt = self:FindGO("ReliveInSavePointBtnCt")
  local ReliveInSavePointBg = self:FindComponent("ReliveInSavePointBtn", UISprite)
  self.ReliveInSituBtnCt = self:FindGO("ReliveInSituBtnCt")
  self.DeathHint = self:FindComponent("DeathHint", UILabel)
  self:UpdateDeathHint()
  if self.isPvpMap or self.mapMng:IsRaidPuzzle() or self.mapMng:IsPVEMode_ComodoRaid() or self.mapMng:IsPVEMode_MultiBossRaid() or self.mapMng:IsPVEMode_Element() or self.mapMng:IsPVEMode_StarArk() or self.mapMng:IsPVPMode_EndlessBattleField() then
    self:Hide(self.ReliveInSituBtnCt)
    if self.isOthelloMap or self.isTransferFight then
      self:StartOthelloReliveCd()
    elseif self.mapMng:IsPvPMode_TeamTwelve() or self.mapMng:IsRaidPuzzle() then
      deltatime = (MyselfProxy.Instance.reliveFubenCD or 0) - ServerTime.CurServerTime() / 1000
      self:StartOthelloReliveCd(deltatime)
    elseif self.mapMng:IsPVPMode_3Teams() then
      self:StartPvp3TeamsRebornCd()
    end
    self:UpdateComodoPhase()
    self:UpdateMultiBossPhase()
    self:UpdateStarArkPhase()
    if self.mapMng:IsPVPMode_GVGDetailed() then
      self:Hide(self.ReliveInRelivePointBtnCt)
    end
  elseif self.isDaoChangMap then
    self:Hide(self.ReliveInRelivePointBtnCt)
    self:Hide(self.timeCt)
    if totalCount < self.reliveCostCount then
      self:Hide(self.ReliveInSituBtnCt)
    end
  elseif not self.isPvpMap then
    self:Hide(self.ReliveInRelivePointBtnCt)
    ReliveInSavePointBg.spriteName = "com_btn_3s"
    self.ReliveInSavePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
    self.timeCt.transform:SetParent(self.ReliveInSavePointBtn.transform, false)
    if totalCount < self.reliveCostCount then
      self:Hide(self.ReliveInSituBtnCt)
    end
  end
  if self:CanHideReliveInSavePoint() then
    self:Hide(ReliveInSavePointBtnCt)
  end
  local BoundCt = self:FindGO("BoundCt")
  local grid = BoundCt:GetComponent(UITable)
  grid:Reposition()
  local btnCt = self:FindGO("btnCt"):GetComponent(UISprite)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(BoundCt.transform, false)
  local tmp = bound.size.y + 54.0
  bound = NGUIMath.CalculateRelativeWidgetBounds(self.DeathHint.transform, false)
  tmp = tmp + bound.size.y
  btnCt.height = tmp
  if Game.MapManager:IsPVeMode_EndlessTowerPrivate() then
    local curMapID = Game.MapManager:GetMapID()
    if curMapID == 115 then
      self.ReliveInSavePointLabel.text = ZhString.PracticeField_BackLabel
    else
      self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveAndLeave
    end
  elseif self.currentMap:IsInDungeonMap() then
    self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveAndLeave
  end
  self.bgTexture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI(DeathPopView.TextureBg, self.bgTexture)
  self:HandleReliveCd()
  self:InitItemPopup()
  self:UpdateResurrectionPop()
end

function DeathPopView:UpdateDeathHint()
  local userData = Game.Myself.data.userdata
  local base = userData:Get(UDEnum.DROPBASEEXP)
  local defeat = userData:GetBytes(UDEnum.KILLERNAME)
  if self.isPvpMap or Game.MapManager:IsPVeMode_EndlessTowerPrivate() then
    self.DeathHint.text = string.format(ZhString.DeathPopView_TitleHintPvP, defeat)
  else
    self.DeathHint.text = string.format(ZhString.DeathPopView_TitleHint, defeat, base)
  end
end

function DeathPopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
  self:AddListenEvt(ItemEvent.ItemUseTip, self.HandleItemUseTip)
  self:AddListenEvt(ServiceEvent.FuBenCmdComodoPhaseFubenCmd, self.UpdateComodoPhase)
  self:AddListenEvt(ServiceEvent.FuBenCmdMultiBossPhaseFubenCmd, self.UpdateMultiBossPhase)
  self:AddListenEvt(MyselfEvent.KillNameChange, self.UpdateDeathHint)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncStarArkStatisticsFuBenCmd, self.UpdateStarArkPhase)
end

function DeathPopView:UpdateComodoPhase()
  local phase
  if Game.MapManager:IsPVEMode_ComodoRaid() then
    phase = GroupRaidProxy.Instance:GetComodoRaidPhase()
  end
  if phase == nil then
    return
  end
  if phase ~= 0 and phase ~= 4 then
    self.ReliveInRelivePointBtnBox.enabled = false
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
  else
    self.ReliveInRelivePointBtnBox.enabled = true
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
  end
end

function DeathPopView:UpdateMultiBossPhase()
  if not self.mapMng:IsPVEMode_MultiBossRaid() and not self.mapMng:IsPVEMode_Element() then
    return
  end
  local phase = GroupRaidProxy.Instance:GetMultiBossRaidPhase()
  if phase ~= 0 then
    self.ReliveInRelivePointBtnBox.enabled = false
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
  else
    self.ReliveInRelivePointBtnBox.enabled = true
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
  end
end

function DeathPopView:UpdateStarArkPhase()
  if Game.MapManager:IsPVEMode_StarArk() then
    passed = DungeonProxy.Instance.starArk_Passed
  else
    return
  end
  if not passed then
    self.ReliveInRelivePointBtnBox.enabled = false
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
  else
    self.ReliveInRelivePointBtnBox.enabled = true
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
  end
end

function DeathPopView:HandleReliveStatus(note)
  self:CloseSelf()
end

function DeathPopView:ConfirmLeave(type, call)
  local raidId = Game.MapManager:GetRaidID()
  local confirmConfig = GameConfig.DeathReviveConfirm
  local cfgNumber = raidId and confirmConfig and confirmConfig[raidId][type]
  if cfgNumber then
    if cfgNumber == 1 then
      if Game.MapManager:IsRaidMode() then
        MsgManager.ConfirmMsgByID(LeaveMsgID, function()
          ServiceNUserProxy.Instance:CallRelive(type)
          if call then
            call()
          end
        end, nil, nil)
      end
      return
    end
  elseif Game.MapManager:IsRaidMode() then
    redlog(string.format("是否需要确认复活. (副本id:%s, 复活类型：%s)", raidId, type), string.format("如果不需要弹框确认，则在 GameConfig.DeathReviveConfirm 中添加配置 [%s] = {[%s] = 0}", raidId, type))
    MsgManager.ConfirmMsgByID(LeaveMsgID, function()
      ServiceNUserProxy.Instance:CallRelive(type)
      if call then
        call()
      end
    end, nil, nil)
    return
  end
  ServiceNUserProxy.Instance:CallRelive(type)
  if call then
    call()
  end
end

function DeathPopView:addEventListener()
  self:AddButtonEvent("ReliveInSituBtn", function(obj)
    if Game.Myself.data:NoRelive() then
      return
    end
    ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_MONEY)
  end)
  self:AddButtonEvent("ReliveInRelivePointBtn", function(obj)
    if self.mapMng:IsPVEMode_ComodoRaid() or self.mapMng:IsPVEMode_MultiBossRaid() or self.mapMng:IsPVEMode_Element() or self.mapMng:IsPVEMode_StarArk() or self.mapMng:IsPVPMode_EndlessBattleField() then
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_SYSTEM_CLIENT)
    else
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
    end
  end)
  self:AddButtonEvent("ReliveInSavePointBtn", function(obj)
    if self.isPvpMap then
      self:ConfirmLeave(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
    elseif Game.MapManager:IsPveMode_Thanatos() then
      MsgManager.ConfirmMsgByID(25937, function()
        ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
      end, nil, nil)
    elseif Game.MapManager:IsPVeMode_EndlessTowerPrivate() then
      MyselfProxy.Instance.failPassPersonalEndlessTower = true
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
    elseif self.mapMng:IsPVEMode_ComodoRaid() or self.mapMng:IsPVEMode_MultiBossRaid() or self.mapMng:IsPVEMode_Element() or self.mapMng:IsPVEMode_StarArk() then
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_SYSTEM_CLIENT)
    else
      self:ConfirmLeave(SceneUser2_pb.ERELIVETYPE_RETURN)
    end
  end)
  self:AddListenEvt(ServiceEvent.UserEventDieTimeCountEventCmd, self.HandleReliveCd)
end

function DeathPopView:HandleReliveCd(data)
  if self.mapMng:IsInGVGRaid() then
    self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInGVG
    local time = MyselfProxy.Instance.reliveStamp
    time = time and time or 0
    if 0 < time then
      self.ReliveInRelivePointBtnBox.enabled = false
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
      local currentTime = ServerTime.CurServerTime()
      currentTime = currentTime / 1000
      self.totalTime = math.floor(time - currentTime)
      self.title.text = string.format(ZhString.DeathPopView_TitleReliveHintGVG, MyselfProxy.Instance.reliveName)
      self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
      if 0 < self.totalTime then
        self.Show(self.timeCt)
        if self.timeTickCD then
          self.timeTickCD:Destroy()
          self.timeTickCD = nil
        end
        self.timeTickCD = TimeTickManager.Me():CreateTick(0, 1000, self.updateCdTime, self)
      end
    elseif self.mapMng:IsPVPMode_GVGDetailed() then
      self.ReliveInRelivePointBtnBox.enabled = false
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13"
    else
      self.ReliveInRelivePointBtnBox.enabled = true
      self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    end
  end
end

function DeathPopView:OnEnter()
  DeathPopView.super.OnEnter(self)
  self:sendNotification(MainViewEvent.ActiveShortCutBord, false)
end

function DeathPopView:OnExit()
  self:sendNotification(MainViewEvent.ActiveShortCutBord, true)
  self.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadUI(DeathPopView.TextureBg, self.bgTexture)
  MyselfProxy.Instance:ClearReliveCd()
  MyselfProxy.Instance:ClearReliveFubenCd()
  if self.blockID then
    self.blockID:Destroy()
    self.blockID = nil
  end
end

function DeathPopView:updateCdTime()
  local currentTime = ServerTime.CurServerTime()
  currentTime = currentTime / 1000
  local time = MyselfProxy.Instance.reliveStamp
  local leftTime = time - currentTime
  leftTime = math.floor(leftTime)
  local delta = 1 - leftTime / self.totalTime
  if leftTime <= 0 then
    leftTime = 0
    local isDead = Game.Myself:IsDead()
    if isDead then
    else
      self:CloseSelf()
      return
    end
  end
  self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintDesGVG, leftTime)
  self.timeSlider.value = delta
  self.timeThumnail.transform.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 90 - delta * 360)
end

function DeathPopView:StartOthelloReliveCd(deltatime)
  redlog("StartOthelloReliveCd", deltatime)
  if deltatime then
    self.oTataltime = deltatime
  elseif self.isOthelloMap then
    self.oTataltime = GameConfig.Othello.revivetime
  elseif self.isTransferFight then
    self.oTataltime = GameConfig.TransferFight.Realive or 3
  end
  if self.oTataltime and self.oTataltime > 0 then
    self.ReliveInRelivePointBtnBox.enabled = false
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13s"
    local currentTime = ServerTime.CurServerTime()
    currentTime = currentTime / 1000
    self.oCdStarttime = currentTime
    self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintOthello, time)
    self.ReliveInRelivePointLabel.effectColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
    if self.timeTickCD then
      self.timeTickCD:Destroy()
      self.timeTickCD = nil
    end
    self.timeTickCD = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateOthelloCdTime, self)
  else
    self.ReliveInRelivePointBtnBox.enabled = true
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
    self.ReliveInRelivePointLabel.text = ZhString.DeathPopView_ReliveInRelivePoint
  end
end

function DeathPopView:UpdateOthelloCdTime()
  local currentTime = ServerTime.CurServerTime()
  currentTime = currentTime / 1000
  local lefttime = self.oTataltime - (currentTime - self.oCdStarttime)
  if 0 < lefttime then
    lefttime = math.modf(lefttime)
    self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintOthello, lefttime)
  else
    self.ReliveInRelivePointBtnBox.enabled = true
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.1607843137254902, 0.4117647058823529, 0, 1)
    self.ReliveInRelivePointLabel.text = ZhString.DeathPopView_ReliveInRelivePoint
    if self.timeTickCD then
      self.timeTickCD:Destroy()
      self.timeTickCD = nil
    end
  end
end

function DeathPopView:StartPvp3TeamsRebornCd()
  local time = GameConfig.Triple.ReliveCD or 0
  if 0 < time then
    local leftTime = time
    self.ReliveInRelivePointBtnBox.enabled = false
    self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13s"
    self.ReliveInRelivePointLabel.effectColor = Color(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
    if self.timeTickCD then
      self.timeTickCD:Destroy()
      self.timeTickCD = nil
    end
    self.timeTickCD = TimeTickManager.Me():CreateTick(0, 1000, function()
      self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintDesGVG, leftTime)
      if leftTime == 0 then
        ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
        return
      end
      leftTime = leftTime - 1
    end, self)
  end
end

function DeathPopView:InitItemPopup()
  if not self.quickPopUp then
    local rightBottomHide = self:FindChild("RightBottomHide")
    local path = ResourcePathHelper.UIPopup("QuickUsePopup")
    local popup = Game.AssetManager_UI:CreateAsset(path, rightBottomHide)
    popup.transform.localPosition = LuaGeometry.Const_V3_zero
    self.quickPopUp = DeathQuickUsePopup.new(popup)
    self:RegisterChildPopObj(popup)
  end
  self.quickPopUp:Hide()
end

function DeathPopView:UpdateResurrectionPop()
  local useTipData = {}
  useTipData.type = QuickUseProxy.Type.Item
  resurrectionItemIds = GameConfig.UserRelive.limit_item_relive
  if not resurrectionItemIds or #resurrectionItemIds == 0 then
    return
  end
  local item
  for i = 1, #resurrectionItemIds do
    resurrectionItemId = resurrectionItemIds[i]
    item = BagProxy.Instance:GetItemByStaticID(resurrectionItemId)
    if item then
      local mapid = SceneProxy.Instance:GetCurMapID()
      if item:CheckMapLimit(mapid) then
        useTipData.data = item
        self.quickPopUp:SetData(useTipData)
        return
      end
    end
  end
end

function DeathPopView:CanHideReliveInSavePoint()
  local MapManager = Game.MapManager
  return MapManager:IsGvgMode_Droiyan() or MapManager:IsPVPMode_TeamPws() or MapManager:IsPveMode_Thanatos() or MapManager:IsPVEMode_Roguelike() or MapManager:IsPvPMode_TeamTwelve() or MapManager:IsPVEMode_DeadBoss() or self.isTransferFight or MapManager:IsRaidPuzzle() or MapManager:IsPVEMode_ComodoRaid() or MapManager:IsPVEMode_MultiBossRaid() or MapManager:IsPVEMode_Element() or MapManager:IsPvpMode_DesertWolf() or MapManager:IsPVEMode_StarArk() or MapManager:IsPVPMode_3Teams() or MapManager:IsPVPMode_EndlessBattleField()
end
