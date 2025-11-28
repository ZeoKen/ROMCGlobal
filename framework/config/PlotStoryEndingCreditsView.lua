PlotStoryEndingCreditsView = class("PlotStoryEndingCreditsView", BaseView)
PlotStoryEndingCreditsView.ViewType = UIViewType.InterstitialLayer
local ElementType = {
  CREDITS = 1,
  IMAGE = 2,
  ANIM = 3
}
local Pivot = {LEFT = 1, RIGHT = 2}
local creditsPrefabName = "PlotStoryEDCredits"
local creditsImagePrefabName = "PlotStoryEDImage"
local creditsAnimPrefabName = "PlotStoryEDAnim"
local videoPlayerPrefabName = "PlotStoryEDVideoPlayer"
local videoRootPath = ApplicationHelper.persistentDataPath .. "/" .. ApplicationInfo.GetRunPlatformStr() .. "/Videos/PlotED/"

function PlotStoryEndingCreditsView:Init()
  self.uiPanel = self.gameObject:GetComponent(UIPanel)
  self.creditsRoot = self:FindGO("creditsRoot")
  self.videoPanel = self:FindGO("videoPanel")
  self.skipBtn = self:FindGO("skipBtn")
  self:AddClickEvent(self.skipBtn, function()
    Game.PlotStoryManager:DoSkip()
  end)
  self.skipBtn:SetActive(false)
  self.scrollElements = {}
  self.videoPlayers = {}
  self.top = 0
  self.left = 0
  self.right = 0
  self.speed = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.speed
  self:AddListenEvt(PlotStoryViewEvent.AddCredits, self.HandleAddCredits)
  self:AddListenEvt(PlotStoryViewEvent.AddEDImage, self.HandleAddImage)
  self:AddListenEvt(PlotStoryViewEvent.PlayEDVideo, self.HandlePlayVideo)
end

function PlotStoryEndingCreditsView:OnEnter()
  local corners = self.uiPanel.localCorners
  self.top = corners[2].y - self.creditsRoot.transform.localPosition.y
  self.left = corners[2].x
  self.right = corners[3].x
  self:AddMonoUpdateFunction(self.Update)
  local skipDelay = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.skipDelay or 0
  TimeTickManager.Me():CreateOnceDelayTick(skipDelay * 1000, function()
    self.skipBtn:SetActive(true)
  end, self)
end

function PlotStoryEndingCreditsView:OnExit()
  PlotStoryEndingCreditsView.super.OnExit(self)
  TableUtility.ArrayClearByDeleter(self.scrollElements, function(element)
    element:Destroy()
  end)
  TableUtility.ArrayClearByDeleter(self.videoPlayers, function(videoPlayer)
    self:CloseVideo(videoPlayer)
  end)
  self.top = 0
  self.left = 0
  self.right = 0
end

function PlotStoryEndingCreditsView:HandleAddCredits(note)
  local params = note.body
  self:AddCredits(params)
end

function PlotStoryEndingCreditsView:HandleAddImage(note)
  local params = note.body
  self:AddImage(params)
end

function PlotStoryEndingCreditsView:HandlePlayVideo(note)
  local params = note.body
  self:AddVideo(params)
end

function PlotStoryEndingCreditsView:AddElement(element)
  TableUtility.ArrayPushBack(self.scrollElements, element)
end

function PlotStoryEndingCreditsView:RemoveElement(element)
  TableUtility.ArrayRemove(self.scrollElements, element)
  element:Destroy()
end

function PlotStoryEndingCreditsView:AddCredits(params)
  if not params then
    return
  end
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Plot(creditsPrefabName), self.creditsRoot)
  if not go then
    redlog("prefab not exist---" .. creditsPrefabName)
    return
  end
  local element = PlotStoryEndingCreditsElement.new(go, ElementType.CREDITS, self.speed, params)
  self:AddElement(element)
end

