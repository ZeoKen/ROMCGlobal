autoImport("BaseCell")
RecallSignCell = class("RecallSignCell", BaseCell)

function RecallSignCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function RecallSignCell:FindObjs()
  self.dayLabel = self:FindGO("Label", self.gameObject):GetComponent(UILabel)
  local nameGO = self:FindGO("Name")
  if nameGO then
    self.nameLabel = nameGO:GetComponent(UILabel)
  end
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.numLabel = self:FindGO("Num"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
end

function RecallSignCell:SetData(data)
  self.data = data
  if data then
    local reward = data.Reward
    if reward and #reward == 2 then
      local itemId = reward[1]
      self.staticData = Table_Item[itemId]
      if self.staticData then
        IconManager:SetItemIcon(self.staticData.Icon, self.icon)
      end
      self.icon:MakePixelPerfect()
      self.numLabel.text = reward[2]
      if self.nameLabel then
        self.nameLabel.text = self.staticData.NameZh
      end
      self:SetCardInfo(self.staticData)
    end
    self.index = data.Day
    self.dayLabel.text = string.format(ZhString.PlayerRefluxView_Day, data.Day or self.indexInList)
  end
end

function RecallSignCell:SetCardInfo(data)
  local itemid = data and data.id
  local cardData = Table_Card[itemid]
  if not cardData then
    if self.cardItem then
      self.cardItem:SetData(nil)
    end
    self.icon.gameObject:SetActive(true)
    return
  else
    self.icon.gameObject:SetActive(false)
  end
  if not self.cardItem then
    local cardObj = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
    cardObj.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
    self.cardItem = ItemCardCell.new(cardObj)
  end
  self.cardItem:SetData(ItemData.new("CardData", itemid))
end

function RecallSignCell:SetStatus(status)
  self.status = status
  if self.status == 3 then
    self.finishSymbol:SetActive(true)
    self:DestroySignInEffect()
  elseif self.status == 2 then
    self.finishSymbol:SetActive(false)
    if not self.signInEff then
      self.signInEff = self:PlayUIEffect(EffectMap.UI.FlipCard_LinkReward, self.effectContainer)
    end
  else
    self.finishSymbol:SetActive(false)
    self:DestroySignInEffect()
  end
end

function RecallSignCell:DestroySignInEffect()
  if self.signInEff then
    self.signInEff:Destroy()
    self.signInEff = nil
  end
end

function RecallSignCell:OnDestroy()
  self:DestroySignInEffect()
  RecallSignCell.super.OnDestroy(self)
end
