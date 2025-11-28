UIUtil = {}

function UIUtil.FitLabelLine(label)
  if label ~= nil then
    local height = label.height
    local size = label.fontSize
    local line = math.floor(height / size)
    if 1 < line then
      label.pivot = UIWidget.Pivot.Left
    else
      label.pivot = UIWidget.Pivot.Center
    end
  end
end

function UIUtil.CenterLabelLine(label)
  if label ~= nil then
    label.pivot = UIWidget.Pivot.Center
  end
end

function UIUtil.FitLabelHeight(label, width)
  if label ~= nil then
    local labelText = label.text
    label.overflowMethod = 3
    label.width = width
    if StringUtil.IsEmpty(labelText) then
      return
    end
    label.text = ""
    local bWarp, strOut, line
    if string.find(labelText, [=[
[
]]=]) then
      line = 2
    else
      line = 1
    end
    bWarp, strOut = label:Wrap(labelText, strOut, label.height * line)
    if bWarp and strOut ~= "" then
      label.overflowMethod = 2
    end
    label.text = labelText
  end
end

function UIUtil.FitLableMaxWidth(_lable, _maxWidth)
  if BranchMgr.IsChina() then
    return
  end
  if _lable ~= nil and _maxWidth ~= nil then
    local labelText = _lable.text
    if _lable.overflowMethod ~= 2 or StringUtil.IsEmpty(labelText) then
      return
    end
    if _maxWidth < _lable.width then
      _lable.overflowMethod = 0
      _lable.width = _maxWidth
    end
  end
end

function UIUtil.FitLableMaxHeight(_lable, _maxHeight)
  if BranchMgr.IsChina() then
    return
  end
  if _lable ~= nil and _maxHeight ~= nil then
    local labelText = _lable.text
    if _lable.overflowMethod ~= 3 or StringUtil.IsEmpty(labelText) then
      return
    end
    if _maxHeight < _lable.height then
      _lable.overflowMethod = 0
      _lable.height = _maxHeight
    end
  end
end

function UIUtil.FitLableSpaceChangeLine(_lable, _maxWidth)
  if AppBundleConfig.GetSDKLang() == "cn" or AppBundleConfig.GetSDKLang() == "jp" or AppBundleConfig.GetSDKLang() == "kr" or AppBundleConfig.GetSDKLang() == "th" then
    return
  end
  local text = _lable.text
  local width = _maxWidth or _lable.width
  local lines = string.split(text, "\n")
  if #lines == 0 then
    table.insert(lines, text)
  end
  local res = ""
  for i = 1, #lines do
    res = res .. UIUtil.FitLableLineChange(_lable, width, lines[i])
    if i ~= #lines then
      res = res .. "\n"
    end
  end
  _lable.text = res
end

function UIUtil.FitLableLineChange(_lable, width, lineText)
  if AppBundleConfig.GetSDKLang() == "cn" or AppBundleConfig.GetSDKLang() == "jp" or AppBundleConfig.GetSDKLang() == "kr" or AppBundleConfig.GetSDKLang() == "th" then
    return
  end
  utf8len = StringUtil.Utf8len
  utf8sub = StringUtil.Utf8sub
  local tempText = lineText
  local length = utf8len(tempText)
  local curText = ""
  local curChar = ""
  local res = ""
  local curWidth = 0
  local curLine = 0
  local vertor
  _lable.text = ""
  _lable:UpdateNGUIText()
  local finalLineHeight = NGUIText.finalLineHeight
  NGUIText.finalSize = _lable.defaultFontSize
  for i = 1, length do
    curChar = utf8sub(tempText, i, 1)
    curText = curText .. curChar
    vertor = NGUIText.CalculatePrintedSize(curText)
    if width < vertor.x or finalLineHeight < vertor.y then
      local curTextLen = utf8len(curText)
      local oneline = ""
      local lastSpaceIndex = curTextLen
      for j = curTextLen, 1, -1 do
        if utf8sub(curText, j, 1) == " " then
          lastSpaceIndex = j
          break
        end
      end
      oneline = utf8sub(curText, 1, lastSpaceIndex - 1)
      if lastSpaceIndex ~= curTextLen and oneline ~= " " then
        oneline = utf8sub(curText, 1, lastSpaceIndex - 1)
        res = res .. oneline .. "\n"
        curText = utf8sub(curText, lastSpaceIndex + 1, curTextLen - lastSpaceIndex)
      else
        oneline = utf8sub(curText, 1, utf8len(curText) - 1)
        res = res .. oneline .. "\n"
        curText = curChar
      end
    end
  end
  res = res .. curText
  return res
