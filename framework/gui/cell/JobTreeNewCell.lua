local baseCell = autoImport("BaseCell")
JobTreeNewCell = class("JobTreeNewCell", baseCell)
autoImport("JobTreeLineCell")

function JobTreeNewCell:Init()
  self:InitView()
end

function JobTreeNewCell:InitView()
  self.bg = self:FindGO("BG"):GetComponent(UISprite)
  self.topJobNode = self:FindGO("TopJobNode")
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.treeLineCtrl = UIGridListCtrl.new(self.table, JobTreeLineCell, "JobTreeLineCell")
  self.c1 = self:FindGO("C1"):GetComponent(UISprite)
  self.c2 = self:FindGO("C2"):GetComponent(UISprite)
  self.l1 = self:FindGO("L1"):GetComponent(UISprite)
  self.r1 = self:FindGO("R1"):GetComponent(UISprite)
  self.professionCellTable = {}
  self.heroClassCellTable = {}
end

function JobTreeNewCell:SetData(data)
  self.originid = data.id
  local isSpecialJob = ProfessionProxy.GetSpecialJobDepth(data.id) > 0
  if isSpecialJob then
  else
    self:CreateJobIconUnderThisGameObj(data.id, self.topJobNode)
  end
  local depth = ProfessionProxy.GetJobDepth(self.originid)
  local advanceClass = data and data.AdvanceClass
  if advanceClass then
    local advClass = {}
    if depth == 1 then
      for i = 1, #advanceClass do
        if Table_Class[advanceClass[i]] then
          TableUtility.ArrayPushBack(advClass, advanceClass[i])
        end
      end
    else
      TableUtility.ArrayPushBack(advClass, data.id)
    end
    if #advClass == 3 and 0 < TableUtility.ArrayFindIndex(ProfessionProxy.MultiSexJob1st, data.id) then
      advClass = self:GetRightUpgradeTableForMultiSexJob(data.id)
    end
    local testStr = ""
    for i = 1, #advClass do
      testStr = testStr .. advClass[i] .. ","
    end
    self.treeLineCtrl:ResetDatas(advClass)
    local cells = self.treeLineCtrl:GetCells()
    for i = 1, #cells do
      local classProCell = cells[i]:GetClassicProfessionIconCell()
      for j = 1, #classProCell do
        table.insert(self.professionCellTable, classProCell[j])
      end
      local heroProCell = cells[i]:GetHeroProfessionIconCell()
      for j = 1, #heroProCell do
        table.insert(self.heroClassCellTable, heroProCell[j])
      end
    end
    if #advClass == 1 then
      self.l1.gameObject:SetActive(false)
      self.r1.gameObject:SetActive(false)
      local line1Pos = cells[1]:GetPosX()
      local offsetX = -line1Pos
      self.table.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offsetX, 153, 0)
      self.bg.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offsetX, 171, 0)
    else
      local line1Pos = cells[1]:GetPosX()
      local line2Pos = cells[2]:GetPosX()
      local offsetX = -line1Pos - (line2Pos - line1Pos) / 2
      self.table.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offsetX, 153, 0)
      self.bg.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(offsetX, 171, 0)
      self.l1.width = (line2Pos - line1Pos) / 2 + 3
      self.r1.width = (line2Pos - line1Pos) / 2 + 3
    end
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.table.gameObject.transform)
    self.bg.width = bound.size.x + 30
  end
  self:Refresh()
end

function JobTreeNewCell:Refresh()
  self:UpdateClassicProfessionIconState()
  self:UpdateProfessionLineState()
  self:UpdateHeroState()
end

function JobTreeNewCell:UpdateClassicProfessionIconState()
  for k, v in pairs(self.professionCellTable) do
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

function JobTreeNewCell:UpdateHeroState()
  if not self.heroClassCellTable then
    return
  end
  for i = 1, #self.heroClassCellTable do
    local single = self.heroClassCellTable[i]
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

function JobTreeNewCell:UpdateProfessionLineState()
  local data = Table_Class[self.originid]
  local advClass = {}
  for i = 1, #data.AdvanceClass do
    if Table_Class[data.AdvanceClass[i]] then
      TableUtility.ArrayPushBack(advClass, data.AdvanceClass[i])
    end
  end
  if #advClass == 1 then
    if ProfessionProxy.GetSpecialJobDepth(data.id) == 3 then
      if self:GetIdState(data.id) == 1 then
        self.c1.spriteName = "persona_line"
        self.c2.spriteName = "persona_line"
      else
        self.c1.spriteName = "persona_empty-line"
        self.c2.spriteName = "persona_empty-line"
      end
    else
      local startid = self.originid
      local originState = self:GetIdState(data.id)
      if originState == 1 or originState == 0 then
        self.c2.spriteName = "persona_line"
      else
        self.c2.spriteName = "persona_empty-line"
      end
      if ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(ProfessionProxy.doramNovice) then
        self.c1.spriteName = "persona_line"
      else
        self.c1.spriteName = "persona_empty-line"
      end
    end
  else
    local originState = self:GetIdState(self.originid)
    if originState == 1 or originState == 0 then
      self.c1.spriteName = "persona_line"
      self.c2.spriteName = "persona_line"
      self.l1.spriteName = "persona_line"
      self.r1.spriteName = "persona_line"
    else
      self.c1.spriteName = "persona_empty-line"
      self.c2.spriteName = "persona_empty-line"
      self.l1.spriteName = "persona_empty-line"
      self.r1.spriteName = "persona_empty-line"
    end
  end
  local cells = self.treeLineCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateProfessionLineState()
  end
end

function JobTreeNewCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  table.insert(self.professionCellTable, ProfessionIconCell.CreateNew(jobid, gameobj))
end

function JobTreeNewCell:GetRightUpgradeTableForMultiSexJob(prof1st)
  local rightTable = {}
  for k, v in pairs(Table_Class[prof1st].AdvanceClass) do
    if Table_Class[v] and Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
    else
      table.insert(rightTable, v)
    end
  end
  return rightTable
end

function JobTreeNewCell:GetIdState(thisId)
  for k, v in pairs(self.professionCellTable) do
    local id = v:Getid()
    if thisId == id then
      return v:GetState()
    end
  end
end

function JobTreeNewCell:GetIconTable()
  return self.professionCellTable or {}
end

function JobTreeNewCell:GetHeroIcon()
  return self.heroClassCellTable or {}
end

function JobTreeNewCell:RecvBuyJob(buyId)
  for k, v in pairs(self.professionCellTable) do
    local id = v:Getid()
    if buyId == id then
      v:SetRecvBuy(4, buyId)
    end
  end
end
