autoImport("PetWorkSpaceCell")
autoImport("PetWorkCombinePetCell")
autoImport("PetSpaceDescCell")
autoImport("PetSpaceRewardCell")
PetWorkSpaceView = class("PetWorkSpaceView", SubView)
PetWorkSpaceView.ViewType = UIViewType.NormalLayer
local _PetWorkSpaceProxy = PetWorkSpaceProxy.Instance
local _PictureManager = PictureManager.Instance
local SINGLE_SPACE_PETNUMBER = 1
local textureName = {
  Bg = "pet_bg_scene",
  MainView = "pet_bg_paper"
}
local GetPlayTimeCost = function(id)
  local staticData = Table_Pet_WorkSpace[id]
  if staticData then
    return staticData.PlayTimeRewardRatio and staticData.PlayTimeRewardRatio[1]
  end
end
local max_playTimeLimit
local PlayTimeLimitedCount = function()
  if not max_playTimeLimit then
    max_playTimeLimit = GameConfig.PetWorkSpace.playtime_limited_count or 99
  end
  return max_playTimeLimit
end
local FIXED_TEX = "shop_bg_05"
local tempVector3 = LuaVector3.Zero()
local SUB_VIEW_PATH = ResourcePathHelper.UIView("PetWorkSpaceView")

function PetWorkSpaceView:Init()
  self:LoadSubView()
  self:FindObjs()
  self:AddEvts()
  self:InitUIView()
  _PictureManager:SetPetWorkSpace(textureName.Bg, self.bgTexture)
  _PictureManager:SetPetWorkSpace(textureName.MainView, self.pageTexture)
  _PictureManager:SetUI(FIXED_TEX, self.fixedTexture)
end

function PetWorkSpaceView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(SUB_VIEW_PATH, self.container.workObj, true)
  obj.name = "PetWorkSpaceView"
end

function PetWorkSpaceView:FindObjs()
  self.root = self:FindGO("Root")
  self.loading = self:FindGO("Loading")
  self.pageScrollView = self:FindComponent("PageScrollView", UIScrollView)
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.pageTexture = self:FindComponent("PageTexture", UITexture)
  self.spaceName = self:FindComponent("spaceName", UILabel, self.pageTexture.gameObject)
  self.introducePos = self:FindGO("IntroducePos", self.pageScrollView.gameObject)
  self.introduceTable = self:FindComponent("IntroduceTable", UITable, self.introducePos)
  self.pagePos = self:FindGO("PagePos", self.pageScrollView.gameObject)
  self.startPos = self:FindGO("StartPos", self.pageTexture.gameObject)
  self.stopPos = self:FindGO("StopPos", self.pageTexture.gameObject)
  self.descLab = self:FindComponent("DescLab", UILabel, self.pagePos)
  self.frequencyLab = self:FindComponent("FrequencyLab", UILabel, self.pagePos)
  self.tipsLab = self:FindComponent("TipsLab", UILabel, self.frequencyLab.gameObject)
  self.startBtn = self:FindGO("StartBtn", self.startPos)
  self.stopBtn = self:FindGO("StopBtn", self.stopPos)
  self.workPos = self:FindGO("workPos", self.pagePos)
  self.petNameLab = self:FindComponent("PetName", UILabel, self.workPos)
  self.workTimeLab = self:FindComponent("WorkTime", UILabel, self.workPos)
  self.RewardGrid = self:FindComponent("RewardGrid", UIGrid, self.frequencyLab.gameObject)
  self.RewardGrid = UIGridListCtrl.new(self.RewardGrid, PetSpaceRewardCell, "PetSpaceRewardCell")
  self.titleTipLab = self:FindComponent("TitleTipLab", UILabel)
  self.emptyPet = self:FindGO("EmptyPet")
  local noPetTip = self:FindComponent("NoPet", UILabel, self.emptyPet)
  noPetTip.text = ZhString.PetWorkSpace_NoPets
  self.lvLimitedLab = self:FindComponent("LevelLab", UILabel, self.pagePos)
  self.fixedTexture = self:FindComponent("FixedTexture", UITexture, self.workPos)
  self.modelTexture = self:FindComponent("PetTexture", UITexture, self.workPos)
  self.playTimeRewardBtn = self:FindGO("PlayTimeRewardBtn", self.stopPos)
  self.playTimeRewardLab = self:FindComponent("Label", UILabel, self.playTimeRewardBtn)
  self.costPlayTimeLab = self:FindComponent("CostPlayTimeLab", UILabel, self.stopPos)
  self.costPlayTimeFixedLab = self:FindComponent("CostLab", UILabel, self.stopPos)
  self.costPlayTimeFixedLab.text = ZhString.PetWorkSpace_PlayTimeReward_Cost_Fixed
