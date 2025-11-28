local BaseCell = autoImport("BaseCell")
DisneySongCell = class("DisneySongCell", BaseCell)
local _SongStateSP = {
  "Disney_stage_icon_song2",
  "Disney_stage_icon_song1"
}

function DisneySongCell:Init()
  self.songLab = self:FindComponent("SongLab", UILabel)
  self.selected = self:FindGO("Selected")
  self.songStateSp = self:FindComponent("State", UISprite)
  self.bg = self:FindGO("Bg")
  self:SetEvent(self.bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DisneySongCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.songLab.text = data.Name
  self:UpdateChoose()
end

function DisneySongCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function DisneySongCell:UpdateChoose()
  if nil ~= self.selected then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.selected:SetActive(true)
      self.songStateSp.spriteName = _SongStateSP[1]
    else
      self.selected:SetActive(false)
      self.songStateSp.spriteName = _SongStateSP[2]
    end
  end
end
