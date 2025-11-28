local baseCell = autoImport("BaseCell")
LotteryMonthGroupCell = class("LotteryMonthGroupCell", baseCell)
local blueColor, blueEffectColor = LuaColor.New(0.25882352941176473, 0.3803921568627451, 0.7529411764705882), LuaColor.New(0.12156862745098039, 0.23137254901960785, 0.5215686274509804)

function LotteryMonthGroupCell:Init()
  self.content = self:FindComponent("Content", UILabel)
  self:AddCellClickEvent()
end

function LotteryMonthGroupCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.content.text = data:GetName()
  self:SetChoose(false)
end

function LotteryMonthGroupCell:SetChoose(isChoose)
  local label = self.content
  if isChoose then
    label.color = blueColor
    label.effectColor = ColorUtil.NGUIWhite
    label.fontSize = 18
  else
    label.color = ColorUtil.NGUIWhite
    label.effectColor = blueEffectColor
    label.fontSize = 16
  end
end
