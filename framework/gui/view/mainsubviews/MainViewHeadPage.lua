MainViewHeadPage = class("MainViewHeadPage", SubView)
autoImport("UIGridListCtrl")
autoImport("MainViewPlayerFaceCell")
autoImport("TargetHeadCell")
autoImport("GuildVoiceCell")
MainViewHeadPage.HeadType = {
  Pet = 1,
  Being = 2,
  Servant = 3,
  LockTarget = 4,
  Boki = 5,
  Pippi = 6,
  Max = 6
}
local M_HeadType = MainViewHeadPage.HeadType
local M_HeadListType = {
  [M_HeadType.Being] = 1
}
local FrenzyBuffID = 124120
local _BokiNpcID

function MainViewHeadPage:Init()
  _BokiNpcID = GameConfig.BoKiConfig and GameConfig.BoKiConfig.BoKiNpcID or 300105
  self:InitUI()
  self:MapInterestEvent()
  self:UpdateMyHead()
  self:UpdateMyHeadTeaminfo()
  self:UpdateItemImageUserNtf()
  self:RegistRedTip()
end

function MainViewHeadPage:InitUI()
  local targetsBord = self:LoadPreferb("part/MainViewHeadTargets", self:FindGO("LeftTopFuncGrid"), true)
  local headContainer = self:FindChild("MyHeadContainer", targetsBord)
  self.headCellObj = self:LoadPreferb("cell/MainViewPlayerHeadCell", headContainer)
  self.headCellObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  self.myHeadCell = MainViewPlayerFaceCell.new(self.headCellObj)
  self:AddOrRemoveGuideId(self.headCellObj, 101)
  self:RegisterGuideTarget(ClientGuide.TargetType.mainview_myselfheadcell, self.myHeadCell.gameObject)
  self.myHeadCell:SetMinDepth(40)
  self.myHeadCell:AddEventListener(MouseEvent.MouseClick, self.ClickMyHead, self)
  self.myHeadData = HeadImageData.new()
  self.frenzy = self:FindComponent("Frenzy", UISlider, headContainer)
  self.frenzyContainer = self:FindGO("EffectContainer", self.frenzy.gameObject)
  self.headGrid = self:FindComponent("HeadGrid", UIGrid, targetsBord)
  self.targetHeadsCtl = UIGridListCtrl.new(self.headGrid, TargetHeadCell, "TargetHeadCell")
  self.targetHeadsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTargetHead, self)
  self.targetHeadsCtl:AddEventListener(TargetHeadEvent.CancelChoose, self.CancelChooseTarget, self)
  self.headTargetDataMap = {}
  self.VoiceGrid = self:FindGO("VoiceGrid", targetsBord)
  if self.VoiceGrid then
    self.VoiceGrid.gameObject:SetActive(false)
    self.VoiceGridVoiceCell1 = self:FindGO("VoiceCell1", self.VoiceGrid)
    self.VoiceGridVoiceCell2 = self:FindGO("VoiceCell2", self.VoiceGrid)
    self.VoiceGridVoiceCell3 = self:FindGO("VoiceCell3", self.VoiceGrid)
    self.VoiceCell1 = GuildVoiceCell.new(self.VoiceGridVoiceCell1)
    self.VoiceCell2 = GuildVoiceCell.new(self.VoiceGridVoiceCell2)
    self.VoiceCell3 = GuildVoiceCell.new(self.VoiceGridVoiceCell3)
    self.VoiceGridVoiceCell1.gameObject:SetActive(false)
    self.VoiceGridVoiceCell2.gameObject:SetActive(false)
    self.VoiceGridVoiceCell3.gameObject:SetActive(false)
    self.VoiceCellTable = {}
    table.insert(self.VoiceCellTable, self.VoiceCell1)
    table.insert(self.VoiceCellTable, self.VoiceCell2)
    table.insert(self.VoiceCellTable, self.VoiceCell3)
  end
  self.quickTargetButton = self:FindGO("QuickTargetButton")
  if self.quickTargetButton then
    self:AddClickEvent(self.quickTargetButton, function(g)
      self:OnClickQuickTarget()
    end)
    self.quickTargetButton:SetActive(false)
  end
end

function MainViewHeadPage:ClickMyHead()
  if FunctionSkillTargetPointLauncher.Me():SetTargetPointPlayer(Game.Myself.data.id) then
    Game.Myself:Client_ManualControlled()
    FunctionSkillTargetPointLauncher.Me():LaunchSkill()
    FunctionPlayerTip.Me():CloseTip()
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Charactor
    })
  end
end

