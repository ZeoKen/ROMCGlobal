ProfessionPage = class("ProfessionPage", SubView)
autoImport("ProfessionTypeIconCell")
autoImport("ProfessionIconCell")
autoImport("MPLineCell")
ProfessionPage.ProfessionIconClick = "ProfessionPage_ProfessionIconClick"
ProfessionPage.cellRes = ResourcePathHelper.UICell("ProfessionTypeIconCell")
ProfessionPage.lineRes = ResourcePathHelper.UICell("MPLineCell")
local professionTypeIconCells = {}
local IconCellTable = {}
local LineTable = {}
local multiProfessionTypeIconCells = {}
HeadIconState = {
  State1 = 1,
  State2 = 2,
  State3 = 3,
  State4 = 4,
  State5 = 5,
  State6 = 6,
  State7 = 7
}

function ProfessionPage:RecvProfessionChangeUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil then
    local b = data.body.branch
    b = ProfessionProxy.TypeBranchS2C(b)
    if data.body.success then
      self:sendNotification(UIEvent.CloseUI, self.container)
      local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      for k, v in pairs(S_ProfessionDatas) do
        if v.branch == b then
          for m, n in pairs(multiProfessionTypeIconCells) do
            local id = n:GetId() or 0
            if id == self.curProfessionId then
              n:SetHeadIconState(HeadIconState.State1)
              n:UpdateState()
              break
            end
          end
          for m, n in pairs(multiProfessionTypeIconCells) do
            local id = n:GetId() or 0
            if id == v.profession then
              n:SetHeadIconState(HeadIconState.State3)
              n:UpdateState()
              break
            end
          end
          v.iscurrent = true
          self.curType = Table_Class[v.profession].Type
          self.curProfessionId = v.profession
          ProfessionProxy.Instance:SetCurTypeBranch(v.branch)
        else
          S_ProfessionDatas[v.branch].iscurrent = false
        end
      end
      self:UpdateUI(true)
    else
      helplog("RecvProfessionChangeUserCmd Failed reviewCode")
    end
  else
    helplog("服务器消息不对 reviewCode")
  end
end

function ProfessionPage:RecvProfessionBuyUserCmd(data)
  helplog("=======>function ProfessionPage:RecvProfessionBuyUserCmd(data)")
  TableUtil.Print(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil then
    if data.body.success then
      local b = data.body.branch
      local boughtId = ProfessionProxy.GetBoughtProfessionIdThroughBranch(b)
      local realGetId = Table_Branch[b] and Table_Branch[b].base_id or 0
      b = ProfessionProxy.TypeBranchS2C(b)
      local SysmsgData = Table_Sysmsg[25412]
      local NameZh = ProfessionProxy.GetProfessionName(boughtId, MyselfProxy.Instance:GetMySex())
      MsgManager.FloatMsg(nil, string.format(SysmsgData.Text, NameZh))
      local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      S_ProfessionDatas[b] = {}
      S_ProfessionDatas[b].branch = b
      S_ProfessionDatas[b].profession = realGetId
      S_ProfessionDatas[b].joblv = 0
      S_ProfessionDatas[b].isbuy = true
      S_ProfessionDatas[b].iscurrent = false
      self:PassEvent(ProfessionPage.ProfessionIconClick, nil)
      self:UpdateUI(false)
    else
      helplog("RecvProfessionBuyUserCmd Failed reviewCode")
    end
  else
    helplog("服务器消息不对 reviewCode")
  end
end

function ProfessionPage:RecvProfessionQueryUserCmd(data)
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_ProfessionDatas) do
    for m, n in pairs(multiProfessionTypeIconCells) do
      local previousId = n:GetPrevious()
      if previousId == v.profession then
        n:SetPreviousJob(previousId, v.joblv)
      end
    end
  end
  self:UpdateUI(true)
end

function ProfessionPage:Init()
  self:initView()
  self:AddListenerEvts()
  self:initData()
end

