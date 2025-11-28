autoImport("Charactor")
autoImport("TeamGoalCombineCellForER")
autoImport("ViceEquipRecommendNewCell")
autoImport("UserEquipRecommendCell")
EquipRecommendNewView = class("EquipRecommendNewView", SubView)
local midDepth = 2

function EquipRecommendNewView.IsSameClassType(l, r)
  return l == r or l == 0 and r == 7 or l == 7 and r == 0
end

function EquipRecommendNewView:Init()
  self:InitView()
  self:FindObjs()
  self.maxProfessionDepth = 0
end

function EquipRecommendNewView:InitView()
  local container = self:FindGO("ServantImproveViewNew")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.UIView("EquipRecommendNewView"), container, true)
end

function EquipRecommendNewView:FindObjs()
  self.jobClassScrollView = self:FindComponent("JobClassScrollView", UIScrollView)
  self.jobClassPanel = self:FindComponent("JobClassScrollView", UIPanel)
  local grid = self:FindComponent("JobClassGrid", UIGrid, self.jobClassScrollView.gameObject)
  self.goalListCtl = UIGridListCtrl.new(grid, TeamGoalCellForER, "TeamGoalCellForER")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickJob, self)
  self.equipScroll = self:FindGO("EquipScroll")
  local equipGrid = self:FindComponent("Grid", UIGrid, self.equipScroll)
  self.equipListCtrl = UIGridListCtrl.new(equipGrid, EquipRecommendNewCell, "EquipRecommendNewCell")
  self.viceEquipScroll = self:FindGO("ViceEquipScroll")
  local viceEquipGrid = self:FindComponent("Grid", UIGrid, self.viceEquipScroll)
  self.viceEquipListCtrl = UIGridListCtrl.new(viceEquipGrid, ViceEquipRecommendNewCell, "EquipRecommendNewCell")
  self.equipScroll_L = self:FindGO("EquipScroll_L")
  local equipGrid_L = self:FindComponent("Grid", UIGrid, self.equipScroll_L)
  self.equipListCtrl_L = UIGridListCtrl.new(equipGrid_L, EquipRecommendNewCell, "EquipRecommendNewCell")
  self.viceEquipScroll_L = self:FindGO("ViceEquipScroll_L")
  local viceEquipGrid_L = self:FindComponent("Grid", UIGrid, self.viceEquipScroll_L)
  self.viceEquipListCtrl_L = UIGridListCtrl.new(viceEquipGrid_L, ViceEquipRecommendNewCell, "EquipRecommendNewCell")
  self.userEquipBg = self:FindGO("UserEquipBg")
  self.bg2 = self:FindGO("Bg2")
  self.bg3 = self:FindGO("Bg3")
  local userEquipGrid = self:FindComponent("UserEquipGrid", UIGrid)
  self.userEquipListCtrl = UIGridListCtrl.new(userEquipGrid, UserEquipRecommendCell, "UserEquipRecommendCell")
  self.userEquipListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickUserEquip, self)
  local headCellObj = self:FindGO("PortraitCell")
  headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
  headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
  local targetCell = PlayerFaceCell.new(headCellObj)
  targetCell:HideLevel()
  targetCell:HideHpMp()
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  targetCell:SetData(headData)
  local nameForJobLabel = self:FindComponent("NameForJob", UILabel)
  nameForJobLabel.text = MyselfProxy.Instance:GetMyProfessionName()
  local nameForZhuanLabel = self:FindComponent("NameForZhuan", UILabel)
  local myProfession = MyselfProxy.Instance:GetMyProfession()
  local depth = ProfessionProxy.Instance:GetDepthByClassId(myProfession)
  if ProfessionProxy.IsHero(myProfession) then
    nameForZhuanLabel.text = ZhString.HeroTransfer
  elseif depth == 1 then
    nameForZhuanLabel.text = ZhString.OneTransfer
  elseif depth == 2 then
    nameForZhuanLabel.text = ZhString.TwoTransfer
  elseif depth == 3 then
    nameForZhuanLabel.text = ZhString.ThreeTransfer
  elseif depth == 4 then
    nameForZhuanLabel.text = ZhString.FourTransfer
  elseif depth == 5 then
    nameForZhuanLabel.text = ZhString.FiveTransfer
  else
    nameForZhuanLabel.text = ""
  end
  self.curProfessionDepth = depth
  local joblv = self:FindGO("joblv")
  local joblvLabel = self:FindComponent("Label", UILabel, joblv)
  local userdata = Game.Myself.data.userdata
  local baseLv = userdata:Get(UDEnum.ROLELEVEL)
  joblvLabel.text = baseLv
  local helpBtn = self:FindGO("rightTop")
  self:RegistShowGeneralHelpByHelpID(30002, helpBtn)
  self.titleLabel = self:FindGO("TitleLabel")
  self.switchRoot = self:FindGO("ViceEquipSwitch")
  self:AddClickEvent(self.switchRoot, function()
    self.isViceEquip = not self.isViceEquip
    self:OnEquipTabChange()
  end)
  self.tog1 = self:FindGO("Tog1", self.switchRoot)
  self.tog1Unselected = self:FindGO("Tog1 (1)")
  self.tog2 = self:FindGO("Tog2", self.switchRoot)
  self.tog2Unselected = self:FindGO("Tog2 (1)")
  local isNoviceServer = FunctionLogin.Me():IsNoviceServer()
  self.titleLabel:SetActive(isNoviceServer)
  self.switchRoot:SetActive(not isNoviceServer)
