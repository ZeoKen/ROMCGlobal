SceneUIType = {
  PhotoFocus = {
    depth = 1,
    name = "ScenePanel_PhotoFocus",
    isUgui = true
  },
  RoleTopFloatMsg = {
    depth = 2,
    name = "ScenePanel_RoleTopFloatMsg",
    isUgui = true
  },
  RoleTopInfo = {
    depth = 3,
    name = "ScenePanel_RoleTopInfo",
    isUgui = true
  },
  RoleTopBoothInfo = {
    depth = 4,
    name = "ScenePanel_RoleTopBoothInfo",
    isUgui = true
  },
  RoleTopEffect = {
    depth = 5,
    name = "ScenePanel_RoleTopEffect",
    isUgui = true
  },
  PlayerBottomInfo = {
    depth = 6,
    name = "ScenePanel_Player_BottomInfo",
    isUgui = true
  },
  StaticPlayerBottomInfo = {
    depth = 7,
    name = "ScenePanel_Static_Player_BottomInfo",
    isUgui = true
  },
  MonsterBottomInfo = {
    depth = 8,
    name = "ScenePanel_Monster_BottomInfo",
    isUgui = true
  },
  NpcBottomInfo = {
    depth = 9,
    name = "ScenePanel_Npc_BottomInfo",
    isUgui = true
  },
  DropItemName = {
    depth = 10,
    name = "ScenePanel_DropItemName",
    isUgui = true
  },
  SpeakWord = {
    depth = 11,
    name = "ScenePanel_SpeakWord",
    isUgui = true
  },
  Emoji = {
    depth = 12,
    name = "ScenePanel_Emoji",
    isUgui = true
  },
  DamageNum = {
    depth = 13,
    name = "ScenePanel_DamageNum",
    isUgui = true
  },
  RoleTopAttachedInfo = {
    depth = 14,
    name = "ScenePanel_RoleTopAttachedInfo",
    isUgui = true
  },
  EBFCoin = {
    depth = 15,
    name = "ScenePanel_EBFCoin",
    isUgui = true
  }
}
autoImport("StaticHurtNum")
autoImport("DynamicHurtNum")
autoImport("FMEmission")
autoImport("SceneTopFocusUI")
autoImport("PlayerSingView")
SceneUIManager = class("SceneUIManager")
SceneUIManager.UseUGUI = true
SceneUIManager.Instance = nil

function SceneUIManager:ctor()
  SceneUIManager.Instance = self
  self.sceneUIParentMap = {}
end

function SceneUIManager:ResetSceneUICanvas()
  if not Slua.IsNull(self.canvasRoot) then
    GameObject.Destroy(self.canvasRoot)
  end
  self.canvasRoot = nil
  self.canvasGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Root("SceneUICanvas"))
  GameObject.DontDestroyOnLoad(self.canvasGO)
  self.canvasRoot = UIUtil.FindComponent("Canvas", Canvas, self.canvasGO)
end

function SceneUIManager:ResetCanvasCamera()
  self.canvasRoot.worldCamera = Camera.main
end

function SceneUIManager:SetCanvasScale(scale)
  self.canvasRoot.transform.localScale = LuaGeometry.Const_V3_one * scale
end

function SceneUIManager:ResetCanvasScale()
  self.canvasRoot.transform.localScale = LuaGeometry.Const_V3_one
end

function SceneUIManager:Destroy()
  if not Slua.IsNull(self.canvasGO) then
    GameObject.DestroyImmediate(self.canvasGO)
  end
end

local tempV3, tempRot = LuaVector3(), LuaQuaternion()

function SceneUIManager:GetSceneUIContainer(sceneUIType)
  if sceneUIType.isUgui then
    return self:_GetSceneUGUIContainer(sceneUIType)
  else
    return self:_GetSceneUIContainer(sceneUIType)
  end
end

function SceneUIManager:_GetSceneUGUIContainer(sceneUIType)
  if Slua.IsNull(self.canvasRoot) then
    self:ResetSceneUICanvas()
  end
  if self.sceneUILayerMap == nil then
    self.sceneUILayerMap = {}
  end
  local depth = sceneUIType.depth
  local panelGO = self.sceneUILayerMap[depth]
  if not Slua.IsNull(panelGO) then
    return panelGO
  end
  local rootTransform = self.canvasRoot.transform
  panelGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Root("SceneUILayer"))
  panelGO.name = sceneUIType.name
  panelGO.transform:SetParent(rootTransform)
  panelGO.layer = self.canvasRoot.gameObject.layer
  local canvas = panelGO:GetComponent(Canvas)
  canvas.overrideSorting = true
  canvas.sortingOrder = 2000 + sceneUIType.depth
  LuaVector3.Better_Set(tempV3, 0, 0, 0)
  panelGO.transform.localPosition = tempV3
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  panelGO.transform.localRotation = tempRot
  LuaVector3.Better_Set(tempV3, 1, 1, 1)
  panelGO.transform.localScale = tempV3
  for i = 1, rootTransform.childCount do
    local go = rootTransform:GetChild(i - 1)
    if sceneUIType.name < go.name then
      panelGO.transform:SetSiblingIndex(i - 1)
      break
    end
  end
  self.sceneUILayerMap[depth] = panelGO
  return panelGO
