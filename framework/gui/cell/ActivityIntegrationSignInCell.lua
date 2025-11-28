autoImport("BaseCell")
ActivityIntegrationSignInCell = class("ActivityIntegrationSignInCell", BaseCell)

function ActivityIntegrationSignInCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ActivityIntegrationSignInCell:FindObjs()
  self.itemRoot = self:FindGO("item"):GetComponent(UIWidget)
  self.bg = self:FindGO("bg"):GetComponent(UIMultiSprite)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.numLabel = self:FindGO("NumLabel"):GetComponent(UILabel)
  self.indexLabel = self:FindGO("Index"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
end

function ActivityIntegrationSignInCell:SetData(data)
  self.data = data
  if data then
    local reward = data.Reward
    if reward and 0 < #reward then
      local targetReward = reward[1]
      itemId = targetReward[1]
      self.staticData = Table_Item[itemId]
      if self.staticData then
        IconManager:SetItemIcon(self.staticData.Icon, self.icon)
      end
      self.icon:MakePixelPerfect()
      self.numLabel.text = targetReward[2]
      self:SetCardInfo(self.staticData)
    end
    local SSR = data.Ssr or 0
    self.bg.CurrentState = SSR
    self.index = data.index
    self.indexLabel.text = self.indexInList
  end
end

function ActivityIntegrationSignInCell:SetCardInfo(data)
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

function ActivityIntegrationSignInCell:SetStatus(status)
  self.status = status
  if self.status == 3 then
    self.itemRoot.alpha = 0.5
    self.finishSymbol:SetActive(true)
    if self.signInEff then
      self.signInEff:Destroy()
      self.signInEff = nil
    end
  elseif self.status == 2 then
    self.itemRoot.alpha = 1
    self.finishSymbol:SetActive(false)
    if not self.signInEff then
      self.signInEff = self:PlayUIEffect(EffectMap.UI.FlipCard_CanFlip, self.effectContainer)
    end
  else
    self.itemRoot.alpha = 1
    self.finishSymbol:SetActive(false)
    if self.signInEff then
      self.signInEff:Destroy()
      self.signInEff = nil
    end
  end
end
