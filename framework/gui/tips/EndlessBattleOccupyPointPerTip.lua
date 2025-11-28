local _SliderColor = {
  [Camp_Vampire] = LuaColor(1.0, 0.22745098039215686, 0.2627450980392157),
  [Camp_Human] = LuaColor(0.12941176470588237, 0.8156862745098039, 0.9882352941176471),
  [Camp_Neutral] = LuaColor(0.39215686274509803, 0.39215686274509803, 0.39215686274509803)
}
local _CampStr = {
  [Camp_Human] = ZhString.EndlessBattleEvent_Camp_Human,
  [Camp_Vampire] = ZhString.EndlessBattleEvent_Camp_Vampire
}
autoImport("GVGPointPerTip")
EndlessBattleOccupyPointPerTip = class("EndlessBattleOccupyPointPerTip", GVGPointPerTip)

function EndlessBattleOccupyPointPerTip:Update()
  local camp = self.data.camp
  if self.data:IsOccupied() then
    local str = string.format(ZhString.EndlessBattleEvent_PerCamp, _CampStr[camp])
    self.descLab.text = str
  else
    self.descLab.text = ZhString.EndlessBattleEvent_Per
  end
  self.processSlider.value = self.data:GetProgress() or 0
  self.processImg.color = _SliderColor[camp]
end
