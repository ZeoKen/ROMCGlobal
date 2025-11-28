autoImport("QuestMini1Point")
autoImport("QuestMini1Line")
QuestMiniGame1DebugPanel = class("QuestMiniGame1DebugPanel", BaseView)
QuestMiniGame1DebugPanel.ViewType = UIViewType.NormalLayer
local pointPfb = "QuestMini1Point"
local linePfb = "QuestMini1Line"
local screenWidth, screenHeight
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local isRunOnStandalone = Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.OSXPlayer

function QuestMiniGame1DebugPanel:Init()
  self.title = self:FindComponent("title", UILabel)
  self.title.text = "QTE测试界面"
  self.debugContainer = self:FindGO("debugContainer")
  self.debugContainer:SetActive(true)
  self.drawline = self:FindComponent("DrawLine", UIToggle, self.debugContainer)
  self:AddClickEvent(self:FindGO("Clear", self.debugContainer), function()
    self:ClearAll()
  end)
  self.container = self:FindGO("container")
end

function QuestMiniGame1DebugPanel:OnEnter()
  QuestMiniGame1DebugPanel.super.OnEnter(self)
  screenWidth, screenHeight = NGUITools.screenSize.x, NGUITools.screenSize.y
  if math.abs(NGUITools.screenSize.x / NGUITools.screenSize.y - 1.7777777777777777) < 0.01 then
    self.title.text = "当前屏幕比例为16:9"
  else
    self.title.text = "[ff0000]当前屏幕比例不是16:9, 请调整[-]"
  end
  Game.GUISystemManager:AddMonoLateUpdateFunction(self.LateUpdate, self)
  self:ClearAll()
end

function QuestMiniGame1DebugPanel:OnExit()
  Game.GUISystemManager:ClearMonoLateUpdateFunction(self)
  QuestMiniGame1DebugPanel.super.OnExit(self)
end

local touchPos

function QuestMiniGame1DebugPanel:LateUpdate()
  if isRunOnStandalone or isRunOnEditor then
    touchPos = LuaVector2(Input.mousePosition.x, Input.mousePosition.y)
    if Input.GetMouseButtonDown(0) then
      self:DrawPoint(touchPos)
    end
  elseif 0 < Input.touchCount then
    local touch = Input.GetTouch(0)
    if touch.phase == TouchPhase.Began then
      touchPos = touch.position
      self:DrawPoint(touchPos)
    end
  end
end

function QuestMiniGame1DebugPanel:DrawPoint(pos)
  if not pos then
    return
  end
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return
  end
  local pointpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(pointPfb))
  pointpfb.transform:SetParent(self.container.transform, false)
  pointpfb.transform.position = uiCamera:ScreenToWorldPoint(LuaGeometry.GetTempVector3(pos.x, pos.y, 0))
  local point = QuestMini1Point.new(pointpfb)
  local sx = pos.x * 100 / screenWidth - 50
  local sy = pos.y * 100 / screenHeight - 50
  point:SetText(string.format([[


(%.1f,%.1f)]], sx, sy))
  redlog(string.format("(%.1f,%.1f)", sx, sy))
  TableUtility.ArrayPushBack(self.pointList, point)
  if self.drawline.value and #self.pointList > 1 then
    local l = #self.pointList
    local linepfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(linePfb))
    linepfb.transform:SetParent(self.container.transform, false)
    local line = QuestMini1Line.new(linepfb)
    line:SetLine(self.pointList[l - 1].gameObject.transform.localPosition, self.pointList[l].gameObject.transform.localPosition)
    TableUtility.ArrayPushBack(self.lineList, line)
  end
end

function QuestMiniGame1DebugPanel:ClearAll()
  if not self.pointList then
    self.pointList = {}
  else
    for i = 1, #self.pointList do
      self.pointList[i]:DestroyEffects()
      GameObject.DestroyImmediate(self.pointList[i].gameObject)
    end
    TableUtility.ArrayClear(self.pointList)
  end
  if not self.lineList then
    self.lineList = {}
  else
    for i = 1, #self.lineList do
      self.lineList[i]:DestroyEffects()
      GameObject.DestroyImmediate(self.lineList[i].gameObject)
    end
    TableUtility.ArrayClear(self.lineList)
  end
end
