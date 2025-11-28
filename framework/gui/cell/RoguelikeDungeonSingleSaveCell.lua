autoImport("RoguelikeItemCell")
RoguelikeDungeonSingleSaveCell = class("RoguelikeDungeonSingleSaveCell", CoreView)

function RoguelikeDungeonSingleSaveCell:ctor(obj)
  RoguelikeDungeonSingleSaveCell.super.ctor(self, obj)
  self:Init()
end

function RoguelikeDungeonSingleSaveCell:Init()
  self.indexLabel = self:FindComponent("IndexLabel", UILabel)
  self.label = self:FindComponent("Label", UILabel)
  self.sprite = self.gameObject:GetComponent(UIMultiSprite)
  self.itemScrollViewObj = self:FindGO("ItemScrollView")
  self.itemCtrl = UIGridListCtrl.new(self:FindComponent("ItemGrid", UIGrid), RoguelikeItemCell, "BagItemCell")
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + 1
  end
  self:AddClickEvent(self.gameObject, function()
    if not self.isAvailable then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function RoguelikeDungeonSingleSaveCell:SetData(data)
  self:SetAvailable(data and data.time)
  self:SetChoose(false)
  self.index = data and data.index or 0
  self.indexLabel.text = self.indexInList
  if not self.isAvailable then
    return
  end
  self.grade = data.grade
  local gradeStr = DungeonProxy.GetGradeStr(data.grade)
  self.label.text = string.format(ZhString.Roguelike_SaveDataLabelFormat, gradeStr, os.date("%Y-%m-%d %H:%M:%S", data.time))
  self.itemCtrl:ResetDatas(data.items)
end

local chooseEffectColor, notChooseEffectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882), Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)

function RoguelikeDungeonSingleSaveCell:SetChoose(isChoose)
  if not self.isAvailable then
    return
  end
  self.sprite.CurrentState = isChoose and 1 or 0
  self:SetLabelEffectColor(isChoose and chooseEffectColor or notChooseEffectColor)
end

function RoguelikeDungeonSingleSaveCell:SetAvailable(isAvailable)
  self.isAvailable = isAvailable and true or false
  self.sprite.CurrentState = self.isAvailable and 0 or 2
  self:SetLabelEffectColor(self.isAvailable and notChooseEffectColor or ColorUtil.NGUIGray)
  self:SetShowGrid(self.isAvailable)
  if not self.isAvailable then
    self.label.text = ""
  end
end

function RoguelikeDungeonSingleSaveCell:SetLabelEffectColor(color)
  color = color or ColorUtil.NGUIGray
  self.indexLabel.effectColor = color
  self.label.effectColor = color
end

function RoguelikeDungeonSingleSaveCell:SetShowGrid(isShow)
  self.itemScrollViewObj:SetActive(isShow)
end
