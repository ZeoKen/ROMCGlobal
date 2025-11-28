DriftBottleView = class("DriftBottleView", ContainerView)
autoImport("DriftBottleCellType1")
autoImport("DriftBottleCellType2")
autoImport("DriftBottleCellType3")
DriftBottleView.ViewType = UIViewType.NormalLayer
local cellPath = "GUI/v1/cell/DriftBottleCellType"

function DriftBottleView:Init()
  self:InitView()
  self:InitDatas()
  self:AddEvts()
  self:InitShow()
end

function DriftBottleView:InitView()
  self.closeBtn = self:FindGO("CloseBtn")
  self.container = self:FindGO("Container")
  self:InitDriftBottleCell()
end

function DriftBottleView:InitDatas()
end

function DriftBottleView:AddEvts()
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function DriftBottleView:InitShow()
  if self.driftBottleCell then
    local viewdata = self.viewdata and self.viewdata.viewdata
    local npc = viewdata.npcdata
    local npcId = npc and npc.data.staticData.id
    self.driftBottleCell:AddEventListener(DriftBottleEvent.ClickAcceptBtn, self.clickAcceptBtn, self)
    self.driftBottleCell:AddEventListener(DriftBottleEvent.ClickAbandonBtn, self.clickAbandonBtn, self)
    xdlog("SetData", npcId)
    self.driftBottleCell:SetData(npcId)
  else
    redlog("Nocell")
    return
  end
end

function DriftBottleView:clickAcceptBtn(cell)
  xdlog("clickAcceptBtn", cell.data)
  ServiceQuestProxy.Instance:CallBottleActionQuestCmd(1, cell.data)
  self:CloseSelf()
end

function DriftBottleView:clickAbandonBtn(cell)
  xdlog("ClickAbandonBtn")
  self:CloseSelf()
end

function DriftBottleView:OnEnter()
  self.super.OnEnter(self)
end

function DriftBottleView:InitDriftBottleCell()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local npc = viewdata.npcdata
  local npcId = npc and npc.data.staticData.id
  xdlog("目标NPCId", npcId)
  local bottleConfig = Table_Bottle[npcId]
  local bottleType = 1
  if bottleConfig then
    local type = bottleConfig.Type
    if type == "piece" then
      bottleType = 1
    elseif type == "quest" then
      bottleType = 3
    elseif type == "reward" then
      bottleType = 2
    end
  end
  local go = self:LoadPreferb_ByFullPath(cellPath .. bottleType, self.container)
  if go == nil then
    redlog("未生成cell")
    return
  end
  if bottleType == 1 then
    self.driftBottleCell = DriftBottleCellType1.new(go)
  elseif bottleType == 2 then
    self.driftBottleCell = DriftBottleCellType2.new(go)
  elseif bottleType == 3 then
    self.driftBottleCell = DriftBottleCellType3.new(go)
  end
end
