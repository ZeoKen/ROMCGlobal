local BaseCell = autoImport("BaseCell")
HRefineEffectTipCell = class("HRefineEffectTipCell", BaseCell)

function HRefineEffectTipCell:Init()
  self.refineLabel = self:FindComponent("Refine", UILabel)
  self.effectLabel = self:FindComponent("Effect", UILabel)
end

function HRefineEffectTipCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.refineLabel.text = string.format(ZhString.HRefineEffectTip_RefineFormat, data[1])
    local effect = data[2]
    if effect then
      local proKey, proValue = effect[1], effect[2]
      local effectName = GameConfig.EquipEffect[effect[1]] or effect[1] .. " No Find"
      local nowEV_Str = ""
      local PropNameConfig = Game.Config_PropName
      local config = PropNameConfig[proKey]
      if config.IsPercent == 1 then
        nowEV_Str = proValue * 100 .. "%"
      else
        nowEV_Str = proValue
      end
      if 0 < proValue then
        nowEV_Str = "+" .. nowEV_Str
      end
      self.effectLabel.text = string.format(ZhString.HRefineEffectTip_EffectFormat, effectName, nowEV_Str)
    else
      self.effectLabel.text = "--"
    end
  else
    self.gameObject:SetActive(false)
  end
end
