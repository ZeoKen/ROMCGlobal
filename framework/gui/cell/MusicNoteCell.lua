local BaseCell = autoImport("BaseCell")
MusicNoteCell = class("MusicNoteCell", BaseCell)

function MusicNoteCell:Init()
  MusicNoteCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function MusicNoteCell:FindObjs()
  self.round = self:FindGO("Round")
  self.round_TweenScale = self.round:GetComponent(TweenScale)
  self.round_TweenScale:SetOnFinished(function()
    self:PassEvent("MusicNoteEnd", self)
  end)
end

function MusicNoteCell:SetData(data)
end

function MusicNoteCell:SetTimeStamp(time)
  self.time = time
end

function MusicNoteCell:SetIndex(index)
  self.index = index
end
