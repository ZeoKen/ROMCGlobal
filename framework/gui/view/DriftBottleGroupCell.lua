local BaseCell = autoImport("BaseCell")
DriftBottleGroupCell = class("DriftBottleGroupCell", BaseCell)

function DriftBottleGroupCell:Init()
  DriftBottleGroupCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DriftBottleGroupCell:FindObjs()
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.questName = self:FindGO("QuestName"):GetComponent(UILabel)
  self.statusGO = self:FindGO("StatusIcon")
  self.statusIcon = self.statusGO:GetComponent(UISprite)
end

function DriftBottleGroupCell:SetData(data)
  self.data = data
  self.id = data
  local config = Table_Bottle[data]
  if config then
    self.questNameText = config.QuestName
    self.questName.text = config.QuestName
  end
  local pieceData = DriftBottleProxy.Instance:GetCurPieceData(data)
  if pieceData then
    if pieceData.status == 2 then
      self:SetStatusIcon(2)
      self:SetQuestName(2)
      self:SetClickAble(true)
    elseif pieceData.status == 1 then
      self:SetStatusIcon(1)
      self:SetQuestName(1)
      self:SetClickAble(true)
    else
      self:SetStatusIcon(0)
      self:SetQuestName(0)
      self:SetClickAble(false)
    end
  else
    self:SetStatusIcon(0)
    self:SetQuestName(0)
    self:SetClickAble(false)
  end
end

function DriftBottleGroupCell:SetStatusIcon(index)
  if index == 0 then
    self.statusGO:SetActive(false)
  elseif index == 1 then
    self.statusGO:SetActive(true)
    self.statusIcon.spriteName = "Rewardtask_icon_processing"
  elseif index == 2 then
    self.statusGO:SetActive(true)
    self.statusIcon.spriteName = "Rewardtask_icon_check"
  end
end

function DriftBottleGroupCell:SetQuestName(index)
  if index == 0 then
    self.questName.text = "?????"
    self.questName.color = LuaGeometry.GetTempVector4(0.49019607843137253, 0.5137254901960784, 0.6431372549019608, 1)
  else
    self.questName.text = self.questNameText
    self.questName.color = LuaColor.white
  end
end

function DriftBottleGroupCell:SetClickAble(bool)
  self.boxCollider.enabled = bool
end
