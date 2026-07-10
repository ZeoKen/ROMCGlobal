local BaseCell = autoImport("BaseCell")
UIEmojiCell = class("UIEmojiCell", BaseCell)
UIEmojiType = {
  Action = ChatRoomProxy.ExpressionType.Action,
  Emoji = ChatRoomProxy.ExpressionType.Emoji,
  RoleExpression = ChatRoomProxy.ExpressionType.RoleExpression
}
UIEmojiEditMode = {
  None = 1,
  Delete = 2,
  Toggle = 3
}
UIEmojiCell.ProfessionReplaceActionConfig = {
  [11] = GameConfig.MarksmanAction
}

function UIEmojiCell:Init()
  self.content = self:FindGO("Content")
  self.actionObj = self:FindGO("Action")
  self.actionSymbol = self:FindComponent("Symbol", UISprite)
  self.actionBg = self:FindComponent("Bg", UISprite, self.actionObj)
  self.deleteBtn = self:FindGO("Delete")
  self.toggle = self:FindComponent("Toggle", UIToggle)
  self.toggleMark = self.toggle.activeSprite
  self.toggleBg = self:FindGO("ToggleBg")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.mask = self:FindGO("Mask")
  self.cdMask = self:FindGO("CdMask")
  self:AddClickEvents()
  self:SetEditMode(UIEmojiEditMode.None)
  self:InitDrag()
end

function UIEmojiCell:AddClickEvents()
  self:AddCellClickEvent()
  self:SetEvent(self.toggleBg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:SetEvent(self.deleteBtn, function()
    self:PassEvent(EmojiEvent.DeleteEmoji, self)
  end)
end

function UIEmojiCell:InitDrag()
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.data = self
  self.dragDrop.dragDropComponent.OnCursor = DragCursorPanel.ShowEmojiCell
  
  function self.dragDrop.dragDropComponent.OnReplace(data)
    if not data then
      return
    end
    if data.id == self.id and data.type == self.type then
      return
    end
    if not self.editMode == UIEmojiEditMode.Delete then
      return
    end
    self:PassEvent(EmojiEvent.SwapEmoji, {data, self})
  end
  
  self:SetDragEnable(false)
end

local forbiddenAction = {playshow2 = 1, playshow3 = 1}

function UIEmojiCell:SetData(data)
  self.content:SetActive(data ~= nil)
  if not data then
    return
  end
  self.id = data.id
  self.type = data.type
  self.name = data.name
  self.pos = data.pos
  self:UnloadEmoji()
  if data.type == UIEmojiType.Action or data.type == UIEmojiType.RoleExpression then
    self.actionObj:SetActive(true)
    self:SetAction(data.name)
    local isPvP, isGvG = Game.MapManager:IsPVPMode(), Game.MapManager:IsInGVG()
    if (isPvP or isGvG) and forbiddenAction[data.name] then
      self.forbiddenByScene = true
    else
      self.forbiddenByScene = false
    end
    self.actionSymbol.color = self.forbiddenByScene and ColorUtil.NGUIGray or ColorUtil.NGUIWhite
    self:UpdateCDTime()
    if data.type == UIEmojiType.Action and data.id == 3 then
      Game.HotKeyTipManager:RegisterHotKeyTip(7, self.actionBg, NGUIUtil.AnchorSide.TopLeft, {11, -8})
    else
      Game.HotKeyTipManager:RemoveHotKeyTip(7, self.actionBg)
    end
  elseif data.type == UIEmojiType.Emoji then
    self.actionObj:SetActive(false)
    self:LoadEmoji(data.name)
  end
  self:TryUpdateToggle()
end

function UIEmojiCell:LoadEmoji(name)
  local resID = ResourcePathHelper.Emoji(name)
  if resID == self.resID and not Slua.IsNull(self.emoji) then
    return
  end
  self.resID = resID
  self.emoji = Game.AssetManager_UI:CreateSceneUIAsset(resID, self.content)
  if self.emoji == nil then
    redlog("ERROR!!!!!!! NOT FIND EMOJI:", name)
    return
  end
  self.emoji.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  UIUtil.ChangeLayer(self.emoji, self.gameObject.layer)
  self.emoji.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.emoji.transform.localRotation = LuaGeometry.GetTempQuaternion(0, 0, 0, 1)
  self.emoji.gameObject:SetActive(true)
  self.emoji.name = name
  local successCall = pcall(function()
    local anim = self.emoji:GetComponent(SkeletonAnimation)
    anim.AnimationName = "ui_animation"
    anim:Reset()
    anim.loop = true
    SpineLuaHelper.PlayAnim(anim, "ui_animation", nil)
  end)
  if not successCall then
    redlog(string.format("Emoji:%s Not Find ui_animation", name))
  end
  local uispine = self.emoji:GetComponent(UISpine)
  uispine.depth = 10
end

function UIEmojiCell:UnloadEmoji()
  if self.resID and not Slua.IsNull(self.emoji) then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resID, self.emoji)
  end
  self.resID = nil
  self.emoji = nil
end

local defaultActionBg = "com_btn_7"
local definedActionBg = {
  playshow2 = "com_btn_icon3",
  playshow3 = "com_btn_icon4"
}