function ProfessionPage:initView()
  self.gameObject = self:FindGO("ProfessionPage")
  self.raceGrid = self:FindComponent("race", UIGrid)
  self.human = self:FindGO("human")
  self.dora = self:FindGO("dora")
  self.dora:SetActive(not ProfessionProxy.IsDoramForbidden())
  self.raceGrid:Reposition()
  self.humanclassicon = self:FindComponent("humanclass", UISprite)
  self.doraclassicon = self:FindComponent("doraclass", UISprite)
  self:AddClickEvent(self.human, function()
    if ProfessionProxy.Instance:IsMPOpen() == false then
      MsgManager.ShowMsgByID(25413)
      return
    end
    self:SetTextureGrey(self.dora)
    self:SetTextureWhite(self.human)
    self:UpdateJobGridList(false)
  end)
  self:AddClickEvent(self.dora, function()
    if ProfessionProxy.Instance:IsMPOpen() == false then
      MsgManager.ShowMsgByID(25413)
      return
    end
    self:SetTextureGrey(self.human)
    self:SetTextureWhite(self.dora)
    self:UpdateJobGridList(true)
  end)
  self.MultiJobsNode = self:FindGO("MultiJobsNode")
  if self.MultiJobsNode == nil then
    helplog("if self.MultiJobsNode==nil then")
  end
  self.topScrollView = self:FindGO("topScrollView", self.MultiJobsNode):GetComponent(UIScrollView)
  self.JobsGrid_UIGrid = self:FindGO("JobsGrid", self.topScrollView.gameObject):GetComponent(UIGrid)
  self.centerScrollView = self:FindComponent("centerScrollView", UIScrollView)
  self.JobsGrid_UIGrid.cellWidth = 85
  if Table_Class == nil then
    helplog("Pif Table_Class==nil then")
  end
  self.skillBtn = self:FindGO("mskillBtn", self.MultiJobsNode)
  if self.skillBtn then
    self:AddClickEvent(self.skillBtn.gameObject, function()
      if ProfessionProxy.Instance:IsMPOpen() then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.CheckAllProfessionPanel,
          viewdata = nil
        })
      else
        MsgManager.ShowMsgByID(25413)
      end
    end)
  end
  local curOcc = Game.Myself.data:GetCurOcc()
  if curOcc ~= nil and curOcc.profession ~= nil then
    if Table_Class[curOcc.profession] == nil then
      helplog("curOcc.profession" .. curOcc.profession .. "不存在")
    else
      self.curType = Table_Class[curOcc.profession].Type
      self.curProfessionId = curOcc.profession
      if ProfessionProxy.IsNovice(self.curProfessionId) then
        self:GetNextTurnTableAndShow(self.curProfessionId, nil)
        self.centerScrollView:ResetPosition()
      else
        local tmp = ProfessionProxy.Instance:GetThisIdChuShiId(curOcc.profession) or -1
        self:GetNextTurnTableAndShow(tmp, nil)
        self.centerScrollView:ResetPosition()
      end
    end
  end
  self.JobsGridList = UIGridListCtrl.new(self.JobsGrid_UIGrid, ProfessionIconCell, "ProfessionIconCell")
  self.JobsGridList:AddEventListener(MouseEvent.MouseClick, self.clickHandler, self)
  self.share = self:FindGO("ShareButton")
  self:AddClickEvent(self.share, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AllProfessionShareView,
      viewdata = {}
    })
  end)
  local rewardTips = self:FindGO("WeekRewardTips")
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", rewardTips):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", GameConfig.Share.ShareReward[1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", rewardTips):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. GameConfig.Share.ShareReward[2]
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 1 then
    rewardTips:SetActive(false)
  else
    rewardTips:SetActive(true)
  end
  if GameConfig.BattleFund then
    local canOpen = FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Share.MenuID)
    if canOpen then
      self:Show(self.share)
    else
      self:Hide(self.share)
    end
  end
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function ProfessionPage:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function ProfessionPage:UpdateJobGridList(isDora, isInit)
  if isDora == nil then
    isDora = ProfessionProxy.IsDoramRace()
  end
  self.topScrollView.gameObject:SetActive(true)
  local topScrollViewIconTable = ProfessionProxy.Instance:GetTopScrollViewIconTable()
  self.JobsGridList:ResetDatas(topScrollViewIconTable)
  local cells = self.JobsGridList:GetCells()
  local showCount = 0
  for _, v in pairs(cells) do
    v:SetShowType(1)
    local data = v:GetData()
    v:setIsSelected(false)
    if isDora == ProfessionProxy.IsDoramRace(data.id) then
      v:Show()
      showCount = showCount + 1
    else
      v:Hide()
    end
  end
  if showCount < 2 then
    self.topScrollView.gameObject:SetActive(false)
    self.centerScrollView.panel.baseClipRegion = Vector4(0, 12, 500, 490)
  else
    self.centerScrollView.panel.baseClipRegion = Vector4(0, -18, 500, 430)
  end
  self.JobsGrid_UIGrid:Reposition()
  self.topScrollView:ResetPosition()
  if not isInit then
    local selected
    if isDora then
      selected = self.doraSelected
    else
      selected = self.humanSelected
    end
    if selected then
      for _, v in pairs(cells) do
        local data = v:GetData()
        if data and selected == data.id then
          v:setIsSelected(true)
          self:clickHandler(v)
          break
        end
      end
    else
      for i = 1, #cells do
        if cells[i].gameObject.activeSelf then
          cells[i]:setIsSelected(true)
          self:clickHandler(cells[i])
          break
        end
      end
    end
  end
