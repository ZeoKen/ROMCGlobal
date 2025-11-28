DynamicSkillItemCell = class("DynamicSkillItemCell", ItemCell)

function DynamicSkillItemCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  self.chooseImg = self:FindGO("chooseImg")
  self.equiped = self:FindGO("Equiped")
  self.limitTimeFlag = self:FindGO("FlagSp")
  DynamicSkillItemCell.super.Init(self)
  self:AddCellClickEvent()
end

function DynamicSkillItemCell:SetData(data)
  if data then
    DynamicSkillItemCell.super.SetData(self, data.itemdata)
    self.effectStatus = data.effectStatus
    self.sendStatus = data.sendStatus
    self.pro = data.pro
    self.itemId = data.itemId
    self.equiped:SetActive(self.effectStatus == 1)
    self.limitTimeFlag:SetActive(data.endTime and data.endTime > 0 or false)
    self:UpdateChoose()
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function DynamicSkillItemCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function DynamicSkillItemCell:UpdateChoose()
  if self.itemId and self.itemId == self.chooseId then
    self.chooseImg:SetActive(true)
  else
    self.chooseImg:SetActive(false)
  end
end
