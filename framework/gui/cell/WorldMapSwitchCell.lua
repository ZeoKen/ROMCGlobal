local baseCell = autoImport("BaseCell")
WorldMapSwitchCell = class("WorldMapSwitchCell", baseCell)
local switchEffectId = "Eff_VortexMap"

function WorldMapSwitchCell:Init()
end

function WorldMapSwitchCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.to = data.to
  if true or WorldMapProxy.Instance.activeWorlds and WorldMapProxy.Instance.activeWorlds[self.to] == 1 then
    self.gameObject:SetActive(true)
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(data.showpos[1], data.showpos[2], 0)
    self:AddClickEvent(self.gameObject, function()
      if GameConfig.SystemForbid.WorldMap then
        return
      end
      self:PassEvent(MouseEvent.MouseClick, self.to)
    end)
  else
    self.gameObject:SetActive(false)
  end
  if not self.effect then
    local ctrl, eff = UIUtil.GetUIParticle(switchEffectId, 100, self.gameObject)
    self.effect = eff
  end
end
