autoImport("BagItemCell")
TwelvePVPItemCell = class("TwelvePVPItemCell", BagItemCell)
local LevelItem = GameConfig.TwelvePvp.ShopItemConfig.LevelItem

function TwelvePVPItemCell:Init()
  TwelvePVPItemCell.super.Init(self)
end

function TwelvePVPItemCell:SetData(data)
  TwelvePVPItemCell.super.SetData(self, data)
  if data and self.numLab then
    if data.staticData and data.staticData.id and not LevelItem[data.staticData.id] then
      self.numLab.text = data.num or 0
      return
    end
    self.numLab.text = StringUtil.IntToRoman(data.num or 0)
  end
end
