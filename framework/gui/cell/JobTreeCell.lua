local baseCell = autoImport("BaseCell")
JobTreeCell = class("JobTreeCell", baseCell)

function JobTreeCell:Init()
  self:initView()
end

function JobTreeCell:initView()
  self.Bg = self:FindComponent("BG", UISprite)
  if ProfessionProxy.Forbid4th then
    self.Bg.height = 416
  else
    self.Bg.height = 556
  end
  self.TopJobNode = self:FindGO("TopJobNode")
  self.TwoBranchLine = self:FindGO("TwoBranchLine")
  self.OneBranchJobEmpty = self:FindGO("OneBranchJobEmpty")
  self.OneBranchLine = self:FindGO("OneBranchLine")
  self.TwoBranchJob = self:FindGO("TwoBranchJob")
  self.TwoBranchJob_l1 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "l1")
  self.TwoBranchJob_l2 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "l2")
  self.TwoBranchJob_l3 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "l3")
  self.TwoBranchJob_l4 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "l4")
  self.TwoBranchJob_r1 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "r1")
  self.TwoBranchJob_r2 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "r2")
  self.TwoBranchJob_r3 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "r3")
  self.TwoBranchJob_r4 = Game.GameObjectUtil:DeepFindChild(self.TwoBranchJob, "r4")
  self.TwoBranchJob_LeftTable = {
    self.TwoBranchJob_l1,
    self.TwoBranchJob_l2,
    self.TwoBranchJob_l3,
    self.TwoBranchJob_l4
  }
  self.TwoBranchJob_RightTable = {
    self.TwoBranchJob_r1,
    self.TwoBranchJob_r2,
    self.TwoBranchJob_r3,
    self.TwoBranchJob_r4
  }
  self.OneBranchJob = self:FindGO("OneBranchJob")
  self.OneBranchJob_c1 = Game.GameObjectUtil:DeepFindChild(self.OneBranchJob, "c1")
  self.OneBranchJob_c2 = Game.GameObjectUtil:DeepFindChild(self.OneBranchJob, "c2")
  self.OneBranchJob_c3 = Game.GameObjectUtil:DeepFindChild(self.OneBranchJob, "c3")
  self.OneBranchJob_c4 = Game.GameObjectUtil:DeepFindChild(self.OneBranchJob, "c4")
  self.OneBranchJob_CenterTable = {
    self.OneBranchJob_c1,
    self.OneBranchJob_c2,
    self.OneBranchJob_c3,
    self.OneBranchJob_c4
  }
  self.ThisCellJobIconTable = {}
  self.TwoBranchLine_c1_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "c1"):GetComponent(UISprite)
  self.TwoBranchLine_c2_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "c2"):GetComponent(UISprite)
  self.TwoBranchLine_l1_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "l1"):GetComponent(UISprite)
  self.TwoBranchLine_l2_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "l2"):GetComponent(UISprite)
  self.TwoBranchLine_l3_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "l3"):GetComponent(UISprite)
  self.TwoBranchLine_l4_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "l4"):GetComponent(UISprite)
  self.TwoBranchLine_l5_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "l5"):GetComponent(UISprite)
  self.TwoBranchLine_r1_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "r1"):GetComponent(UISprite)
  self.TwoBranchLine_r2_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "r2"):GetComponent(UISprite)
  self.TwoBranchLine_r3_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "r3"):GetComponent(UISprite)
  self.TwoBranchLine_r4_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "r4"):GetComponent(UISprite)
  self.TwoBranchLine_r5_UISprite = Game.GameObjectUtil:DeepFindChild(self.TwoBranchLine, "r5"):GetComponent(UISprite)
  self.TwoBranchLine_LeftTable = {
    self.TwoBranchLine_l1_UISprite,
    self.TwoBranchLine_l2_UISprite,
    self.TwoBranchLine_l3_UISprite,
    self.TwoBranchLine_l4_UISprite,
    self.TwoBranchLine_l5_UISprite
  }
  self.TwoBranchLine_RightTable = {
    self.TwoBranchLine_r1_UISprite,
    self.TwoBranchLine_r2_UISprite,
    self.TwoBranchLine_r3_UISprite,
    self.TwoBranchLine_r4_UISprite,
    self.TwoBranchLine_r5_UISprite
  }
  self.OneBranchLine_c1_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c1"):GetComponent(UISprite)
  self.OneBranchLine_c2_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c2"):GetComponent(UISprite)
  self.OneBranchLine_c3_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c3"):GetComponent(UISprite)
  self.OneBranchLine_c4_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c4"):GetComponent(UISprite)
  self.OneBranchLine_c5_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c5"):GetComponent(UISprite)
  self.OneBranchLine_c6_UISprite = Game.GameObjectUtil:DeepFindChild(self.OneBranchLine, "c6"):GetComponent(UISprite)
  self.OneBranchLine_c1_UISprite.height = 62
  self.OneBranchLine_Table = {
    self.OneBranchLine_c1_UISprite,
    self.OneBranchLine_c2_UISprite,
    self.OneBranchLine_c3_UISprite,
    self.OneBranchLine_c4_UISprite,
    self.OneBranchLine_c5_UISprite,
    self.OneBranchLine_c6_UISprite
  }
  self.oneBranchHero = self:FindGO("BranchHero")
  self.oneBranchHeroGrid = self:FindGO("HeroGrid", self.oneBranchHero):GetComponent(UIGrid)
  self.twoBranchHero = self:FindGO("TwoBranchHero")
  self.heroBranchGrid = {}
  self.heroBranchGrid[1] = self:FindGO("LGrid", self.twoBranchHero):GetComponent(UIGrid)
  self.heroBranchGrid[2] = self:FindGO("RGrid", self.twoBranchHero):GetComponent(UIGrid)