end

function PetWorkSpaceView:AddEvts()
  self:AddClickEvent(self.startBtn, function(g)
    self:OnStartBtn()
  end)
  self:AddClickEvent(self.stopBtn, function(g)
    self:OnStopBtn()
  end)
  if self.playTimeRewardBtn then
    self:AddClickEvent(self.playTimeRewardBtn, function()
      self:OnClickPlayTimeReward()
    end)
  end
end

function PetWorkSpaceView:UpdatePlayTimeRewardBtn()
  if not self.chooseSpaceID then
    return
  end
  local spaceData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not spaceData then
    return
  end
  if not self.playTimeRewardBtn then
    return
  end
  local forbidden = FunctionUnLockFunc.CheckForbiddenByFuncState("petwork_playtime_reward")
  self:_updatePlayTimeUI(forbidden)
  if not forbidden then
    local cost_second = GetPlayTimeCost(self.chooseSpaceID)
    local left_time = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.PLAY)
    self.costPlayTimeLab.text = string.format(ZhString.PetWorkSpace_PlayTimeReward_Cost, cost_second // 60, left_time // 60)
    self.playTimeRewardLab.text = string.format(ZhString.PetWorkSpace_PlayTimeReward_Btn, PetWorkSpaceProxy.Instance:GetSpacePlayTimeCount(spaceData.id), PlayTimeLimitedCount())
  end
end

function PetWorkSpaceView:_updatePlayTimeUI(forbidden_play_time)
  if forbidden_play_time then
    self.playTimeRewardBtn:SetActive(false)
    LuaVector3.Better_Set(tempVector3, -278, -218, 0)
    self.stopBtn.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, -47, 0)
    self.workTimeLab.gameObject.transform.localPosition = tempVector3
  else
    self.playTimeRewardBtn:SetActive(true)
    LuaVector3.Better_Set(tempVector3, -375, -218, 0)
    self.stopBtn.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, -92, -47, 0)
    self.workTimeLab.gameObject.transform.localPosition = tempVector3
  end
end

