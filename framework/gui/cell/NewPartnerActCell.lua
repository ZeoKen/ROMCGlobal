NewPartnerActCell = class("NewPartnerActCell", BaseCell)

function NewPartnerActCell:Init()
  self:FindOBJ()
  self:AddEvents()
end

function NewPartnerActCell:FindOBJ()
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

function NewPartnerActCell:AddEvents()
  self:AddClickEvent(self.receiveButton, function()
    ServiceActivityCmdProxy.Instance:CallUserInviteAwardCmd({
      self.indexInList
    }, NewPartnerActProxy.Instance.actId)
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_GLOBAL_NEWPARTNER, NewPartnerActProxy.Instance.actId)
  end)
  self:AddClickEvent(self.ItemBg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NewPartnerActCell:ShowToday()
  self.selectRoot:SetActive(true)
  self.notReceiveIcon:SetActive(false)
  self.receiveIcon:SetActive(false)
end

function NewPartnerActCell:HasReceiveDay()
  self.selectRoot:SetActive(false)
  self.receiveIcon:SetActive(true)
  self.notReceiveIcon:SetActive(false)
end

function NewPartnerActCell:NotReceiveDay()
  self.selectRoot:SetActive(false)
  self.receiveIcon:SetActive(false)
  self.notReceiveIcon:SetActive(true)
end

function NewPartnerActCell:SetData(_data)
  self.data = _data
  local itemData = ItemUtil.GetRewardItemIdsByTeamId(self.data.reward)
  if itemData then
    local itemId = itemData[1].id
    local itemStatic = ItemData.new("NewPartnerActCell", itemId)
    if itemStatic and itemStatic.staticData.Icon then
      IconManager:SetItemIcon(itemStatic.staticData.Icon, self.icon_Sprite)
    end
    local num = itemData[1].num
    self.numberLable.text = num
    local dayText = string.format(ZhString.PlayerRefluxView_Day, self.data.login)
    self.dayLable.text = dayText
    self.selectDatLable.text = dayText
    self.data.itemData = itemStatic
  end
  self.canReceive = false
end

function NewPartnerActCell:RefeshCell(_loginawarddid)
  if _loginawarddid and _loginawarddid[self.indexInList] then
    if _loginawarddid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_PROHIBIT then
      self:NotReceiveDay()
      self.canReceive = false
    elseif _loginawarddid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_CANGET then
      self:ShowToday()
      self.canReceive = true
    elseif _loginawarddid[self.indexInList].state == EAWARDSTATE.EAWARD_STATE_RECEIVED then
      self:HasReceiveDay()
      self.canReceive = false
    end
  else
    self:NotReceiveDay()
    self.canReceive = false
  end
end

function NewPartnerActCell:Is_include(value, tab)
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

function NewPartnerActCell:OnCellDestroy()
  NewPartnerActCell.super.OnCellDestroy(self)
end