function MainViewHeadPage:ClickTargetHead(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local headType = data:GetCustomParam("HeadType")
  if headType == M_HeadType.LockTarget then
    local creature = SceneCreatureProxy.FindCreature(self.targetId)
    if creature and creature:GetCreatureType() == Creature_Type.Player then
      if not self.playerTipShow then
        if GuildProxy.Instance:GetMercenaryGuildName(creature.data) ~= nil then
          MsgManager.ShowMsgByID(2669)
          return
        end
        local playerData = PlayerTipData.new()
        playerData:SetByCreature(creature)
        self.playerTipShow = true
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
        local tipData = {playerData = playerData}
        tipData.funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(self.targetId)
        table.insert(tipData.funckeys, "Double_Action")
        table.insert(tipData.funckeys, "Booth")
        table.insert(tipData.funckeys, "EnterHomeRoom")
        playerTip:SetData(tipData)
        
        function playerTip.closecallback(go)
          self.playerTipShow = false
        end
      else
        FunctionPlayerTip.Me():CloseTip()
        self.playerTipShow = false
      end
    elseif creature and creature:GetCreatureType() == Creature_Type.Npc and creature.data:IsSkada() then
      if not self.playerTipShow then
        local playerData = PlayerTipData.new()
        playerData:SetByCreature(creature)
        self.playerTipShow = true
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
        local tipData = {
          playerData = playerData,
          isskada = 1,
          funckeys = {
            "Skada_Settings",
            "Skada_Analysis"
          }
        }
        playerTip:SetData(tipData)
        
        function playerTip.closecallback(go)
          self.playerTipShow = false
        end
      else
        FunctionPlayerTip.Me():CloseTip()
        self.playerTipShow = false
      end
    end
  elseif headType == M_HeadType.Pet then
    if data:GetCustomParam("alive") then
      if not self.petTipShow then
        local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
        if myPetInfo then
          self.petTipShow = true
          local playerData = PlayerTipData.new()
          playerData:SetByPetInfoData(myPetInfo)
          FunctionPet.Me():ShowPetTip(playerData, function(go)
            self.petTipShow = false
          end, cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
        end
      else
        FunctionPlayerTip.Me():CloseTip()
        self.petTipShow = false
      end
    end
  elseif headType == M_HeadType.Being then
    if not self.beingTipShow then
      local beingInfo = PetProxy.Instance:GetMyBeingNpcInfo(data.beingid)
      if beingInfo then
        self.beingTipShow = true
        local playerData = PlayerTipData.new()
        playerData:SetByBeingInfoData(beingInfo)
        local petTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
        local tipData = {playerData = playerData, isBeing = 1}
        tipData.funckeys = {
          "Pet_CallBack",
          "Pet_ShowDetail",
          "Pet_AutoFight"
        }
        petTip:SetData(tipData)
        
        function petTip.closecallback(go)
          self.beingTipShow = false
        end
        
        local s1 = string.format(ZhString.MainViewHeadPage_Name, beingInfo.name)
        local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data:GetName())
        petTip:SetDesc(s1, s2, "")
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.beingTipShow = false
    end
  elseif headType == M_HeadType.Servant then
    if not self.servantTipShow and self.myServant then
      self.servantTipShow = true
      local playerData = PlayerTipData.new()
      playerData:SetByCreature(self.myServant)
      playerData.headData:TransByNpcData(self.myServant.data.staticData)
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
      local tipData = {
        playerData = playerData,
        funckeys = {
          "ServantShop",
          "ServantHandIn",
          "ServantReset"
        },
        isServant = 1
      }
      playerTip:SetData(tipData)
      
      function playerTip.closecallback(go)
        self.servantTipShow = false
      end
      
      local s1 = string.format(ZhString.MainViewHeadPage_Name, data.name)
      local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data:GetName())
      playerTip:SetDesc(s1, s2, "")
    else
      FunctionPlayerTip.Me():CloseTip()
      self.servantTipShow = false
    end
  elseif headType == M_HeadType.Boki then
    local myBoki = BokiProxy.Instance:GetSceneBoki()
    if not self.bokiTipShow and myBoki then
      self.bokiTipShow = true
      local playerData = PlayerTipData.new()
      playerData:SetByBokiData(myBoki)
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
      local tipData = {
        playerData = playerData,
        funckeys = {
          "Boki_Detail",
          "Boki_Follow",
          "Boki_CancelFollow",
          "Boki_ResetPos"
        },
        isBoki = 1
      }
      playerTip:SetData(tipData)
      
      function playerTip.closecallback(go)
        self.bokiTipShow = false
      end
      
      local s1 = string.format(ZhString.MainViewHeadPage_Name, data.name)
      local s2 = string.format(ZhString.MainViewHeadPage_Master, Game.Myself.data:GetName())
      playerTip:SetDesc(s1, s2, "")
    else
      FunctionPlayerTip.Me():CloseTip()
      self.bokiTipShow = false
    end
  elseif headType == M_HeadType.Pippi then
    local pippi = true
    if pippi then
      self.pippiTipShow = true
      local playerData = PlayerTipData.new()
      playerData:SetByPippiData()
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headBg, NGUIUtil.AnchorSide.TopRight, {-18, 36})
      local tipData = {
        playerData = playerData,
        funckeys = {
          "Pippi_Summon",
          "Pippi_Retire"
        },
        isPippi = 1
      }
      playerTip:SetData(tipData)
      
      function playerTip.closecallback(go)
        self.pippiTipShow = false
      end
      
      local mypippiGUID = NScenePetProxy.Instance:GetMyPipipi()
      local p_creature = SceneCreatureProxy.FindCreature(mypippiGUID)
      if p_creature then
        Game.Myself:Client_LockTarget(p_creature)
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.pippiTipShow = false
    end
  end
