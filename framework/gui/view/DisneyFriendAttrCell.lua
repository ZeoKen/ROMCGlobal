local BaseCell = autoImport("BaseCell")
DisneyFriendAttrCell = class("DisneyFriendAttrCell", BaseCell)

function DisneyFriendAttrCell:Init()
  DisneyFriendAttrCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyFriendAttrCell:FindObjs()
  self.colorSprite = self:FindGO("ColorSprite"):GetComponent(UISprite)
  self.attrName = self:FindGO("Name"):GetComponent(UILabel)
  self.attrEffectName = self:FindGO("AttrName"):GetComponent(UILabel)
  self.attrNum = self:FindGO("AttrNum"):GetComponent(UILabel)
end

function DisneyFriendAttrCell:SetData(data)
  self.data = data
  local name = data.Name
  self.attrName.text = name
  self.attrEffectName.text = data.attrNameEn
  local type = data.type
  if type and type == 2 then
    self.colorSprite.color = LuaGeometry.GetTempVector4(0.7372549019607844, 0.5607843137254902, 1, 1)
  else
    self.colorSprite.color = LuaGeometry.GetTempVector4(1, 0.7764705882352941, 0.5607843137254902, 1)
  end
  if not data.attrNum then
    self.attrNum.text = ""
    self.attrEffectName.width = 200
    return
  end
  if data.attrNum == 0 then
    self.attrNum.text = ""
    self.attrEffectName.width = 200
  elseif data.attrNum > 0 then
    self.attrNum.text = "+" .. data.attrNum .. data.unit
    self.attrEffectName.width = 137
  elseif data.attrNum < 0 then
    self.attrNum.text = data.attrNum .. data.unit
    self.attrEffectName.width = 137
  end
end