function PetWorkSpaceView:OnClickPlayTimeReward()
  local spaceData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not spaceData then
    return
  end
  local curPlayTimeCostCount = PetWorkSpaceProxy.Instance:GetSpacePlayTimeCount(spaceData.id)
  if curPlayTimeCostCount >= PlayTimeLimitedCount() then
    MsgManager.ShowMsgByID(43483)
    return
  end
  local cost_second = GetPlayTimeCost(self.chooseSpaceID)
  local leftTime = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.PLAY)
  if cost_second > leftTime then
    MsgManager.ShowMsgByID(43481)
    return
  end
  local confirmCall = function()
    ServiceScenePetProxy.Instance:CallStartWorkPetCmd(self.chooseSpaceID, nil, ScenePet_pb.ESTARTWORK_PLAYTIME)
  end
  local pet = spaceData:GetSinglePetByIndex(1)
  local pet_name = spaceData:GetPetNameByIndex(1)
  redlog("pet.petid| pet.lv| pet.friendlv| pet.petWorkSkillID: ", pet.petid, pet.lv, pet.friendlv, pet.petWorkSkillID)
  local cnt = PetFun.calcPlayTimeRewardCount(spaceData.id, pet.petid, pet.lv, pet.friendlv, pet.petWorkSkillID)
  redlog("PetFun.calcPlayTimeRewardCount 公式计算结果 ", cnt)
  MsgManager.DontAgainConfirmMsgByID(43482, confirmCall, nil, nil, cost_second // 60, pet_name, cnt, leftTime // 60)
end

local choosenPets = {}

function PetWorkSpaceView:OnStartBtn()
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if chooseSpace and chooseSpace.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  if nil == chooseSpace.staticData.ActID then
    local curWork = _PetWorkSpaceProxy:GetWorkingSpace(true)
    local curRest = _PetWorkSpaceProxy:GetRestSpace(true)
    curWork = #curWork + #curRest
    local maxWorkCount = _PetWorkSpaceProxy:GetMaxSpace()
    if curWork >= maxWorkCount then
      local msgID = maxWorkCount == GameConfig.PetWorkSpace.pet_work_max_workcount and 8104 or 8108
      MsgManager.ShowMsgByID(msgID)
      return
    end
  end
  if not self.choosePetID then
    MsgManager.ShowMsgByID(8105)
    return
  end
  TableUtility.ArrayClear(choosenPets)
  choosenPets[#choosenPets + 1] = self.choosePetID
  ServiceScenePetProxy.Instance:CallStartWorkPetCmd(self.chooseSpaceID, choosenPets, ScenePet_pb.ESTARTWORK_NORMAL)
end

function PetWorkSpaceView:OnStopBtn()
  local spaceData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not spaceData then
    return
  end
  if spaceData.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  local petName = spaceData:GetPetNameByIndex(SINGLE_SPACE_PETNUMBER)
  MsgManager.ConfirmMsgByID(8106, function()
    ServiceScenePetProxy.Instance:CallStopWorkPetCmd(self.chooseSpaceID)
  end, nil, nil, petName)
end

function PetWorkSpaceView:HandleNtf()
  self:UpdataView()
end

function PetWorkSpaceView:HandleBattlePet(note)
  local data = note.body
  if data and data.pets then
    _PetWorkSpaceProxy:GetBattlePet(data.pets)
  end
end

function PetWorkSpaceView:HandleStopAct(note)
  local data = note.body
  if data then
    PetWorkSpaceProxy.Instance:HandleStopAct(data.id)
  end
end

function PetWorkSpaceView:InitUIView()
  self.introduceCtl = UIGridListCtrl.new(self.introduceTable, PetSpaceDescCell, "PetSpaceDescCell")
  self.tipsLab.text = ZhString.PetWorkSpace_Tips
  local spaceGrid = self:FindComponent("SpaceGrid", UIGrid)
  self.spaceCtl = UIGridListCtrl.new(spaceGrid, PetWorkSpaceCell, "PetWorkSpaceCell")
  self.spaceCtl:AddEventListener(MouseEvent.MouseClick, self.showView, self)
  self.petWrapContainer = self:FindGO("PetWorkWrap")
  local wrapConfig = {
    wrapObj = self.petWrapContainer,
    pfbNum = 4,
    cellName = "PetWorkCombinePetCell",
    control = PetWorkCombinePetCell
  }
  self.petWraplist = WrapCellHelper.new(wrapConfig)
  self.petWraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickPetItem, self)
  self:UpdataView()
  self:_startTimeTick()
end

function PetWorkSpaceView:SetIntroduceDesc()
  local datas = PetWorkSpaceProxy.Instance:GetIntroduceDescData()
  if datas and 0 < #datas then
    self.introduceCtl:ResetDatas(datas)
  end
end

function PetWorkSpaceView:SetPetData(datas)
  local newdata = self:ReUnitData(datas, 4)
  self.petWraplist:UpdateInfo(newdata)
  self.petWraplist:ResetPosition()
end

function PetWorkSpaceView:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function PetWorkSpaceView:HandleClickPetItem(cellctl)
  if cellctl and cellctl.data and cellctl.data.guid then
    local petState = cellctl.data.state
    if nil == cellctl.data.petWorkSkillID or 0 == cellctl.data.petWorkSkillID then
      MsgManager.ShowMsgByID(8110)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_FIGHT or petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_Scene then
      MsgManager.ShowMsgByID(8101)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_REJECT then
      MsgManager.ShowMsgByID(8103)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_SPACE_LIMITED then
      local param = GameConfig.PetWorkSpace.pet_work_max_exchange
      MsgManager.ShowMsgByID(8102, param)
      return
    end
    local curPetId = cellctl.data.guid
    if curPetId == self.choosePetID then
      self.choosePetID = nil
      self:_UpdateFrequency(nil)
    else
      self.choosePetID = curPetId
      self:_UpdateFrequency(cellctl.data)
    end
    self:_UpdateChoosePet()
  end
end

function PetWorkSpaceView:_UpdateChoosePet()
  local cellCtls = self.petWraplist:GetCellCtls()
  for i = 1, #cellCtls do
    local cells = cellCtls[i]:GetCells()
    for j = 1, #cells do
      cells[j]:SetChoosePetID(self.choosePetID)
    end
  end
end

function PetWorkSpaceView:_UpdateFrequency(pet)
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if nil == chooseSpace then
    return
  end
  local isCurDay = false
  local desc = chooseSpace.staticData.Desc
  local max_reward = chooseSpace.staticData.Max_reward
  local petFrequency = chooseSpace:GetFrequency(pet)
  local unused = chooseSpace:Unused()
  local own
  local startTime = chooseSpace.startTime
  local endTime = chooseSpace:GetEndTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local endTimeRefreshTime = os.date("*t", endTime)
  endTimeRefreshTime = os.time({
    year = endTimeRefreshTime.year,
    month = endTimeRefreshTime.month,
    day = endTimeRefreshTime.day,
    hour = 5
  })
  local lastCount = chooseSpace.lastCounts
  lastCount = lastCount and 0 < #lastCount and lastCount[1] or 0
  if chooseSpace:IsOverCfgTime() then
    own = 0
  else
    if startTime ~= 0 then
      own, isCurDay = PetWorkSpaceProxy.calcPetWorkCurDayRewardCount(startTime, endTime, petFrequency, max_reward, lastCount)
    end
    if startTime ~= 0 then
      own, isCurDay = PetWorkSpaceProxy.calcPetWorkCurDayRewardCount(startTime, endTime, petFrequency, max_reward, lastCount)
    end
  end
  if unused then
    own = lastCount
  elseif isCurDay == true then
    own = own + lastCount
  end
  own = math.min(own, max_reward)
  self.frequencyLab.text = string.format(ZhString.PetWorkSpace_DescFrequency, petFrequency, own, max_reward)
end

function PetWorkSpaceView:showView(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  local curID = data.id
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(curID)
  if chooseSpace and chooseSpace.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  local reward = data:GetUIReward()
  if reward then
    ServiceScenePetProxy.Instance:CallGetPetWorkRewardPetCmd(data.id)
  end
  if not data:IsOpen() then
    return
  end
  if not data:IsUnlock() then
    MsgManager.ShowMsgByID(8107)
    if 0 < #data.petEggs then
      ServiceScenePetProxy.Instance:CallStopWorkPetCmd(curID)
    end
    return
  end
  if curID == self.chooseSpaceID then
    self.chooseSpaceID = nil
  else
    self.chooseSpaceID = curID
    self.choosePetID = nil
    self:_UpdateChoosePet()
  end
  self:UpdatePlayTimeRewardBtn()
  local cells = self.spaceCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetChoose(self.chooseSpaceID)
  end
  self:UpdataPage()
end

function PetWorkSpaceView:UpdataPage()
  self.pageScrollView.enabled = true
  self.pageScrollView:ResetPosition()
  if not self.chooseSpaceID then
    self:Hide(self.stopPos)
    self:Hide(self.startPos)
    self:Show(self.introducePos)
    self:Hide(self.pagePos)
    self.spaceName.text = ZhString.PetWorkSpace_IntroduceTitle
    self:SetIntroduceDesc()
    self:Hide(self.emptyPet)
    self:UnloadPetModel()
  else
    self:Hide(self.introducePos)
    self:Show(self.pagePos)
    local pageData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
    if not pageData then
      return
    end
    local unUsed = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_UNUSED == pageData.state
    if unUsed then
      self:Show(self.startPos)
      self:Show(self.petWrapContainer)
      self:Hide(self.stopPos)
      self:Hide(self.workPos)
      LuaVector3.Better_Set(tempVector3, -166, 92, 0)
      local petsData = _PetWorkSpaceProxy:GetTotalPetsData(pageData.id)
      if petsData and 0 < #petsData then
        self:Show(self.petWrapContainer)
        self:Hide(self.emptyPet)
        self:SetPetData(petsData)
      else
        self:Show(self.emptyPet)
        self:Hide(self.petWrapContainer)
      end
      self:UnloadPetModel()
    else
      LuaVector3.Better_Set(tempVector3, -166, 120, 0)
      self:Hide(self.startPos)
      self:Hide(self.petWrapContainer)
      self:Show(self.stopPos)
      self:Show(self.workPos)
      self.pageScrollView.enabled = false
      local petName = pageData:GetPetNameByIndex(SINGLE_SPACE_PETNUMBER)
      self.petNameLab.text = string.format(ZhString.PetWorkSpace_PetName, petName)
      local petID = pageData:GetPetIDByIndex(SINGLE_SPACE_PETNUMBER)
      local equips = pageData:GetPetEquips(SINGLE_SPACE_PETNUMBER)
      self:SetPetModel(SINGLE_SPACE_PETNUMBER, petID, equips)
    end
    local staticData = pageData.staticData
    if not staticData then
      return
    end
    self.spaceName.text = staticData.Name
    self.frequencyLab.gameObject.transform.localPosition = tempVector3
    self.lvLimitedLab.gameObject:SetActive(unUsed)
    self.descLab.text = staticData.Desc
    self.lvLimitedLab.text = string.format(ZhString.PetWorkSpace_Level, staticData.Level)
    self:_UpdateFrequency()
    local rewards = pageData:GetRewardArray()
    self.RewardGrid:ResetDatas(rewards)
  end
end

function PetWorkSpaceView:_startTimeTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.Update, self, 2)
end

function PetWorkSpaceView:Update()
  self:UpdatePageView()
  self:UpdateState()
end

function PetWorkSpaceView:UpdateState()
  local workingSpace = _PetWorkSpaceProxy:GetWorkingSpace()
  for i = 1, #workingSpace do
    local data = workingSpace[i]
    if data:IsWorking() and (data:IsOverCfgTime() or data:MaxRewardLimited()) then
      data.state = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST
      self:UpdataView()
    end
  end
end

function PetWorkSpaceView:UpdatePageView()
  local data = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not data then
    return
  end
  local duringTime = data:GetDuringTime()
  if 0 == duringTime then
    return
  end
  if data:IsWorking() or data:IsResting() then
    self:_UpdateFrequency(data.petEggs[1])
  end
  if not data:IsWorking() then
    self.workTimeLab.text = ZhString.PetWorkSpace_Rest
    return
  end
  local fre = data:GetFrequency(data.petEggs[1])
  duringTime = duringTime % (fre * 60)
  if data:MaxRewardLimited() or data:IsOverCfgTime() then
    data.state = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST
    self.workTimeLab.text = ZhString.PetWorkSpace_Rest
    self:UpdataView()
    return
  end
  local t = ClientTimeUtil.FormatTimeTick(duringTime, "mm:ss")
  self.workTimeLab.text = string.format(ZhString.PetWorkSpace_Working, t)
end

local tempVec = LuaVector3.Zero()

function PetWorkSpaceView:SetPetModel(index, id, equips)
  local monsterParts = PetEggInfo.GetPetDessParts(id, equips)
  if self.modelAssetRole then
    self.modelAssetRole:Redress(monsterParts)
    self:SetPetModelCallBack(id, monsterParts)
  else
    UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, monsterParts, UIModelCameraTrans.Role, nil, nil, nil, nil, function(obj)
      self.modelAssetRole = obj
      self:SetPetModelCallBack(id, monsterParts)
    end)
    UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
  end
  Asset_Role.DestroyPartArray(monsterParts)
