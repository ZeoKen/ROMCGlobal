local baseCell = autoImport("BaseCell")
ExtraBonusCell = class("ExtraBonusCell", baseCell)
local ExtraTip = GameConfig.Lottery.extraTip

function ExtraBonusCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ExtraBonusCell:FindObjs()
  self.itemIcon = self:FindGO("itemIcon"):GetComponent(UISprite)
  self.check = self:FindGO("check")
  self.countlabel = self:FindGO("countlabel"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("effectContainer")
  self.loadEffect = false
  self.numLabel = self:FindGO("numLabel"):GetComponent(UILabel)
  self.unLock = self:FindGO("unLock")
  self.unlockLabel = self:FindGO("unlockLabel"):GetComponent(UILabel)
  self.unlockText = self:FindGO("unlockText"):GetComponent(UILabel)
  self.unlockLabel.text = ZhString.ExtraBonusCell_Unlock
end

function ExtraBonusCell:SetData(data)
  if data then
    self.data = data
    self.key = data.key
    self.lotterytype = data.lotterytype
    local itemdata = data.itemids and data.itemids[1] or _EmptyTable
    self.itemid = itemdata.itemid or 0
    local count = itemdata.count
    local icon = Table_Item[self.itemid] and Table_Item[self.itemid].Icon or ""
    IconManager:SetItemIcon(icon, self.itemIcon)
    if count and 1 < count then
      self.numLabel.gameObject:SetActive(true)
      self.numLabel.text = string.format("x%d", count)
    else
      self.numLabel.gameObject:SetActive(false)
    end
    if ExtraTip and ExtraTip[self.itemid] then
      self.unlockText.text = ExtraTip[self.itemid]
      self.unLock:SetActive(true)
    else
      self.unLock:SetActive(false)
    end
  end
end

function ExtraBonusCell:UpdateStatus(current)
  if LotteryProxy.Instance:CheckReceive(self.lotterytype, self.key) then
    self.check:SetActive(true)
    self.countlabel.gameObject:SetActive(false)
    self.effectContainer:SetActive(false)
  elseif current >= self.key then
    self.countlabel.gameObject:SetActive(true)
    self.countlabel.text = string.format("%d/%d", current, self.key)
    self.check:SetActive(false)
    if not self.loadEffect then
      self:PlayUIEffect(EffectMap.UI.BoliBubble, self.effectContainer, false)
      self.loadEffect = true
    end
    self.effectContainer:SetActive(true)
  else
    self.countlabel.gameObject:SetActive(true)
    self.countlabel.text = string.format("%d/%d", current, self.key)
    self.check:SetActive(false)
    self.effectContainer:SetActive(false)
  end
end