end

function MainViewHeadPage:CancelChooseTarget()
  if not Game.AutoBattleManager.on then
    Game.Myself:Client_LockTarget(nil)
  end
end

function MainViewHeadPage:UpdateMyHead()
  self.myHeadData:Reset()
  self.myHeadData:TransformByCreature(Game.Myself)
  self.myHeadData.iconData.isMyself = 1
  self.myHeadCell:SetData(self.myHeadData)
end

function MainViewHeadPage:onTeamUpdate()
  self:UpdateMyHead()
  self.myHeadCell:updateGmeInfo()
end

function MainViewHeadPage:onEnterTeam()
  self:UpdateMyHead()
  self.myHeadCell:onEnterTeam()
end

function MainViewHeadPage:UpdateMyHeadByNpcID(data)
  self.myHeadData:Reset()
  self.myHeadData:TransByNpcData(Table_Npc[data.body])
  self.myHeadData.iconData.isMyself = 1
  self.myHeadCell:SetData(self.myHeadData)
end

function MainViewHeadPage:UpdateMyHeadTeaminfo(note)
  if TeamProxy.Instance:IHaveTeam() then
    local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
    self.myHeadCell:SetTeamLeaderSymbol(myMemberData and myMemberData.job)
  else
    self.myHeadCell:SetTeamLeaderSymbol(false)
  end
end

function MainViewHeadPage:UpdateItemImageUserNtf()
  self.myHeadCell.symbols:Active(PlayerFaceCell_SymbolType.ImageCreate, TeamProxy.Instance:CheckImageInActive())
end

function MainViewHeadPage:UpdateMyHeadPortraitFrame(note)
  local userData = Game.Myself.data.userdata
  local portraitFrame = userData:Get(UDEnum.PORTRAIT_FRAME) or 0
  self.myHeadCell:SetPortraitFrame(portraitFrame)
end

function MainViewHeadPage:HidePetHeadCell(b)
  if self.petHead_Hide == b then
    return
  end
  self.targetDatas_Dirty = true
  self.petHead_Hide = b
  if self.petHead_Hide then
    local petImageData = self.headTargetDataMap[M_HeadType.Pet]
    if petImageData then
      petImageData:Reset()
    end
  else
    self:UpdatePetHeadData()
  end
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:HideBeingHeadCell(b)
  if self.beingHead_Hide == b then
    return
  end
  self.targetDatas_Dirty = true
  self.beingHead_Hide = b
  if self.beingHead_Hide then
    local beingImageDatas = self.headTargetDataMap[M_HeadType.Being]
    if beingImageDatas then
      for i = 1, #beingImageDatas do
        beingImageDatas[i]:Reset()
      end
    end
  else
    self:UpdateBeingHeadDatas()
  end
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:UpdatePetHeadData()
  if self.petHead_Hide then
    return
  end
  self.targetDatas_Dirty = true
  local petImageData = self.headTargetDataMap[M_HeadType.Pet]
  local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
  if myPetInfo == nil then
    if petImageData ~= nil then
      petImageData:Reset()
    end
    return
  end
  if petImageData == nil then
    petImageData = HeadImageData.new()
    petImageData:SetCustomParam("HeadType", M_HeadType.Pet)
    self.headTargetDataMap[M_HeadType.Pet] = petImageData
  end
  petImageData:TransByPetInfoData(myPetInfo)
  petImageData:SetCustomParam("alive", myPetInfo:IsAlive())
  petImageData:SetCustomParam("relivetime", myPetInfo.relivetime)
end

function MainViewHeadPage:UpdateBeingHeadDatas()
  if self.beingHead_Hide then
    return
  end
  self.targetDatas_Dirty = true
  local beingImageDatas = self.headTargetDataMap[M_HeadType.Being]
  if beingImageDatas == nil then
    beingImageDatas = {}
    self.headTargetDataMap[M_HeadType.Being] = beingImageDatas
  end
  local _PetProxy = PetProxy.Instance
  local beinglist = _PetProxy:GetMySummonBeingList()
  local beingCount = #beinglist
  for i = 1, beingCount do
    local headData = beingImageDatas[i]
    if headData == nil then
      headData = HeadImageData.new()
      headData:SetCustomParam("HeadType", M_HeadType.Being)
      beingImageDatas[i] = headData
    end
    local beingInfo = _PetProxy:GetMyBeingNpcInfo(beinglist[i])
    if beingInfo == nil then
      headData:Reset()
    else
      headData:TransByBeingInfoData(beingInfo)
      headData:SetCustomParam("alive", beingInfo:IsAlive())
    end
  end
  for i = beingCount + 1, #beingImageDatas do
    beingImageDatas[i]:Reset()
  end