end

function PetWorkSpaceView:SetPetModelCallBack(id, monsterParts)
  self.modelAssetRole:PlayAction_Idle()
  local configSize = Table_Monster[id] and Table_Monster[id].LoadShowSize
  if configSize then
    self.modelAssetRole:SetScale(configSize)
  else
    self.modelAssetRole:SetScale(1)
  end
  local showPos = Table_Monster[id] and Table_Monster[id].LoadShowPose
  if showPos and #showPos == 3 then
    LuaVector3.Better_Set(tempVec, showPos[1], showPos[2], showPos[3])
    self.modelAssetRole:SetPosition(tempVec)
  else
    self.modelAssetRole:SetPosition(LuaGeometry.Const_V3_zero)
  end
  self:RemoveDelayTick()
  self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:HideModelEff()
  end, self, 1)
end

function PetWorkSpaceView:RemoveDelayTick()
  if self.delayTick then
    self.delayTick:Destroy()
    self.delayTick = nil
  end
end

function PetWorkSpaceView:HideModelEff()
  if not self.modelAssetRole then
    self:RemoveDelayTick()
    return
  end
  if not self.modelAssetRole.complete.body then
    return
  end
  if self.modelAssetRole and self.modelAssetRole.complete then
    local bodyObj = self.modelAssetRole:GetPartObject(Asset_Role.PartIndex.Body)
    local pss = self.modelAssetRole.complete.gameObject:GetComponentsInChildren(ParticleSystem)
    for i = 1, #pss do
      if bodyObj and pss[i].transform.parent.gameObject == bodyObj.gameObject then
        pss[i].transform.gameObject:SetActive(false)
      else
        pss[i].transform.parent.gameObject:SetActive(false)
      end
    end
    self:RemoveDelayTick()
  end
