local BaseCell = autoImport("BaseCell")
AnnounceQuestVersionTaskCell = class("AnnounceQuestVersionTaskCell", BaseCell)
AnnounceQuestVersionTaskCellLabelColor = {
  [1] = LuaColor.New(0.08627450980392157, 0.47058823529411764, 0.4745098039215686, 1),
  [2] = LuaColor.New(1, 1, 1, 1),
  [3] = LuaColor.New(0.5764705882352941, 0.5803921568627451, 0.5803921568627451, 1),
  [4] = LuaColor.New(0.23529411764705882, 0.23529411764705882, 0.23529411764705882, 1)
}

function AnnounceQuestVersionTaskCell:Init()
  self.title = self:FindComponent("Title", UILabel)
  self.finMark = self:FindGO("gou")
  self.processMark = self:FindGO("process")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AnnounceQuestVersionTaskCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.title.text = data[1]
    if data[2] < 0 then
      self.title.color = AnnounceQuestVersionTaskCellLabelColor[3]
      self.title.effectColor = AnnounceQuestVersionTaskCellLabelColor[4]
      self.finMark:SetActive(false)
      self.processMark:SetActive(false)
    elseif data[2] > 0 then
      self.title.color = AnnounceQuestVersionTaskCellLabelColor[1]
      self.title.effectColor = AnnounceQuestVersionTaskCellLabelColor[2]
      self.finMark:SetActive(true)
      self.processMark:SetActive(false)
    else
      self.title.color = AnnounceQuestVersionTaskCellLabelColor[1]
      self.title.effectColor = AnnounceQuestVersionTaskCellLabelColor[2]
      self.finMark:SetActive(false)
      self.processMark:SetActive(true)
    end
  else
    self.gameObject:SetActive(false)
  end
end

local tempPos = LuaVector3.Zero()

function AnnounceQuestVersionTaskCell:ShowSelectHere(selectObj)
  if selectObj then
    selectObj.transform:SetParent(self.gameObject.transform)
    selectObj.transform.localPosition = tempPos
    selectObj:SetActive(true)
  end
end