function PlotStoryEndingCreditsView:AddImage(params)
  if not params then
    return
  end
  local isAnim = params.isAnim
  local pivot = params.pivot
  local prefab = creditsImagePrefabName
  local type = ElementType.IMAGE
  if isAnim then
    prefab = creditsAnimPrefabName
    type = ElementType.ANIM
  end
  if pivot == Pivot.LEFT then
    params.left = self.left
  elseif pivot == Pivot.RIGHT then
    params.right = self.right
  end
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Plot(prefab), self.creditsRoot)
  if not go then
    redlog("prefab not exist---", prefab)
    return
  end
  local element = PlotStoryEndingCreditsElement.new(go, type, self.speed, params)
  self:AddElement(element)
end

function PlotStoryEndingCreditsView:AddVideo(params)
  local path = params.path .. ".mp4"
  local offset = params.offset
  local pivot = params.pivot
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Plot(videoPlayerPrefabName), self.videoPanel)
  if not go then
    redlog("prefab not exist---", videoPlayerPrefabName)
    return
  end
  if offset then
    go.transform.localPosition = LuaGeometry.GetTempVector3(offset, 0, 0)
  end
  local videoPlayer = go:GetComponent(VideoPlayerNGUI)
  self:InitVideoPlayer(videoPlayer, pivot)
  TableUtility.ArrayPushBack(self.videoPlayers, videoPlayer)
  self:PlayVideo(videoPlayer, path)
end

function PlotStoryEndingCreditsView:RemoveVideo(videoPlayer)
  TableUtility.ArrayRemove(self.videoPlayers, videoPlayer)
  self:CloseVideo(videoPlayer)
end

function PlotStoryEndingCreditsView:InitVideoPlayer(videoPlayer, pivot)
  function videoPlayer.onStarted()
    self:SetVideoTexture(videoPlayer, pivot)
  end
  
  function videoPlayer.onFinishedPlaying()
    self:RemoveVideo(videoPlayer)
  end
  
  function videoPlayer.onError()
    MsgManager.ShowMsgByIDTable(41491)
  end
end

function PlotStoryEndingCreditsView:PlayVideo(videoPlayer, path)
  local fullPath = videoRootPath .. path
  if FileHelper.ExistFile(fullPath) then
    videoPlayer:OpenVideo(fullPath, true)
  else
    videoPlayer:OpenVideo("Videos/PlotED/" .. path, false)
  end
end

function PlotStoryEndingCreditsView:CloseVideo(videoPlayer)
  videoPlayer:Close()
  local go = videoPlayer.gameObject
  Game.GOLuaPoolManager:AddToUIPool(go.name, go)
end

function PlotStoryEndingCreditsView:SetVideoTexture(videoPlayer, pivot)
  local rootSize, vRatio = UIManagerProxy.Instance:GetUIRootSize(), videoPlayer:GetVideoTextureRatio()
  local height = rootSize[2]
  local width = height * vRatio
  videoPlayer:SetTextureSize(width, height)
  local x = 0
  if pivot == Pivot.LEFT then
    x = self.left + width * 0.5
  elseif pivot == Pivot.RIGHT then
    x = self.right - width * 0.5
  end
  local trans = videoPlayer.transform
  trans.localPosition = LuaGeometry.GetTempVector3(x, 0, 0)
end

function PlotStoryEndingCreditsView:Update(time, deltaTime)
  for i = #self.scrollElements, 1, -1 do
    local element = self.scrollElements[i]
    element:Update(time, deltaTime)
    if element:isOutOfLimit(self.top) then
      self:RemoveElement(element)
    end
  end
end

PlotStoryEndingCreditsElement = class("PlotStoryEndingCreditsElement", CoreView)
local creditsCellPrefabName = "PlotStoryEDCreditsCell"
local _speed = 50

