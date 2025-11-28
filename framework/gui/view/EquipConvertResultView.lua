autoImport("EquipConvertAttributeCell")
autoImport("ItemTipComCell")
EquipConvertResultView = class("EquipConvertResultView", BaseView)
EquipConvertResultView.ViewType = UIViewType.PopUpLayer
local animDuration1, animDuration2, animDuration3, attriAnimInterval = 0.5, 1.5, 0.5, 0.25
local bgBaseHeight = 282
local labelAnimTickId, tickManager = 999

function EquipConvertResultView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  EquipConvertResultView.super.Init(self)
  self:InitItemCell(self:FindGO("ItemContainer"))
  self.bg = self:FindComponent("Bg", UISprite)
  self.itemNameLabel = self:FindComponent("ItemName", UILabel)
  self.lockParent = self:FindComponent("Lock", UIWidget)
  local lockLabel = self:FindComponent("Locked", UILabel)
  lockLabel.text = ZhString.ItemTip_UnlockAfterGot
  self.itemEffContainer = self:FindGO("ItemEffContainer")
  self.bubbleContainer = self:FindGO("BubbleContainer")
  self:InitAttri()
  self.ctrlParent = self:FindComponent("Ctrls", UIWidget)
  self:AddButtonEvent("InfoBtn", function()
    self:OnClickInfo()
  end)
  self:AddButtonEvent("ConfirmBtn", function()
    if not self.clickEnabled then
      return
    end
    self:CloseSelf()
  end)
  self.fullTipPanel = self:FindGO("FullTipPanel")
  self:AddButtonEvent("FullTipBg", function()
    self.fullTipPanel:SetActive(false)
  end)
end

function EquipConvertResultView:InitItemCell(container)
  if not container then
    return
  end
  local cellObj = self:LoadPreferb("cell/ItemNewCell", container)
  if not cellObj then
    return
  end
  local cellTrans = cellObj.transform
  cellTrans:SetParent(container.transform, true)
  cellTrans.localPosition = LuaGeometry.Const_V3_zero
  self.itemCell = ItemNewCell.new(cellObj)
  self.itemCell:HideNum()
  self:AddClickEvent(container, function()
    self:OnClickInfo()
  end)
end

function EquipConvertResultView:InitAttri()
  self.attriGrid = self:FindComponent("AttriGrid", UIGrid)
  self.attriGridPosY = self.attriGrid.transform.localPosition.y
  self.attriCtl = ListCtrl.new(self.attriGrid, EquipConvertAttributeCell, "EquipConvertAttributeCell")
  self.attriCells = self.attriCtl:GetCells()
end

function EquipConvertResultView:OnEnter()
  EquipConvertResultView.super.OnEnter(self)
  local item = self:GetItemData()
  self.itemCell:SetData(item)
  self.itemNameLabel.text = item.staticData.NameZh
  self:PlayUIEffect(EffectMap.UI.Get_UI, self.itemEffContainer)
  self:PlayUIEffect(EffectMap.UI.DisneyBubble, self.bubbleContainer)
  self:PlayResultStartAnim()
end

function EquipConvertResultView:OnExit()
  if self.infoTipCell then
    self.infoTipCell:OnDestroy()
  end
  tickManager:ClearTick(self)
  EquipConvertResultView.super.OnExit(self)
end

function EquipConvertResultView:OnClickInfo()
  if not self.clickEnabled then
    return
  end
  self.fullTipPanel:SetActive(true)
  if not self.infoTipCell then
    local obj = self:LoadPreferb("cell/ItemTipComCell", self.fullTipPanel)
    self.infoTipCell = ItemTipComCell.new(obj)
    self.infoTipCell:SetData(self:GetItemData())
    self.infoTipCell:UpdateTipButtons(_EmptyTable)
    self.infoTipCell:UpdateBgHeight()
    self.infoTipCell:HideGetPath()
  end
end

function EquipConvertResultView:PlayResultStartAnim()
  if self.resultAnimPlayed then
    return
  end
  self.attriGrid.transform.localPosition = LuaGeometry.GetTempVector3(1500, self.attriGridPosY)
  self:ResetRandomAttri()
  self.ctrlParent.alpha = 0.5
  self.lockParent.alpha = 0
  self.bg.height = bgBaseHeight + 36 * #self.attriCells
  TweenAlpha.Begin(self.lockParent.gameObject, animDuration1, 1):SetOnFinished(function()
    tickManager:CreateOnceDelayTick(16, self._PlayResultStartAnim, self)
  end)
  self.resultAnimPlayed = true
end

function EquipConvertResultView:ResetRandomAttri()
  local item = self:GetItemData()
  self.attriCtl:ResetDatas(item and item.equipInfo and item.equipInfo:GetRandomEffectList() or _EmptyTable)
end

function EquipConvertResultView:_PlayResultStartAnim()
  TweenAlpha.Begin(self.lockParent.gameObject, animDuration2, 0):SetOnFinished(function()
    tickManager:CreateOnceDelayTick(33, function(self)
      self.attriGrid.transform.localPosition = LuaGeometry.GetTempVector3(0, self.attriGridPosY)
      local labelTrans, y
      for i = 1, #self.attriCells do
        labelTrans = self:GetAttriCellTransByIndex(i)
        if labelTrans then
          _, y = LuaGameObject.GetLocalPosition(labelTrans.transform)
          labelTrans.localPosition = LuaGeometry.GetTempVector3(1500, y)
        end
      end
      self.movingLabelCount = 0
      tickManager:CreateTick(0, attriAnimInterval, self.LaunchLabelAnim, self, labelAnimTickId)
    end, self)
  end)
end

function EquipConvertResultView:LaunchLabelAnim()
  self.movingLabelCount = self.movingLabelCount + 1
  local labelTrans = self:GetAttriCellTransByIndex(self.movingLabelCount)
  if labelTrans then
    local _, y = LuaGameObject.GetLocalPosition(labelTrans.transform)
    local t = TweenPosition.Begin(labelTrans.gameObject, animDuration3, LuaGeometry.GetTempVector3(0, y, 0))
    if self.movingLabelCount == 1 then
      t:SetOnFinished(function()
        self.ctrlParent.alpha = 1
        self.clickEnabled = true
      end)
    end
  else
    tickManager:ClearTick(self, labelAnimTickId)
  end
end

function EquipConvertResultView:GetAttriCellTransByIndex(i)
  local cell = self.attriCells[i]
  return cell and cell.gameObject.transform
end

function EquipConvertResultView:GetItemData()
  return self.viewdata.viewdata
end
