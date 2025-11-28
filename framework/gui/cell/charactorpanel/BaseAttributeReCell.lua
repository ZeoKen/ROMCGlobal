autoImport("BaseAttributeCell")
BaseAttributeReCell = class("BaseAttributeReCell", BaseAttributeCell)
local maxFormat = "（Max: %.1f%% ）"
local defaultSpd = 3.3

function BaseAttributeReCell:Init()
  self:initView()
  self:addViewEventListener()
end

function BaseAttributeReCell:addViewEventListener()
  self:AddCellClickEvent()
end

local tempVector3 = LuaVector3.Zero()

function BaseAttributeReCell:SetData(data)
  BaseAttributeReCell.super.SetData(self, data)
  local id = data.prop.propVO.id
  local staticData = Table_RoleData[id]
  if not staticData then
    return
  end
  local desc = staticData.DataDesc
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.name.transform))
  if StringUtil.IsEmpty(desc) then
    tempVector3[2] = 0
    self.name.transform.localPosition = tempVector3
    self:Hide(self.attributeDesc.gameObject)
  else
    tempVector3[2] = 6.5
    self.name.transform.localPosition = tempVector3
    self:Show(self.attributeDesc.gameObject)
    self.attributeDesc.text = desc
  end
  self:Show(self.line)
  if self.upLimitLabel and GameConfig.Charactor_InfoShow_Limit then
    local limitValue = GameConfig.Charactor_InfoShow_Limit[id]
    if limitValue then
      if id ~= 221 then
        self.upLimitLabel.text = "（Max: " .. limitValue .. "）"
      else
        local delta = Game.Myself.data.props:GetPropByName("MoveSpd_Limit"):GetValue() or 0
        self.upLimitLabel.text = string.format(maxFormat, (defaultSpd - delta) * 100)
      end
    end
  end
end

function BaseAttributeReCell:initView()
  BaseAttributeReCell.super.initView(self)
  self.attributeDesc = self:FindComponent("attributeDesc", UILabel)
  self.upLimitLabel = self:FindComponent("upLimit", UILabel)
end
