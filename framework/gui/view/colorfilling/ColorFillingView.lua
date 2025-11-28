autoImport("ColorFillingColorCell")
autoImport("ColorFillingColorChooseView")
autoImport("ColorFillingDialogView")
ColorFillingView = class("ColorFillingView", ContainerView)
ColorFillingView.ViewType = UIViewType.NormalLayer
local handleUndoStack = {}
local handleRedoStack = {}
local defaultColorCellSpriteName = "Disney_Comics_btn_colour01"
local customColorCellSpriteName = "Disney_Comics_btn_colour02"
local white = ColorUtil.NGUIWhite
local defaultText = ""
local scaleSize = 2
local zoomInPos = LuaVector3(537, -258, 0)
local dialogPrefabPath = "part/ColorFillingDialog"
local saveColors = {}
local saveDialogs = {}
local areaMaxDepth = {}

function ColorFillingView:Init()
  self.comicId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.comicID or self.viewdata.viewdata.params
  local questData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.questData
  if questData then
    self.questId = questData.id
  end
  if not self.comicId then
    self:CloseSelf()
    return
  end
  self.colorTemplate = self:GetTemplate(Table_ComicTemplate)
  self.dialogTemplate = self:GetTemplate(Table_ComicDialogTemplate)
  self.colorChooseView = self:AddSubView("ColorFillingColorChooseView", ColorFillingColorChooseView)
  self.dialogView = self:AddSubView("ColorFillingDialogView", ColorFillingDialogView)
  self.isRunOnEditor = ApplicationInfo.IsRunOnEditor()
  self.isRunOnWindows = ApplicationInfo.IsRunOnWindowns()
  self.touchSupported = Input.touchSupported
  local layer = LayerMask.NameToLayer("UI")
  self.camera = NGUITools.FindCameraForLayer(layer)
  self:InitData()
  self:InitView()
  self:InitColorArea()
  if self.questId then
    self:InitQuestView()
  else
    self:SetZoomInBtnState(true)
    self:AddListenEvt(ServiceEvent.ItemColoringQueryItemCmd, self.ShowPanel)
    self:AddListenEvt(ServiceEvent.ItemColoringModifyItemCmd, self.OnColorFillingSave)
    ServiceItemProxy.Instance:CallColoringQueryItemCmd(self.comicId)
  end
end

function ColorFillingView:InitData()
  self.defaultColors = GameConfig.ColorFilling and GameConfig.ColorFilling.defaultColors or {}
  self.customColors = {}
  self.customColorCount = 0
  self.colorWidgetMap = {}
  self.dialogLabelMap = {}
  self.maxUndoCount = GameConfig.ColorFilling and GameConfig.ColorFilling.maxUndoCount or 0
  self.bgNames = GameConfig.ColorFilling and GameConfig.ColorFilling.bgName and GameConfig.ColorFilling.bgName[self.comicId]
end

