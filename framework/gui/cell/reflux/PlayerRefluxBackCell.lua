PlayerRefluxBackCell = class("PlayerRefluxBackCell", BaseCell)

function PlayerRefluxBackCell:Init()
  self:FindOBJ()
  self:AddEvents()
end

function PlayerRefluxBackCell:FindOBJ()
  self.ItemBg = self:FindGO("ItemBg")
  self.dayLable = self:FindComponent("dayLable", UILabel)
  self.icon_Sprite = self:FindComponent("icon_sprite", UISprite)
  self.numberLable = self:FindComponent("number", UILabel)
  self.notReceiveIcon = self:FindGO("notReceiveIcon")
  self.receiveIcon = self:FindGO("receiveIcon")
  self.selectRoot = self:FindGO("selectRootBg")
  self.selectDatLable = self:FindComponent("selectdayLable", UILabel, self.selectRoot)
  self.receiveButton = self:FindGO("receiveButton", self.selectRoot)
  self.selectbg = self:FindGO("selectBg")
  self.effectBg = self:FindGO("effectRoot")
  self.selectRoot:SetActive(false)
  self.notReceiveIcon:SetActive(false)
  self.receiveIcon:SetActive(false)
end

function PlayerRefluxBackCell:AddEvents()
  self:AddClickEvent(self.receiveButton, function()
    self:sendNotification(PlayerRefluxEvent.RefluxBackLoginReward)
  end)
  self:AddClickEvent(self.ItemBg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PlayerRefluxBackCell:ShowToday()
  self.selectRoot:SetActive(true)
  self.notReceiveIcon:SetActive(false)
  self.receiveIcon:SetActive(false)
end

function PlayerRefluxBackCell:HasReceiveDay()
  self.selectRoot:SetActive(false)
  self.receiveIcon:SetActive(true)
  self.notReceiveIcon:SetActive(false)
end

function PlayerRefluxBackCell:NotReceiveDay()
  self.selectRoot:SetActive(false)
  self.receiveIcon:SetActive(false)
  self.notReceiveIcon:SetActive(true)
end

function PlayerRefluxBackCell:SetData(_data)
  self.data = _data
  local itemData = self.data.Item
  if Game.Myself.data.userdata:Get(UDEnum.SEX) ~= 1 and self.data.FemaleItem then
    itemData = self.data.FemaleItem
  end
  if itemData then
    local itemId = itemData[1]
    local itemStatic = ItemData.new("PlayerRefluxBackCell", itemId)
    if itemStatic and itemStatic.staticData.Icon then
      IconManager:SetItemIcon(itemStatic.staticData.Icon, self.icon_Sprite)
    end
    local num = itemData[2]
    self.numberLable.text = num
    local dayText = string.format(ZhString.PlayerRefluxView_Day, ZhString.ChinaNumber[self.indexInList])
    self.dayLable.text = dayText
    self.selectDatLable.text = dayText
    self.data.itemData = itemStatic
  end
  self.canReceive = false
end

function PlayerRefluxBackCell:RefeshCell(_recalllogindays, _loginawarddid)
  if self:Is_include(self.indexInList, _loginawarddid) then
    self:HasReceiveDay()
    self.canReceive = false
  elseif _recalllogindays >= self.indexInList then
    self:ShowToday()
    self.canReceive = true
  else
    self:NotReceiveDay()
    self.canReceive = false
  end
end

function PlayerRefluxBackCell:Is_include(value, tab)
  if not tab then
    return false
  end
  for k, v in pairs(tab) do
    if v == value then
      return true
    end
  end
  return false
end

function PlayerRefluxBackCell:OnCellDestroy()
  PlayerRefluxBackCell.super.OnCellDestroy(self)
end
