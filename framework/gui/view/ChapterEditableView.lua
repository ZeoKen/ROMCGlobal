ChapterEditableView = class("ChapterEditableView", ContainerView)
ChapterEditableView.ViewType = UIViewType.MovieLayer
local FadeColor = {
  [1] = LuaColor.black,
  [2] = LuaColor.white,
  [3] = LuaColor.red,
  [4] = LuaColor.black
}

function ChapterEditableView:Init()
  self:AddEventListener()
  self.uiPrefabMap = {}
  self.uiPrefabTexMap = {}
  self.root = self:FindGO("Root"):GetComponent(UISprite)
  self.root.alpha = 0
  self.mask = self:FindGO("BlackBG"):GetComponent(UISprite)
  self.editableRoot = self:FindGO("EditableUI", self.root.gameObject)
  self.editableRoot:SetActive(false)
  self.prefabRoot = self:FindGO("PrefabRoot", self.root.gameObject)
  self.data = self.viewdata.viewdata and self.viewdata.viewdata
  self.questData = self.data.questData
  if self.questData then
    self.inTime = self.questData.params.fadein or 0
    self.outTime = self.questData.params.fadeout or 0
    self.duration = self.questData.params.time or 0
    self.color = self.questData.params.color or 1
    self.chapterID = self.questData.params.chapter
    self.alpha = self.questData.params.alpha
  else
    self.inTime = self.data.inTime or 0
    self.outTime = self.data.outTime or 0
    self.duration = self.data.time
    self.color = self.data.color or 1
    self.chapterID = self.data.chapter
    self.alpha = self.data.alpha
  end
  self.chapterConfig = self.chapterID and GameConfig.chapter_editable and GameConfig.chapter_editable[self.chapterID]
  if self.chapterConfig then
    self.editableRoot:SetActive(true)
    self:InitEditableUI()
  end
  self:DefaultColorMask()
end

function ChapterEditableView:AddEventListener()
  self:AddListenEvt(PlotStoryViewEvent.HideMask, self.HandleHideMask)
  self:AddListenEvt(PlotStoryViewEvent.AddUIPrefab, self.HandleAddUIPrefab)
  self:AddListenEvt(PlotStoryViewEvent.RemoveUIPrefab, self.HandleRemoveUIPrefab)
end

function ChapterEditableView:InitEditableUI()
  self.topSp = self:FindGO("TopSp", self.editableRoot):GetComponent(UISprite)
  self.topSpBg = self:FindGO("TopSpBg", self.topSp.gameObject):GetComponent(UISprite)
  self.topSpFrame = self:FindGO("TopSpFrame", self.editableRoot)
  self.topSpFrame1 = self:FindGO("Frame1", self.topSpFrame):GetComponent(UISprite)
  self.topSpFrame2 = self:FindGO("Frame2", self.topSpFrame):GetComponent(UISprite)
  self.iconLab = self:FindGO("IconLab", self.editableRoot):GetComponent(UILabel)
  self.nameLab = self:FindGO("NameLab", self.editableRoot):GetComponent(UILabel)
  self.lineTexture = self:FindGO("LineTexture", self.editableRoot):GetComponent(UITexture)
  self.descLab = self:FindGO("DescLab", self.editableRoot):GetComponent(UILabel)
  self.bottomLab = self:FindGO("BottomLab", self.editableRoot):GetComponent(UILabel)
  self.leftSp = self:FindGO("LeftSp", self.bottomLab.gameObject):GetComponent(UIWidget)
  self.rightSp = self:FindGO("RightSp", self.bottomLab.gameObject):GetComponent(UIWidget)
  self:SetEditableUI()
end