end

function MainViewHeadPage:UpdateServantHeadData(creature)
  local servantImageData = self.headTargetDataMap[M_HeadType.Servant]
  if creature == nil then
    if servantImageData ~= nil then
      servantImageData:Reset()
      self.targetDatas_Dirty = true
    end
    return
  end
  self.targetDatas_Dirty = true
  if servantImageData == nil then
    servantImageData = HeadImageData.new()
    self.headTargetDataMap[M_HeadType.Servant] = servantImageData
    servantImageData:SetCustomParam("HeadType", M_HeadType.Servant)
  end
  servantImageData:TransByNpcData(creature.data.staticData)
end

function MainViewHeadPage:UpdateLockTargetHeadData(creature)
  local lockTargetImageData = self.headTargetDataMap[M_HeadType.LockTarget]
  if creature and creature.IsMyPet and creature:IsMyPet() then
    creature = nil
  elseif creature and creature:GetCreatureType() == Creature_Type.Pet and creature.data:IsSkillNpc() and not creature.data:IsPippi() then
    creature = nil
  end
  if creature == nil then
    if lockTargetImageData then
      lockTargetImageData:Reset()
      self.targetDatas_Dirty = true
    end
    return
  end
  self.targetDatas_Dirty = true
  if lockTargetImageData == nil then
    lockTargetImageData = HeadImageData.new()
    lockTargetImageData:SetCustomParam("HeadType", M_HeadType.LockTarget)
    self.headTargetDataMap[M_HeadType.LockTarget] = lockTargetImageData
  end
  lockTargetImageData:TransformByCreature(creature)
  if lockTargetImageData.hide then
    lockTargetImageData:Reset()
  end
end

function MainViewHeadPage:HandelUpdatePippi(...)
  self:UpdatePippiHeadData()
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:UpdatePippiHeadData()
  self.targetDatas_Dirty = true
  local pState, pTime = PetProxy.Instance:GetMyPippiInfoData()
  local petInfo = {}
  petInfo.petid = 580400
  petInfo.guid = NScenePetProxy.Instance:GetMyPipipi()
  local pippiImageData = self.headTargetDataMap[M_HeadType.Pippi]
  if not pState then
    if pippiImageData then
      pippiImageData:Reset()
      self.targetDatas_Dirty = true
    end
    return
  end
  if not pippiImageData then
    pippiImageData = HeadImageData.new()
    pippiImageData:SetCustomParam("HeadType", M_HeadType.Pippi)
    self.headTargetDataMap[M_HeadType.Pippi] = pippiImageData
  else
    pippiImageData.guid = petInfo.guid
  end
  pippiImageData:TransByPippiData(petInfo)
  pippiImageData:SetCustomParam("pippi_state", pState)
  pippiImageData:SetCustomParam("pippi_revivetime", pTime)
end

function MainViewHeadPage:_DoUpdateHeadTargetsUI()
  if not self.targetDatas_Dirty then
    return
  end
  self.targetDatas_Dirty = false
  if self.headTargetsDatas == nil then
    self.headTargetsDatas = {}
  else
    TableUtility.ArrayClear(self.headTargetsDatas)
  end
  for i = 1, M_HeadType.Max do
    local data = self.headTargetDataMap[i]
    if data then
      if M_HeadListType[i] then
        for j = 1, #data do
          table.insert(self.headTargetsDatas, data[j])
        end
      else
        table.insert(self.headTargetsDatas, data)
      end
    end
  end
  self.targetHeadsCtl:ResetDatas(self.headTargetsDatas)
  self:ClearHeadRepositonTick()
  self.repositionHeadTick = TimeTickManager.Me():CreateOnceDelayTick(UnityDeltaTime * 6000, function(owner, deltaTime)
    self.headGrid.repositionNow = true
    self.repositionHeadTick = nil
  end, self)
end

function MainViewHeadPage:RegistRedTip()
  local headSprite = self:FindComponent("Frame", UISprite, self.headCellObj)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ADD_POINT, headSprite, 50, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MONSTER_IMG, headSprite, 50, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PORTRAIT_FRAME, headSprite, 50, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_BACKGROUND_FRAME, headSprite, 50, {-9, -9})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_CHAT_FRAME, headSprite, 50, {-9, -9})
end