end

function ProfessionPage:clickHandler(obj)
  if ProfessionProxy.Instance:IsMPOpen() == false then
    MsgManager.ShowMsgByID(25413)
    return
  end
  self:PassEvent(ProfessionPage.ProfessionIconClick, nil)
  obj:setIsSelected(true)
  local cellsTable = self.JobsGridList:GetCells()
  for i = 1, #cellsTable do
    local single = cellsTable[i]
    if single ~= obj then
      single:setIsSelected(false)
    else
      single:setIsSelected(true)
      self.lastSelectId = single.data.id
    end
  end
  local id = obj.data.id
  if not ProfessionProxy.IsDoramRace(id) then
    self.humanclassicon.gameObject:SetActive(true)
    self.doraclassicon.gameObject:SetActive(false)
    IconManager:SetProfessionIcon(obj.ProfessIcon_UISprite.spriteName, self.humanclassicon)
    self.humanSelected = obj.data.id
  else
    self.doraclassicon.gameObject:SetActive(true)
    self.humanclassicon.gameObject:SetActive(false)
    IconManager:SetProfessionIcon(obj.ProfessIcon_UISprite.spriteName, self.doraclassicon)
    self.doraSelected = obj.data.id
  end
  self:ResetIcons()
  self:GetNextTurnTableAndShow(id, nil)
  self:ResetHeadIconsState()
  self.centerScrollView:ResetPosition()
end

function ProfessionPage:ResetHeadIconsState2()
  for k, v in pairs(multiProfessionTypeIconCells) do
    local id = v:GetId() or 0
    if self.curProfessionId == id then
      v:SetHeadIconState(HeadIconState.State3)
    elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and self:IsThisIdKeQieHuan(id) then
      v:SetHeadIconState(HeadIconState.State1)
    elseif ProfessionProxy.Instance:IsThisIdYiGouMai(id) and ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) == false then
      v:SetHeadIconState(HeadIconState.State7)
      if ProfessionProxy.GetJobDepth(id) > 2 then
        v:SetHeadIconState(HeadIconState.State5)
      end
    elseif ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
      if ProfessionProxy.Instance:IsMPOpen() then
        v:SetHeadIconState(HeadIconState.State6)
      else
        v:SetHeadIconState(HeadIconState.State5)
      end
    elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and self:IsThisIdKeQieHuan(id) == false then
      v:SetHeadIconState(HeadIconState.State2)
    else
      v:SetHeadIconState(HeadIconState.State5)
    end
    v:UpdateState()
    local previousId = ProfessionProxy.Instance:GetThisIdPreviousId(id)
    if previousId == nil then
    elseif ProfessionProxy.GetJobDepth(previousId) >= 1 then
      for k1, v1 in pairs(multiProfessionTypeIconCells) do
        local v1_id = v1:GetId() or 0
        if previousId == v1_id then
          v:SetPreviousCell(v1)
        end
      end
    end
    if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange == true and ProfessionProxy.GetJobDepth(id) >= 4 then
      v.gameObject:SetActive(false)
    end
  end
