local BaseCell = autoImport("BaseCell")
QuestTraceRewardCell = class("QuestTraceRewardCell", BaseCell)

function QuestTraceRewardCell:ctor(obj)
  QuestTraceRewardCell.super.ctor(self, obj)
  self.item = self:FindGO("Item")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.itemCell = ItemCell.new(self.item)
  self.numLabel = self:FindGO("NumLabel"):GetComponent(UILabel)
  self.icon = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.scenicSymbol = self:FindGO("ScenicSymbol")
  self.customRewardIcon = self:FindGO("CustomRewardIcon"):GetComponent(UISprite)
  self.customRewardLabel = self:FindGO("CustomRewardCount"):GetComponent(UILabel)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.tipLabel.text = ZhString.HeroStory_AllFinishReward
  self.tipLabel.gameObject:SetActive(false)
end

function QuestTraceRewardCell:SetData(data)
  self.data = data
  if data.staticData then
    self.scenicSymbol:SetActive(false)
    self.customRewardIcon.gameObject:SetActive(false)
    self.itemCell.gameObject:SetActive(true)
    self.itemCell:SetData(data)
  else
    self.itemCell.gameObject:SetActive(false)
    self.scenicSymbol:SetActive(false)
    local type = data.type
    if type == "achieve" then
      self.customRewardIcon.gameObject:SetActive(true)
      IconManager:SetUIIcon(data.icon, self.customRewardIcon)
      self.customRewardLabel.text = data.value or ""
      self.customRewardIcon.width = 80
      self.customRewardIcon.height = 80
    end
  end
  if data.isExtra then
    self.tipLabel.gameObject:SetActive(true)
  else
    self.tipLabel.gameObject:SetActive(false)
  end
end

function QuestTraceRewardCell:SetFinish(bool)
  self.finishSymbol:SetActive(bool)
end

function QuestTraceRewardCell:SetFontSize(size)
  if self.numLabel then
    self.numLabel.fontSize = 24
  end
end

function QuestTraceRewardCell:SetTipLabel(str)
  if str and str ~= "" then
    self.tipLabel.gameObject:SetActive(true)
    self.tipLabel.text = str
  else
    self.tipLabel.gameObject:SetActive(false)
  end
end