function MainViewHeadPage:MapInterestEvent()
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(SceneCreatureEvent.PropHpChange, self.HandleUpdateMyHpMp)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.HandleUpdateMyFrenzy)
  self:AddListenEvt(CreatureEvent.Name_Change, self.HandleNameChange)
  self:AddListenEvt(MyselfEvent.TransformChange, self.UpdateMyHead)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.onEnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.onTeamUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.onTeamUpdate)
  self:AddListenEvt(MyselfEvent.ChangeDress, self.UpdateMyHead)
  self:AddListenEvt(MyselfEvent.ChangeDressByNpcID, self.UpdateMyHeadByNpcID)
  self:AddListenEvt(CreatureEvent.PortraitFrame_Change, self.UpdateMyHead)
  self:AddListenEvt(MyselfEvent.LevelUp, self.UpdateMyHeadLv)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
  self:AddListenEvt(MyselfEvent.SexChange, self.UpdateMyHead)
  self:AddListenEvt(PlayerEvent.AnonymousStateChange, self.UpdateMyHead)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateMyHeadTeaminfo)
  self:AddListenEvt(TeamEvent.MyLeaderChange, self.UpdateMyHeadTeaminfo)
  self:AddListenEvt(TeamEvent.MyImageChanged, self.UpdateItemImageUserNtf)
  self:AddListenEvt(ServiceEvent.NUserQueryUserInfoUserCmd, self.HandleUpdatePlayerHead)
  self:AddListenEvt(MainViewEvent.PetInfoUpdate, self.HandlePetHeadUpdate)
  self:AddListenEvt(ServiceEvent.ScenePetPetInfoPetCmd, self.HandlePetHeadUpdate)
  self:AddListenEvt(ServiceEvent.ScenePetPetOffPetCmd, self.HandlePetHeadUpdate)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiStateQueryPetCmd, self.HandleUpdateBoki)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiDataUpdatePetCmd, self.HandleUpdateBoki)
  self:AddListenEvt(MyselfEvent.AddBoki, self.HandleUpdateBoki)
  self:AddListenEvt(MyselfEvent.RemoveBoki, self.HandleUpdateBoki)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingInfoQuery, self.HandleBeingHeadUpdate)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingInfoUpdate, self.HandleBeingHeadUpdate)
  self:AddListenEvt(ServiceEvent.SceneBeingBeingOffCmd, self.HandleBeingHeadUpdate)
  EventManager.Me():AddEventListener(MyselfEvent.Pet_HpChange, self.HandlePetHpChange, self)
  self:AddListenEvt(MyselfEvent.DoubleAction_Build, self.HidePetsHeads)
  self:AddListenEvt(MyselfEvent.DoubleAction_Break, self.ShowPetsHeads)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleHideHead)
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.HandleTargetChange)
  EventManager.Me():AddEventListener(SceneCreatureEvent.CreatureRemove, self.HandleCreatureRemove, self)
  EventManager.Me():AddEventListener(MyselfEvent.VoiceChange, self.VoiceChange, self)
  EventManager.Me():AddEventListener(GuildEvent.VoiceChange, self.GuildEventVoiceChange, self)
  EventManager.Me():AddEventListener(CreatureEvent.BuffHpChange, self.UpdateMyHp, self)
  self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddServant)
  self:AddListenEvt(SceneUserEvent.SceneRemovePets, self.HandleRemoveServant)
  self:AddListenEvt(SkillEvent.DynamicProps, self.UpdateMyHp)
  self:AddListenEvt(ServiceEvent.NUserSendTargetPosUserCmd, self.UpdateQuickTarget)
  self:AddListenEvt(ServiceEvent.HomeCmdFurnitureDataUpdateHomeCmd, self.HandleTargetFurnitureChange)
  EventManager.Me():AddEventListener(CreatureEvent.NatureChange, self.UpdateNatureChange, self)
  EventManager.Me():AddEventListener(CreatureEvent.NatureResistanceChange, self.UpdateNatureResistanceChange, self)
  self:AddListenEvt(SkillEvent.ShowTargetPointTip, self.HandleShowTargetPointTip)
  self:AddListenEvt(SkillEvent.HideTargetPointTip, self.HandleHideTargetPointTip)
  self:AddListenEvt(CreatureEvent.PrestigeChange, self.HandlePrestigeLevelUpdate)
  self:AddListenEvt(UIMenuEvent.UnlockPrestige, self.HandlePrestigeLevelUpdate)
  self:AddListenEvt(MyselfEvent.ShowDefAttr, self.UpdateShowAttr)
  self:AddListenEvt(MyselfEvent.HideDefAttr, self.UpdateShowAttr)
  self:AddListenEvt(HotKeyEvent.FollowSelectMember, self.HandleHotKeyFollowSelectMember)
  self:AddListenEvt(ServiceEvent.MessCCmdSetPippiStateMessCCmd, self.HandelUpdatePippi)
  self:AddListenEvt(MyselfEvent.MyPippiChange, self.HandelUpdatePippi)
end

function MainViewHeadPage:UpdateMyHeadLv()
  local myHeadCell = self.myHeadCell
  if not myHeadCell then
    return
  end
  local lv = MyselfProxy.Instance:RoleLevel()
  myHeadCell:SetLevel(lv)
end

function MainViewHeadPage:UpdateMyProfession()
  local myHeadCell = self.myHeadCell
  if not myHeadCell then
    return
  end
  local pro = MyselfProxy.Instance:GetMyProfession()
  local myHeadData = self.myHeadData
  myHeadData.profession = pro
  myHeadCell:SetPlayerPro(myHeadData)
  self:HandelUpdatePippi()
