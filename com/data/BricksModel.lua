BricksModel = class("BricksModel")
local _tempVec3 = LuaVector3()

function BricksModel:ctor(cfg, sort)
  self:InitStatic(cfg)
  self.sortID = sort
  self.done = false
  self.system = FunctionShadowBricks.Me():GetSystem()
  if self.system then
    self:_creatOutline()
  end
end

function BricksModel:InitStatic(cfg)
  self.id = cfg.ID
  self.ID = tonumber(cfg.ID)
  self.targetRow = cfg.CellIndex[1]
  self.targetColumn = cfg.CellIndex[2]
  self.targetSlotIndex = FunctionShadowBricks.RowColumn2Pos(self.targetRow, self.targetColumn)
  self.shadowOffset = LuaVector2()
  LuaVector2.Better_Set(self.shadowOffset, cfg.ShadowOffset[1], cfg.ShadowOffset[2])
  self.targetRotation = LuaVector3()
  LuaVector3.Better_Set(self.targetRotation, cfg.TargetRotation[1], cfg.TargetRotation[2], cfg.TargetRotation[3])
  self.centerOffset = LuaVector3()
  LuaVector3.Better_Set(self.centerOffset, cfg.CenterOffset[1], cfg.CenterOffset[2], cfg.CenterOffset[3])
  self.defaultScale = LuaVector3()
  LuaVector3.Better_Set(self.defaultScale, cfg.DefaultScale[1], cfg.DefaultScale[2], cfg.DefaultScale[3])
  self.defaultRotation = LuaVector3()
  LuaVector3.Better_Set(self.defaultRotation, cfg.DefaultRotation[1], cfg.DefaultRotation[2], cfg.DefaultRotation[3])
  self.icon = Table_Brick[self.ID] and Table_Brick[self.ID].Icon or ""
  if nil ~= cfg.OverrideCompleteEpsilon then
    self.overrideCompleteEpsilon = cfg.OverrideCompleteEpsilon
  else
    self.overrideCompleteEpsilon = false
  end
  local globalDisplayEpsilon = FunctionShadowBricks:Me():GetGlobalDisplayEpsilon()
  local globalCompleteEpsilon = FunctionShadowBricks:Me():GetGlobalCompleteEpsilon()
  self.completeEpsilon = cfg.CompleteEpsilon or 0
  self.realCompleteEpsilon = self.overrideCompleteEpsilon and self.completeEpsilon or globalCompleteEpsilon
  self.realDisplayEpsilon = self.overrideCompleteEpsilon and cfg.DisplayProgressEpsilon or globalDisplayEpsilon
end

function BricksModel:CreatShadow(row, column)
  if not self.system then
    return
  end
  self:_creatShadow(row, column)
end

function BricksModel:_removeShadowOnSuccess()
  if not self.puzzleShadow then
    return
  end
  self.system:RemoveTarget(self.puzzleShadow)
  GameObject.Destroy(self.puzzleShadow.gameObject)
  self.puzzleShadow = nil
end

function BricksModel:_removeOutlineOnSuccess()
  if not self.puzzleOutline then
    return
  end
  self.system:RemoveTarget(self.puzzleOutline)
  GameObject.Destroy(self.puzzleOutline.gameObject)
  self.puzzleOutline = nil
end

function BricksModel:_creatOutline()
  local resID = ResourcePathHelper.BrickOutline(self.id)
  local asset = Game.AssetManager:Load(resID)
  local outlineObj = GameObject.Instantiate(asset)
  Game.AssetManager:UnloadAsset(resID)
  if not outlineObj then
    return
  end
  self.puzzleOutline = outlineObj:GetComponent(ShadowPuzzleOutline)
  if not self.puzzleOutline then
    redlog("-------光影系统 预设未绑定脚本ShadowPuzzleOutline")
    return
  end
  self:Active(self.puzzleOutline, true)
  self.system:AddTarget(self.puzzleOutline, self.defaultScale, self.defaultRotation, self.centerOffset, self.targetRotation, self.shadowOffset, self.targetRow, self.targetColumn, self.overrideCompleteEpsilon, self.completeEpsilon)
end

function BricksModel:_creatShadow(row, column)
  local resID = ResourcePathHelper.BrickShadow(self.id)
  local asset = Game.AssetManager:Load(resID)
  self.shadowObj = GameObject.Instantiate(asset)
  Game.AssetManager:UnloadAsset(resID)
  if not self.shadowObj then
    return
  end
  self.puzzleShadow = self.shadowObj:GetComponent(ShadowPuzzleShadow)
  if not self.puzzleShadow then
    redlog("-------光影系统 预设未绑定脚本ShadowPuzzleShadow")
    return
  end
  self.system:AddTarget(self.puzzleShadow, self.defaultScale, self.defaultRotation, self.centerOffset, LuaVector3.Zero(), self.shadowOffset, row, column)
end

function BricksModel:OnSuccess()
  self.done = true
end

local _fadeOutDuration = 1

function BricksModel:FadeOut()
  if self.puzzleShadow then
    self.puzzleShadow:FadeOut(_fadeOutDuration)
  end
  if self.puzzleOutline and not GameConfig.Bricks.debug then
    self.puzzleOutline:FadeOut(_fadeOutDuration)
  end
end

function BricksModel:OnClear()
  if self.puzzleOutline then
    GameObject.Destroy(self.puzzleOutline.gameObject)
    self.puzzleOutline = nil
  end
  if self.puzzleShadow then
    GameObject.Destroy(self.puzzleShadow.gameObject)
    self.puzzleShadow = nil
    self.shadowObj = nil
  end
  self.done = false
end

function BricksModel:OnShow(row, column, isAuto)
  if not self:IsPuzzleShadowInitialized() then
    self:CreatShadow(row, column)
  else
    self:Active(self.puzzleShadow, true)
    if not self.done then
      self.puzzleShadow:SetLocalRotation(LuaVector3.Zero())
      self.system:SetTargetCell(self.puzzleShadow, row, column)
    end
  end
  if isAuto then
    FunctionShadowBricks.Me():TryPlayAppearanceAni(self.puzzleShadow, true)
  end
end

function BricksModel:Restore()
  if not self.puzzleOutline then
    self:_creatOutline()
  else
    self:Active(self.puzzleOutline, true)
  end
  if self.done then
    self:Active(self.puzzleShadow, true)
  end
end

function BricksModel:OnHide()
  if self:IsPuzzleShadowInitialized() and not self.done then
    self:Active(self.puzzleShadow, false)
  end
end

function BricksModel:OnExit()
  self:Active(self.puzzleShadow, false)
  self:Active(self.puzzleOutline, false)
end

function BricksModel:Active(component, var)
  if component and component.gameObject.activeSelf ~= var then
    component.gameObject:SetActive(var)
  end
end

function BricksModel:IsPuzzleShadowInitialized()
  return nil ~= self.puzzleShadow
end

function BricksModel:GetOutline()
  return self.puzzleOutline
end

function BricksModel:GetShadow()
  return self.puzzleShadow
end