end

function JobTreeCell:SetData(data)
  self.originid = data.id
  local isSpecialJob = ProfessionProxy.GetSpecialJobDepth(data.id) > 0
  if isSpecialJob then
  else
    self:CreateJobIconUnderThisGameObj(data.id, self.TopJobNode)
  end
  if data and data.AdvanceClass then
    local advClass = {}
    for i = 1, #data.AdvanceClass do
      if Table_Class[data.AdvanceClass[i]] then
        TableUtility.ArrayPushBack(advClass, data.AdvanceClass[i])
      end
    end
    if #advClass == 1 then
      if isSpecialJob then
        self.TwoBranchLine.gameObject:SetActive(false)
        self.TwoBranchJob.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(true)
        self.OneBranchJobEmpty.gameObject:SetActive(true)
        if Table_Class[data.id] then
          self:CreateJobIconUnderThisGameObj(data.id, self.OneBranchJob_c2)
        end
        if Table_Class[data.id + 1] then
          self:CreateJobIconUnderThisGameObj(data.id + 1, self.OneBranchJob_c3)
        end
        if Table_Class[data.id + 2] then
          self:CreateJobIconUnderThisGameObj(data.id + 2, self.OneBranchJob_c4)
        end
      else
        self.OneBranchJobEmpty.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(true)
        self.TwoBranchLine.gameObject:SetActive(false)
        self.TwoBranchJob.gameObject:SetActive(false)
        self.OneBranchJob.gameObject:SetActive(true)
        self:FullUpJobNodeTableWithStartId(advClass[1], self.OneBranchJob_CenterTable)
      end
      self.heroClassCells = {}
      for k, v in pairs(Table_Class) do
        if v.OriginId and 0 < TableUtility.ArrayFindIndex(v.OriginId, self.originid) and not ProfessionProxy.Instance:CheckProfIsBanned(v.id) then
          table.insert(self.heroClassCells, ProfessionIconCell.CreateNew(v.id, self.oneBranchHeroGrid.gameObject))
        end
      end
      self.oneBranchHeroGrid:Reposition()
    elseif #advClass == 2 then
      self.OneBranchJobEmpty.gameObject:SetActive(false)
      self.OneBranchLine.gameObject:SetActive(false)
      self.TwoBranchLine.gameObject:SetActive(true)
      self.TwoBranchJob.gameObject:SetActive(true)
      self:FullUpJobNodeTableWithStartId(advClass[1], self.TwoBranchJob_LeftTable)
      self:FullUpJobNodeTableWithStartId(advClass[2], self.TwoBranchJob_RightTable)
      self.heroClassCells = {}
      for i = 1, #advClass do
        local originID = advClass[i]
        for k, v in pairs(Table_Class) do
          if v.OriginId and 0 < TableUtility.ArrayFindIndex(v.OriginId, self.originid) and not ProfessionProxy.Instance:CheckProfIsBanned(v.id) then
            table.insert(self.heroClassCells, ProfessionIconCell.CreateNew(v.id, self.heroBranchGrid[i].gameObject))
          end
        end
      end
      for i = 1, 2 do
        self.heroBranchGrid[i]:Reposition()
      end
    elseif 3 <= #advClass then
      self.OneBranchJobEmpty.gameObject:SetActive(false)
      self.OneBranchLine.gameObject:SetActive(false)
      if 0 < TableUtility.ArrayFindIndex(ProfessionProxy.MultiSexJob1st, data.id) then
        self.OneBranchJobEmpty.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(false)
        self.TwoBranchLine.gameObject:SetActive(true)
        self.TwoBranchJob.gameObject:SetActive(true)
        local rightTable = self:GetRightUpgradeTableForMultiSexJob(data.id)
        self:FullUpJobNodeTableWithStartId(rightTable[1], self.TwoBranchJob_LeftTable)
        self:FullUpJobNodeTableWithStartId(rightTable[2], self.TwoBranchJob_RightTable)
      else
      end
    end
  end
  self:Update()