end

function MainViewHeadPage:UpdateMyHp()
  local myHeadCell = self.myHeadCell
  if myHeadCell == nil then
    return
  end
  local myselfData = Game.Myself.data
  local props = myselfData.props
  if props == nil then
    return
  end
  local value = 0
  local buffhp, buffmaxhp = myselfData:GetBuffHpVals()
  if buffhp then
    buffmaxhp = buffmaxhp or 1
    value = buffhp / buffmaxhp
    self.hpBgChanged = true
    self.myHeadCell:UpdateHp(value, true)
  else
    local hp = myselfData:GetHP()
    local maxhp = props:GetPropByName("MaxHp"):GetValue()
    if maxhp ~= 0 then
      value = hp / maxhp
    end
    if self.hpBgChanged then
      self.hpBgChanged = nil
      self.myHeadCell:UpdateHp(value, false)
    else
      self.myHeadCell:UpdateHp(value)
    end
  end
end

function MainViewHeadPage:HandleUpdateMyHpMp(note)
  local props = Game.Myself.data.props
  if props ~= nil then
    self:UpdateMyHp()
    local mp = props:GetPropByName("Sp"):GetValue()
    local maxMp = props:GetPropByName("MaxSp"):GetValue()
    if self.myHeadCell ~= nil then
      local value = 0
      if mp ~= 0 or maxMp ~= 0 then
        value = mp / maxMp
      end
      self.myHeadCell:UpdateMp(value)
    end
  end
end

function MainViewHeadPage:HandleUpdateMyFrenzy()
  if self.myHeadCell ~= nil then
    local layer = Game.Myself:GetBuffLayer(FrenzyBuffID)
    if self.frenzyLayer ~= layer then
      self.frenzyLayer = layer
      local isActive = 0 < layer
      if isActive then
        local data = Table_Buffer[FrenzyBuffID]
        local maxLayer = Game.Myself.data:GetBuffMaxLayer(FrenzyBuffID) or data and data.BuffEffect.limit_layer or 1
        self:UpdateFrenzy(layer / maxLayer)
      end
      self:SetFrenzyActive(isActive)
    end
  end
end

function MainViewHeadPage:SetFrenzyActive(active)
  local obj = self.frenzy.gameObject
  if obj.activeSelf ~= active then
    obj:SetActive(active)
  end
end

function MainViewHeadPage:UpdateFrenzy(value)
  if self.frenzy ~= nil and value ~= nil then
    value = math.floor(value * 100) / 100
    self.frenzy.value = value
    if value == 1 then
      if self.frenzyEffect == nil then
        self.frenzyEffect = self:PlayUIEffect(EffectMap.UI.Eff_Frenzy_ui, self.frenzyContainer)
      end
    elseif self.frenzyEffect ~= nil then
      self.frenzyEffect:Destroy()
      self.frenzyEffect = nil
    end
  end
end

function MainViewHeadPage:HandleNameChange(note)
  local creature = note.body
  if creature and creature.data.id == Game.Myself.data.id then
    self:UpdateMyHead()
  end
end

function MainViewHeadPage:HandleUpdatePlayerHead(note)
  local playerid = note.body.charid
  if playerid and self.targetId == playerid then
    self:UpdateLockTargetHeadData(SceneCreatureProxy.FindCreature(playerid))
    self:_DoUpdateHeadTargetsUI()
  end
end

function MainViewHeadPage:HandlePetHeadUpdate(note)
  self:UpdatePetHeadData()
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:HandleUpdateBoki()
  self:UpdateBokiHeadData()
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:HandleBeingHeadUpdate(note)
  self:UpdateBeingHeadDatas()
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:HandlePetHpChange(creature)
  if creature == nil then
    return
  end
  self:UpdatePetHeadData()
  self:UpdateBeingHeadDatas()
  self:UpdateBokiHeadData()
  local cells = self.targetHeadsCtl:GetCells()
  for i = 1, #cells do
    local d = cells[i].data
    if d and d.guid == creature.data.id then
      cells[i]:UpdateHp()
    end
  end
end

function MainViewHeadPage:HandleTargetChange(note)
  local nowId = note.body and note.body.data.id
  if self.targetId == nowId then
    return
  end
  self.targetId = nowId
  if nowId == nil then
    self:UpdateLockTargetHeadData(nil)
  else
    self:UpdateLockTargetHeadData(SceneCreatureProxy.FindCreature(self.targetId))
  end
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:HandleTargetFurnitureChange(note)
  local furnitureID = note.body and note.body.guid
  if not self.targetId then
    return
  end
  local creature = SceneCreatureProxy.FindCreature(self.targetId)
  if not creature then
    return
  end
  if creature.data.furnitureID and creature.data.furnitureID == furnitureID then
    self:UpdateLockTargetHeadData(creature)
    self:_DoUpdateHeadTargetsUI()
  end
