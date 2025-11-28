autoImport("ItemCell")
SoundItemCell = class("SoundItemCell", ItemCell)
SoundItemCellEvent = {
  Play = "SoundItemCellEvent_Play",
  Buy = "SoundItemCellEvent_Buy"
}
local MusicCost = GameConfig.Music.cost or {100, 10000}

function SoundItemCell:Init()
  SoundItemCell.super.Init(self)
  self:InitCell()
end

function SoundItemCell:InitCell()
  self.playButton = self:FindGO("PlayButton")
  self:AddClickEvent(self.playButton, function(go)
    self:PassEvent(SoundItemCellEvent.Play, self)
  end)
  self.buyButton = self:FindGO("BuyButton")
  self:AddClickEvent(self.buyButton, function(go)
    self:PassEvent(SoundItemCellEvent.Buy, self)
  end)
  local costData = MusicCost[1] and Table_Item[MusicCost[1]]
  if costData then
    local buyButton_Icon = self:FindComponent("Icon", UISprite, self.buyButton)
    IconManager:SetItemIcon(costData.Icon, buyButton_Icon)
    local buyButton_Cost = self:FindComponent("Cost", UILabel, self.buyButton)
    buyButton_Cost.text = MusicCost[2]
  end
  self.soundName = self:FindComponent("SoundName", UILabel)
  self.timelab = self:FindComponent("Time", UILabel)
end

function SoundItemCell:SetData(data)
  SoundItemCell.super.SetData(self, data)
  if data then
    local sid = data.staticData and data.staticData.id
    local musicData = Table_MusicBox[sid]
    if musicData then
      local min = math.floor(musicData.MusicTim / 60)
      local sec = math.floor(musicData.MusicTim % 60)
      self.timelab.text = string.format("%02d:%02d", min, sec)
    end
    self.playButton:SetActive(data.num > 0)
    self.buyButton:SetActive(data.num <= 0)
    self.soundName.text = data.staticData.NameZh or musicData.MusicName
    UIUtil.WrapLabel(self.soundName)
  end
end
