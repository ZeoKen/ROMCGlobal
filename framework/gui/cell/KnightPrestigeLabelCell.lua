local BaseCell = autoImport("BaseCell")
KnightPrestigeLabelCell = class("KnightPrestigeLabelCell", BaseCell)

function KnightPrestigeLabelCell:Init()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.conditionSymbol = self:FindGO("ConditionSymbol")
end

function KnightPrestigeLabelCell:SetData(data)
  self.data = data
  local id = data.id
  local process = data and data.process or 0
  local state = data and data.state or 0
  self.lockSymbol:SetActive(state == 0)
  self.finishSymbol:SetActive(state == 1)
  self.conditionSymbol:SetActive(false)
  self.label.color = state == 1 and LuaColor.Black() or LuaGeometry.GetTempVector4(0.49411764705882355, 0.49411764705882355, 0.49411764705882355, 1)
  local conditionConfig = Table_PrestigeUnlockCondition[id]
  if conditionConfig then
    local desc = OverSea.LangManager.Instance():GetLangByKey(conditionConfig.Desc)
    if state == 0 and conditionConfig.Condition ~= "prestige" then
      desc = desc .. "  " .. process .. "/" .. conditionConfig.TargetNum
    end
    self.label.text = desc
  else
    self.label.text = "????????"
  end
end

function KnightPrestigeLabelCell:SetFinish(bool)
  self.finishSymbol:SetActive(bool)
  self.lockSymbol:SetActive(not bool)
  self.conditionSymbol:SetActive(false)
  self.label.color = bool and LuaColor.Black() or LuaGeometry.GetTempVector4(0.49411764705882355, 0.49411764705882355, 0.49411764705882355, 1)
end

function KnightPrestigeLabelCell:SetCondition(bool)
  self.conditionSymbol:SetActive(bool)
  self.finishSymbol:SetActive(false)
  self.lockSymbol:SetActive(false)
end

KnightPrestigeUnlockCell = class("KnightPrestigeUnlockCell", KnightPrestigeLabelCell)

function KnightPrestigeUnlockCell:SetData(data)
  self.id = data
  local assetEffectConfig = Table_AssetEffect[self.id]
  if assetEffectConfig then
    local desc = OverSea.LangManager.Instance():GetLangByKey(assetEffectConfig.Desc)
    self.label.text = desc
    self.label.color = LuaColor.Black()
  end
end