function ColorFillingView:InitView()
  self.title = self:FindComponent("title", UILabel)
  self.textBox = self:FindGO("textBox")
  self.sendBtn = self:FindGO("sendBtn")
  self.inputLabel = self:FindComponent("inputText", UIInput, self.textBox)
  for i = 0, 3 do
    self["fillingArea" .. i] = self:FindGO("area" .. i)
    self["fillingAreaTex" .. i] = self["fillingArea" .. i]:GetComponent(UITexture)
  end
  local defaultColorGrid = self:FindComponent("defaultColorGrid", UIGrid)
  self.defaultColorList = UIGridListCtrl.new(defaultColorGrid, ColorFillingColorCell, "ColorFillingColorCell")
  self.defaultColorList:AddEventListener(MouseEvent.MouseClick, self.OnColorCellClick, self)
  local customColorGrid = self:FindComponent("customColorGrid", UIGrid)
  self.customColorList = UIGridListCtrl.new(customColorGrid, ColorFillingColorCell, "ColorFillingColorCell")
  self.customColorList:AddEventListener(MouseEvent.MouseClick, self.OnColorCellClick, self)
  self.customColorArea = customColorGrid.gameObject
  self.zoomInBtn = self:FindGO("zoomInBtn")
  self.zoomOutBtn = self:FindGO("zoomOutBtn")
  self.dragArea = self:FindGO("fillingArea")
  self.dragAreaDefaultPos = self.dragArea.transform.localPosition
  self.dragPanel = self.dragArea:GetComponent(UIPanel)
  local dragPanelSize = self.dragPanel:GetViewSize()
  self.zoomInOffset = LuaVector2(-dragPanelSize.x * 0.5, dragPanelSize.y * 0.5)
  self.zoomArea = self:FindGO("zoomArea")
  self.zoomAreaTrans = self.zoomArea.transform
  self.dragScrollView = self.dragArea:GetComponent(UIScrollView)
  local undoBtn = self:FindGO("undoBtn")
  local redoBtn = self:FindGO("redoBtn")
  local resetBtn = self:FindGO("resetBtn")
  self.colorChooseBtn = self:FindGO("colorChooseBtn")
  self.colorChooseBg = self:FindGO("bg_bottom")
  self.completeBtn = self:FindGO("completeBtn")
  local completeLable = self:FindGO("Label", self.completeBtn):GetComponent(UILabel)
  if BranchMgr.IsJapan() then
    completeLable.text = ZhString.ColorFillingView_ShareJpLable
  end
  self.autoFillingBtn = self:FindGO("autoFillingBtn")
  self.goonBtn = self:FindGO("goonBtn")
  self.goonBtn:SetActive(false)
  self:AddButtonEvent("closeButton", function()
    if self.questId then
      MsgManager.ConfirmMsgByID(20009, function()
        local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
        if questData then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        end
        self:CloseSelf()
      end)
      return
    end
    MsgManager.ConfirmMsgByID(41451, function()
      self.isClose = true
      self:OnSave()
    end)
  end)
  local helpId = GameConfig.ColorFilling and GameConfig.ColorFilling.help_id
  self:RegistShowGeneralHelpByHelpID(helpId, self:FindGO("helpButton"))
  self:AddClickEvent(undoBtn, function()
    self:UndoFilling()
  end)
  self:AddClickEvent(redoBtn, function()
    self:RedoFilling()
  end)
  self:AddClickEvent(resetBtn, function()
    MsgManager.ConfirmMsgByID(41452, function()
      self:ResetAll()
    end)
  end)
  self:AddClickEvent(self.zoomInBtn, function()
    self:ZoomIn()
  end)
  self:AddClickEvent(self.zoomOutBtn, function()
    self:ZoomOut()
  end)
  self:AddClickEvent(self.colorChooseBtn, function()
    self:OpenColorChooseView()
  end)
  self:AddClickEvent(self.autoFillingBtn, function()
    self:AutoFilling()
  end)
  self:AddClickEvent(self.completeBtn, function()
    self:OnComplete()
  end)
  self:AddClickEvent(self.goonBtn, function()
    self:OnGoonBtnClick()
  end)
  self:AddOrRemoveGuideId(self.zoomInBtn, 302)
  self:AddOrRemoveGuideId(self.zoomOutBtn, 312)
  self:AddOrRemoveGuideId(self.colorChooseBtn, 303)
end

function ColorFillingView:InitQuestView()
  self.zoomInBtn:SetActive(false)
  self.zoomOutBtn:SetActive(false)
  self.colorChooseBtn:SetActive(false)
  self.colorChooseBg:SetActive(false)
  self.autoFillingBtn:SetActive(false)
  self.completeBtn:SetActive(false)
  self.goonBtn:SetActive(true)
  self.customColorArea:SetActive(false)
  self.dragScrollView.enabled = false
  self:ShowPanel()
end

