autoImport("BaseCell")
NoviceTarget2023NodeCell = class("NoviceTarget2023NodeCell", BaseCell)

function NoviceTarget2023NodeCell:Init()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
  self.itemCellGO = self:FindGO("ItemCell")
  self.itemCell = BaseItemCell.new(self.itemCellGO)
  self.icon = self:FindGO("Icon_Sprite")
  self.icon_Tween = self:FindGO("Icon_Sprite"):GetComponent(TweenRotation)
  self.effectContainer = self:FindGO("EffectContainer")
  self:AddCellClickEvent()
end

function NoviceTarget2023NodeCell:SetData(data)
  self.data = data
  local reward = data.curReward
  if reward and 0 < #reward then
    local single = reward[1]
    local itemData = ItemData.new("Reward", single[1])
    if itemData and single[2] then
      itemData:SetItemNum(single[2])
    end
    self.itemCell:SetData(itemData)
  end
  local rewarded = data.rewarded or false
  self:SetFinish(rewarded)
  local process = data.process or 0
  self.processLabel.text = process
  local canRecv = data.canRecv
  if canRecv then
    self.effect = self:PlayUIEffect(EffectMap.UI.ServantGift2, self.effectContainer)
    self.icon_Tween.enabled = true
  else
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    self.icon_Tween.enabled = false
    self.icon.transform.localRotation = LuaGeometry.Const_Qua_identity
  end
end

function NoviceTarget2023NodeCell:SetUnlock(bool)
  if bool then
    self.icon.color = LuaColor.White()
  else
    self.icon.color = LuaGeometry.GetTempVector4(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
  end
end

function NoviceTarget2023NodeCell:SetFinish(bool)
  self.finishSymbol:SetActive(bool)
end

function NoviceTarget2023NodeCell:OnCellDestroy()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
end
