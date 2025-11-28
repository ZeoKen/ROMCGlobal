local IsNull = Slua.IsNull
NSceneSpeakCell = reusableClass("NSceneSpeakCell")
NSceneSpeakCell.PoolSize = 10
NSceneSpeakCell.ResID = ResourcePathHelper.UIPrefab_Cell("SceneSpeakCell")
NSceneSpeakCell.ResIDSkill = ResourcePathHelper.UIPrefab_Cell("SceneSkillSpeakCell")

function NSceneSpeakCell:CreateSpeakGO()
  local resID = self.isSkill and NSceneSpeakCell.ResIDSkill or NSceneSpeakCell.ResID
  if self.listCanvasGroup[resID] == nil then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(resID, self.parent)
    local canvasGroup = self.gameObject:GetComponent(CanvasGroup)
    self.listCanvasGroup[resID] = canvasGroup
    self.transform = self.gameObject.transform
    self.transform:SetParent(self.parent.transform, false)
    self.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.transform.localScale = LuaGeometry.Const_V3_one
    local cls = self.isSkill and Text or EmojiText
    self.label = Game.GameObjectUtil:DeepFind(self.gameObject, "Label"):GetComponent(cls)
    if not self.isSkill then
      self.animator = self.gameObject:GetComponent(Animator)
    end
    self.preStr = ""
    self.leftStr = ""
  end
  self:SetOffsetY(0)
  return self.gameObject
end

function NSceneSpeakCell:SetActive(visible)
  if self.visible == visible then
    return
  end
  self.visible = visible and self.speak and true or false
  local resIDVisible = self.isSkill and NSceneSpeakCell.ResIDSkill or NSceneSpeakCell.ResID
  local resIDInVisible = not self.isSkill and NSceneSpeakCell.ResIDSkill or NSceneSpeakCell.ResID
  local canvasGroupVisible = self.listCanvasGroup[resIDVisible]
  if canvasGroupVisible then
    canvasGroupVisible.alpha = visible and self.speak and 1 or 0
  end
  local canvasGroupInVisible = self.listCanvasGroup[resIDInVisible]
  if canvasGroupInVisible then
    canvasGroupVisible.alpha = 0
  end
end

local cellOffset = LuaVector3.New(0, 10, 0)

function NSceneSpeakCell:SetOffsetY(offsetY)
  if offsetY ~= 0 then
    cellOffset[2] = 10 + offsetY
  end
  self.transform.localPosition = cellOffset
end

local EventDelegate_Set = EventDelegate.Set

function NSceneSpeakCell:SetDelayDestroy(destroyDelay)
  if Slua.IsNull(self.gameObject) then
    return
  end
  if not self.isSkill and self.animator then
    self.animator:Play("SceneSpeakCell_Anim", -1, 1)
  end
  if self.lt ~= nil then
    self.lt:Destroy()
    self.lt = nil
  end
  destroyDelay = destroyDelay or 3000
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(destroyDelay, NSceneSpeakCell._DelayDestroy, self)
end

function NSceneSpeakCell:_DelayDestroy(deltaTime)
  if self.leftStr ~= "" then
    self:SetData(self.leftStr)
  elseif not IsNull(self.gameObject) then
    self.speak = false
    if not self.isSkill and self.animator then
      self.animator:Play("Stop", 0, 0)
    end
    self:SetActive(false)
  end
  self.lt = nil
end

function NSceneSpeakCell:_Cancel_DelayDestroy()
  if self.lt ~= nil then
    self.lt:Destroy()
    self.lt = nil
  end
  if self.gameObject then
    local animator = self.gameObject:GetComponent(Animator)
    if animator then
      animator.enabled = false
    end
    local image = self.gameObject:GetComponentInChildren(Image)
    if image then
      image.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    end
    local text = self.gameObject:GetComponentInChildren(EmojiText)
    if text then
      text.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    end
  end
end

function NSceneSpeakCell:SetData(text, destroyDelay)
  if not self.creature then
    return
  end
  if self.creature.forceMaskUI then
    return
  end
  self:CreateSpeakGO()
  if self.gameObject == nil then
    return
  end
  if text and self.label then
    if self.preStr ~= text then
      self.preStr = text
      self.leftStr = UGUIUtil.Ins:WrapText(self.label, OverSea.LangManager.Instance():GetLangByKey(text), 230, 72, true)
    end
    self.speak = true
    self:UpdateGameObjectActive()
    self:SetDelayDestroy(destroyDelay)
  end
end

function NSceneSpeakCell:Active(visible)
  self.objActive = visible
  self:UpdateGameObjectActive()
end

function NSceneSpeakCell:UpdateGameObjectActive()
  self:SetActive(self.objActive)
end

function NSceneSpeakCell:DoConstruct(asArray, args)
  self.speak = true
  self.objActive = true
  self.visible = false
  self.listCanvasGroup = {}
  self.parent = args[1]
  self.creature = args[2]
  self.isSkill = args[3]
  self.isStatic = args[4]
end

function NSceneSpeakCell:DoDeconstruct(asArray)
  if self.lt ~= nil then
    self.lt:Destroy()
    self.lt = nil
  end
  for resID, canvasGroup in pairs(self.listCanvasGroup) do
    local gameObject = canvasGroup.gameObject
    if not IsNull(gameObject) then
      Game.GOLuaPoolManager:AddToSceneUIPool(resID, gameObject)
    end
    self.listCanvasGroup[resID] = nil
  end
  self.listCanvasGroup = {}
  self.gameObject = nil
  self.transform = nil
  self.label = nil
  self.parent = nil
  self.animator = nil
  self.creature = nil
  self.isSkill = false
  self.isStatic = false
end