function UIEmojiCell:SetAction(name)
  if self.actionSymbol and IconManager:SetActionIcon(name, self.actionSymbol) then
    self.actionSymbol:MakePixelPerfect()
  end
  local needDebug = definedActionBg[name] ~= nil
  if self.actionBg then
    self.actCfg = Game.Config_Action[name]
    local _atlasName = "NewCom"
    if self.actCfg then
      local _spriteName
      local _definedSpName = definedActionBg[name]
      if self.actCfg.DoubleAction then
        _spriteName = "com_btn_21"
      elseif self.actCfg.SkillAction then
        _spriteName = "com_btn_22"
      end
    end
    if needDebug then
      self.actionBg.atlas = RO.AtlasMap.GetAtlas("UI_Reflux")
      self.actionBg.spriteName = definedActionBg[name]
    else
      self.actionBg.atlas = RO.AtlasMap.GetAtlas("NewCom")
      self.actionBg.spriteName = _spriteName or defaultActionBg
    end
  end
end

function UIEmojiCell:UpdateCDTime()
  if not self.id or not MyselfProxy.Instance:IsActionInCD(self.id) then
    self:Hide(self.cdMask)
    return
  end
  self:Show(self.cdMask)
  local interval = Table_ActionAnime[self.id].IntervalTime
  local starttime = MyselfProxy.Instance:GetRecentAction(self.id)
  local endtime = starttime + interval
  if starttime and endtime then
    local totalDeltaTime = endtime - starttime
    if totalDeltaTime <= 0 then
      return
    end
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 33, function(self, deltatime)
      local nowDelteTime = math.max(ServerTime.CurServerTime() - starttime, 0)
      local fillAmount = nowDelteTime / totalDeltaTime
      if fillAmount < 1 then
        self.cdMask.fillAmount = fillAmount
      else
        TimeTickManager.Me():ClearTick(self, 1)
      end
    end, self, 1)
  end
end

function UIEmojiCell:TryUpdateToggle()
  if self.togglePredicate then
    self:SetToggleValue(self.togglePredicate())
  end
end

function UIEmojiCell:OnCellDestroy()
  self:UnloadEmoji()
  Game.HotKeyTipManager:RemoveHotKeyTip(7, self.actionBg)
  TimeTickManager.Me():ClearTick(self, 1)
end

local tempColor = LuaColor(1, 1, 1, 1)

function UIEmojiCell:Forbid(state)
  self.forbidState = state
  if self.editMode ~= UIEmojiEditMode.None or state == 0 then
    LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
    self:SetTextureColor(self.actionObj, tempColor, true)
  elseif state == 1 then
    if self.type == UIEmojiType.Action then
      LuaColor.Better_Set(tempColor, 0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
      self:SetTextureColor(self.actionObj, tempColor, true)
    end
  elseif state ~= 2 or self.type == UIEmojiType.Emoji then
  end
end

function UIEmojiCell:SetEditMode(mode)
  self.editMode = mode
  self:UpdateEditMode()
end

function UIEmojiCell:UpdateEditMode()
  self.deleteBtn:SetActive(self.editMode == UIEmojiEditMode.Delete)
  local toggleActive = self.editMode == UIEmojiEditMode.Toggle
  if not toggleActive and self.toggleMark then
    local tweener = self.toggleMark:GetComponent(TweenAlpha)
    if tweener and tweener.enabled then
      tweener:Sample(1, true)
      tweener.enabled = false
    end
  end
  self.toggle.gameObject:SetActive(toggleActive)
  self:Forbid(self.forbidState)
  self:TryUpdateToggle()
end

function UIEmojiCell:SetToggleValue(value, force)
  if not force and self.editMode ~= UIEmojiEditMode.Toggle then
    return
  end
  value = value and true or false
  self.toggle.value = value
  self:SetShowMask(value)
end

function UIEmojiCell:SetTogglePredicate(predicate)
  if type(predicate) ~= "function" then
    LogUtility.Error("You're trying to set togglePredicate with a non-function!")
    return
  end
  self.togglePredicate = predicate
end

function UIEmojiCell:SetDragEnable(value)
  self.dragDrop:SetDragEnable(value)
end

function UIEmojiCell:SetShowMask(isShow)
  isShow = isShow and true or false
  self.mask:SetActive(isShow)
end

function UIEmojiCell:TryDestroyCollider()
  if not self.boxCollider then
    return
  end
  Component.Destroy(self.boxCollider)
  self.boxCollider = nil
end

local nameAnimeDataMap

function UIEmojiCell.TryReplaceMyProfessionAction(id)
  local sdata = Table_ActionAnime[id]
  if not sdata then
    return
  end
  local replaceCfg = UIEmojiCell.ProfessionReplaceActionConfig[MyselfProxy.Instance:GetMyProfessionType()]
  if replaceCfg and replaceCfg[sdata.Name] then
    if not nameAnimeDataMap then
      nameAnimeDataMap = {}
      for _, d in pairs(Table_ActionAnime) do
        nameAnimeDataMap[d.Name] = d
      end
    end
    sdata = nameAnimeDataMap[replaceCfg[sdata.Name]] or sdata
  end
  return sdata
end

function UIEmojiCell.CheckIsPassiveActionByName(name)
  if not StringUtil.IsEmpty(name) then
    local cfg = Game.Config_Action[name]
    if cfg then
      return Game.Config_PassiveDoubleAction[cfg.id] ~= nil
    end
  end
  return false
end

function UIEmojiCell.CheckDoubleActionValid(id)
  local cfg = GameConfig.TwinsAction.anime_hide
  if cfg and TableUtility.ArrayFindIndex(cfg, id) > 0 then
    return false
  else
    return true
  end
end