end

function SceneUIManager:_GetSceneUIContainer(sceneUIType)
  if LuaGameObject.ObjectIsNull(self.suiContainer) then
    self.suiContainer = GameObject.Find("SceneUIContainer")
    if not BackwardCompatibilityUtil.CompatibilityMode_V35 then
      self.suiContainer.transform:SetParent(nil)
    end
  end
  if LuaGameObject.ObjectIsNull(self.suiContainer) then
    return
  end
  local depth = sceneUIType.depth
  local panelGO = self.sceneUIParentMap[depth]
  if LuaGameObject.ObjectIsNull(panelGO) then
    panelGO = GameObject(sceneUIType.name)
    panelGO.transform:SetParent(self.suiContainer.transform)
    panelGO.layer = self.suiContainer.layer
    LuaVector3.Better_Set(tempV3, 0, 0, 0)
    panelGO.transform.localPosition = tempV3
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
    panelGO.transform.localRotation = tempRot
    LuaVector3.Better_Set(tempV3, 1, 1, 1)
    panelGO.transform.localScale = tempV3
    local panel = panelGO:AddComponent(UIPanel)
    panel.depth = depth
    container = panelGO
    self.sceneUIParentMap[depth] = panelGO
  end
  return panelGO
end

function SceneUIManager:GetStaticHurtLabelWorker()
  return FunctionDamageNum.Me():GetStaticHurtLabelWorker()
end

function SceneUIManager:ShowDynamicHurtNum(pos, text, type, hurtNumColorType, crit, isFromMe, isToMe)
  FunctionDamageNum.Me():ShowDynamicHurtNum(pos, text, type, hurtNumColorType, crit, isFromMe, isToMe)
end

function SceneUIManager:RolePlayEmojiById(roleid, emojiId)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:PlayEmojiById(emojiId)
    end
  end
end

function SceneUIManager:RolePlayEmoji(roleid, name)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:PlayEmoji(name)
    end
  end
end

function SceneUIManager:PlayerSpeak(roleid, msg)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:Speak(msg)
    end
  end
end

function SceneUIManager:FloatRoleTopMsgById(roleid, msgid, param)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:FloatRoleTopMsgById(msgid, param)
    end
  end
end

function SceneUIManager:FloatRoleTopMsg(roleid, msg, param)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:FloatTopMsg(msg, param)
    end
  end
end

function SceneUIManager:AddRoleTopFuncWords(role, icon, text, clickFunc, clickArgs)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:SetTopFuncFrame(text, icon, clickFunc, clickArgs, role)
    end
  end
end

function SceneUIManager:RemoveRoleTopFuncWords(role)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:RemoveTopFuncFrame()
    end
  end
end

function SceneUIManager:AddRoleTopFuncWords_TrainEscort(role, icons, texts, clickFunc, clickArgs)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:SetTopFuncFrame_TrainEscort(texts, icons, clickFunc, clickArgs, role)
    end
  end
end

function SceneUIManager:RemoveRoleTopFuncWords_TrainEscort(role)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:RemoveTopFuncFrame_TrainEscort()
    end
  end
end

function SceneUIManager:PlayUIEffectOnRoleTop(effectid, roleid, once, offset, callback, callArgs)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      local effect = sceneUI.roleTopUI:PlaySceneUIEffect(effectid, once, callback, callArgs)
      if effect and offset then
        effect:ResetLocalPosition(offset)
      end
      return effect
    end
  end
end

function SceneUIManager:ActiveBackUIMask(b)
  if Slua.IsNull(self.back_mask) then
    local uiRoot = UIManagerProxy.Instance.UIRoot
    if uiRoot == nil then
      return
    end
    self.back_mask = UIUtil.FindGO("Mask", uiRoot)
  end
  self.back_mask:SetActive(b)
end

function SceneUIManager:FloatGoldMsg(roleid, gold)
  local role = SceneCreatureProxy.FindCreature(roleid)
  if role then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:FloatGoldMsg(string.format(ZhString.TwelvePVPShop_GoldMsg, gold))
    end
  end
end
