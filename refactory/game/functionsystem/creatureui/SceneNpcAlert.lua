SceneNpcAlert = reusableClass("SceneNpcAlert")
local PATH_PFB_LOW = ResourcePathHelper.EffectSkill("eff_qws_chajue_yellow")
local PATH_PFB_HIGH = ResourcePathHelper.EffectSkill("eff_qws_chajue_red")
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
local tempVector2 = LuaVector2.New(0.5, 0)
local Height = LuaVector3.New(0, 20, 0)
local SCALE = LuaVector3.New(200, 200, 1)

function SceneNpcAlert:UpdateLowValue(value)
  if _gameUtilInstance:ObjectIsNULL(self.lowMat) or _gameUtilInstance:ObjectIsNULL(self.lowGameObject) then
    return
  end
  if not self.lowGameObject.activeSelf then
    self.lowGameObject:SetActive(true)
  end
  if self.highGameObject.activeSelf then
    self.highGameObject:SetActive(false)
  end
  tempVector2:Set(0, value)
  if self.lowMat:HasProperty("_MainTex") then
    self.lowMat:SetTextureOffset("_MainTex", tempVector2)
  end
end

function SceneNpcAlert:UpdateHighValue(value)
  if _gameUtilInstance:ObjectIsNULL(self.highMat) or _gameUtilInstance:ObjectIsNULL(self.highGameObject) then
    return
  end
  if not self.highGameObject.activeSelf then
    self.highGameObject:SetActive(true)
  end
  if self.lowGameObject.activeSelf then
    self.lowGameObject:SetActive(false)
  end
  tempVector2:Set(0, value)
  if self.highMat:HasProperty("_MainTex") then
    self.highMat:SetTextureOffset("_MainTex", tempVector2)
  end
  self.sp:SetActive(0.5 <= value)
end

function SceneNpcAlert:DoConstruct(asArray, args)
  local parent = args[1]
  self.SceneTopUI = args[3]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.lowGameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB_LOW, parent.transform)
    self.lowGameObject.transform.localPosition = Height
    self.lowGameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.lowGameObject.transform.localScale = SCALE
    self.highGameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB_HIGH, parent.transform)
    self.highGameObject.transform.localPosition = Height
    self.highGameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.highGameObject.transform.localScale = SCALE
    self.low = func_deepFind(_gameUtilInstance, self.lowGameObject, "jlz_fx_mask_026_mt"):GetComponent(ParticleSystemRenderer)
    self.lowMat = self.low and self.low.material
    self.high = func_deepFind(_gameUtilInstance, self.highGameObject, "jlz_fx_mask_025_mt"):GetComponent(ParticleSystemRenderer)
    self.highMat = self.high and self.high.material
    self.sp = func_deepFind(_gameUtilInstance, self.highGameObject, "jlz_fx_pattern_031_mt")
    if self.sp then
      self.sp:SetActive(false)
    end
    if not self.highMat or not self.lowMat then
      return
    end
    self.lowGameObject:SetActive(true)
    self.highGameObject:SetActive(false)
  end
end

function SceneNpcAlert:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.lowGameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB_LOW, self.lowGameObject)
  end
  if not LuaGameObject.ObjectIsNull(self.highGameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB_HIGH, self.highGameObject)
  end
  self.lowGameObject = nil
  self.highGameObject = nil
end