end

function EquipRecommendNewView:OnEnter()
  local branches, childGoals = self:GetFatherTable()
  self.goalListCtl:ResetDatas(childGoals)
  EventManager.Me():AddEventListener(EquipRecommendMainNewEvent.RecvProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd, self)
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd()
end

function EquipRecommendNewView:OnExit()
  EventManager.Me():RemoveEventListener(EquipRecommendMainNewEvent.RecvProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd, self)
end

function EquipRecommendNewView:RecvProfessionQueryUserCmd(data)
  local datas, maxDepth, depth = data.items, 0
  if not datas then
    self.maxProfessionDepth = self.curProfessionDepth
    return nil
  end
  for k, v in pairs(datas) do
    depth = ProfessionProxy.Instance:GetDepthByClassId(v.profession)
    if maxDepth < depth then
      maxDepth = depth
    end
  end
  self.maxProfessionDepth = maxDepth
  self.maxProfessionDepth = self.maxProfessionDepth < self.curProfessionDepth and self.curProfessionDepth or self.maxProfessionDepth
  self.maxProfessionDepth = self.maxProfessionDepth < 2 and 2 or self.maxProfessionDepth
  self:TrySelectFirstProfession()
end

function EquipRecommendNewView:RecSyncPassUserInfoCmd(note)
  local data = note.body and note.body.data
  if data and data.over then
    local branch = note.body and note.body.branch
    self:RefreshView(branch)
  end
end

function EquipRecommendNewView:RefreshView(typeBranch)
  self:SetJobChoose()
  local datas = {}
  local equipListCtrl, viceEquipListCtrl
  local userInfos = DungeonProxy.Instance:GetPassUserInfos(typeBranch)
  if userInfos then
    local count = #userInfos
    if count == 0 then
      equipListCtrl = self.equipListCtrl_L
      viceEquipListCtrl = self.viceEquipListCtrl_L
      self.equipListCtrl:ResetDatas()
      self.viceEquipListCtrl:ResetDatas()
      self.bg2:SetActive(false)
      self.bg3:SetActive(true)
      self.userEquipBg:SetActive(false)
    else
      equipListCtrl = self.equipListCtrl
      viceEquipListCtrl = self.viceEquipListCtrl
      self.equipListCtrl_L:ResetDatas()
      self.viceEquipListCtrl_L:ResetDatas()
      self.bg2:SetActive(true)
      self.bg3:SetActive(false)
      self.userEquipBg:SetActive(true)
      count = math.max(count, 5)
      for i = 1, count do
        local data = userInfos[i]
        datas[i] = data or BagItemEmptyType.Empty
      end
    end
  end
  self.userEquipListCtrl:ResetDatas(datas)
  datas = DungeonProxy.Instance:GetPassUserEquipInfo(typeBranch)
  if datas and equipListCtrl then
    equipListCtrl:ResetDatas(datas)
  end
  datas = DungeonProxy.Instance:GetPassUserViceEquipInfo(typeBranch)
  if datas and viceEquipListCtrl then
    viceEquipListCtrl:ResetDatas(datas)
  end
  self:OnEquipTabChange()
end

function EquipRecommendNewView:TrySyncPassUserInfo(branch)
  if DungeonProxy.Instance:NeedUpdatePassUserEquipInfo(branch) then
    if self.isCd then
      local msgid = GameConfig.PassUserInfo.query_cd_msg
      MsgManager.ShowMsgByID(msgid)
      return
    end
    self.isCd = true
    local delay = GameConfig.PassUserInfo.query_cd * 1000
    TimeTickManager.Me():CreateOnceDelayTick(delay, function()
      self.isCd = false
    end, self)
    ServiceFuBenCmdProxy.Instance:CallSyncPassUserInfo(branch)
  else
    self:RefreshView(branch)
  end
end

function EquipRecommendNewView:OnClickJob(cell)
  if not cell or not cell.data then
    return
  end
  self.goal = cell.data.id
  self.curProfessionId = self.goal
  self.chooseJob = cell.data.id
  local typeBranch = cell.data.TypeBranch
  self:TrySyncPassUserInfo(typeBranch)
  self.typeBranch = typeBranch
end

function EquipRecommendNewView:SetJobChoose()
  if not self.chooseJob then
    return
  end
  local goalCells = self.goalListCtl:GetCells()
  local count, childCtls = #goalCells
  for i = 1, count do
    childCtls = goalCells[i]
    childCtls:SetChoose(childCtls.data.id == self.chooseJob)
  end
  self.chooseJob = nil
end

function EquipRecommendNewView:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end

