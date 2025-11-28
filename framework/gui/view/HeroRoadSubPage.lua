autoImport("HeroRoadDiffPathSmallNodeCell")
autoImport("HeroRoadDiffPathBigNodeCell")
autoImport("HeroRoadDiffNodePicCell")
HeroRoadSubPage = class("HeroRoadSubPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("HeroRoadSubPage")
local NodeType = {
  Small = 1,
  Big = 2,
  Spec = 3
}
local NodeTypeCell = {
  [NodeType.Small] = {
    class = HeroRoadDiffPathSmallNodeCell,
    prefab = "HeroRoadDiffPathSmallNodeCell"
  },
  [NodeType.Big] = {
    class = HeroRoadDiffPathBigNodeCell,
    prefab = "HeroRoadDiffPathBigNodeCell"
  },
  [NodeType.Spec] = {
    class = HeroRoadDiffPathBigNodeCell,
    prefab = "HeroRoadDiffPathSpecNodeCell"
  }
}
local NodeTypePicCell = {
  [NodeType.Big] = {
    class = HeroRoadDiffNodePicCell,
    prefab = "HeroRoadDiffNodePicCell"
  },
  [NodeType.Spec] = {
    class = HeroRoadDiffNodeSpecPicCell,
    prefab = "HeroRoadDiffNodeSpecPicCell"
  }
}
local ScrollTexName = "hero3_bg_01s"
local LogoName = "hero3_logo"

function HeroRoadSubPage:Init(param)
  self.groupId = param.groupId
  self.parent = param.parent
  self:LoadPrefab()
  self:FindObjs()
end

function HeroRoadSubPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.parent, true)
  obj.name = "HeroRoadSubPage_" .. self.groupId
  self.gameObject = obj
  self.trans = obj.transform
end

function HeroRoadSubPage:FindObjs()
  local diffNodeContainer = self:FindGO("DiffNodeContainer")
  local picNodeContainer = self:FindGO("PicContainer")
  self.diffList = {}
  self.diffPicList = {}
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.groupId)
  for i = 1, #diffs do
    if diffs[i] ~= PveEntranceProxy.EmptyDiff then
      local id = diffs[i].id
      local config = Table_HeroJourneyNode[id]
      if config then
        local info = NodeTypeCell[config.Type]
        local class = info and info.class
        local prefab = info and info.prefab
        if class and prefab then
          self.diffList[i] = class.new(prefab, diffNodeContainer)
          self.diffList[i]:SetPos(config.NodePos)
          self.diffList[i]:AddEventListener(MouseEvent.MouseClick, self.OnDiffNodeClick, self)
        end
        if not StringUtil.IsEmpty(config.Picture) then
          info = NodeTypePicCell[config.Type]
          class = info and info.class
          prefab = info and info.prefab
          if class and prefab then
            self.diffPicList[i] = class.new(prefab, picNodeContainer)
            self.diffPicList[i]:SetPos(config.PicPos)
            self.diffPicList[i]:AddEventListener(MouseEvent.MouseClick, self.OnNodePicClick, self)
          end
        end
      end
      if i == 2 then
        local pos = self.diffList[i]:GetPos()
        self.scrollPivotPos = self.trans.parent:InverseTransformPoint(pos)
      end
    end
  end
  local dragScrollView = self:FindGO("ItemDragScrollView")
  self:AddClickEvent(dragScrollView, function()
    self:PassEvent(HeroRoad_OnBgClick)
  end)
  self.scrollTex = self:FindComponent("ScrollTex", UITexture)
  self.nodeScrollView = self:FindComponent("DiffNodeScrollView", UIScrollView)
  
  function self.nodeScrollView.onDragStarted()
    self.isScrollMoving = true
    self.nodeScrollPos = self.nodeScrollView.transform.localPosition
  end
  
  function self.nodeScrollView.onStoppedMoving()
    self.isScrollMoving = false
  end
  
  self.linksTex = self:FindComponent("Links", UITexture)
  self.bgScrollView = self:FindComponent("BgScrollView", UIScrollView)
  self.logoTex = self:FindComponent("Logo", UITexture)
  self.logoLabel = self:FindComponent("SubLogo", UILabel)
end