end

function MainViewHeadPage:HidePetsHeads(note)
  self:HidePetHeadCell(true)
  self:HideBeingHeadCell(true)
end

function MainViewHeadPage:ShowPetsHeads(note)
  self:HidePetHeadCell(false)
  self:HideBeingHeadCell(false)
end

function MainViewHeadPage:HandleHideHead(note)
  local id = Game.MapManager:GetMapID()
  local data = Table_Map[id]
  if data ~= nil then
    local hide = data.NoCat
    if hide ~= nil then
      self:HidePetHeadCell(hide & MapManager.EnumNoCat.HideHead_Pet > 0)
      self:HideBeingHeadCell(0 < hide & MapManager.EnumNoCat.HideHead_Being)
      return
    end
  end
  self:HidePetHeadCell(false)
  self:HideBeingHeadCell(false)
  self.quickTargetButton:SetActive(false)
  self:HandlePrestigeLevelUpdate()
end

function MainViewHeadPage:HandleCreatureRemove(evt)
  if evt.data and self.targetId == evt.data then
    self.targetId = nil
    self:UpdateLockTargetHeadData(nil)
    self:_DoUpdateHeadTargetsUI()
  end
end

local ServantSID_Map
local Get_ServantSID_Map = function()
  if ServantSID_Map == nil then
    ServantSID_Map = {}
    local cfg = GameConfig.Servant.description
    for k, v in pairs(cfg) do
      ServantSID_Map[v.id] = 1
    end
  end
  return ServantSID_Map
end

function MainViewHeadPage:HandleAddServant(note)
  local npcs = note.body
  if not npcs then
    return
  end
  local myId = Game.Myself.data.id
  for _, npc in pairs(npcs) do
    if npc.data and npc.data.staticData then
      local staticID = npc.data.staticData.id
      if npc.data.ownerID == myId and Get_ServantSID_Map()[staticID] then
        self.myServant = npc
        self:delayFocus()
        break
      end
    end
  end
  self:UpdateServantHeadData(self.myServant)
  if nil ~= self.myServant then
    self:_DoUpdateHeadTargetsUI()
  end
end

function MainViewHeadPage:UpdateBokiHeadData()
  local myBoki = BokiProxy.Instance:GetSceneBoki()
  local BokiImageData = self.headTargetDataMap[M_HeadType.Boki]
  if nil == myBoki or nil == myBoki.data then
    if nil ~= BokiImageData then
      BokiImageData:Reset()
      redlog("BokiImageData Reset")
      self.targetDatas_Dirty = true
    end
    return
  end
  self.targetDatas_Dirty = true
  if nil == BokiImageData then
    BokiImageData = HeadImageData.new()
    self.headTargetDataMap[M_HeadType.Boki] = BokiImageData
    BokiImageData:SetCustomParam("HeadType", M_HeadType.Boki)
  end
  BokiImageData:TransByBokiData(myBoki)
  BokiImageData:SetCustomParam("relivetime", BokiProxy.Instance:GetBokiReliveTime())
end

function MainViewHeadPage:HandleRemoveServant(note)
  if self.myServant == nil then
    return
  end
  if self.myServant:Alive() then
    return
  end
  self.myServant = nil
  self:UpdateServantHeadData(nil)
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:VoiceChange(note)
  if note then
    self.myHeadCell:UpdateVoice(note.showMic)
  else
    self.myHeadCell:UpdateVoice(nil)
  end
end

function MainViewHeadPage:GuildEventVoiceChange(note)
  if note == nil then
    if self.VoiceGrid == nil then
      return
    end
    self.VoiceGrid.gameObject:SetActive(false)
    return
  end
  if self.VoiceGrid ~= nil and not self.VoiceGrid.gameObject.activeInHierarchy then
    self.VoiceGrid.gameObject:SetActive(true)
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local memberData = myGuildData:GetMemberByGuid(tonumber(note.userId))
    if memberData then
      for k, v in pairs(self.VoiceCellTable) do
        if note.showMic == true then
          if v.bVoiceOpen == false then
            v:ShowMic(memberData.name, memberData.id)
            break
          elseif v.bVoiceOpen == true and v.id == memberData.id then
            break
          end
        elseif v.id == memberData.id then
          v:HideMicAndDisappear()
          break
        end
      end
    end
  end
end

function MainViewHeadPage:RemoveLeanTween()
  if self.DelayFocusTwId then
    self.DelayFocusTwId:Destroy()
    self.DelayFocusTwId = nil
  end
end

function MainViewHeadPage:delayFocus(trans)
  self:RemoveLeanTween()
  local delayTime = nil == ServantRecommendProxy.Instance:GetModelShow(self.myServant.data.staticData.id) and 2 or 0.2
  self.DelayFocusTwId = TimeTickManager.Me():CreateOnceDelayTick(delayTime * 1000, function(owner, deltaTime)
    self.DelayFocusTwId = nil
    self:ShowServantEffect()
  end, self)
