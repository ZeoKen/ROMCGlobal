local BaseCell = autoImport("BaseCell")
BanCardCombineCell = class("BanCardCombineCell", BaseCell)
autoImport("BanCardCell")

function BanCardCombineCell:Init()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.banCardGrid = self:FindComponent("CardGrid", UIGrid)
  self.banCardListCtrl = UIGridListCtrl.new(self.banCardGrid, BanCardCell, "BagCardCell")
  self.banCardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCardCell, self)
  self.connentBanCardGrid = self:FindComponent("ConnectCardGrid", UIGrid)
  self.connentBanCardListCtrl = UIGridListCtrl.new(self.connentBanCardGrid, BanCardCell, "BagCardCell")
  self.connentBanCardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCardCell, self)
  self.connentLines = {}
  for i = 1, 6 do
    self.connentLines[i] = self:FindGO("Connent" .. i)
  end
  self.banCardListCtrl:SetEmptyDatas(6)
  self.connentBanCardListCtrl:SetEmptyDatas(6)
end

function BanCardCombineCell:SetOptionEnable(enable)
  if self.optionEnable and self.optionEnable == enable then
    return
  end
  self.optionEnable = enable
end

function BanCardCombineCell:SetConnentCardHide(hide)
  self.connentCardHide = hide
end

function BanCardCombineCell:OpenBanCardPopup()
  if not self.optionEnable then
    return
  end
  local viewdata = {
    chosenList = self.banCardIds,
    callback = self.ChooseBanCardCallBack,
    callbackParam = self
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.BanCardPopup,
    viewdata = viewdata
  })
end

function BanCardCombineCell:ChooseBanCardCallBack(id)
  xdlog("选择卡片", id)
  if id then
    if TableUtility.ArrayFindIndex(self.banCardIds, id) == 0 then
      table.insert(self.banCardIds, id)
    else
      TableUtility.ArrayRemove(self.banCardIds, id)
    end
    self:SetData(self.banCardIds)
  end
end

function BanCardCombineCell:GetID()
  return self.banCardIds
end

function BanCardCombineCell:SetData(list)
  self.banCardIds = list
  local cells = self.banCardListCtrl:GetCells()
  for i = 1, 6 do
    local cell = cells[i]
    if cell then
      if list[i] then
        local itemData = ItemData.new("CardBan", list[i])
        itemData.isBan = true
        cell:SetData(itemData)
      else
        cell:SetData(nil)
      end
    end
  end
  if not self.connentCardHide then
    self.connentBanCardGrid.gameObject:SetActive(true)
    local connectCells = self.connentBanCardListCtrl:GetCells()
    for i = 1, 6 do
      if list and list[i] then
        local config = Table_Card[list[i]]
        if config and config.ForbidCards and config.ForbidCards[1] then
          local itemData = ItemData.new("CardBan", config.ForbidCards[1])
          itemData.isBan = true
          connectCells[i].gameObject:SetActive(true)
          self.connentBanCardListCtrl:UpdateCell(i, itemData)
          self.connentLines[i]:SetActive(true)
        else
          self.connentBanCardListCtrl:UpdateCell(i, nil)
          connectCells[i].gameObject:SetActive(false)
          self.connentLines[i]:SetActive(false)
        end
      else
        connectCells[i].gameObject:SetActive(false)
        self.connentLines[i]:SetActive(false)
      end
    end
  else
    self.connentBanCardGrid.gameObject:SetActive(false)
  end
end

function BanCardCombineCell:HandleClickCardCell(cell)
  local data = cell.data
  if data == nil or data == BagItemEmptyType.Empty then
    self:OpenBanCardPopup()
  else
    local tipData = {}
    tipData.itemdata = data
    local cardStaticData = Table_Card[data.staticData.id]
    if cardStaticData and cardStaticData.SelectToForbid and self.optionEnable then
      tipData.customFuncConfig = {
        name = ZhString.PvpCustomRoom_UnBanCard,
        btnStyle = 2,
        callback = function()
          self:ChooseBanCardCallBack(data.staticData.id)
        end
      }
    end
    self:ShowItemTip(tipData, self.widget, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end