function HeroRoadSubPage:OnEnter()
  local config = GameConfig.HeroRoad and GameConfig.HeroRoad[self.groupId]
  self.bgName = config and config.BgTex or ScrollTexName
  self.linkTexName = config and config.LinkTex or ""
  PictureManager.Instance:SetHeroRoadTexture(self.bgName, self.scrollTex)
  PictureManager.Instance:SetHeroRoadTexture(self.linkTexName, self.linksTex)
  self.linksTex:MakePixelPerfect()
  PictureManager.Instance:SetHeroRoadTexture(LogoName, self.logoTex)
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.groupId)
  if diffs[1] and diffs[1] ~= PveEntranceProxy.EmptyDiff then
    self.logoLabel.text = diffs[1].staticEntranceData.staticData.Name
  end
  self:AddMonoUpdateFunction(self.Update)
end

function HeroRoadSubPage:OnExit()
  PictureManager.Instance:UnloadHeroRoadTexture(self.bgName, self.scrollTex)
  PictureManager.Instance:UnloadHeroRoadTexture(self.linkTexName, self.linksTex)
  PictureManager.Instance:UnloadHeroRoadTexture(LogoName, self.logoTex)
  self:ClearDiffNodeList(self.diffList)
  self:ClearDiffNodeList(self.diffPicList)
  self:RemoveMonoUpdateFunction()
end

function HeroRoadSubPage:RefreshView()
  local diffs = PveEntranceProxy.Instance:GetDifficultyData(self.groupId)
  for i = 1, #diffs do
    if diffs[i] ~= PveEntranceProxy.EmptyDiff then
      local data = {}
      data.pvePassInfo = diffs[i]
      data.level = i
      data.isUnlocked = diffs[i].open or false
      if self.diffList[i] then
        self.diffList[i]:SetData(data)
      end
      if self.diffPicList[i] then
        self.diffPicList[i]:SetData(data)
      end
    end
  end
end

function HeroRoadSubPage:OnDiffNodeClick(cell)
  self.curNodeCell = cell
  cell:SetSelectState(true)
  for i = 1, #self.diffList do
    if self.diffList[i] and self.diffList[i] ~= cell then
      self.diffList[i]:SetSelectState(false)
    end
  end
  FunctionPve.Me():SetCurPve(cell.pvePassInfo.staticEntranceData)
  self:TryScrollToPivot()
  self:PassEvent(HeroRoad_OnDiffNodeClick, cell)
end

function HeroRoadSubPage:OnNodePicClick(cell)
  self.nodeScrollView:DisableSpring()
  if cell.pvePassInfo:CheckAccPass() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HeroRoadPicPopUp,
      viewdata = cell.id
    })
  else
    local levelStr = DifficultyPathNodeCell.LevelIndex[cell.level]
    local name = cell.name or ""
    local param = string.format("[%s %s]", levelStr, name)
    MsgManager.ShowMsgByID(43544, param)
  end
end

local ScrollTime = 0.5

function HeroRoadSubPage:TryScrollToPivot()
  local curNodePos = self.trans.parent:InverseTransformPoint(self.curNodeCell.trans.position)
  self.nodeScrollView:DisableSpring()
  self.isScrollMoving = true
  self.nodeScrollPos = self.nodeScrollView.transform.localPosition
  self.targetRelative = self.scrollPivotPos.x - curNodePos.x
  self.scrollSpeed = self.targetRelative / ScrollTime
  self.totalRelative = 0
end

function HeroRoadSubPage:ClearDiffNodeList(list)
  for _, cell in pairs(list) do
    if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
      cell:OnCellDestroy()
    end
    TableUtility.TableClear(cell)
  end
  TableUtility.TableClear(list)
end

function HeroRoadSubPage:InvalidateNodeScrollBounds()
  self.nodeScrollView:InvalidateBounds()
  self.nodeScrollView:RestrictWithinBounds(false)
end

local BgScrollMaxX = 155
local BgScrollMinX = -1041

function HeroRoadSubPage:Update(time, deltaTime)
  if self.scrollSpeed then
    local relativePerUpdate = self.scrollSpeed * deltaTime
    local relative = LuaGeometry.GetTempVector3(relativePerUpdate, 0, 0)
    self.nodeScrollView:MoveRelative(relative)
    self.isScrollMoving = true
    self.totalRelative = self.totalRelative + relativePerUpdate
    if math.abs(self.totalRelative) >= math.abs(self.targetRelative) then
      self.scrollSpeed = nil
    end
  end
  if not self.isScrollMoving then
    return
  end
  local relative = self.nodeScrollView.transform.localPosition - self.nodeScrollPos
  local x = math.clamp(self.bgScrollView.transform.localPosition.x + relative.x, BgScrollMinX, BgScrollMaxX)
  relative.x = x - self.bgScrollView.transform.localPosition.x
  self.bgScrollView:MoveRelative(relative)
  self.nodeScrollPos = self.nodeScrollView.transform.localPosition
end