function ChapterEditableView:SetEditableUI()
  local config = self.chapterConfig
  IconManager:SetChapterIcon(config.TopSp.name, self.topSp)
  self.topSp:MakePixelPerfect()
  local success, color = ColorUtil.TryParseHexString(config.TopSp.color)
  if success then
    self.topSp.color = color
  end
  self.topSpBg.spriteName = config.TopSpBg.name
  self.topSpBg:MakePixelPerfect()
  local success, color = ColorUtil.TryParseHexString(config.TopSpBg.color)
  if success then
    self.topSpBg.color = color
    self.topSpBg.alpha = config.TopSpBg.alpha or 1
  end
  if config.IconLab then
    self.iconLab.gameObject:SetActive(true)
    self.iconLab.text = config.IconLab.name
    local success, color = ColorUtil.TryParseHexString(config.IconLab.color)
    if success then
      self.iconLab.color = color
    end
  else
    self.iconLab.gameObject:SetActive(false)
  end
  self.nameLab.text = config.NameLab.name
  local success, color = ColorUtil.TryParseHexString(config.NameLab.color)
  if success then
    self.nameLab.color = color
  end
  self.lineName = config.LineTexture.name
  PictureManager.Instance:SetUI(self.lineName, self.lineTexture)
  local success, color = ColorUtil.TryParseHexString(config.LineTexture.color)
  if success then
    self.lineTexture.color = color
  end
  self.descLab.text = config.DescLab.name
  local success, color = ColorUtil.TryParseHexString(config.DescLab.color)
  if success then
    self.descLab.color = color
  end
  if config.BottomLab then
    self.bottomLab.gameObject:SetActive(true)
    self.bottomLab.text = config.BottomLab.name
    local success, color = ColorUtil.TryParseHexString(config.BottomLab.color)
    if success then
      self.bottomLab.color = color
      self.leftSp.color = color
      self.rightSp.color = color
    end
    self.leftSp:ResetAndUpdateAnchors()
    self.rightSp:ResetAndUpdateAnchors()
  else
    self.bottomLab.gameObject:SetActive(false)
  end
  if config.TopSpFrame and 1 < #config.TopSpFrame then
    self.topSpFrame:SetActive(true)
    local success, color
    success, color = ColorUtil.TryParseHexString(config.TopSpFrame[1])
    if success then
      self.topSpFrame1.color = color
    end
    self.topSpFrame1.alpha = 0.5
    success, color = ColorUtil.TryParseHexString(config.TopSpFrame[2])
    if success then
      self.topSpFrame2.color = color
    end
    self.topSpFrame1.alpha = 0.6
  else
    self.topSpFrame:SetActive(false)
  end
end

function ChapterEditableView:DefaultColorMask()
  if self.color and FadeColor[self.color] then
    self.mask.color = FadeColor[self.color]
    if self.color == 4 then
      self.mask.alpha = self.alpha or 0.5
    elseif self.alpha then
      self.mask.alpha = self.alpha
    end
  end
  self:ClearTick()
  helplog(self.inTime, self.outTime, tostring(self.duration))
  local inTime = (1 - self.root.alpha) * self.inTime
  LeanTween.alphaNGUI(self.root, self.root.alpha, 1, inTime)
  if self.duration then
    self.timeTick = TimeTickManager.Me():CreateOnceDelayTick((self.duration - self.outTime) * 1000, function(owner, deltaTime)
      LeanTween.alphaNGUI(self.root, 1, 0, self.outTime)
    end, self, 2)
    self.timeTickEnd = TimeTickManager.Me():CreateOnceDelayTick(self.duration * 1000, function(owner, deltaTime)
      if self.questData then
        QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
      end
      self:ClearTick()
      self:CloseSelf()
    end, self, 3)
  end
end

function ChapterEditableView:HandleHideMask(note)
  local outTime = note and note.body or 0
  self:HideMask(outTime)
end

function ChapterEditableView:HandleAddUIPrefab(note)
  local params = note and note.body
  if params then
    local id = params.id
    local prefabName = params.prefabName
    local prefabPos = params.pos
    local prefabScale = params.scale
    local title = params.title
    local titleFontsize = params.title_fontsize
    local texName = params.texName
    local inTime = params.inTime
    self:AddUIPrefab(id, prefabName, prefabPos, prefabScale, title, titleFontsize, texName, inTime)
  end