end

function MainViewHeadPage:ShowServantEffect()
  if self.myServant then
    local servantPos = self.myServant.assetRole.completeTransform.localPosition
    Asset_Effect.PlayOneShotAt(EffectMap.Maps.ServantShow, LuaGeometry.GetTempVector3(servantPos.x, servantPos.y + 0.5, servantPos.z))
    self.myServant.assetRole:PlayAction_PlayShow()
    ServantRecommendProxy.Instance:SetServantModelShow(self.myServant.data.staticData.id)
  end
end

function MainViewHeadPage:OnEnter()
  MainViewHeadPage.super.OnEnter(self)
  self.myHeadCell:AddIconEvent()
  self:UpdatePetHeadData()
  self:UpdateBeingHeadDatas()
  self:UpdatePippiHeadData()
  self:_DoUpdateHeadTargetsUI()
end

function MainViewHeadPage:ClearHeadRepositonTick()
  if nil ~= self.repositionHeadTick then
    self.repositionHeadTick:Destroy()
    self.repositionHeadTick = nil
  end
end

function MainViewHeadPage:OnExit()
  self.myHeadCell:RemoveIconEvent()
  self.myServant = nil
  self:RemoveLeanTween()
  self:ClearHeadRepositonTick()
  MainViewHeadPage.super.OnExit(self)
end

function MainViewHeadPage:UpdateQuickTarget(note)
  if note and note.body then
    local data = note.body
    self.quickTargetButton:SetActive(data.sign == true)
  end
end

function MainViewHeadPage:UpdateNatureChange(creature)
  local cells = self.targetHeadsCtl:GetCells()
  for i = 1, #cells do
    local d = cells[i].data
    if d and creature.data and d.creatureId == creature.data.id then
      cells[i]:UpdateNature()
    end
  end
end

function MainViewHeadPage:UpdateNatureResistanceChange(creature)
  local cells = self.targetHeadsCtl:GetCells()
  for i = 1, #cells do
    local d = cells[i].data
    if d and d.creatureId == creature.data.id then
      cells[i]:SetResistanceValue(creature)
    end
  end
end

local tempV3 = LuaVector3()

function MainViewHeadPage:OnClickQuickTarget(note)
  local guid, pos = MyselfProxy.Instance:GetTargetAndPos()
  if guid and pos then
    local player = NSceneUserProxy.Instance:Find(guid)
    if player then
      Game.Myself:Client_LockTarget(player)
    else
      local npc = NSceneNpcProxy.Instance:Find(guid)
      if npc then
        MsgManager.ShowMsgByID(43452)
      else
        MsgManager.ShowMsgByID(43430)
      end
    end
  end
end

function MainViewHeadPage:HandleShowTargetPointTip()
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID == 0 then
    self:HandleHideTargetPointTip(skillID)
  else
    self:ShowTargetPointTip(skillID)
  end
end

function MainViewHeadPage:ShowTargetPointTip(skillID)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillinfo and skillinfo:CheckCamps_Friend() then
    self.myHeadCell:ShowEffect()
  end
end

function MainViewHeadPage:HandleHideTargetPointTip()
  self.myHeadCell:ClearEffect()
end

function MainViewHeadPage:HandlePrestigeLevelUpdate()
  self.myHeadData.prestigeLevel = Game.Myself.data.userdata:Get(UDEnum.PRESTIGE_LEVEL)
  self.myHeadCell:RefreshPrestigeLevel()
end

function MainViewHeadPage:HandleVarUpdate()
  self:HandleUpdateMyPrestigeLevel()
end

function MainViewHeadPage:UpdateShowAttr(note)
  local playerid = note.body
  local cells = self.targetHeadsCtl:GetCells()
  for i = 1, #cells do
    local d = cells[i].data
    if d and playerid and d.creatureId == playerid then
      cells[i]:UpdateNature()
    end
  end
end

function MainViewHeadPage:HandleHotKeyFollowSelectMember(note)
  local followId = Game.Myself:Client_GetFollowLeaderID()
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if handTargetId and handTargetId ~= 0 then
    return
  end
  local playerTip = FunctionPlayerTip.Me():CurPlayerTip()
  if playerTip then
    playerTip:HandleFollowSelectMember()
  elseif followId and followId ~= 0 then
    Game.Myself:Client_SetFollowLeader(0)
  else
    if not self.targetId then
      return
    end
    local cells = self.targetHeadsCtl:GetCells()
    if not cells or #cells == 0 then
      return
    end
    local data = cells[1].data
    if data == nil then
      return
    end
    local headType = data:GetCustomParam("HeadType")
    if headType == M_HeadType.LockTarget then
      local creature = SceneCreatureProxy.FindCreature(self.targetId)
      if creature and creature:GetCreatureType() == Creature_Type.Player then
        GameFacade.Instance:sendNotification(FollowEvent.Follow, self.targetId)
      end
    end
  end
end