end

function ProfessionPage:IsThisIdKeQieHuan(id)
  for k, v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
    if v.profession == id then
      return true
    end
  end
  return false
end

function ProfessionPage:ResetHeadIconsState()
  self:ResetHeadIconsState2()
  self:ResetLineState()
end

function ProfessionPage:GetNextTurnTableAndShow(id, previousId, countOfBro, index, turnNumber, isNoviceSpecial, isFakeClassInfo)
  countOfBro = countOfBro or 1
  index = index or 0
  turnNumber = turnNumber or 1
  local nowClassData = Table_Class[id]
  if nowClassData ~= nil then
    if nowClassData.IsOpen == 0 then
      return nil
    end
    if isNoviceSpecial then
      self:DrawHeadIcon(id, previousId, countOfBro, index, 2, true, isFakeClassInfo)
      return
    end
    self:DrawHeadIcon(id, previousId, countOfBro, index, turnNumber, isNoviceSpecial, isFakeClassInfo)
    local nextTurnTable = {}
    for i = 1, #nowClassData.AdvanceClass do
      if Table_Class[nowClassData.AdvanceClass[i]] then
        TableUtility.ArrayPushBack(nextTurnTable, nowClassData.AdvanceClass[i])
      end
    end
    if ProfessionProxy.IsNovice(id) then
      if 1 < #nextTurnTable then
        self:GetNextTurnTableAndShow(nextTurnTable[1], id, 1, 1, nil, true, true)
      elseif #nextTurnTable == 1 then
        self:GetNextTurnTableAndShow(nextTurnTable[1], id, 1, 1, nil, true)
      else
        return nil
      end
    elseif nextTurnTable ~= nil then
      local countOfBroXiuzheng = #nextTurnTable
      for k, v in pairs(nextTurnTable) do
        if Table_Class[v].IsOpen == 0 then
          countOfBroXiuzheng = countOfBroXiuzheng - 1
        end
        if Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
          countOfBroXiuzheng = countOfBroXiuzheng - 1
        end
      end
      local kXiuZheng = 1
      for k, v in pairs(nextTurnTable) do
        if Table_Class[v].gender == nil or Table_Class[v].gender == ProfessionProxy.Instance:GetCurSex() then
          self:GetNextTurnTableAndShow(v, id, countOfBroXiuzheng, kXiuZheng, turnNumber + 1)
          kXiuZheng = kXiuZheng + 1
        end
      end
    elseif nextTurnTable == nil then
      local nextId = id + 1
      if Table_Class[nextId].IsOpen == 0 then
        return nil
      end
      self:GetNextTurnTableAndShow(nextId, id, 1, 1, turnNumber + 1)
    end
  end
  return nil
end