end

function ChapterEditableView:HandleRemoveUIPrefab(note)
  local params = note and note.body
  if params then
    local id = params.id
    local outTime = params.outTime
    self:RemoveUIPrefab(id, outTime)
  end
end

function ChapterEditableView:HideMask(outTime)
  outTime = outTime * self.root.alpha
  LeanTween.alphaNGUI(self.root, self.root.alpha, 0, outTime)
  TimeTickManager.Me():CreateOnceDelayTick(outTime * 1000, function(owner, deltaTime)
    if self.questData then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
    end
    self:CloseSelf()
  end, self)
end

function ChapterEditableView:AddUIPrefab(id, prefabName, prefabPos, prefabScale, title, titleFontsize, texName, inTime)
  local prefabGo = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Chapter(prefabName), self.prefabRoot.transform)
  if prefabGo then
    if prefabPos then
      LuaGameObject.SetLocalPositionGO(prefabGo, prefabPos[1], prefabPos[2], prefabPos[3])
    end
    if prefabScale then
      LuaGameObject.SetLocalScaleGO(prefabGo, prefabScale, prefabScale, prefabScale)
    end
    if title then
      local titleLabel = self:FindComponent("title", UILabel, prefabGo)
      if titleLabel then
        titleLabel.text = title
        if titleFontsize then
          titleLabel.fontSize = titleFontsize
        end
      end
    end
    if texName then
      local texture = self:FindComponent("Texture", UITexture, prefabGo)
      if texture then
        PictureManager.Instance:SetChapterTexture(texName, texture)
        texture:MakePixelPerfect()
        self.uiPrefabTexMap[id] = texName
      end
    end
    if inTime then
      local widget = prefabGo:GetComponent(UIWidget)
      if widget then
        LeanTween.alphaNGUI(widget, 0, 1, inTime)
      end
    end
    self.uiPrefabMap[id] = prefabGo
  end
end

function ChapterEditableView:RemoveUIPrefab(id, outTime)
  if not self.uiPrefabMap then
    return
  end
  local prefabGo = self.uiPrefabMap[id]
  if prefabGo then
    if outTime then
      local widget = prefabGo:GetComponent(UIWidget)
      if widget then
        LeanTween.alphaNGUI(widget, 1, 0, outTime)
      end
      TimeTickManager.Me():CreateOnceDelayTick(outTime * 1000, function()
        self:DestroyUIPrefab(id)
      end, self)
    else
      self:DestroyUIPrefab(id)
    end
  end
end

function ChapterEditableView:DestroyUIPrefab(id)
  if not self.uiPrefabMap then
    return
  end
  local prefabGo = self.uiPrefabMap[id]
  if prefabGo then
    local key = prefabGo.name
    local texName = self.uiPrefabTexMap[id]
    if texName then
      self:UnloadUIPrefabTex(prefabGo, texName)
      self.uiPrefabTexMap[id] = nil
    end
    Game.GOLuaPoolManager:AddToUIPool(key, prefabGo)
    self.uiPrefabMap[id] = nil
  end
end

function ChapterEditableView:UnloadUIPrefabTex(go, texName)
  local texture = self:FindComponent("Texture", UITexture, go)
  if texture then
    PictureManager.Instance:UnloadChapterTexture(texName, texture)
  end
end

function ChapterEditableView:ClearTick()
  if self.timeTick or self.timeTickEnd then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
    self.timeTickEnd = nil
  end
end

function ChapterEditableView:OnEnter()
  ChapterEditableView.super.OnEnter(self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.Show3D2DLayer, false)
end

function ChapterEditableView:OnExit()
  self:ClearTick()
  if nil ~= self.lineName then
    PictureManager.Instance:UnLoadUI(self.lineName, self.lineTexture)
  end
  for id, _ in pairs(self.uiPrefabMap) do
    self:DestroyUIPrefab(id)
  end
  TableUtility.TableClear(self.uiPrefabTexMap)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.Show3D2DLayer, true)
end
