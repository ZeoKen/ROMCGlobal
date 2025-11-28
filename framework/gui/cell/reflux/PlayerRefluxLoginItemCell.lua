PlayerRefluxLoginItemCell = class("PlayerRefluxLoginItemCell", BaseCell)

function PlayerRefluxLoginItemCell:Init()
  self:FindOBJ()
  self:AddEvents()
end

function PlayerRefluxLoginItemCell:FindOBJ()
  self.bgBtn = self:FindGO("Background")
  self.selectToggle = self:FindGO("selectToggle")
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.icon_Sprite = self:FindComponent("Icon_Sprite", UISprite)
  self.titleLable = self:FindComponent("titleLable", UILabel)
  self.effectRoot = self:FindGO("effectRoot")
  local effect = self:PlayUIEffect(EffectMap.UI.SignIn21Hint, self.effectRoot)
  effect:ResetLocalScaleXYZ(2, 2, 2)
  self.canReceive = false
end

function PlayerRefluxLoginItemCell:AddEvents()
  self:AddClickEvent(self.chooseSymbol, function()
    self:sendNotification(PlayerRefluxEvent.InviteLoginAward)
  end)
  self:AddClickEvent(self.bgBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PlayerRefluxLoginItemCell:SetData(_data)
  self.data = _data
  local itemConfig = self.data.Item
  if itemConfig then
    local itemId = itemConfig[1]
    local itemData = ItemData.new("PlayerRefluxLoginItemCell", itemId)
    if itemData and itemData.staticData.Icon then
      IconManager:SetItemIcon(itemData.staticData.Icon, self.icon_Sprite)
    end
    local num = itemConfig[2]
    self.numLabel.text = num
    self.titleLable.text = string.format(ZhString.PlayerRefluxView_Day, ZhString.ChinaNumber[self.data.index])
    local inviteawardid = self.data.inviteawardid
    local index = self.data.index
    local invitelogindays = self.data.invitelogindays
    self:RefreshCell(invitelogindays, index, inviteawardid)
    self.data.itemData = itemData
  end
end

function PlayerRefluxLoginItemCell:SetGetRewardDay(_day)
  self:RefreshCell(self.data.invitelogindays, self.data.index, _day)
end

function PlayerRefluxLoginItemCell:RefreshCell(_invitelogindays, _index, _inviteawardid)
  if self:Is_include(_index, _inviteawardid) then
    self.selectToggle:SetActive(true)
    self.chooseSymbol:SetActive(false)
    self.canReceive = false
  elseif _index <= _invitelogindays then
    self.selectToggle:SetActive(false)
    self.chooseSymbol:SetActive(true)
    self.canReceive = true
  else
    self.selectToggle:SetActive(false)
    self.chooseSymbol:SetActive(false)
    self.canReceive = false
  end
end

function PlayerRefluxLoginItemCell:Is_include(value, tab)
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

function PlayerRefluxLoginItemCell:HasReceiveDay()
  self.selectToggle:SetActive(false)
end

function PlayerRefluxLoginItemCell:OnCellDestroy()
  PlayerRefluxLoginItemCell.super.OnCellDestroy(self)
end

function PlayerRefluxLoginItemCell:OnClickCallReward()
  PlayerRefluxProxy.Instance:CallUserInviteInviteLoginAwardCmd(self.data.index)
end
