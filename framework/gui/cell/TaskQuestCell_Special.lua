TaskQuestCell_Special = class("TaskQuestCell_Special", BaseCell)

function TaskQuestCell_Special:ctor(parent)
  self.gameObject = self:LoadPreferb("cell/TaskQuestCell_Special", parent)
  self:Init()
end

function TaskQuestCell_Special:Init()
  self.slider = self:FindComponent("progress", UISlider)
  self.label = self:FindComponent("Label", UILabel)
end

function TaskQuestCell_Special:SetData(style)
  self.slider.value = 1
  self.progressMax = style.LimitItem[2] or 1
  self.label.text = string.format("%s/%s", 0, self.progressMax)
end

function TaskQuestCell_Special:SetProgress(val, maxVal)
  maxVal = maxVal or self.progressMax
  self.slider.value = math.clamp(val / maxVal, 0, 1)
  self.label.text = string.format("%s/%s", val, maxVal)
end

function TaskQuestCell_Special:DestroySelf()
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
  end
  TableUtility.TableClear(self)
end
