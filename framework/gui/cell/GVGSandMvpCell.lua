local tempV3 = LuaVector3()
local max_hp
local mvp_id = 40023
local GetMaxHp = function()
  if not max_hp then
    max_hp = Table_Monster[mvp_id].Hp
  end
  return max_hp
end
local hp_str = "%d/%d"
BaseCell = autoImport("BaseCell")
GVGSandMvpCell = class("GVGSandMvpCell", BaseCell)

function GVGSandMvpCell:Init()
  self:FindObjs()
  self:InitCellFunc()
end

function GVGSandMvpCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.willSummonLab = self:FindGO("WillSummonLab"):GetComponent(UILabel)
  self.hp = self:FindGO("HP")
  self.hpSlider = self.hp:GetComponent(UISlider)
  self.hpLabel = self:FindComponent("HpLab", UILabel, self.hp)
  self.deadSp = self:FindGO("DeadSp")
  self.MvpSp_Light = self:FindGO("MvpSp_Light")
  self.MvpSp_Gray = self:FindGO("MvpSp_Gray")
end

function GVGSandMvpCell:InitCellFunc()
  self.updateCellFunc = {}
  self.updateCellFunc[GvgProxy.EMvpState.Will_Summon] = self.Update_WillSummon
  self.updateCellFunc[GvgProxy.EMvpState.Summoned] = self.Update_Summoned
  self.updateCellFunc[GvgProxy.EMvpState.Die] = self.Update_Die
end

function GVGSandMvpCell:SetData(gvgSandTableData)
  self.data = gvgSandTableData
  local config = GameConfig.GvgNewConfig.city_type_to_mvp
  if not self.data.mvp or not config then
    self:Hide()
    return
  end
  local city_type = gvgSandTableData.staticData and gvgSandTableData.staticData.CityType
  if city_type and config[city_type] then
    self:SetPos()
    self:UpdateCell()
  else
    self:Hide()
  end
end

function GVGSandMvpCell:UpdateCell()
  self:ClearTick()
  local state = self.data.mvp.mvp_state
  local updateFunc = state and self.updateCellFunc[state]
  if updateFunc then
    self:Show()
    updateFunc(self)
  else
    self:Hide()
  end
end

function GVGSandMvpCell:Update_WillSummon()
  self:Show(self.willSummonLab)
  self:Hide(self.hp)
  self:Hide(self.deadSp)
  self:Hide(self.MvpSp_Light)
  self:Show(self.MvpSp_Gray)
  self:Hide(self.name)
  self:CreateTick()
end

function GVGSandMvpCell:Update_Summoned()
  self:Show(self.hp)
  self:Show(self.name)
  self:Hide(self.deadSp)
  self:Hide(self.willSummonLab)
  self.hpSlider.value = self.data.mvp.mvp_hp_per / 100
  local hp = self.data.mvp.mvp_hp_per / 100 * GetMaxHp()
  self.hpLabel.text = string.format(hp_str, hp, GetMaxHp())
  self.name.text = ZhString.GVGSandTable_Sommoned
  self:Show(self.MvpSp_Light)
  self:Hide(self.MvpSp_Gray)
end

function GVGSandMvpCell:Update_Die()
  self:Show(self.hp)
  self:Show(self.name)
  self:Hide(self.MvpSp_Light)
  self:Hide(self.willSummonLab)
  self:Show(self.MvpSp_Gray)
  self.hpSlider.value = 0
  self.hpLabel.text = string.format(hp_str, 0, GetMaxHp())
  self.name.text = ZhString.GVGSandTable_MvpDie
  self:Show(self.deadSp)
end

function GVGSandMvpCell:SetPos()
  local pos = GameConfig.GVGSandTable.MapConfig.MvpNodePos
  if not pos then
    return
  end
  local mode = Game.MapManager:GetLobbyMode()
  pos = pos[mode]
  if not pos then
    return
  end
  LuaVector3.Better_Set(tempV3, pos[1], pos[2], 0)
  self.gameObject.transform.localPosition = tempV3
end

function GVGSandMvpCell:CreateTick()
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTick, self, 1)
end

function GVGSandMvpCell:_UpdateTick()
  local mvp_summon_time = self.data and self.data.mvp and self.data.mvp.mvp_summon_time
  if not mvp_summon_time then
    self:ClearTick()
    return
  end
  local server_time = ServerTime.CurServerTime() / 1000
  local left_time = mvp_summon_time - server_time
  if 0 < left_time then
    self.willSummonLab.text = string.format(ZhString.GVGSandTable_WillSommon, left_time)
  else
    self:ClearTick()
  end
end

function GVGSandMvpCell:ClearTick()
  if not self.tick then
    return
  end
  self.tick:Destroy()
  self.tick = nil
end