function ColorFillingView:OnGoonBtnClick()
  local match = true
  if not next(self.colorWidgetMap) then
    match = false
  else
    for id, widget in pairs(self.colorWidgetMap) do
      local color = widget.color
      local r = math.floor(color.r * 255 + 0.5)
      local g = math.floor(color.g * 255 + 0.5)
      local b = math.floor(color.b * 255 + 0.5)
      local data = self.colorTemplate[id]
      if not data.color then
        match = false
        break
      else
        local R = math.floor(data.color[1] * 255 + 0.5)
        local G = math.floor(data.color[2] * 255 + 0.5)
        local B = math.floor(data.color[3] * 255 + 0.5)
        if R ~= r or G ~= g or B ~= b then
          match = false
          break
        end
      end
    end
  end
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(self.questId)
  if questData then
    if match then
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    end
  end
  self:CloseSelf()
end

function ColorFillingView:ShowPanel()
  self:InitFillingArea()
  self:InitDialogArea()
end

function ColorFillingView:LoadFillingAreaBg()
  if not self.bgNames then
    return
  end
  for i = 1, #self.bgNames do
    local bgName = self.bgNames[i]
    PictureManager.Instance:SetColorFillingTexture(bgName, self["fillingAreaTex" .. i - 1])
  end
end

function ColorFillingView:UnloadFillingAreaBg()
  if not self.bgNames then
    return
  end
  for i = 1, #self.bgNames do
    local bgName = self.bgNames[i]
    PictureManager.Instance:UnloadColorFillingTexture(bgName, self["fillingAreaTex" .. i - 1])
  end
end

function ColorFillingView:InitFillingArea()
  local layer = LayerMask.NameToLayer("UI")
  for id, data in pairs(self.colorTemplate) do
    local areaId = data.areaId
    local parent = self["fillingArea" .. areaId]
    local parentWidget = parent:GetComponent(UIWidget)
    local go = GameObject(tostring(id))
    go.layer = layer
    go.transform:SetParent(parent.transform, false)
    if data.pos then
      go.transform.localPosition = data.pos
    end
    local sprite = go:AddComponent(UISprite)
    local spriteName = data.spriteName
    IconManager:SetColorFillingIcon(spriteName, sprite)
    sprite:MakePixelPerfect()
    NGUITools.AddWidgetCollider(go)
    local depth = parentWidget.depth + id
    sprite.depth = depth
    if not areaMaxDepth[areaId] or depth > areaMaxDepth[areaId] then
      areaMaxDepth[areaId] = depth
    end
    local color = ColorFillingProxy.Instance:GetWidgetColor(id)
    if not color then
      color = white
      if data.emptyColor then
        color = data.emptyColor
      end
    end
    sprite.color = color
    self.colorWidgetMap[id] = sprite
    self:AddClickEvent(go, function(go)
      self:DoNewFilling(go)
    end)
    go:AddComponent(UIDragScrollView)
    if id == 7 then
      self:AddOrRemoveGuideId(go, 301)
    end
  end
end

function ColorFillingView:InitDialogArea()
  for _, data in pairs(self.dialogTemplate) do
    local id = data.id
    local areaId = data.areaId
    local parent = self["fillingArea" .. areaId]
    local go = self:LoadPreferb(dialogPrefabPath, parent)
    if data.pos then
      go.transform.localPosition = data.pos
    end
    local label = go:GetComponent(UILabel)
    if data.size then
      label.width = data.size[1]
      label.height = data.size[2]
    end
    if data.fontSize then
      label.fontSize = data.fontSize
    end
    if data.color then
      label.color = data.color
    end
    self.dialogLabelMap[id] = label
    if StringUtil.IsEmpty(defaultText) then
      defaultText = label.text
    end
    local dialogContent = ColorFillingProxy.Instance:GetDialogContent(id)
    if not StringUtil.IsEmpty(dialogContent) then
      label.text = dialogContent
    end
    if not areaMaxDepth[areaId] then
      local parentWidget = parent:GetComponent(UIWidget)
      label.depth = parentWidget.depth + 1
    else
      label.depth = areaMaxDepth[areaId] + 1
    end
    self:AddClickEvent(go, function()
      self.curDialogId = id
      self:ShowTextBox()
    end)
    if id == 2 then
      self:AddOrRemoveGuideId(go, 309)
    end
  end