function ProfessionPage:DrawHeadIcon(id, previousId, countOfBro, index, turnNumber, isNoviceSpecial, isFakeClassInfo)
  local FirstIconY = 164.6
  local YSpace = 170.6
  local tempVector3 = LuaGeometry.GetTempVector3()
  if previousId == nil then
    tempVector3:Set(0, FirstIconY, 0)
  elseif 3 <= turnNumber then
    if IconCellTable[previousId] ~= nil and IconCellTable ~= nil and IconCellTable[previousId] ~= nil then
      tempVector3:Set(IconCellTable[previousId].transform.localPosition.x, FirstIconY - YSpace * (turnNumber - 1), 0)
    else
      helplog("review code!!!!")
    end
  else
    local x = 0
    if countOfBro == 2 then
      if index == 1 then
        x = -135
      elseif index == 2 then
        x = 135
      end
    end
    if countOfBro == 3 then
      if index == 1 then
        x = -135
      elseif index == 2 then
        x = 0
      elseif index == 3 then
        x = 135
      end
    end
    tempVector3:Set(x, FirstIconY - YSpace * (turnNumber - 1), 0)
  end
  local obj
  local pfTable1 = Table_Class[id]
  if isFakeClassInfo then
    pfTable1 = {
      id = id,
      NameZh = "???",
      isFake = true
    }
  end
  local pfnCell1
  for k, v in pairs(multiProfessionTypeIconCells) do
    if v.gameObject.name == "resetcell" then
      obj = v.gameObject
      pfnCell1 = v
      break
    end
  end
  if obj == nil then
    obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.cellRes, self.centerScrollView.gameObject)
    pfnCell1 = ProfessionTypeIconCell.new(obj)
    table.insert(multiProfessionTypeIconCells, pfnCell1)
    pfnCell1:AddEventListener(MouseEvent.MouseClick, self.clickMultiProfessionIcon, self)
  end
  pfnCell1:SetData(nil)
  pfnCell1:SetPreviousJob(previousId, 0)
  for k, v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
    if v.profession == previousId then
      pfnCell1:SetPreviousJob(previousId, v.joblv)
      break
    end
  end
  obj.gameObject.name = tostring(id)
  obj.gameObject.transform:SetParent(self.centerScrollView.transform, false)
  obj.transform.localPosition = tempVector3
  IconCellTable[id] = obj
  if pfTable1 == nil then
    helplog("if pfTable1 == nil then id:" .. id)
  end
  pfnCell1:SetData(pfTable1)
  pfnCell1:SetPreviousId(previousId)
  pfnCell1:isShowName(true)
  pfnCell1:SetSelectedMPActive(false)
  if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange == true and ProfessionProxy.GetJobDepth(id) >= 4 then
    helplog("隐藏SetActive(false) id:" .. id)
    pfnCell1.gameObject:SetActive(false)
  end
  if isNoviceSpecial then
  else
    self:DrawLine(id, previousId, countOfBro, index, turnNumber)
  end
end

function ProfessionPage:ResetLineState()
  local id, jobDepth, leftid, rightid, centerid
  for k, v in pairs(LineTable) do
    id = v:GetId() or 0
    jobDepth = ProfessionProxy.GetJobDepth(id)
    if jobDepth == 1 then
      local thisac = Table_Class[id].AdvanceClass
      if #thisac == 2 then
        leftid = thisac[1]
        rightid = thisac[2]
        v:RootSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
      elseif #thisac == 3 then
        leftid = thisac[1]
        centerid = thisac[2]
        rightid = thisac[3]
        v:RootThreeSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
      elseif #thisac == 1 then
        v:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[1]))
      else
        helplog("reviewCode")
      end
    elseif jobDepth == 2 then
    elseif 2 < jobDepth then
      v:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(id))
      if not ProfessionProxy.Instance:ShouldThisIdVisible(id) then
        v.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.01, 0.01, 0.01)
      else
        v.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      end
    elseif ProfessionProxy.IsNovice(id) then
      v:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(next(Table_Class[id].AdvanceClass) and Table_Class[id].AdvanceClass[1]))
    else
      helplog("reviewcode")
    end
  end
end

