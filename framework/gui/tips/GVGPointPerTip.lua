local _SliderColor = {
  red = LuaColor(1.0, 0.22745098039215686, 0.2627450980392157),
  blue = LuaColor(0.12941176470588237, 0.8156862745098039, 0.9882352941176471)
}
GVGPointPerTip = class("GVGPointPerTip", CoreView)

function GVGPointPerTip:ctor(go)
  GVGPointPerTip.super.ctor(self, go)
  self:Init()
end

function GVGPointPerTip:Init()
  self:_InitView()
end

function GVGPointPerTip:_InitView()
  self.descLab = self:FindComponent("DescLab", UILabel)
  local processObj = self:FindGO("ProcessObj")
  self.processImg = processObj:GetComponent(UISprite)
  self.processSlider = processObj:GetComponent(UISlider)
end

function GVGPointPerTip:Update()
  self.descLab.text = self.data.per > 0 and string.format(ZhString.GvgPoint_Per_Guild, self.data.guildName) or ZhString.GvgPoint_Per
  self.processSlider.value = self.data:GetOccupyProcess() or 0
  self.processImg.color = self.data:IsMyGuildPoint() and _SliderColor.blue or _SliderColor.red
end

function GVGPointPerTip:OnShow(data)
  self.data = data
  self:Update()
end
