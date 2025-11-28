autoImport("GVGRoadBlockEditorCell")
GVGRoadBlockEditorView = class("GVGRoadBlockEditorView", ContainerView)
GVGRoadBlockEditorView.ViewType = UIViewType.PopUpLayer
local MapTexName = "GVG_map"
local ClassicMapTexName = "GVG_map2"
local ForbiddenMapTexName = "Novicecopy_diaoluo_bg2"

function GVGRoadBlockEditorView:Init()
  self.isClassicCity = GuildProxy.Instance:IHaveClassicCity()
  self:AddListenEvts()
  self:InitData()
  self:FindObjs()
  self:InitView()
end

function GVGRoadBlockEditorView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRoadblockModifyGuildCmd, self.OnRoadBlockModified)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRoadblockQueryGuildCmd, self.RefreshView)
end

function GVGRoadBlockEditorView:InitData()
  self.blockStates = {}
end

function GVGRoadBlockEditorView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(530, self:FindGO("HelpButton"))
  self.editableRoot = self:FindGO("EditableType")
  self.classicRoot = self:FindGO("ClassicType")
  self.descLab = self:FindComponent("DescLab", UILabel)
  self:InitEditableGOs()
  self:InitClassicGOs()
end

function GVGRoadBlockEditorView:InitEditableGOs()
  self.mapTex = self:FindComponent("MapTex", UITexture, self.editableRoot)
  self.blockIconA1 = self:FindComponent("blockA1", UIMultiSprite, self.editableRoot)
  self.blockIconA2 = self:FindComponent("blockA2", UIMultiSprite, self.editableRoot)
  self.blockIconB1 = self:FindComponent("blockB1", UIMultiSprite, self.editableRoot)
  self.blockIconB2 = self:FindComponent("blockB2", UIMultiSprite, self.editableRoot)
  self.blockIconB3 = self:FindComponent("blockB3", UIMultiSprite, self.editableRoot)
  self.blockIconC1 = self:FindComponent("blockC1", UIMultiSprite, self.editableRoot)
  self.blockIconC2 = self:FindComponent("blockC2", UIMultiSprite, self.editableRoot)
  local grid = self:FindComponent("BlockGrid", UIGrid, self.editableRoot)
  self.blockListCtrl = UIGridListCtrl.new(grid, GVGRoadBlockEditorCell, "GVGRoadBlockEditorCell")
  self.blockListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleBlockSelect, self)
  self.saveBtn = self:FindGO("SaveBtn", self.editableRoot)
  self:AddClickEvent(self.saveBtn, function()
    self:OnSaveBtnClick()
  end)
  self.saveBtnGrey = self:FindGO("SaveBtnGrey", self.editableRoot)
end

function GVGRoadBlockEditorView:InitClassicGOs()
  self.forbiddenTex = self:FindComponent("ForbiddenTexture", UITexture, self.classicRoot)
  self.classicMapTex = self:FindComponent("ClassicMapTex", UITexture, self.classicRoot)
end

function GVGRoadBlockEditorView:InitView()
  if self.isClassicCity then
    self:Show(self.classicRoot)
    self:Hide(self.editableRoot)
    self.descLab.text = ZhString.GVGRoadBlockEditorView_Desc_Type2
  else
    self:Show(self.editableRoot)
    self:Hide(self.classicRoot)
    self.descLab.text = ZhString.GVGRoadBlockEditorView_Desc_Type1
    ServiceGuildCmdProxy.Instance:CallGvgRoadblockQueryGuildCmd()
  end
end

function GVGRoadBlockEditorView:RefreshView()
  self.roadBlock = GvgProxy.Instance:GetMyGuildRoadBlock()
  local datas = ReusableTable.CreateArray()
  local mod = self.roadBlock or 0
  for i = 1, 3 do
    local data = {}
    data.index = i
    data.state = mod // 10 ^ (3 - i)
    mod = mod % 10 ^ (3 - i)
    datas[#datas + 1] = data
    self.blockStates[i] = data.state
  end
  self.blockListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
end

function GVGRoadBlockEditorView:OnEnter()
  PictureManager.Instance:SetRoadBlockTexture(MapTexName, self.mapTex)
  PictureManager.Instance:SetRoadBlockTexture(ClassicMapTexName, self.classicMapTex)
  PictureManager.Instance:SetUI(ForbiddenMapTexName, self.forbiddenTex)
end

function GVGRoadBlockEditorView:OnExit()
  PictureManager.Instance:UnloadRoadBlockTexture(MapTexName, self.mapTex)
  PictureManager.Instance:UnloadRoadBlockTexture(ClassicMapTexName, self.classicMapTex)
  PictureManager.Instance:UnLoadUI(ForbiddenMapTexName, self.forbiddenTex)
end

function GVGRoadBlockEditorView:HandleBlockSelect(cell)
  local state = cell.state
  if cell.index == 1 then
    self.blockIconA1.CurrentState = state == 1 and 1 or 0
    self.blockIconA2.CurrentState = state == 2 and 1 or 0
  elseif cell.index == 2 then
    self.blockIconB1.CurrentState = state == 1 and 1 or 0
    self.blockIconB2.CurrentState = state == 2 and 1 or 0
    self.blockIconB3.CurrentState = state == 3 and 1 or 0
  elseif cell.index == 3 then
    self.blockIconC1.CurrentState = state == 1 and 1 or 0
    self.blockIconC2.CurrentState = state == 2 and 1 or 0
  end
  if not self.isDirty then
    self.isDirty = state ~= self.blockStates[cell.index]
  end
  self:SetSaveBtnState(self.isDirty)
end

function GVGRoadBlockEditorView:OnSaveBtnClick()
  if GvgProxy.Instance:IsInRoadBlockActivedTime() then
    MsgManager.ShowMsgByID(2676)
    return
  end
  local roadBlock = 0
  local cells = self.blockListCtrl:GetCells()
  local count = #cells
  for i = 1, count do
    roadBlock = roadBlock + cells[i].state * 10 ^ (count - i)
  end
  self.roadBlock = roadBlock
  ServiceGuildCmdProxy.Instance:CallGvgRoadblockModifyGuildCmd(roadBlock)
end

function GVGRoadBlockEditorView:SetSaveBtnState(state)
  self.saveBtn:SetActive(state)
  self.saveBtnGrey:SetActive(not state)
end

function GVGRoadBlockEditorView:OnRoadBlockModified(note)
  if note.body and note.body.ret then
    MsgManager.ShowMsgByID(34009)
    local cells = self.blockListCtrl:GetCells()
    for i = 1, #cells do
      self.blockStates[cells[i].index] = cells[i].state
    end
    self.isDirty = false
    self:SetSaveBtnState(self.isDirty)
  end
end