function ProfessionPage:DrawLine(id, previousId, countOfBro, index, turnNumber)
  local obj, lineCell
  for k, v in pairs(LineTable) do
    if v.gameObject.name == "resetline" then
      obj = v.gameObject
      lineCell = v
      break
    end
  end
  if lineCell == nil then
    obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.lineRes, self.centerScrollView.gameObject)
    lineCell = MPLineCell.new(obj)
  end
  obj.gameObject.name = "line" .. id
  lineCell:SetId(id)
  lineCell:SetPreviousId(previousId)
  local leftid, rightid, centerid
  if ProfessionProxy.GetSpecialJobDepth(id) == 3 or ProfessionProxy.GetJobDepth(id) == 1 then
    obj.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 62.7, 0)
    local thisac = Table_Class[id].AdvanceClass
    local thisacXiuZheng = {}
    for k, v in pairs(thisac) do
      if not Table_Class[v] or Table_Class[v].IsOpen == 0 then
      elseif Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
      else
        table.insert(thisacXiuZheng, v)
      end
    end
    if #thisacXiuZheng == 1 then
      obj.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 83.3, 0)
      lineCell:ShowLine(2)
      centerid = thisacXiuZheng[1]
      lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid))
    elseif #thisacXiuZheng == 2 then
      lineCell:ShowLine(1)
      leftid = thisacXiuZheng[1]
      rightid = thisacXiuZheng[2]
      lineCell:RootSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
    elseif #thisacXiuZheng == 3 then
      lineCell:ShowLine(3)
      leftid = thisacXiuZheng[1]
      centerid = thisacXiuZheng[2]
      rightid = thisacXiuZheng[3]
      lineCell:RootThreeSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
    else
      helplog("reviewCode")
    end
  elseif ProfessionProxy.GetSpecialJobDepth(id) == 4 or ProfessionProxy.GetJobDepth(id) == 2 then
    obj.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(100000, 0, 0)
  elseif ProfessionProxy.GetSpecialJobDepth(id) > 4 or ProfessionProxy.GetJobDepth(id) > 2 then
    local thisIconCell = IconCellTable[id]
    local previousIdIconCell = IconCellTable[previousId]
    local x = thisIconCell.gameObject.transform.localPosition.x
    local thisY = thisIconCell.gameObject.transform.localPosition.y
    if previousIdIconCell == nil then
      helplog("id:" .. id .. "previousIdIconCell is null!pleaseCheckCode")
      return
    end
    local previousY = previousIdIconCell.gameObject.transform.localPosition.y
    local finalY = (thisY + previousY) / 2
    obj.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, finalY, 0)
    local lineCell = MPLineCell.new(obj)
    lineCell:ShowLine(2)
    lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(id))
  elseif ProfessionProxy.IsNovice(id) then
    obj.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 83.3, 0)
    lineCell:ShowLine(2)
    lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(next(Table_Class[id].AdvanceClass) and Table_Class[id].AdvanceClass[1]))
  else
    helplog("reviewcode")
  end
  table.insert(LineTable, lineCell)
  if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange == true and ProfessionProxy.GetJobDepth(id) >= 4 then
    helplog("隐藏id" .. id)
    lineCell.gameObject:SetActive(false)
  end
end

function ProfessionPage:ResetIcons()
  for k, v in pairs(multiProfessionTypeIconCells) do
    v.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(10000, 0, 0)
    v.gameObject.name = "resetcell"
  end
  for k, v in pairs(LineTable) do
    v.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(10000, 0, 0)
    v.gameObject.name = "resetline"
  end
end

function ProfessionPage:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd, self.RecvProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd, self.RecvProfessionChangeUserCmd)
end