function EquipRecommendNewView:GetFatherTable()
  local branchTable = {}
  local forbidBranch = ProfessionProxy.GetBannedBranches()
  for k, v in pairs(Table_EquipRecommend_New) do
    if not forbidBranch or not forbidBranch[v.branch] then
      branchTable[v.branch] = v.branch
    end
  end
  local fatherTable = {}
  local childGoals = {}
  local branchTypeTable = {}
  for k, v in pairs(branchTable) do
    local branchType = self:GetTableClassTypeFromBranch(v)
    if branchType then
      branchTypeTable[branchType] = branchType
    end
  end
  for k, v in pairs(branchTypeTable) do
    for m, n in pairs(Table_Class) do
      if (n.id % 10 == 1 or TableUtility.ArrayFindIndex(ProfessionProxy.specialDepthJobs, n.id) > 0) and EquipRecommendNewView.IsSameClassType(n.Type, v) then
        table.insert(fatherTable, {
          fatherGoal = Table_Class[n.id]
        })
      end
    end
  end
  table.sort(fatherTable, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  local sortFunc = function(a, b)
    return a.TypeBranch > b.TypeBranch
  end
  for m, n in ipairs(fatherTable) do
    for k, v in pairs(branchTable) do
      if EquipRecommendNewView.IsSameClassType(n.fatherGoal.Type, self:GetTableClassTypeFromBranch(v)) then
        local cData = self:GetClassDataToShow(v)
        if cData ~= nil and cData ~= _EmptyTable then
          TableUtility.InsertSort(childGoals, cData, sortFunc)
        end
      end
    end
  end
  return fatherTable, childGoals
end

function EquipRecommendNewView:GetTableClassTypeFromBranch(branchId)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId then
      return v.Type
    end
  end
end

function EquipRecommendNewView:GetClassDataToShow(branchId)
  local myDepth, isSpecialBranch, job, branch, isHero = ProfessionProxy.GetJobDepth()
  for i = 1, #ProfessionProxy.specialJobs do
    job = ProfessionProxy.specialJobs[i]
    branch = ProfessionProxy.GetTypeBranchFromProf(job)
    if branch == branchId then
      isSpecialBranch = true
    end
    if isSpecialBranch then
      isHero = ProfessionProxy.IsHero(job)
    end
  end
  local minBranchDepth = isHero and 5 or isSpecialBranch and 3 or 2
  local targetDepth = math.clamp(myDepth, minBranchDepth, 9999)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId and ProfessionProxy.GetJobDepth(v.id) == targetDepth then
      return v
    end
  end
  return _EmptyTable
end

local noviceRaceFirstProfMap = {
  [2] = 152
}
local firstProfessionPredicate = function(curClass)
  if ProfessionProxy.IsNovice() then
    local noviceFProf = noviceRaceFirstProfMap[MyselfProxy.Instance:GetMyRace()]
    if noviceFProf then
      return curClass.TypeBranch == ProfessionProxy.GetTypeBranchFromProf(noviceFProf)
    end
  end
  return EquipRecommendNewView.IsSameClassType(curClass.Type, MyselfProxy.Instance:GetMyProfessionType())
end

function EquipRecommendNewView:TrySelectFirstProfession()
  local professionId = MyselfProxy.Instance:GetMyProfession()
  local goalCells, clicked, goalData = self.goalListCtl:GetCells()
  for i = 1, #goalCells do
    if professionId == goalCells[i].data.id then
      self:OnClickJob(goalCells[i])
      self.goalListCtl:ScrollToIndex(i)
      break
    end
  end
end

function EquipRecommendNewView:JobClassScrollTowardsIndex(index)
  self.goalListCtl:ResetPosition()
  local goalCells = self.goalListCtl:GetCells()
  local targetCell = goalCells[index]
  if not targetCell then
    return
  end
  local targetX, targetY, targetZ = LuaGameObject.GetLocalPosition(self.jobClassScrollView.transform)
  targetY = targetY + 50 * math.clamp(index - 2, 0, 99999)
  SpringPanel.Begin(self.jobClassScrollView.gameObject, LuaGeometry.GetTempVector3(targetX, targetY, targetZ), 30)
end

function EquipRecommendNewView:OnClickUserEquip(cell)
  if not cell.data or cell.data == BagItemEmptyType.Empty then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EquipRecommendNewUserView,
    viewdata = {
      userIndex = cell.indexInList,
      branch = self.typeBranch
    }
  })
end

function EquipRecommendNewView:OnEquipTabChange()
  if self.isViceEquip then
    self:Hide(self.tog1)
    self:Hide(self.tog2Unselected)
    self:Show(self.tog2)
    self:Show(self.tog1Unselected)
    self:Hide(self.equipScroll)
    self:Hide(self.equipScroll_L)
    self:Show(self.viceEquipScroll)
    self:Show(self.viceEquipScroll_L)
  else
    self:Show(self.tog1)
    self:Hide(self.tog1Unselected)
    self:Hide(self.tog2)
    self:Show(self.tog2Unselected)
    self:Show(self.equipScroll)
    self:Show(self.equipScroll_L)
    self:Hide(self.viceEquipScroll)
    self:Hide(self.viceEquipScroll_L)
  end
end
