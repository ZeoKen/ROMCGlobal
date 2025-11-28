SceneCursorInfo = reusableClass("SceneCursorInfo")
SceneCursorInfo.PoolSize = 2
local PATH_PFB = ResourcePathHelper.EffectCommon("cfx_cw_nl_prf")
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
local effectPath = ResourcePathHelper.EffectCommon("cfx_cw_nl_prf")
local failEffectPath = "Common/cfx_cw_nl_hit_prf"
local tempVector2 = LuaVector2.New(0.5, 0)
local tempValue = 0
local IndicatorMax = 0.5
local IndicatorMin = -1.5
local baseOrder = 3600
local Height = LuaVector3.New(0, 60, 0)
local CursorSkillID = GameConfig.CursorSkillID or 23204001

function SceneCursorInfo:UpdateValue(value)
  if _gameUtilInstance:ObjectIsNULL(self.sliderMat) then
    return
  end
  tempValue = value / self.MaxValue
  self.totalValue = tempValue
  self.rightValue = 0.5 + tempValue
  self.leftValue = -tempValue / 2
  tempVector2:Set(self.leftValue, 0)
  if self.sliderMat:HasProperty("_MainTex") then
    self.sliderMat:SetTextureOffset("_MainTex", tempVector2)
  end
  if value >= self.MaxValue then
    self:ShowResult(false)
  elseif value <= -self.MaxValue then
    self:ShowResult(true)
  end
end

function SceneCursorInfo:DoConstruct(asArray, args)
  local parent = args[1]
  local staticData = Table_Skill[CursorSkillID]
  if not staticData then
    return
  end
  self.duration = (staticData.Lead_Type.ReadyTime or 3) * 1000
  self.MaxValue = staticData.Logic_Param and staticData.Logic_Param.cursor_max_value or 30
  self.SceneTopUI = args[3]
  self.endtime = self.duration + ServerTime.CurServerTime()
  self.rightValue = 0
  self.leftValue = 0
  self.totalValue = 0
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB, parent.transform)
    self.gameObject.transform.localPosition = Height
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self.uibg = func_deepFind(_gameUtilInstance, self.gameObject, "ui_cw_nl01"):GetComponent(ParticleSystemRenderer)
    self.uibgMat = self.uibg and self.uibg.material
    if not self.uibgMat then
      return
    end
    self.slider = func_deepFind(_gameUtilInstance, self.gameObject, "wenli_cw_nl03"):GetComponent(ParticleSystemRenderer)
    self.sliderMat = self.slider and self.slider.material
    if not self.sliderMat then
      return
    end
    self.uibg.sortingOrder = baseOrder + self.uibg.sortingOrder
    self.slider.sortingOrder = baseOrder + self.slider.sortingOrder
    self.bg1 = func_deepFind(_gameUtilInstance, self.gameObject, "wenli_cw_nl02"):GetComponent(ParticleSystemRenderer)
    self.bg2 = func_deepFind(_gameUtilInstance, self.gameObject, "wenli_cw_nl01"):GetComponent(ParticleSystemRenderer)
    if self.bg1 and self.bg2 then
      self.bg1.sortingOrder = baseOrder + self.bg1.sortingOrder
      self.bg2.sortingOrder = baseOrder + self.bg2.sortingOrder
    end
    tempVector2:Set(0.5, 0)
    if self.sliderMat:HasProperty("_MainTex") then
      self.sliderMat:SetTextureOffset("_MainTex", tempVector2)
    end
    if not self.timetick then
      self.timetick = TimeTickManager.Me():CreateTick(0, 500, self.CheckWinning, self)
    end
  end
end

local lefttime = 0

function SceneCursorInfo:CheckWinning()
  lefttime = self.endtime - ServerTime.CurServerTime()
  if lefttime <= 0 then
    self:ShowResult(0 >= self.totalValue)
  end
end

function SceneCursorInfo:ShowResult(b)
  if self.timetick then
    TimeTickManager.Me():ClearTick(self)
    self.timetick = nil
  end
  if self.SceneTopUI then
    self.SceneTopUI:RemoveCursorInfo()
    if b then
      local fEffect = self.SceneTopUI:PlaySceneEffect(failEffectPath, true)
      if fEffect then
        fEffect:ResetLocalPosition(Height)
      end
    end
  end
end

function SceneCursorInfo:DoDeconstruct(asArray)
  self.uibg.sortingOrder = self.uibg.sortingOrder - baseOrder
  self.slider.sortingOrder = self.slider.sortingOrder - baseOrder
  self.bg1.sortingOrder = self.bg1.sortingOrder - baseOrder
  self.bg2.sortingOrder = self.bg2.sortingOrder - baseOrder
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  if self.timetick then
    TimeTickManager.Me():ClearTick(self)
    self.timetick = nil
  end
end
