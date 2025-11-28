StealthGameEntranceAchievementCell = class("StealthGameEntranceAchievementCell", CoreView)
local finishedColor, notFinishedColor = LuaColor.New(0.08235294117647059, 0.5882352941176471, 0), LuaColor.New(0.2784313725490196, 0.1568627450980392, 0)

function StealthGameEntranceAchievementCell:ctor(obj)
  StealthGameEntranceAchievementCell.super.ctor(self, obj)
  self.icon = self:FindComponent("Icon", UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self.toggleGO = self:FindGO("Toggle")
end

function StealthGameEntranceAchievementCell:SetData(data)
  self.data = data
  local flag = data ~= nil and next(data) ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.label.text = string.format("%s\t+%s", data.Desc, data.Point * data.Count)
  self:UpdateFinished()
end

function StealthGameEntranceAchievementCell:UpdateFinished()
  self:SetFinished(DungeonProxy.Instance:GetClientRaidAchievementFinished(self.data.id))
end

function StealthGameEntranceAchievementCell:SetFinished(finished)
  self.icon.color = finished and finishedColor or notFinishedColor
  self.label.color = finished and finishedColor or notFinishedColor
  self.toggleGO:SetActive(finished and true or false)
end
