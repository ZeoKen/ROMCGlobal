autoImport("BaseCell")
ActivityIntegrationQuestCell = class("ActivityIntegrationQuestCell", BaseCell)

function ActivityIntegrationQuestCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ActivityIntegrationQuestCell:FindObjs()
  self.itemRoot = self:FindGO("item"):GetComponent(UIWidget)
  self.bg = self:FindGO("bg"):GetComponent(UIMultiSprite)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.numLabel = self:FindGO("NumLabel"):GetComponent(UILabel)
  self.indexLabel = self:FindGO("Index"):GetComponent(UILabel)
  self.index_bg = self:FindGO("IndexBg"):GetComponent(UISprite)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
end

function ActivityIntegrationQuestCell:SetData(data)
  self.data = data
  self.id = data.id
  local config = Table_ActivityQuestSign[self.id]
  if config then
    local reward = config.Reward
    if reward and 0 < #reward then
      local targetReward = reward[1]
      itemId = targetReward[1]
      self.staticData = Table_Item[itemId]
      if self.staticData then
        IconManager:SetItemIcon(self.staticData.Icon, self.icon)
      end
      self.icon:MakePixelPerfect()
      self.numLabel.text = targetReward[2]
    end
    local SSR = config.Ssr or 0
    self.bg.CurrentState = SSR == 1 and 3 or 2
    self.index_bg.color = SSR == 1 and LuaGeometry.GetTempVector4(0.9686274509803922, 0.7254901960784313, 0.44313725490196076, 1) or LuaGeometry.GetTempVector4(0.9137254901960784, 0.8274509803921568, 0.6666666666666666, 1)
    self.index = config.index
    self.indexLabel.text = self.indexInList
  end
  self.status = data.status
  self:SetStatus(data.status)
  self.indexLabel.effectColor = LuaGeometry.GetTempVector4(0.8, 0.49019607843137253, 0.1568627450980392, 1)
end

function ActivityIntegrationQuestCell:SetStatus(status)
  if status == 1 then
    self.itemRoot.alpha = 1
    self.finishSymbol:SetActive(false)
    if self.signInEff then
      self.signInEff:Destroy()
      self.signInEff = nil
    end
  elseif status == 2 then
    self.itemRoot.alpha = 0.5
    self.finishSymbol:SetActive(true)
    if self.signInEff then
      self.signInEff:Destroy()
      self.signInEff = nil
    end
  else
    if not self.signInEff then
      self.signInEff = self:PlayUIEffect(EffectMap.UI.FlipCard_CanFlip, self.effectContainer)
    end
    self.itemRoot.alpha = 1
    self.finishSymbol:SetActive(false)
  end
end

function ActivityIntegrationQuestCell:SetFinished(bool)
  if bool then
    self.itemRoot.alpha = 0.5
    self.finishSymbol:SetActive(true)
  else
    self.itemRoot.alpha = 1
    self.finishSymbol:SetActive(false)
  end
end
