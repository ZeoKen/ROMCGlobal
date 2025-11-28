SceneSpeakCell = reusableClass("SceneSpeakCell")
SceneSpeakCell.PoolSize = 10
SceneSpeakCell.ResID = ResourcePathHelper.UICell("SceneSpeakCell")

function SceneSpeakCell:CreateSpeakGO()
  if LuaGameObject.ObjectIsNull(self.parent) then
    return
  end
  if self.gameObject == nil or LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneSpeakCell.ResID, self.parent)
    self.gameObject.transform:SetParent(self.parent.transform, false)
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self:SetOffsetY(0)
    self.widget = self.gameObject:GetComponent(UIWidget)
    self.label = Game.GameObjectUtil:DeepFind(self.gameObject, "Label"):GetComponent(UILabel)
    self.bg = Game.GameObjectUtil:DeepFind(self.gameObject, "Background"):GetComponent(UISprite)
    
    function self.label.onChange()
      self.bg:UpdateAnchors()
    end
    
    local l_objHiddenLabel = Game.GameObjectUtil:DeepFind(self.gameObject, "HiddenLabel")
    self.hiddenLabel = l_objHiddenLabel and l_objHiddenLabel:GetComponent(UILabel)
  end
  return self.gameObject
end

local cellOffset = LuaVector3()

function SceneSpeakCell:SetOffsetY(offsetY)
  cellOffset[2] = 10 + offsetY
  self.gameObject.transform.localPosition = cellOffset
end

function SceneSpeakCell:SetDelayDestroy(fadeInTime, stayTime, fadeOutTime)
  if self.gameObject then
    self.widget.alpha = 0
    self.fadeInTime = fadeInTime or 0
    self.stayTime = stayTime or 3
    self.fadeOutTime = fadeOutTime or 0
    self:_FadeIn()
  end
end

function SceneSpeakCell:CancelTween()
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
end

function SceneSpeakCell:_FadeIn()
  self:CancelTween()
  if not Slua.IsNull(self.gameObject) then
    self.lt = LeanTween.alphaNGUI(self.widget, 0, 1, self.fadeInTime):setOnComplete(function()
      self:CancelTween()
      if not Slua.IsNull(self.gameObject) then
        self.lt = LeanTween.alphaNGUI(self.widget, 1, 0, self.fadeOutTime):setOnComplete(function()
          self:CancelTween()
          local leftlen = StringUtil.getTextLen(self.leftStr)
          if type(self.leftStr) == "string" and 0 < leftlen then
            self:SetData(self.leftStr)
          elseif not Slua.IsNull(self.gameObject) then
            Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
            self.gameObject = nil
            self.label = nil
            self.bg = nil
            self.widget = nil
          end
        end)
      end
    end)
  end
end

function SceneSpeakCell:_FadeOut()
end

function SceneSpeakCell:_FadeEnd()
end

function SceneSpeakCell:SetData(text)
  self:CreateSpeakGO()
  if self.gameObject == nil then
    return
  end
  if text and self.label then
    if text == "" then
      return
    end
    local newText = text
    text = OverSea.LangManager.Instance():GetLangByKey(text)
    if self.hiddenLabel ~= nil then
      self.hiddenLabel.text = text
      local lines = StringUtil.Split(self.hiddenLabel.processedText, "\n")
      if lines ~= nil and #lines == 4 then
        i, j = string.find(text, lines[3], 1, true)
        if j ~= nil and text:sub(j + 1, j + 1) == " " then
          j = j + 1
        end
        if j then
          newText = string.sub(text, 1, j)
        end
      end
    end
    self:UpdateGameObjectActive()
    self.label.text = newText
    UIUtil.FitLabelHeight(self.label, 232)
    if not self.label.bitmapFont and (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) then
      OverSea.LangManager.Instance():ResetGameFont()
    end
    local len = StringUtil.getTextLen(self.label.processedText)
    local textlen = StringUtil.getTextLen(text)
    if len < textlen then
      self.leftStr = StringUtil.getTextByIndex(text, len + 1, textlen)
    else
      self.leftStr = ""
    end
    self:SetDelayDestroy(0.3, 2, 0.5)
  end
end

function SceneSpeakCell:Active(b)
  self.objActive = b
  self:UpdateGameObjectActive()
end

function SceneSpeakCell:UpdateGameObjectActive()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject:SetActive(self.objActive)
  end
end

function SceneSpeakCell:DoConstruct(asArray, parent)
  self.leftStr = ""
  self.objActive = true
  self.parent = parent
end

function SceneSpeakCell:DoDeconstruct(asArray)
  self:CancelTween()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.label = nil
  self.widget = nil
  self.bg = nil
  self.parent = nil
end
