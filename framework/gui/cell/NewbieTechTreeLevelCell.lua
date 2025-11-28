local BaseCell = autoImport("BaseCell")
NewbieTechTreeLevelCell = class("NewbieTechTreeLevelCell", BaseCell)
local tempVector3 = LuaVector3.Zero()

function NewbieTechTreeLevelCell:Init()
  NewbieTechTreeLevelCell.super.Init(self)
  self:FindObjs()
end

function NewbieTechTreeLevelCell:FindObjs()
  self.widget = self:FindGO("Container"):GetComponent(UIWidget)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processDot = self:FindGO("ProcessDot")
  self.processFinish = self:FindGO("ProcessFinish")
  self.greenLine = self:FindGO("GreenLine"):GetComponent(UISprite)
  self.emptyLine = self:FindGO("EmptyLine"):GetComponent(UISprite)
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemCellGO = self:FindGO("ItemCell")
  self.itemCell = BagItemCell.new(self.itemCellGO)
  self:SetEvent(self.itemCellGO, function()
    self:sendNotification(UICellEvent.OnCellClicked, {
      itemid = self.itemid
    })
  end)
  self.icon = self:FindGO("Icon", self.itemContainer):GetComponent(UISprite)
  self.count = self:FindGO("Count", self.itemContainer):GetComponent(UILabel)
end

function NewbieTechTreeLevelCell:SetData(data)
  self.data = data
  self.leafID = data.leafId
  self.isUnlock = data.isUnlock
  local proxyIns = TechTreeProxy.Instance
  local effects = proxyIns:GetEffectsOfLeaf(self.leafID)
  if effects and effects[1] and effects[1].Type == "direct_reward" then
    self.itemCellGO:SetActive(true)
    self.itemContainer:SetActive(false)
    local params = effects[1].Params
    local targetReward = params and params[1]
    self.itemid = targetReward.itemid
    local itemData = ItemData.new(self.itemid, self.itemid)
    itemData.num = targetReward.num
    self.itemCell:SetData(itemData)
  else
    self.itemContainer:SetActive(true)
    self.itemCellGO:SetActive(false)
    IconManager:SetItemIcon(proxyIns:GetStaticValueOfLeaf(self.leafID, nil, "Icon"), self.icon)
  end
  self.nameLabel.text = proxyIns:GetStaticValueOfLeaf(self.leafID, nil, "Name")
  self.descLabel.text = proxyIns:GetStaticValueOfLeaf(self.leafID, nil, "Desc")
  self.finishSymbol:SetActive(self.isUnlock)
  self.greenLine.gameObject:SetActive(self.isUnlock)
  self.processFinish:SetActive(self.isUnlock)
  self.widget.alpha = self.isUnlock and 1 or 0.33
end
