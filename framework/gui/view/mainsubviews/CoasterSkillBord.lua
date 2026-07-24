autoImport("UIGridListCtrl")
autoImport("ShortCutCoasterSkill")
autoImport("SnakeCoasterManager")
CoasterSkillBord = class("CoasterSkillBord", CoreView)

function CoasterSkillBord.LoadPreferb_ByFullPath(path, parent, initPanel)
  local obj = Game.AssetManager_UI:CreateAsset(path, parent.gameObject)
  if obj == nil then
    errorLog(path)
    return
  end
  UIUtil.ChangeLayer(obj, parent.gameObject.layer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  if obj and initPanel then
    local upPanel = UIUtil.GetComponentInParents(obj, UIPanel)
    if upPanel then
      local panels = UIUtil.GetAllComponentsInChildren(obj, UIPanel, true)
      for i = 1, #panels do
        panels[i].depth = panels[i].depth + upPanel.depth
      end
    end
  end
  return obj, path
end

function CoasterSkillBord.CreateSelf(parent)
  local go = CoasterSkillBord.LoadPreferb_ByFullPath("GUI/v1/part/CoasterSkillBord", parent, true)
  if go == nil then
    return nil
  end
  return CoasterSkillBord.new(go)
end

function CoasterSkillBord:ctor(go)
  self.gameObject = go
  self:InitView()
end

function CoasterSkillBord:InitView()
  self.inputEnabled = false
  self.coasterQuitButton = self:FindGO("CoasterQuitButton")
  self:AddClickEvent(self.coasterQuitButton, self.OnClickQuitButton)
  self.coasterSkillGrid = self:FindGO("CoasterSkillGrid")
  if self.coasterSkillGrid then
    self.coasterSkillGrid = self.coasterSkillGrid:GetComponent(UIGridActiveSelf) or self.coasterSkillGrid:GetComponent(UIGrid)
  end
  if self.coasterSkillGrid ~= nil then
    self.coasterSkillShotCutList = UIGridListCtrl.new(self.coasterSkillGrid, ShortCutCoasterSkill, "ShortCutCoasterSkill")
    self.coasterSkillShotCutList:SetAddCellHandler(self.AddCoasterSkillCellHandler, self)
    self.coasterSkillShotCutList:AddEventListener(MouseEvent.MouseClick, self.OnClickCoasterSkill, self)
  end
  EventManager.Me():AddEventListener(SnakeCoasterEvent.InnerGameFinish, self.OnGameFinish, self)
  EventManager.Me():AddEventListener(SnakeCoasterEvent.InnerGameStart, self.OnGameStart, self)
end

function CoasterSkillBord:AddCoasterSkillCellHandler(cell)
  cell.container = self.coasterSkillGrid
end

function CoasterSkillBord:_GetSnakeCoasterConfig(difficulty)
  return SnakeCoasterManager.Me():GetRuntimeConfig(difficulty)
end

function CoasterSkillBord:_GetSnakeCoasterPointConfig(sexKey)
  local snakeCoaster = GameConfig.SnakeCoaster
  if snakeCoaster == nil then
    return nil
  end
  if sexKey == "Female" then
    return snakeCoaster.FemalePoints
  end
  return snakeCoaster.MalePoints
end

function CoasterSkillBord:_ResolveSnakeCoasterSkillData(sexKey, pointID)
  if pointID == nil then
    return nil
  end
  local pointConfig = self:_GetSnakeCoasterPointConfig(sexKey)
  return pointConfig and pointConfig[pointID] or nil
end

function CoasterSkillBord:_BuildSnakeCoasterSkillDatas(difficulty)
  local coasterConfig = self:_GetSnakeCoasterConfig(difficulty)
  local sexConfigKey = "Male"
  if MyselfProxy.Instance ~= nil and MyselfProxy.Instance:GetMySex() == 2 then
    sexConfigKey = "Female"
  end
  local sourceSkillDatas = coasterConfig and coasterConfig[sexConfigKey] or {}
  local skillDatas = {}
  for i = 1, #sourceSkillDatas do
    local sourceSkillData = sourceSkillDatas[i]
    local skillData = self:_ResolveSnakeCoasterSkillData(sexConfigKey, sourceSkillData)
    if skillData ~= nil then
      skillDatas[#skillDatas + 1] = {
        actionId = skillData.actionId,
        actionType = skillData.actionType,
        icon = skillData.icon,
        text = skillData.text,
        effectPath = skillData.effectPath
      }
    end
  end
  return skillDatas
end

function CoasterSkillBord:SetInputEnabled(enabled)
  self.inputEnabled = enabled
end

function CoasterSkillBord:OnGameFinish()
  self:SetInputEnabled(false)
end

function CoasterSkillBord:OnGameStart()
  self:SetInputEnabled(true)
end

function CoasterSkillBord:OnClickCoasterSkill(cell)
  if not self.inputEnabled then
    return
  end
  local data = cell.data
  if data == nil then
    return
  end
  local logicActionId = data.actionType
  local skillActionId = data.actionId
  self.lastClickedActionId = logicActionId
  self.lastClickedSkillData = data
  local coasterMove = Game.Myself and Game.Myself.snakeCoasterMove or nil
  if coasterMove ~= nil and coasterMove.SetCurrentActionId ~= nil then
    coasterMove:SetCurrentActionId(logicActionId)
  end
  if coasterMove ~= nil and coasterMove.PlayCoasterAction ~= nil then
    coasterMove:PlayCoasterAction(skillActionId)
  end
end

function CoasterSkillBord:SetSkills(skillDatas)
  if self.coasterSkillShotCutList == nil then
    return
  end
  self.lastClickedActionId = nil
  self.lastClickedSkillData = nil
  self.coasterSkillShotCutList:ResetDatas(skillDatas or {})
  self.coasterSkillShotCutList:Layout()
end

function CoasterSkillBord:SetSnakeCoasterSkills(difficulty)
  self.difficulty = difficulty or SnakeCoasterManager.Me():GetCurrentDifficulty() or 1
  self:SetSkills(self:_BuildSnakeCoasterSkillDatas(self.difficulty))
end

function CoasterSkillBord:OnClickQuitButton()
  if not self.inputEnabled then
    return
  end
  SnakeCoasterManager.Me():ClearCoasterGame()
end

function CoasterSkillBord:Destroy()
  EventManager.Me():RemoveEventListener(SnakeCoasterEvent.InnerGameFinish, self.OnGameFinish, self)
  EventManager.Me():RemoveEventListener(SnakeCoasterEvent.InnerGameStart, self.OnGameStart, self)
  if self.coasterSkillShotCutList then
    self.coasterSkillShotCutList:RemoveAll()
    self.coasterSkillShotCutList = nil
  end
  self.clickCallback = nil
  self.lastClickedActionId = nil
  self.lastClickedSkillData = nil
  self.difficulty = nil
  if not Slua.IsNull(self.gameObject) then
    GameObject.DestroyImmediate(self.gameObject)
  end
  self.gameObject = nil
  self.coasterSkillGrid = nil
end