end

function JobTreeCell:Update()
  self:UpdateThisCellJobIconState()
  self:UpdateThisCellLineState()
  self:UpdateHeroState()
end

function JobTreeCell:FullUpJobNodeTableWithStartId(startid, branchTable)
  for k, v in pairs(branchTable) do
    if startid and Table_Class[startid] and Table_Class[startid].IsOpen ~= 0 then
      self:CreateJobIconUnderThisGameObj(startid, v)
      if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
        startid = Table_Class[startid].AdvanceClass[1]
      else
        break
      end
    else
      break
    end
  end
end

function JobTreeCell:GetRightUpgradeTableForMultiSexJob(prof1st)
  local rightTable = {}
  for k, v in pairs(Table_Class[prof1st].AdvanceClass) do
    if Table_Class[v] and Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
    else
      table.insert(rightTable, v)
    end
  end
  return rightTable
end

function JobTreeCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  table.insert(self.ThisCellJobIconTable, ProfessionIconCell.CreateNew(jobid, gameobj))
end

function JobTreeCell:UpdateThisCellJobIconState()
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    local depth = ProfessionProxy.GetJobDepth(id)
    if depth == 0 then
      if ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(id) then
        v:SetState(0, id)
      elseif ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
        v:SetState(3, id)
      else
        v:SetState(4, id)
      end
    elseif depth == 1 then
      if ProfessionProxy.IsDoramRace(id) and ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(ProfessionProxy.doramNovice) and ProfessionProxy.Instance.hasdora2nd or ProfessionProxy.IsHumanRace(id) and ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(ProfessionProxy.humanNovice) and ProfessionProxy.Instance.hashuman2nd or ProfessionProxy.Instance:IsThisIdYiGouMai(id) then
        v:SetState(0, id)
      else
        v:SetState(4, id)
      end
    elseif depth == 2 then
      if ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
        v:SetState(3, id)
      elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    elseif depth == 3 then
      if 0 < ProfessionProxy.GetSpecialJobDepth(id) then
        if ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) and (ProfessionProxy.IsHumanRace(id) and ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(ProfessionProxy.humanNovice) or ProfessionProxy.IsDoramRace(id) and ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(ProfessionProxy.doramNovice)) then
          v:SetState(3, id)
        elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
          v:SetState(1, id)
        else
          v:SetState(4, id)
        end
      elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    elseif 4 <= depth then
      if ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    end
  end
end

function JobTreeCell:UpdateThisCellLineState()
  local data = Table_Class[self.originid]
  local advClass = {}
  for i = 1, #data.AdvanceClass do
    if Table_Class[data.AdvanceClass[i]] then
      TableUtility.ArrayPushBack(advClass, data.AdvanceClass[i])
    end
  end
  if #advClass == 1 then
    if ProfessionProxy.GetSpecialJobDepth(data.id) == 3 then
      self:ChangeLineColorForSpecialJob(data.id)
    else
      self:ChangeLineColorWithStartIdForOneBranchLine(advClass[1], self.OneBranchLine_Table)
    end
  elseif #advClass == 2 then
    self:ChangeLineColorWithStartId(advClass[1], self.TwoBranchLine_LeftTable)
    self:ChangeLineColorWithStartId(advClass[2], self.TwoBranchLine_RightTable)
  else
    if 3 <= #advClass and TableUtility.ArrayFindIndex(ProfessionProxy.MultiSexJob1st, data.id) > 0 then
      local rightTable = self:GetRightUpgradeTableForMultiSexJob(data.id)
      self:ChangeLineColorWithStartId(rightTable[1], self.TwoBranchLine_LeftTable)
      self:ChangeLineColorWithStartId(rightTable[2], self.TwoBranchLine_RightTable)
    else
    end
  end
end

function JobTreeCell:UpdateHeroState()
  if not self.heroClassCells then
    return
  end
  for i = 1, #self.heroClassCells do
    local single = self.heroClassCells[i]
    local id = single:Getid()
    local state = ProfessionProxy.Instance:GetClassState(id)
    if state == 6 then
      single:SetState(3, id)
    elseif state == 1 or state == 2 or state == 3 or state == 4 then
      single:SetState(1, id)
    else
      single:SetState(4, id)
    end
  end
end

function JobTreeCell:RecvBuyJob(buyId)
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    if buyId == id then
      v:SetRecvBuy(4, buyId)
    end
  end
end

