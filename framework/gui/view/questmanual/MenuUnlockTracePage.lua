MenuUnlockTracePage = class("MenuUnlockTracePage", SubView)
autoImport("FuncUnlockManulData")
autoImport("MenuUnlockTraceCell")
autoImport("MenuCategoryCell")
local reusableArray = {}
local questInstance = QuestProxy.Instance
local Offset = 50
local tempVector3 = LuaVector3.Zero()

function MenuUnlockTracePage:Init()
end

function MenuUnlockTracePage:TryInit()
  if not self.loaded then
    self:ReLoadPerferb("view/MenuUnlockTracePage", false)
    self.loaded = true
    self:initView()
    self:addViewEventListener()
    self:AddListenerEvts()
    self:initData()
  end
end

function MenuUnlockTracePage:initView()
  self.bgtexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.traceCellListCtr = UIGridListCtrl.new(self.table, MenuUnlockTraceCell, "MenuUnlockTraceCell")
  self.cateoryScrollview = self:FindGO("CateoryScrollview"):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.cateoryListCtr = UIGridListCtrl.new(self.grid, MenuCategoryCell, "MenuCategoryCell")
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.nPCName = self:FindComponent("NPCName", UILabel)
  self.contentSVPanel = self:FindGO("ContentScrollview"):GetComponent(UIPanel)
  self.contentScrollView = self:FindGO("ContentScrollview"):GetComponent(UIScrollView)
end

function MenuUnlockTracePage:Show(target)
  self:TryInit()
  MenuUnlockTracePage.super.Show(self, target)
  PictureManager.Instance:SetPuzzleBG("taskmanual_bg_bottom4_new", self.bgtexture)
end

function MenuUnlockTracePage:Hide(target)
  self:TryInit()
  helplog("====MenuUnlockTracePage:Hide==>>>")
  if self.modeltexture then
    UIModelUtil.Instance:ResetTexture(self.modeltexture)
  end
  MenuUnlockTracePage.super.Hide(self, target)
end

function MenuUnlockTracePage:initData()
end

function MenuUnlockTracePage:SetData()
  self:TryInit()
  local datas = QuestManualProxy.Instance:GetCategoryList()
  self.cateoryListCtr:ResetDatas(datas)
  local cells = self.cateoryListCtr:GetCells()
  self:UpdateFunctionDetail(cells[1])
  self.grid:Reposition()
  self.table:Reposition()
  self.cateoryScrollview:ResetPosition()
  self.contentScrollView:ResetPosition()
end

function MenuUnlockTracePage:OnEnter()
end

function MenuUnlockTracePage:OnExit()
  if self.modeltexture then
    UIModelUtil.Instance:ResetTexture(self.modeltexture)
  end
end

function MenuUnlockTracePage:addViewEventListener()
  self:AddListenEvt(ServiceEvent.QuestManualFunctionQuestCmd, self.SetData)
  EventManager.Me():AddEventListener(QuestManualEvent.FuncOpenToggleClick, self.ResetPostion, self)
end

function MenuUnlockTracePage:AddListenerEvts()
  self.cateoryListCtr:AddEventListener(MouseEvent.MouseClick, self.UpdateFunctionDetail, self)
end

function MenuUnlockTracePage:ResetPostion()
  self.table:Reposition()
  self.table.repositionNow = true
end

local CategoryConfig = GameConfig.FunctionOpening

function MenuUnlockTracePage:UpdateFunctionDetail(cell)
  if not cell then
    return
  end
  if cell.index then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_FUNCTION_OPENING, cell.index)
  end
  if self.currentSelectedCell then
    if self.currentSelectedCell == cell then
      self.currentSelectedCell:setIsSelected(true)
    else
      self.currentSelectedCell:setIsSelected(false)
    end
  end
  self.currentSelectedCell = cell
  if not self.currentSelectedCell then
    return
  end
  self.currentSelectedCell:setIsSelected(true)
  local categoryData = QuestManualProxy.Instance:GetFunctionOpeningData(cell.index)
  self.traceCellListCtr:ResetDatas(categoryData)
  local cells = self.traceCellListCtr:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateDepth(self.contentSVPanel.depth)
  end
  if CategoryConfig and CategoryConfig[cell.index] then
    local single = CategoryConfig[cell.index]
    self:Show3DModel(single)
    LuaVector3.Better_Set(tempVector3, 0, single.NpcSpace or 0, 0)
    self.modeltexture.gameObject.transform.localPosition = tempVector3
  end
  self.contentScrollView:ResetPosition()
end

function MenuUnlockTracePage:Show3DModel(config)
  if not config or not config.npcid then
    return
  end
  local sdata = Table_Npc[config.npcid]
  if sdata then
    local otherScale = 1
    if config.NpcScale then
      otherScale = config.NpcScale
    elseif sdata.Scale then
      otherScale = sdata.Scale
    elseif sdata.Shape then
      otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
    end
    if self.modelId and self.modelId ~= sdata.id then
      UIModelUtil.Instance:ClearModel(self.modeltexture)
    end
    self.modelId = sdata.id
    self.nPCName.text = sdata.NameZh
    UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id, nil, function(obj)
      self.model = obj
      UIModelUtil.Instance:SetCellTransparent(self.modeltexture)
      local showPos = sdata.LoadShowPose
      if showPos and #showPos == 3 then
        LuaVector3.Better_Set(tempVector3, showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
        self.model:SetPosition(tempVector3)
      end
      if sdata.LoadShowRotate then
        self.model:SetEulerAngleY(sdata.LoadShowRotate)
      end
      if sdata.LoadShowSize then
        otherScale = sdata.LoadShowSize
      end
      self.model:SetScale(otherScale)
    end)
  end
end

function MenuUnlockTracePage:ResizeScrollview(isExtended)
  if self.scrollview.panel then
    if isExtended then
      self.scrollview.panel.baseClipRegion = Vector4(0, -50, 414, 358 + Offset * 2)
    else
      self.scrollview.panel.baseClipRegion = Vector4(0, 0, 414, 358)
    end
  end
end
