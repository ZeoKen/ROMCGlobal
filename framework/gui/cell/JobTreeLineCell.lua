local baseCell = autoImport("BaseCell")
JobTreeLineCell = class("JobTreeLineCell", baseCell)

function JobTreeLineCell:Init()
  self:InitView()
end

function JobTreeLineCell:InitView()
  self.classNode = self:FindGO("ClassicNode")
  self.nodeRoot = {}
  self.lines = {}
  for i = 1, 4 do
    local go = self:FindGO("Node" .. i)
    if go then
      self.nodeRoot[i] = go
      local line = self:FindGO("Line", go):GetComponent(UISprite)
      self.lines[i] = line
    end
  end
  self.heroNode = self:FindGO("HeroNode")
  self.heroBG = self:FindGO("HeroBg", self.heroNode):GetComponent(UISprite)
  self.heroLine1 = self:FindGO("Line1", self.heroNode):GetComponent(UISprite)
  self.heroLine2 = self:FindGO("Line2", self.heroNode):GetComponent(UISprite)
  self.heroLine2_2 = self:FindGO("Line2_2", self.heroNode):GetComponent(UISprite)
  self.heroLines = {
    self.heroLine1,
    self.heroLine2,
    self.heroLine2_2
  }
  self.heroGrid = self:FindGO("HeroGrid"):GetComponent(UIGrid)
  self.professionCellTable = {}
  self.heroClassCellTable = {}
end

function JobTreeLineCell:SetData(data)
  self.data = data
  local startID = data
  local depth = ProfessionProxy.GetJobDepth(startID)
  for i = depth - 1, #self.nodeRoot do
    if Table_Class[startID] and Table_Class[startID].IsOpen ~= 0 then
      self:CreateJobIconUnderThisGameObj(startID, self.nodeRoot[i])
      if Table_Class[startID].AdvanceClass and #Table_Class[startID].AdvanceClass == 1 then
        startID = Table_Class[startID].AdvanceClass[1]
      else
        break
      end
    else
      redlog("职业分支未开启", startID)
      break
    end
  end
  local heroList = {}
  for k, v in pairs(Table_Class) do
    if v.OriginId and 0 < TableUtility.ArrayFindIndex(v.OriginId, self.data) then
      local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      local curTypeBranch = ProfessionProxy.GetTypeBranchFromProf(v.id)
      if S_data[curTypeBranch] or not ProfessionProxy.Instance:CheckProfIsBanned(v.id) then
        table.insert(heroList, v.id)
      end
    end
  end
  table.sort(heroList, function(l, r)
    return l < r
  end)
  for i = 1, #heroList do
    table.insert(self.heroClassCellTable, ProfessionIconCell.CreateNew(heroList[i], self.heroGrid.gameObject))
  end
  if 0 < #self.heroClassCellTable then
    self.heroNode:SetActive(true)
    self.heroGrid:Reposition()
    local row = math.ceil(#self.heroClassCellTable / 3)
    local column = #self.heroClassCellTable >= 3 and 3 or #self.heroClassCellTable
    self.heroBG.width = 125 + (row - 1) * 130
    self.heroBG.height = 137 + (column - 1) * 140
    self.heroLine2.gameObject:SetActive(#self.heroClassCellTable == 1)
  else
    self.heroNode:SetActive(false)
  end
end

function JobTreeLineCell:UpdateProfessionLineState()
  local startid = self.data
  if ProfessionProxy.GetSpecialJobDepth(startid) == 3 then
    if self:GetIdState(startid) == 1 then
      self.lines[1].spriteName = "persona_line"
    else
      self.lines[1].spriteName = "persona_empty-line"
    end
  end
  while startid do
    local depth = ProfessionProxy.GetJobDepth(startid)
    if self:GetIdState(startid) == 1 then
      self.lines[depth - 1].spriteName = "persona_line"
      if depth == 4 then
        self:UpdateHeroLineState(true)
      end
    else
      self.lines[depth - 1].spriteName = "persona_empty-line"
      if depth == 4 then
        self:UpdateHeroLineState(false)
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

function JobTreeLineCell:UpdateHeroLineState(bool)
  for i = 1, #self.heroLines do
    self.heroLines[i].spriteName = bool and "persona_line" or "persona_empty-line"
  end
end

function JobTreeLineCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  table.insert(self.professionCellTable, ProfessionIconCell.CreateNew(jobid, gameobj))
end

function JobTreeLineCell:GetClassicProfessionIconCell()
  return self.professionCellTable
end

function JobTreeLineCell:GetHeroProfessionIconCell()
  return self.heroClassCellTable
end

function JobTreeLineCell:GetPosX()
  return self.gameObject.transform.localPosition[1]
end

function JobTreeLineCell:GetIdState(thisId)
  for k, v in pairs(self.professionCellTable) do
    local id = v:Getid()
    if thisId == id then
      return v:GetState()
    end
  end
end