function ProfessionPage:UpdateUI(updateJobGridList)
  local topScrollViewIconTable = ProfessionProxy.Instance:GetTopScrollViewIconTable()
  if self.JobsGridList == nil then
    return
  end
  self.JobsGridList:ResetDatas(topScrollViewIconTable)
  local tmpData = Table_Class[MyselfProxy.Instance:GetMyProfession()]
  if tmpData and tmpData.Type then
  else
    helplog("Table Class 有问题请策划检查id:" .. MyselfProxy.Instance:GetMyProfession())
    return
  end
  local startid = tmpData.Type * 10 + 1
  local selected
  local cells = self.JobsGridList:GetCells()
  for k, v in pairs(cells) do
    v:SetShowType(1)
    local data = v:GetData()
    if data and data.id == startid then
      v:setIsSelected(true)
      selected = v
    else
      v:setIsSelected(false)
    end
  end
  if selected then
    if not ProfessionProxy.IsDoramRace(startid) then
      self.humanclassicon.gameObject:SetActive(true)
      self.doraclassicon.gameObject:SetActive(false)
      IconManager:SetProfessionIcon(selected.ProfessIcon_UISprite.spriteName, self.humanclassicon)
      self.humanSelected = selected.data.id
    else
      self.doraclassicon.gameObject:SetActive(true)
      self.humanclassicon.gameObject:SetActive(false)
      IconManager:SetProfessionIcon(selected.ProfessIcon_UISprite.spriteName, self.doraclassicon)
      self.doraSelected = selected.data.id
    end
  end
  if updateJobGridList then
    if ProfessionProxy.IsDoramRace() then
      self:SetTextureGrey(self.human)
      self:SetTextureWhite(self.dora)
    else
      self:SetTextureGrey(self.dora)
      self:SetTextureWhite(self.human)
    end
    self:UpdateJobGridList(nil, true)
    local cells = self.JobsGridList:GetCells()
    for k, v in pairs(cells) do
      v:SetShowType(1)
      local data = v:GetData()
      if data and data.id == startid then
        v:setIsSelected(true)
        selected = v
      else
        v:setIsSelected(false)
      end
    end
  end
  self:ResetHeadIconsState()
  self.centerScrollView:ResetPosition()
end

function ProfessionPage:initData()
  self.guidText = nil
  self.textLen = 0
  self.starIndex = 0
end

function ProfessionPage:getAdvanceLevel(professionData)
  if professionData then
    local id = professionData.id
    return id - math.floor(id / 10) * 10
  else
    return 0
  end
end

ProfessionPage.isDebug = true

function ProfessionPage:clickMultiProfessionIcon(obj)
  local data = obj.data
  if data.isFake then
    return
  end
  if FunctionUnLockFunc.Me():CheckCanOpen(9004, nil) == false and ProfessionPage.isDebug == false then
    MsgManager.ShowMsgByID(25413)
    return
  end
  if ProfessionProxy.Instance:HasMPInfo() and not SaveInfoProxy.Instance:HasInfo(SaveInfoEnum.Branch) then
    MsgManager.FloatMsg("", ZhString.Charactor_Profession_WaitBranchInfo)
    return
  end
  if not obj.isSelected then
    self:PassEvent(ProfessionPage.ProfessionIconClick, nil)
  else
    self:PassEvent(ProfessionPage.ProfessionIconClick, obj)
    obj:SetSelectedMPActive(true)
    for i = 1, #multiProfessionTypeIconCells do
      local single = multiProfessionTypeIconCells[i]
      if single ~= obj then
        single:setIsSelected(false)
        single:SetSelectedMPActive(false)
      end
    end
  end
end

function ProfessionPage:unSelectedProfessionIconCell()
  for i = 1, #professionTypeIconCells do
    local single = professionTypeIconCells[i]
    if single ~= obj then
      single:setIsSelected(false)
    end
  end
  for i = 1, #multiProfessionTypeIconCells do
    local single = multiProfessionTypeIconCells[i]
    if single ~= obj then
      single:setIsSelected(false)
    end
  end
end

function ProfessionPage:OnEnter()
  self.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
end

function ProfessionPage:OnGoSetAcitve()
  self.centerScrollView:ResetPosition()
end

function ProfessionPage:OnExit()
  self.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  TableUtility.ArrayClear(multiProfessionTypeIconCells)
  TableUtility.ArrayClear(professionTypeIconCells)
  TableUtility.TableClear(IconCellTable)
  TableUtility.ArrayClear(LineTable)
end