function JobTreeCell:ChangeLineColorWithStartIdForOneBranchLine(startid, branchTable)
  branchTable[4].gameObject:SetActive(false)
  branchTable[5].gameObject:SetActive(false)
  branchTable[6].gameObject:SetActive(false)
  while startid do
    local depth = ProfessionProxy.GetJobDepth(startid)
    if depth == 2 then
      if self:GetIdState(startid) == 1 then
        branchTable[1].spriteName = "persona_line"
        branchTable[2].spriteName = "persona_line"
        branchTable[3].spriteName = "persona_line"
      else
        branchTable[1].spriteName = "persona_line"
        branchTable[2].spriteName = "persona_empty-line"
        branchTable[3].spriteName = "persona_empty-line"
      end
    elseif 3 <= depth then
      if self:GetIdState(startid) == 1 then
        branchTable[depth + 1].spriteName = "persona_line"
        branchTable[depth + 1].gameObject:SetActive(true)
      else
        if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
          branchTable[depth + 1].gameObject:SetActive(true)
        else
          branchTable[depth + 1].gameObject:SetActive(false)
        end
        branchTable[depth + 1].spriteName = "persona_empty-line"
      end
      if not Table_Class[startid] or Table_Class[startid].IsOpen ~= 1 then
        branchTable[depth + 1].gameObject:SetActive(false)
      end
    end
    if Table_Class[startid] then
      if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
        startid = Table_Class[startid].AdvanceClass[1]
      else
        startid = nil
      end
    else
      startid = nil
    end
  end
end

function JobTreeCell:ChangeLineColorForSpecialJob(prof1st)
  if self:GetIdState(prof1st) == 1 then
    self.OneBranchLine_Table[1].spriteName = "persona_line"
    self.OneBranchLine_Table[2].spriteName = "persona_line"
    self.OneBranchLine_Table[3].spriteName = "persona_line"
    self.OneBranchLine_Table[4].spriteName = "persona_line"
  else
    self.OneBranchLine_Table[1].spriteName = "persona_empty-line"
    self.OneBranchLine_Table[2].spriteName = "persona_empty-line"
    self.OneBranchLine_Table[3].spriteName = "persona_empty-line"
    self.OneBranchLine_Table[4].spriteName = "persona_empty-line"
  end
  if self:GetIdState(prof1st + 1) == 1 then
    self.OneBranchLine_Table[5].spriteName = "persona_line"
  else
    self.OneBranchLine_Table[5].spriteName = "persona_empty-line"
  end
  if Table_Class[prof1st + 2] then
    self.OneBranchLine_Table[6].gameObject:SetActive(true)
  else
    self.OneBranchLine_Table[6].gameObject:SetActive(false)
  end
  if self:GetIdState(prof1st + 2) == 1 then
    self.OneBranchLine_Table[6].spriteName = "persona_line"
  else
    self.OneBranchLine_Table[6].spriteName = "persona_empty-line"
  end
end

function JobTreeCell:ChangeLineColorWithStartId(startid, branchTable)
  branchTable[3].gameObject:SetActive(false)
  branchTable[4].gameObject:SetActive(false)
  branchTable[5].gameObject:SetActive(false)
  while startid do
    local depth = ProfessionProxy.GetJobDepth(startid)
    if depth == 2 then
      if self:GetIdState(startid) == 1 then
        branchTable[1].spriteName = "persona_line"
        branchTable[2].spriteName = "persona_line"
      else
        branchTable[1].spriteName = "persona_empty-line"
        branchTable[2].spriteName = "persona_empty-line"
      end
    elseif 3 <= depth then
      if self:GetIdState(startid) == 1 then
        branchTable[depth].spriteName = "persona_line"
        branchTable[depth].gameObject:SetActive(true)
      else
        if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
          branchTable[depth].gameObject:SetActive(true)
        else
          branchTable[depth].gameObject:SetActive(false)
        end
        branchTable[depth].spriteName = "persona_empty-line"
      end
      if not Table_Class[startid] or Table_Class[startid].IsOpen ~= 1 then
        branchTable[depth].gameObject:SetActive(false)
      end
    end
    if Table_Class[startid] then
      if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
        startid = Table_Class[startid].AdvanceClass[1]
      else
        startid = nil
      end
    else
      startid = nil
    end
  end
end

function JobTreeCell:GetIdState(thisId)
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    if thisId == id then
      return v:GetState()
    end
  end
end

function JobTreeCell:GetIconTable()
  return self.ThisCellJobIconTable or {}
end

function JobTreeCell:GetHeroIcon()
  return self.heroClassCells or {}
end

function JobTreeCell:OnCellDestroy()
  TableUtility.TableClear(self.ThisCellJobIconTable)
end