function PlotStoryEndingCreditsElement:ctor(go, type, speed, params)
  PlotStoryEndingCreditsElement.super.ctor(self, go)
  self.speed = speed or _speed
  local offset = params.offset
  if offset then
    go.transform.localPosition = LuaGeometry.GetTempVector3(offset, 0, 0)
  end
  if type == ElementType.CREDITS then
    self.children = {}
    self:InitCredits(params)
  elseif type == ElementType.IMAGE then
    self:InitImage(params)
  elseif type == ElementType.ANIM then
    self:InitAnim(params)
  end
end

function PlotStoryEndingCreditsElement:InitCredits(params)
  local id = params.id
  local data = Table_Credits[id]
  if not data then
    return
  end
  self.title = self:FindComponent("title", UILabel)
  self.grid = self:FindComponent("grid", UIGrid)
  if data.columnNum then
    self.grid.maxPerLine = data.columnNum
  end
  if data.cellWidth then
    self.grid.cellWidth = data.cellWidth
  end
  if data.cellHeight then
    self.grid.cellHeight = data.cellHeight
  end
  self.title.text = data.title
  if data.titleFontSize then
    self.title.fontSize = data.titleFontSize
  end
  if not StringUtil.IsEmpty(data.titleFontColor) then
    local _, color = ColorUtil.TryParseHexString(data.titleFontColor)
    self.title.color = color
  end
  self:CreateChild(data.content, data.contentFontSize, data.contentFontColor)
end

function PlotStoryEndingCreditsElement:InitImage(params)
  self.name = params.name
  self.texture = self.gameObject:GetComponent(UITexture)
  PictureManager.Instance:SetPlotEDTexture(self.name, self.texture)
  self.texture:MakePixelPerfect()
  local x = 0
  if params.left then
    x = params.left + self.texture.width * 0.5
  elseif params.right then
    x = params.right - self.texture.width * 0.5
  end
  self.trans.localPosition = LuaGeometry.GetTempVector3(x, 0, 0)
end

function PlotStoryEndingCreditsElement:InitAnim(params)
  local name = params.name
  self:PlayUIEffect(EffectMap.UI[name], self.gameObject)
end

function PlotStoryEndingCreditsElement:CreateChild(contents, fontSize, color)
  if contents then
    for i = 1, #contents do
      local content = contents[i]
      local child = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPrefab_Plot(creditsCellPrefabName), self.grid.gameObject)
      if child then
        local label = child:GetComponent(UILabel)
        label.text = content
        if fontSize then
          label.fontSize = fontSize
        end
        if not StringUtil.IsEmpty(color) then
          local _, c = ColorUtil.TryParseHexString(color)
          label.color = c
        end
        self.children[#self.children + 1] = child
      end
    end
    self.grid:Reposition()
  end
end

function PlotStoryEndingCreditsElement:isOutOfLimit(limit)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.trans)
  local y = bound.min.y + self.trans.localPosition.y
  return limit < y
end

function PlotStoryEndingCreditsElement:Update(time, deltaTime)
  local x, y, z = LuaGameObject.GetLocalPosition(self.trans)
  y = y + self.speed * deltaTime
  self.trans.localPosition = LuaGeometry.GetTempVector3(x, y, z)
end

function PlotStoryEndingCreditsElement:Destroy()
  if self.children then
    TableUtility.ArrayClearByDeleter(self.children, function(child)
      Game.GOLuaPoolManager:AddToUIPool(creditsCellPrefabName, child)
    end)
    self.children = nil
  end
  self.grid = nil
  self.title = nil
  if self.texture then
    PictureManager.Instance:UnloadPlotEDTexture(self.name, self.texture)
    self.texture = nil
    self.name = nil
  end
  if self.effectContainer then
    self:DestroyUIEffects()
    self.effectContainer = nil
  end
  self.trans = nil
  Game.GOLuaPoolManager:AddToUIPool(self.gameObject.name, self.gameObject)
  self.gameObject = nil
end
