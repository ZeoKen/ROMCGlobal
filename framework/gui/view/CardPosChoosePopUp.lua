CardPosChoosePopUp = class("CardPosChoosePopUp", BaseView)
CardPosChoosePopUp.ViewType = UIViewType.ConfirmLayer
autoImport("EquipCardCell")

function CardPosChoosePopUp:Init()
  self:InitView()
end

function CardPosChoosePopUp:InitView()
  local grid = self:FindComponent("EquipCardPosGrid", UIGrid)
  self.posCtl = UIGridListCtrl.new(grid, EquipCardCell, "EquipCardCell")
  self.posCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosePos, self)
  local title = self:FindComponent("Title", UILabel)
  title.text = ZhString.CardPosChoosePopUp_Title
  local cost = self:FindGO("Cost")
  local l_zenyIcon = self:FindComponent("Sprite", UISprite, cost)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  local costTipLabel = self:FindComponent("CostTip", UILabel, cost)
  costTipLabel.text = ZhString.CardPosChoosePopUp_CostTip
  self.costLabel = cost:GetComponent(UILabel)
  local closeButton = self:FindGO("CloseButton")
  local closeButton_Label = self:FindComponent("Label", UILabel, closeButton)
  closeButton_Label.text = ZhString.CardPosChoosePopUp_Cancel
  self.confirmButton = self:FindGO("ConfirmButton")
  self.confirmButton_Collider = self.confirmButton:GetComponent(BoxCollider)
  self.confirmButton_Label = self:FindComponent("Label", UILabel, self.confirmButton)
  self.confirmButton_Label.text = ZhString.CardPosChoosePopUp_Confirm
  self.confirmButton_Sp = self.confirmButton:GetComponent(UISprite)
  self:AddClickEvent(self.confirmButton, function(go)
    self:sendNotification(CardPosChoosePopUpEvent.ChoosePos, {
      self.choosePos,
      self.cost
    })
    self:CloseSelf()
  end)
  self.closeBtn2 = self:FindGO("CloseBtn")
  self:AddClickEvent(self.closeBtn2, function()
    self:CloseSelf()
  end)
end

function CardPosChoosePopUp:ActiveConfirmButton(b)
  if b then
    self.confirmButton_Collider.enabled = true
    self.confirmButton_Label.effectColor = LuaGeometry.GetTempColor(0.08627450980392157, 0.4235294117647059, 0.00392156862745098, 1)
    self.confirmButton_Sp.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
  else
    self.confirmButton_Collider.enabled = false
    self.confirmButton_Label.effectColor = LuaGeometry.GetTempColor(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.confirmButton_Sp.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
  end
end

function CardPosChoosePopUp:ClickChoosePos(cellCtl)
  if cellCtl then
    if self.chooseCell ~= nil then
      self.chooseCell:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    local data = cellCtl.data
    local cost = 0
    if data and data ~= EquipCardCell.Empty then
      local quality = data.staticData.Quality
      if quality then
        cost = GameConfig.EquipRecover.Card[quality]
      end
    end
    if 0 < cost then
      self.costLabel.text = NewRechargeProxy.Ins:AmIMonthlyVIP() and ZhString.NewRecharge_Free or cost
    else
      self.costLabel.gameObject:SetActive(false)
    end
    self.cost = cost
    self:ActiveConfirmButton(true)
    self.choosePos = cellCtl.indexInList
    self.chooseCell = cellCtl
  end
end

function CardPosChoosePopUp:UpdateCardPosInfo(itemData)
  if itemData then
    if self.datas == nil then
      self.datas = {}
    else
      TableUtility.TableClear(self.datas)
    end
    local equipCardInfo = itemData.equipedCardInfo or {}
    local cardSlotNum = itemData.cardSlotNum or 0
    for i = 1, cardSlotNum do
      if equipCardInfo[i] then
        table.insert(self.datas, equipCardInfo[i])
      else
        table.insert(self.datas, EquipCardCell.Empty)
      end
    end
    self.posCtl:ResetDatas(self.datas)
    local cells = self.posCtl:GetCells()
    self:ClickChoosePos(cells[1])
  end
end

function CardPosChoosePopUp:OnEnter()
  CardPosChoosePopUp.super.OnEnter(self)
  local itemData = self.viewdata and self.viewdata.itemData
  self:UpdateCardPosInfo(itemData)
  self:ActiveConfirmButton(self.choosePos ~= nil)
end

function CardPosChoosePopUp:OnExit()
  CardPosChoosePopUp.super.OnExit(self)
  helplog("CardPosChoosePopUp OnExit")
  self.choosePos = nil
end
