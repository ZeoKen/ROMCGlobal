local baseCell = autoImport("BaseCell")
local TogColor = {
  [1] = Color(0.7019607843137254, 0.4196078431372549, 0.1411764705882353, 1),
  [2] = Color(0.5176470588235295, 0.6431372549019608, 0.8352941176470589, 1)
}
GeffenMagicWaveCell = class("GeffenMagicWaveCell", baseCell)

function GeffenMagicWaveCell:Init()
  GeffenMagicWaveCell.super.Init(self)
  self:FindObj()
  self:AddCellClickEvent()
end

function GeffenMagicWaveCell:FindObj()
  self.bgSprite = self:FindComponent("SpriteBg", UISprite)
  self.waveIndexLab = self.gameObject:GetComponent(UILabel)
end

function GeffenMagicWaveCell:SetData(data)
  self.data = data
  self.waveIndexLab.text = string.format(ZhString.GeffenMagic_Wave_Title, data)
  self:UpdateChoose()
end

function GeffenMagicWaveCell:SetChoosen(id)
  self.chooseWave = id
  self:UpdateChoose()
end

function GeffenMagicWaveCell:UpdateChoose()
  if self.data and self.chooseWave and self.data == self.chooseWave then
    self.bgSprite.spriteName = "recharge_btn_1"
    self.waveIndexLab.color = TogColor[1]
  else
    self.bgSprite.spriteName = "recharge_btn_3"
    self.waveIndexLab.color = TogColor[2]
  end
end