end

function UIUtil.FitLableMaxWidth_UseLeftPivot(label, maxWidth)
  if label ~= nil and _maxWidth ~= nil then
    local labelText = label.text
    if StringUtil.IsEmpty(labelText) then
      return
    end
    label.overflowMethod = 3
    label.width = maxWidth
    if string.find(labelText, [=[
[
]]=]) then
      label.pivot = UIWidget.Pivot.Left
      label.overflowMethod = 2
    end
  end
end

function UIUtil.SceneCountDownMsg(id, params, removeWhenLoadScene)
  MsgManager.ShowMsgByIDTable(id, params, id)
  FloatingPanel.Instance:SetCountDownRemoveOnChangeScene(id, removeWhenLoadScene)
end

function UIUtil.StartSceenCountDown(text, data)
  FloatingPanel.Instance:AddCountDown(text, data)
end

function UIUtil.EndSceenCountDown(id)
  FloatingPanel.Instance:RemoveCountDown(id)
end

function UIUtil.FloatMiddleBottom(sortID, text)
  FloatingPanel.Instance:FloatMiddleBottom(sortID, text)
end

function UIUtil.ClearFloatMiddleBottom()
  FloatingPanel.Instance:ClearFloatMiddleBottom()
end

function UIUtil.FloatMsgByData(text)
  FloatingPanel.Instance:TryFloatMessageByData(text)
end

function UIUtil.FloatRainbowMsgByData(data)
  if data and data.params and type(data.params) == "table" and type(data.params[1]) == "string" then
    local suffix = OverseasConfig.OriginTeamName
    data.params[1] = data.params[1]:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
  end
  data.parsed = true
  if data.params ~= nil and type(data.params) == "table" then
    data.text = MsgParserProxy.Instance:TryParse(data.text, unpack(data.params))
  else
    data.text = MsgParserProxy.Instance:TryParse(data.text, data.params)
  end
  FloatingPanel.Instance:ShowRainbowMsg(data.text)
end

function UIUtil.FloatShowyMsg(text)
  FloatingPanel.Instance:FloatShowyMsg(text)
end

function UIUtil.FloatMsgByText(text, cellType)
  FloatingPanel.Instance:TryFloatMessageByText(text, cellType)
end

function UIUtil.ShowEightTypeMsgByData(data, startPos, offset)
  FloatingPanel.Instance:FloatTypeEightMsgByData(data, startPos, offset)
end

function UIUtil.StopEightTypeMsg()
  FloatingPanel.Instance:StopFloatTypeEightMsg()
end

function UIUtil.PopUpRichConfirmView(titleText, contentText, confirmtext, canceltext, confirm, cancel, src, needCloseBtn, needExitDefaultHandle, unique, lockreason)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "RichUniqueConfirmView",
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src,
    needCloseBtn = needCloseBtn,
    needExitDefaultHandle = needExitDefaultHandle,
    unique = unique,
    lockreason = lockreason
  }
  redlog("lockreason", lockreason)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.PopUpConfirmView(titleText, contentText, confirmtext, canceltext, confirm, cancel, src, needCloseBtn, needExitDefaultHandle, unique, lockreason)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "UniqueConfirmView",
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src,
    needCloseBtn = needCloseBtn,
    needExitDefaultHandle = needExitDefaultHandle,
    unique = unique,
    lockreason = lockreason
  }
  redlog("lockreason", lockreason)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.PopUpItemConfirmView(titleText, contentText, itemDatas, confirmtext, canceltext, confirm, cancel, src)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "ItemConfirmView",
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src,
    needCloseBtn = needCloseBtn,
    needExitDefaultHandle = needExitDefaultHandle,
    unique = unique,
    lockreason = lockreason,
    items = itemDatas
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.PopUpDontAgainConfirmView(contentText, confirm, cancel, src, data)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "DontShowAgainConfirmView",
    data = data,
    content = contentText,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.PopUpRichConfirmYesNoView(title, content, confirmHandler, cancelHandler, source, confirmtext, canceltext, unique, lockreason, needCloseBtn)
  UIUtil.PopUpRichConfirmView(title, content, confirmtext, canceltext, confirmHandler, cancelHandler, source, needCloseBtn, false, unique, lockreason)