end

function PetWorkSpaceView:UnloadPetModel()
  if self.modelAssetRole then
    self.modelAssetRole = nil
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
  end
end

function PetWorkSpaceView:InitPos()
  self:Show(self.introducePos)
  self:Hide(self.pagePos)
end

function PetWorkSpaceView:UpdataView()
  local workingSpaces = _PetWorkSpaceProxy:GetWorkingSpace(true)
  local restSpaces = _PetWorkSpaceProxy:GetRestSpace(true)
  local maxWorkCount = _PetWorkSpaceProxy:GetMaxSpace()
  if workingSpaces then
    local total = restSpaces and #restSpaces + #workingSpaces or #workingSpaces
    self.titleTipLab.text = string.format(ZhString.PetWorkSpace_TitleTip, total, maxWorkCount)
  end
  local data = _PetWorkSpaceProxy:GetSpaceViewData()
  if data then
    self.spaceCtl:ResetDatas(data)
  end
  self.choosePetID = nil
  self:_UpdateChoosePet()
  self:UpdataPage()
end

function PetWorkSpaceView:OnEnter()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
  PetWorkSpaceView.super.OnEnter(self)
  _PetWorkSpaceProxy:ClearSpaceData()
  ServiceScenePetProxy.Instance:CallQueryPetWorkDataPetCmd()
  ServiceScenePetProxy.Instance:CallQueryBattlePetCmd()
end

function PetWorkSpaceView:ClearTick()
  TimeTickManager.Me():ClearTick(self)
  self.timeTick = nil
  self.delayTick = nil
end

function PetWorkSpaceView:OnExit()
  self:ClearTick()
  self:UnloadPetModel()
  self.modelTexture = nil
  PetWorkSpaceView.super.OnExit(self)
  TipsView.Me():HideCurrent()
end