end

function ColorFillingView:InitColorArea()
  local defaultDatas = {}
  local customDatas = {}
  local count = #self.defaultColors
  for i = 1, count do
    local defaultHexColor = self.defaultColors[i]
    local _, defaultColor = ColorUtil.TryParseHexString(defaultHexColor)
    local defaultData = {}
    defaultData.spriteName = defaultColorCellSpriteName
    defaultData.color = defaultColor
    defaultDatas[#defaultDatas + 1] = defaultData
    local customData = {}
    customData.spriteName = customColorCellSpriteName
    customData.color = white
    customData.isEmpty = true
    customDatas[#customDatas + 1] = customData
    self.customColors[#self.customColors + 1] = white
  end
  self.defaultColorList:ResetDatas(defaultDatas)
  self.customColorList:ResetDatas(customDatas)
  local cells = self.defaultColorList:GetCells()
  local cell = cells[2]
  cell:AddOrRemoveGuideId(cell.gameObject, 300)
  cells = self.customColorList:GetCells()
  cell = cells[1]
  cell:AddOrRemoveGuideId(cell.gameObject, 311)
end

function ColorFillingView:OnEnter()
  self:ClearStack()
  self.title.text = GameConfig.ColorFilling and GameConfig.ColorFilling.comicName and GameConfig.ColorFilling.comicName[self.comicId] or ""
  self:LoadFillingAreaBg()
  ColorFillingView.super.OnEnter(self)
end

function ColorFillingView:OnExit()
  self:ClearStack()
  self:UnloadFillingAreaBg()
  ColorFillingView.super.OnExit(self)
end

function ColorFillingView:GetTemplate(templateTable)
  if not templateTable then
    self:CloseSelf()
    return
  end
  local template = {}
  for id, data in pairs(templateTable) do
    if data.ItemID == self.comicId then
      local temp = {}
      temp.id = data.id
      temp.itemId = data.ItemID
      temp.areaId = data.AreaID
      if data.SpriteName then
        temp.spriteName = data.SpriteName
      end
      temp.pos = LuaVector3.Zero()
      if data.Pos then
        temp.pos.x = data.Pos[1]
        temp.pos.y = data.Pos[2]
      end
      if data.Color and #data.Color >= 3 then
        temp.color = LuaColor(data.Color[1] / 255, data.Color[2] / 255, data.Color[3] / 255, 1)
      end
      if data.EmptyColor and 3 <= #data.EmptyColor then
        temp.emptyColor = LuaColor(data.EmptyColor[1] / 255, data.EmptyColor[2] / 255, data.EmptyColor[3] / 255, 1)
      end
      if data.Content then
        temp.content = data.Content
      end
      if data.Size then
        temp.size = data.Size
      end
      if data.FontSize then
        temp.fontSize = data.FontSize
      end
      template[id] = temp
    end
  end
  return template
end

function ColorFillingView:DoNewFilling(go)
  local widget = go:GetComponent(UISprite)
  if not widget then
    redlog("gameObject not has UIWidget Component!")
    return
  end
  local id = tonumber(go.name)
  if not id then
    redlog("widget not exist!")
    return
  end
  local x, y, z = 0, 0, 0
  if self.isRunOnEditor or self.isRunOnWindows then
    x, y, z = LuaGameObject.GetMousePosition()
  elseif self.touchSupported then
    x, y = LuaGameObject.GetTouchPosition(0, false)
  end
  local screenPos = LuaGeometry.GetTempVector3(x, y, z)
  x, y, z = LuaGameObject.ScreenToWorldPointByVector3(self.camera, screenPos)
  local worldPos = LuaGeometry.GetTempVector3(x, y, z)
  local templateData = self.colorTemplate[id]
  local parent = self["fillingArea" .. templateData.areaId]
  x, y, z = LuaGameObject.InverseTransformPointByVector3(parent.transform, worldPos)
  local localPos = LuaGeometry.GetTempVector3(x, y, z)
  local texPos = localPos - templateData.pos
  local pixelColor = self:GetPixelColor(texPos, widget)
  if pixelColor then
    local canFill = false
    if 0 >= pixelColor.a then
      id = id - 1
      while 0 < id do
        local data = self.colorTemplate[id]
        if data then
          if data.areaId ~= templateData.areaId then
            break
          end
          widget = self.colorWidgetMap[id]
          texPos = localPos - data.pos
          local pixel = self:GetPixelColor(texPos, widget)
          if pixel and 0 < pixel.a then
            canFill = true
            break
          end
        end
        id = id - 1
      end
    else
      canFill = true
    end
    if canFill then
      if self.selectColor then
        TableUtility.ArrayClear(handleRedoStack)
        self:DoFillColor(widget, id, self.selectColor)
      else
        MsgManager.ShowMsgByID(41453)
      end
    end
  end
end

function ColorFillingView:DoFillColor(widget, id, color)
  local handle = {}
  handle.id = id
  handle.color = widget.color
  self:PushStack(handle)
  self:ColorFill(widget, color)
end

function ColorFillingView:UndoFilling()
  local handle = TableUtility.ArrayPopBack(handleUndoStack)
  if handle then
    local redoHandle = self:DoHandle(handle)
    TableUtility.ArrayPushBack(handleRedoStack, redoHandle)
  end
end

function ColorFillingView:RedoFilling()
  local handle = TableUtility.ArrayPopBack(handleRedoStack)
  if handle then
    local undoHandle = self:DoHandle(handle)
    self:PushStack(undoHandle)
  end
end

function ColorFillingView:DoHandle(handle)
  local curHandle = {}
  curHandle.id = handle.id
  if handle.color then
    if type(handle.id) == "table" then
      local colors = {}
      for id, color in pairs(handle.color) do
        local widget = self.colorWidgetMap[id]
        if widget then
          colors[id] = widget.color
          self:ColorFill(widget, color)
        end
      end
      curHandle.color = colors
    else
      local widget = self.colorWidgetMap[handle.id]
      if widget then
        curHandle.color = widget.color
        self:ColorFill(widget, handle.color)
      end
    end
  end
  if handle.text then
    if type(handle.id) == "table" then
      local texts = {}
      for id, text in pairs(handle.text) do
        local label = self.dialogLabelMap[id]
        if label then
          texts[id] = label.text
          self:SetDialogText(label, text)
        end
      end
      curHandle.text = texts
    else
      local label = self.dialogLabelMap[handle.id]
      if label then
        curHandle.text = label.text
        self:SetDialogText(label, handle.text)
      end
    end
  end
  return curHandle
end

function ColorFillingView:ColorFill(widget, color)
  if color then
    widget.color = color
  end
end

function ColorFillingView:ResetAll()
  TableUtility.ArrayClear(handleRedoStack)
  local ids = {}
  local colors = {}
  local texts = {}
  for id, widget in pairs(self.colorWidgetMap) do
    local data = self.colorTemplate[id]
    local color = data and data.emptyColor and data.emptyColor or white
    ids[#ids + 1] = id
    colors[id] = widget.color
    self:ColorFill(widget, color)
  end
  for id, label in pairs(self.dialogLabelMap) do
    ids[#ids + 1] = id
    texts[id] = label.text
    self:SetDialogText(label, defaultText)
  end
  local handle = {}
  handle.id = ids
  handle.color = colors
  handle.text = texts
  self:PushStack(handle)
end

function ColorFillingView:AutoFilling()
  TableUtility.ArrayClear(handleRedoStack)
  local ids = {}
  local colors = {}
  local texts = {}
  for id, data in pairs(self.colorTemplate) do
    local widget = self.colorWidgetMap[id]
    if widget then
      ids[#ids + 1] = id
      colors[id] = widget.color
      self:ColorFill(widget, data.color)
    end
  end
  for id, data in pairs(self.dialogTemplate) do
    local label = self.dialogLabelMap[id]
    if label then
      ids[#ids + 1] = id
      texts[id] = label.text
      self:SetDialogText(label, data.content)
    end
  end
  local handle = {}
  handle.id = ids
  handle.color = colors
  handle.text = texts
  self:PushStack(handle)
end

function ColorFillingView:ZoomIn()
  self.zoomAreaTrans.localScale = LuaGeometry.GetTempVector3(1, 1, 1) * scaleSize
  self.dragArea.transform.localPosition = zoomInPos
  self.dragPanel.clipOffset = self.zoomInOffset
  self:SetZoomInBtnState(false)
end

function ColorFillingView:ZoomOut()
  self.zoomAreaTrans.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.dragArea.transform.localPosition = self.dragAreaDefaultPos
  self.dragPanel.clipOffset = LuaVector2.Zero()
  self:SetZoomInBtnState(true)
end

function ColorFillingView:OnComplete()
  if not self:OnSave() then
    MsgManager.ShowMsgByID(41466)
    self.isComplete = false
  else
    self.isComplete = true
  end
end

function ColorFillingView:OnSave()
  TableUtility.ArrayClear(saveColors)
  TableUtility.ArrayClear(saveDialogs)
  local isColorFilling = false
  for id, widget in pairs(self.colorWidgetMap) do
    local templateData = self.colorTemplate[id]
    local color = widget.color
    local info = {}
    local rgb = {}
    rgb.r = math.floor(color.r * 255 + 0.5)
    rgb.g = math.floor(color.g * 255 + 0.5)
    rgb.b = math.floor(color.b * 255 + 0.5)
    info.picid = id
    info.rgb = rgb
    saveColors[#saveColors + 1] = info
    if not isColorFilling and color ~= white and color ~= templateData.emptyColor then
      isColorFilling = true
    end
  end
  for id, label in pairs(self.dialogLabelMap) do
    local info = {}
    info.textid = id
    info.content = label.text
    saveDialogs[#saveDialogs + 1] = info
  end
  ServiceItemProxy.Instance:CallColoringModifyItemCmd(self.comicId, saveColors, saveDialogs)
  return isColorFilling
end

function ColorFillingView:OnColorFillingSave(data)
  if data.body.success then
    if self.isClose then
      self:CloseSelf()
    elseif self.isComplete then
      if GameConfig.ColorFilling and GameConfig.ColorFilling.directShare then
        ServiceItemProxy.Instance:CallColoringShareItemCmd(self.comicId)
        self:CloseSelf()
      else
        self:OpenShareView()
      end
    end
  end
end

function ColorFillingView:PushStack(handle)
  if #handleUndoStack >= self.maxUndoCount then
    table.remove(handleUndoStack, 1)
  end
  TableUtility.ArrayPushBack(handleUndoStack, handle)
end

function ColorFillingView:ClearStack()
  TableUtility.ArrayClear(handleUndoStack)
  TableUtility.ArrayClear(handleRedoStack)
end

function ColorFillingView:OpenColorChooseView()
  self.colorChooseView:ShowPanel()
end

function ColorFillingView:OpenShareView()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  local viewdata = {}
  local clones = self:CloneFillingArea()
  viewdata.comicId = self.comicId
  viewdata.pics = clones
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ColorFillingShareView,
    viewdata = viewdata
  })
end

function ColorFillingView:SetZoomInBtnState(state)
  self.zoomInBtn:SetActive(state)
  self.zoomOutBtn:SetActive(not state)
end

function ColorFillingView:OnColorCellClick(cell)
  local defaultColorCells = self.defaultColorList:GetCells()
  self:SetColorCellSelect(defaultColorCells, cell)
  local customColorCells = self.customColorList:GetCells()
  self:SetColorCellSelect(customColorCells, cell)
  self.selectColor = cell.data.color
end

function ColorFillingView:SetColorCellSelect(cells, cell)
  for i = 1, #cells do
    local colorCell = cells[i]
    if colorCell == cell then
      colorCell:SetColorSelect(true)
    else
      colorCell:SetColorSelect(false)
    end
  end
end

function ColorFillingView:OnColorChooseConfirm(color)
  self.customColorCount = math.min(self.customColorCount + 1, #self.customColors)
  for i = self.customColorCount, 2, -1 do
    self.customColors[i] = self.customColors[i - 1]
  end
  self.customColors[1] = color
  for i = 1, self.customColorCount do
    local data = {}
    data.color = self.customColors[i]
    data.isEmpty = false
    self.customColorList:UpdateCell(i, data)
  end
  local cells = self.customColorList:GetCells()
  local cell = cells[1]
  self:OnColorCellClick(cell)
end

function ColorFillingView:ShowTextBox()
  self.dialogView:ShowPanel()
end

function ColorFillingView:SetCurDialogText(text)
  if self.curDialogId then
    TableUtility.ArrayClear(handleRedoStack)
    self:DoFillDialogText(self.curDialogId, text)
    self.curDialogId = nil
  end
end

function ColorFillingView:DoFillDialogText(id, text)
  local label = self.dialogLabelMap[id]
  if label then
    local handle = {}
    handle.id = id
    handle.text = label.text
    self:PushStack(handle)
    self:SetDialogText(label, text)
  end
end

function ColorFillingView:SetDialogText(label, text)
  if text then
    label.text = text
  end
end

function ColorFillingView:CloneFillingArea()
  local clones = {}
  for i = 0, 3 do
    local clone = GameObject.Instantiate(self["fillingArea" .. i])
    clones[#clones + 1] = clone
  end
  return clones
end

function ColorFillingView:GetPixelColor(texPos, widget)
  local spriteData = widget:GetAtlasSprite()
  if not spriteData then
    return
  end
  local texture = widget.mainTexture
  if not texture then
    return
  end
  if texPos then
    local width = widget.width
    local height = widget.height
    if texPos.x < -width * 0.5 or texPos.y < -height * 0.5 or texPos.x > width * 0.5 or texPos.y > height * 0.5 then
      return
    end
    local x = texPos.x + width * 0.5
    local y = texPos.y + height * 0.5
    x = spriteData.x + x
    y = texture.height - spriteData.y - height + y
    local color = texture:GetPixel(x, y)
    return color
  end
end

function ColorFillingView:Update()
  if Input.touchCount >= 2 then
    self.isTouch2Fingers = true
    local x0, y0 = LuaGameObject.GetTouchPosition(0, false)
    local x1, y1 = LuaGameObject.GetTouchPosition(1, false)
    local x = x1 - x0
    local y = y1 - y0
    local distance = math.sqrt(x * x + y * y)
    if not self.dis2Fingers then
      self.dis2Fingers = distance
    end
    local touch1 = Input.GetTouch(0)
    local touch2 = Input.GetTouch(1)
    if touch1.phase == TouchPhase.Moved or touch2.phase == TouchPhase.Moved then
      local diff = distance - self.dis2Fingers
      local localScale = LuaGeometry.TempGetLocalScale(self.zoomAreaTrans)
      localScale = localScale + LuaGeometry.Const_V3_one * diff * 0.01
      localScale.x = math.min(localScale.x, scaleSize)
      localScale.x = math.max(localScale.x, 1)
      localScale.y = math.min(localScale.y, scaleSize)
      localScale.y = math.max(localScale.y, 1)
      localScale.z = math.min(localScale.z, scaleSize)
      localScale.z = math.max(localScale.z, 1)
      self.zoomAreaTrans.localScale = localScale
      self.dis2Fingers = distance
    end
  else
    self.isTouch2Fingers = false
    self.dis2Fingers = nil
  end
  if self.isTouch2Fingers then
    self.dragScrollView.enabled = false
  else
    self.dragScrollView.enabled = true
  end
end