end

function UIUtil.PopUpConfirmYesNoView(title, content, confirmHandler, cancelHandler, source, confirmtext, canceltext, unique, lockreason, needCloseBtn)
  UIUtil.PopUpConfirmView(title, content, confirmtext, canceltext, confirmHandler, cancelHandler, source, needCloseBtn, false, unique, lockreason)
end

function UIUtil.PopUpFuncView(title, content, confirmHandler, cancelHandler, source, confirmtext, canceltext)
  UIUtil.PopUpConfirmView(title, content, confirmtext, canceltext, confirmHandler, cancelHandler, source, true, false)
end

function UIUtil.PopUpItemConfirmYesNoView(title, content, itemDatas, confirmHandler, cancelHandler, source, confirmtext, canceltext)
  UIUtil.PopUpItemConfirmView(title, content, itemDatas, confirmtext, canceltext, confirmHandler, cancelHandler, source)
end

function UIUtil.WarnPopup(titleText, contentText, confirm, cancel, src, confirmtext, canceltext)
  local data = {
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src
  }
  if UIWarning.Instance ~= nil then
    UIWarning.Instance:AddWarnPopUp(data)
  end
end

function UIUtil.ShowScreenMask(fadeInTime, fadeOutTime, fadeInCallBack, fadeOutCallBack, color)
  helplog("UIUtil.ShowScreenMask")
  color = color or ColorUtil.NGUIBlack
  local viewData = {
    viewname = "ScreenMaskView",
    fadeInTime = fadeInTime,
    fadeOutTime = fadeOutTime,
    fadeInCallBack = fadeInCallBack,
    fadeOutCallBack = fadeOutCallBack,
    color = color
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.RotateAround()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end

function UIUtil.CenterScrollViewPos(scrollView, worldPos, springStr)
  local mTrans = scrollView.transform
  local panel = scrollView.panel
  local cp = mTrans:InverseTransformPoint(worldPos)
  local corners = panel.worldCorners
  local panelCenter = (corners[3] + corners[1]) * 0.5
  local cc = mTrans:InverseTransformPoint(panelCenter)
  LuaGameObject.InverseTransformPointByVector3(mTrans, panelCenter)
  local localOffset = cp - cc
  if springStr then
    SpringPanel.Begin(scrollView.gameObject, mTrans.localPosition - localOffset, springStr)
  else
    mTrans.localPosition = mTrans.localPosition - localOffset
    local co = panel.clipOffset
    panel.clipOffset = co + Vector2(localOffset.x, localOffset.y)
  end
end

function UIUtil.GetUIParticle(effectID, depth, parent)
  local containerResID = ResourcePathHelper.UICell("UIParticleHolder")
  local container = Game.AssetManager_UI:CreateAsset(containerResID, parent)
  local effectResID = ResourcePathHelper.EffectUI(effectID)
  local effect = Game.AssetManager_UI:CreateAsset(effectResID, container)
  local ctrl = container:GetComponent(ChangeRqByTex)
  ctrl.transform.localPosition = LuaVector3.Zero()
  ctrl.depth = depth
  ctrl:AddChild(effect)
  return ctrl, effect
end

function UIUtil.WrapLabel(uiLabel)
  local strContent = uiLabel.text
  local bWarp, strOut
  bWarp, strOut = uiLabel:Wrap(strContent, strOut, uiLabel.height)
  local length = StringUtil.getTextLen(strOut)
  if not bWarp and 2 < length then
    local repStr = ""
    local count = 0
    local rep_bWrap, rep_strOut = false, strOut
    repeat
      count = count + 1
      repStr = StringUtil.getTextByIndex(rep_strOut, 1, length - count)
      repStr = repStr .. "..."
      rep_bWrap, rep_strOut = uiLabel:Wrap(repStr, rep_strOut, uiLabel.height)
    until rep_bWrap
    uiLabel.text = repStr
  end
  return bWarp
end

function UIUtil.GetWrapLeftString(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, finallen, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end

function UIUtil.GetWrapLeftStringOfEnglishText(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local lastSpaceIndex = StringUtil.LastIndexOf(finalStr, " ") or finallen
    uiLabel.text = StringUtil.getTextByIndex(finalStr, 1, lastSpaceIndex)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, lastSpaceIndex + 1, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end

function UIUtil.ChangeLayer(go, layer)
  layer = layer or go.gameObject.layer
  go.gameObject.layer = layer
  local trans = go.gameObject.transform
  for i = 0, trans.childCount - 1 do
    local transChild = trans:GetChild(i)
    transChild.gameObject.layer = layer
    UIUtil.ChangeLayer(transChild.gameObject, layer)
  end
end

function UIUtil.GetAllComponentInChildren(go, type)
  local result = UIUtil.GetAllComponentsInChildren(go, type, true)
  return result[1]
end

function UIUtil.GetAllComponentsInChildren(go, type, containSelf)
  local comps = {}
  local sp = go:GetComponent(type)
  if containSelf and sp then
    table.insert(comps, sp)
  end
  local childCount = go.transform.childCount
  for i = 0, childCount - 1 do
    local trans = go.transform:GetChild(i)
    local childComps = UIUtil.GetAllComponentsInChildren(trans.gameObject, type, true)
    for i = 1, #childComps do
      table.insert(comps, childComps[i])
    end
  end
  return comps
end

function UIUtil.GetComponentInParents(go, type)
  if go == nil then
    return nil
  end
  local comp
  local t = go.transform.parent
  while t ~= nil and comp == nil do
    comp = t.gameObject:GetComponent(type)
    t = t.parent
  end
  return comp
end

function UIUtil.LimitInputCharacter(input, limitNum, validFunc)
  local obj = input.gameObject
  if not Game.GameObjectUtil:ObjectIsNULL(obj) then
    local inputLimit = math.max(limitNum * 5, 20)
    input.characterLimit = inputLimit
    local func = function(go, state)
      if not state then
        local str = input.value
        if type(validFunc) == "function" then
          str = validFunc(str)
        end
        local length = StringUtil.ChLength(str)
        if length > limitNum then
          str = StringUtil.getTextByIndex(str, 1, limitNum)
        end
        input.value = str
      end
    end
    UIEventListener.Get(obj).onSelect = {"+=", func}
  end
end

function UIUtil.PopupTipAchievement(achievement_conf_id)
  UIViewAchievementPopupTip.Instance:ShowAchievementPopupTip(achievement_conf_id)
end

function UIUtil.isClickLeftScreenArea()
  local tempVector3 = LuaVector3.Zero()
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return true
  end
  if Input.touchCount > 1 then
    for i = 1, Input.touchCount do
      local single = Input.GetTouch(i - 1)
      if single.phase == TouchPhase.Ended then
        local x, y = LuaGameObject.GetTouchPosition(i - 1, false)
        LuaVector3.Better_Set(tempVector3, x, y, 0)
        break
      end
    end
  else
    local x, y, z = LuaGameObject.GetMousePosition()
    LuaVector3.Better_Set(tempVector3, x, y, z)
  end
  if not UIUtil.IsScreenPosValid(tempVector3[1], tempVector3[2]) then
    LogUtility.Error(string.format("isClickLeftScreenArea MousePosition is Invalid! x: %s, y: %s", tempVector3[1], tempVector3[3]))
    return false
  end
  local x, y, z = LuaGameObject.ScreenToWorldPointByVector3(uiCamera, tempVector3)
  return x <= 0
end

local _GameObjectUtil_Ins = GameObjectUtil.Instance
local _DeepFind = _GameObjectUtil_Ins.DeepFind

function UIUtil.FindGO(name, parent)
  return parent and _DeepFind(_GameObjectUtil_Ins, parent, name) or nil
end

function UIUtil.FindComponent(name, comp, parent)
  return parent ~= nil and _GameObjectUtil_Ins:DeepFindComponent(parent, comp, name) or nil
end

function UIUtil.FindAllComponents(parent, compType, containSelf)
  if parent == nil then
    return
  end
  return Game.GameObjectUtil:GetAllComponentsInChildren(parent, compType, containSelf) or {}
end

function UIUtil.AddClickEvent(obj, event)
  if event == nil then
    return
  end
  UIEventListener.Get(obj).onClick = {"+=", event}
end

function UIUtil.AddUGUIClickEvent(obj, event)
  if event == nil then
    UGUIEventListener.Get(obj).onClick = nil
    return
  end
  UGUIEventListener.Get(obj).onClick = function(go)
    if UICamera.isOverUI then
      return
    end
    if event then
      event(go)
    end
  end
end

function UIUtil.RemoveClickEvent(obj, event)
  if event == nil then
    return
  end
  UIEventListener.Get(obj).onClick = {"-=", event}
end

function UIUtil.GetTextBeforeLastSpace(label, withCommon)
  local oldString = label.text
  local lastSpaceIndex = StringUtil.LastIndexOf(oldString, " ")
  if withCommon then
    label.text = StringUtil.getTextByIndex(oldString, 1, lastSpaceIndex) .. "..."
  else
    label.text = StringUtil.getTextByIndex(oldString, 1, lastSpaceIndex)
  end
end

function UIUtil.ResetAndUpdateAllAnchors(go)
  local uiRects = UIUtil.FindAllComponents(go, UIRect, true)
  if not uiRects or not next(uiRects) then
    return
  end
  for i = 1, #uiRects do
    uiRects[i]:ResetAndUpdateAnchors()
  end
end

XDEInvisibleChara = "\002"

function AppendSpace2Str(str)
  if BranchMgr.IsChina() then
    return str
  end
  if str ~= nil and OverSea.LangManager.Instance():GetLangByKey(str) ~= str then
    return str .. XDEInvisibleChara
  end
  return str
end

function removeNewLine(str)
  return str:gsub("\r", ""):gsub("\n", "")
end

function AddSpecialCharaIfNecessary(str)
  if BranchMgr.IsChina() then
    return str
  end
  if not str then
    return str
  end
  if str:match(XDEInvisibleChara) then
    return str
  end
  return XDEInvisibleChara .. str
end

local utf8ToCodePoint = function(str, index)
  index = index or 1
  local byte = string.byte(str, index)
  if byte < 128 then
    return byte, 1
  elseif 192 <= byte and byte < 224 then
    local byte2 = string.byte(str, index + 1) or 0
    return (byte & 31) << 6 | byte2 & 63, 2
  elseif 224 <= byte and byte < 240 then
    local byte2 = string.byte(str, index + 1) or 0
    local byte3 = string.byte(str, index + 2) or 0
    return (byte & 15) << 12 | (byte2 & 63) << 6 | byte3 & 63, 3
  elseif 240 <= byte and byte <= 247 then
    local byte2 = string.byte(str, index + 1) or 0
    local byte3 = string.byte(str, index + 2) or 0
    local byte4 = string.byte(str, index + 3) or 0
    return (byte & 7) << 18 | (byte2 & 63) << 12 | (byte3 & 63) << 6 | byte4 & 63, 4
  end
  return byte, 1
end

function ContainsSpecialCharacters(text)
  if text == nil or text == "" then
    return false
  end
  local index = 1
  while index <= #text do
    local codePoint, size = utf8ToCodePoint(text, index)
    if 8203 <= codePoint and codePoint <= 8207 or 8288 <= codePoint and codePoint <= 8303 or 8232 <= codePoint and codePoint <= 8239 or 8192 <= codePoint and codePoint <= 8202 or codePoint == 10240 or 55296 <= codePoint and codePoint <= 57343 then
      return true
    end
    index = index + size
  end
  return false
end

function RemoveSpecialChara(str)
  if BranchMgr.IsChina() then
    return str
  end
  return str and str:gsub("\002", "")
end

function SkipTranslatingInput(input, solution)
  if BranchMgr.IsChina() then
    return
  end
  local obj = input.gameObject
  local lbl = input.label
  if not obj or not lbl then
    return
  end
  local status, result = pcall(function()
    lbl.skipTranslation = true
  end)
  if status ~= true then
    xdlog("使用 lua 方案")
    if solution == 1 then
      EventDelegate.Set(input.onChange, function()
        xdlog("input changed")
        lbl.text = AppendSpace2Str(input.value)
      end)
      local obj = input.gameObject
      if not Game.GameObjectUtil:ObjectIsNULL(obj) then
        local func = function(go, state)
          xdlog("called")
          lbl.text = AppendSpace2Str(input.value)
        end
        UIEventListener.Get(obj).onSelect = {"+=", func}
      end
      return
    end
    EventDelegate.Set(input.onChange, function()
      xdlog("input changed")
      input.value = AddSpecialCharaIfNecessary(input.value)
    end)
    local obj = input.gameObject
    if not Game.GameObjectUtil:ObjectIsNULL(obj) then
      local func = function(go, state)
        xdlog("called")
        input.value = AddSpecialCharaIfNecessary(input.value)
      end
      UIEventListener.Get(obj).onSelect = {"+=", func}
    end
  end
end

function SkipTranslatingLabel(label)
  if BranchMgr.IsChina() then
    return
  end
  local status, result = pcall(function()
    label.skipTranslation = true
  end)
  if status ~= true then
    xdlog("使用 lua 方案")
    label.text = AppendSpace2Str(label.text)
  end
end

function alignWidgetToTransform_Right(widget, transform, offset)
  offset = offset or 0
  widget.leftAnchor.target = transform
  widget.leftAnchor.relative = 1
  widget.leftAnchor.absolute = offset
  widget.rightAnchor.target = transform
  widget.rightAnchor.relative = 1
  widget.rightAnchor.absolute = widget.width + offset
end

function alignWidgetToTransform_Right2(widget, transform, offset)
  offset = offset or 0
  widget.leftAnchor.target = transform
  widget.leftAnchor.relative = 1
  widget.leftAnchor.absolute = offset * -1 - widget.width
  widget.rightAnchor.target = transform
  widget.rightAnchor.relative = 1
  widget.rightAnchor.absolute = offset
end

function restoreOriginSize(sprite)
  local atlas = sprite.atlas
  local name = sprite.spriteName
  sprite.atlas = nil
  sprite.atlas = atlas
  local spriteData = sprite.atlas:GetSprite(name)
  if spriteData == nil then
    redlog("sprite is nil", name)
    return
  end
  sprite.width = spriteData.width
  sprite.height = spriteData.height
end

function ShowLineEnding(str)
  return str:gsub("\r\n", "[CRLF]"):gsub("\n", "[LF]")
end

local Cache_SortingOrder = {}

function UIUtil.NormalizedSortingOrder(go)
  if Slua.IsNull(go) then
    return
  end
  local prs = UIUtil.FindAllComponents(go, ParticleSystemRenderer, true)
  if prs == nil then
    return
  end
  for i = 1, #prs do
    local pr = prs[i]
    local instanceID = pr.gameObject:GetInstanceID()
    Cache_SortingOrder[instanceID] = pr.sortingOrder
    pr.sortingOrder = 0
  end
end

function UIUtil.RevertSortingOrder(go)
  if Slua.IsNull(go) then
    return
  end
  local prs = UIUtil.FindAllComponents(go, ParticleSystemRenderer, true)
  if prs == nil then
    return
  end
  for i = 1, #prs do
    local pr = prs[i]
    local instanceID = pr.gameObject:GetInstanceID()
    local orilayer = Cache_SortingOrder[instanceID]
    if orilayer ~= nil then
      pr.sortingOrder = orilayer
    end
  end
end

function UIUtil.IsScreenPosValid(posX, posY)
  if not (UIUtil.screenWidth and UIUtil.screenHeight) or ApplicationInfo.IsRunOnEditor() or ApplicationInfo.IsRunOnWindowns() then
    UIUtil.screenWidth = Screen.width
    UIUtil.screenHeight = Screen.height
  end
  return 0 <= posX and posX <= UIUtil.screenWidth and 0 <= posY and posY <= UIUtil.screenHeight
end

function UIUtil.HandleDragScrollForObj(obj, dragScrollViewComp)
  if not obj or not dragScrollViewComp then
    return
  end
  local listener = UIEventListener.Get(obj)
  
  function listener.onPress(go, pressed)
    dragScrollViewComp:SendMessage("OnPress", pressed, 1)
  end
  
  function listener.onDrag(go, delta)
    dragScrollViewComp:SendMessage("OnDrag", delta, 1)
  end
end

function UIUtil.TryAddClickUrlCompToGameObject(obj, callback)
  if Slua.IsNull(obj) then
    return
  end
  local clickUrlComp = obj:GetComponent(UILabelClickUrl)
  if not clickUrlComp then
    clickUrlComp = obj:AddComponent(UILabelClickUrl)
    obj:AddComponent(BoxCollider)
    local ancestor = Game.GameObjectUtil:FindCompInParents(obj, GameObjectForLua)
    if ancestor then
      UIUtil.HandleDragScrollForObj(obj, ancestor.gameObject:GetComponentInChildren(UIDragScrollView))
    end
  end
  NGUITools.UpdateWidgetCollider(obj)
  clickUrlComp.callback = callback or function()
  end
  return clickUrlComp
end

function UIUtil.TryRemoveClickUrlCompFromGameObject(obj)
  if Slua.IsNull(obj) then
    return
  end
  local clickUrlComp = obj:GetComponent(UILabelClickUrl)
  if clickUrlComp then
    Component.Destroy(clickUrlComp)
    local collider = obj:GetComponent(BoxCollider)
    if collider then
      Component.Destroy(collider)
    end
  end
end

function UIUtil.AdaptGotoModeClickUrl(labelObj, str)
  local hasUrl = string.match(str, "%[url=")
  if hasUrl then
    UIUtil.TryAddClickUrlCompToGameObject(labelObj, function(url)
      if string.sub(url, 1, 8) ~= "gotomode" then
        return
      end
      FuncShortCutFunc.Me():CallByID(tonumber(string.sub(url, 10)))
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    end)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(labelObj)
  end
end

local halfWhiteSpaceLangs = {
  en = 1,
  ru = 1,
  de = 1,
  tr = 1,
  fr = 1,
  pt = 1,
  es = 1,
  id = 1,
  th = 1
}

function UIUtil.GetIndentString()
  return ZhString.QuestManual_TwoSpace
end

UIUtil.ButtonStyle = {
  gray = 0,
  blue = 1,
  green = 2,
  red = 3,
  orange = 4,
  modern_gray = 10,
  morden_blue = 11,
  modern_orange = 12,
  modern_rect_gray = 20,
  modern_rect_blue = 21,
  modern_rect_orange = 22
}
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)

function UIUtil.TempSetButtonStyle(style, btn, sp, lb, bc)
  sp = sp or btn:GetComponentInChildren(UISprite)
  lb = lb or btn:GetComponentInChildren(UILabel)
  bc = bc or btn:GetComponentInChildren(BoxCollider)
  if style == 0 then
    lb.effectColor = GRAY_LABEL_COLOR
    sp.spriteName = "com_btn_13s"
    bc.enabled = false
  elseif style == 1 then
    lb.effectColor = ColorUtil.ButtonLabelBlue
    sp.spriteName = "com_btn_1s"
    bc.enabled = true
  elseif style == 2 then
    lb.effectColor = ColorUtil.ButtonLabelGreen
    sp.spriteName = "com_btn_3s"
    bc.enabled = true
  elseif style == 3 then
    lb.effectColor = Color(0.41568627450980394, 0.03137254901960784, 0.054901960784313725, 1)
    sp.spriteName = "com_btn_0"
    bc.enabled = true
  elseif style == 4 then
    lb.effectColor = ColorUtil.ButtonLabelOrange
    sp.spriteName = "com_btn_2s"
    bc.enabled = true
  elseif style == 10 then
    lb.effectColor = GRAY_LABEL_COLOR
    sp.spriteName = "new-com_btn_a_gray"
    bc.enabled = false
  elseif style == 11 then
    lb.effectColor = ColorUtil.ButtonLabelBlue
    sp.spriteName = "new-com_btn_a"
    bc.enabled = true
  elseif style == 12 then
    lb.effectColor = ColorUtil.ButtonLabelOrange
    sp.spriteName = "new-com_btn_c"
    bc.enabled = true
  end
end

function UIUtil.TempSetItemIcon(sp, icon, maxWidth, maxHeight)
  local setSuc = IconManager:SetItemIcon(icon, sp)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", sp)
  sp:MakePixelPerfect()
  if maxWidth and maxWidth < sp.width then
    sp.height = sp.height * maxWidth / sp.width
    sp.width = maxWidth
  end
  if maxHeight and maxHeight < sp.height then
    sp.width = sp.width * maxHeight / sp.height
    sp.height = maxHeight
  end
end

function UIUtil.TempLimitIconSize(sp, maxWidth, maxHeight)
  sp:MakePixelPerfect()
  if maxWidth and maxWidth < sp.width then
    sp.height = sp.height * maxWidth / sp.width
    sp.width = maxWidth
  end
  if maxHeight and maxHeight < sp.height then
    sp.width = sp.width * maxHeight / sp.height
    sp.height = maxHeight
  end
end

function UIUtil.EnableGrey(uiwidget, value)
  if value then
    ColorUtil.ShaderGrayUIWidget(uiwidget)
    uiwidget.alpha = 0.5
  else
    ColorUtil.WhiteUIWidget(uiwidget)
    uiwidget.alpha = 1
  end
end
