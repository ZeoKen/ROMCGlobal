local baseCell = autoImport("BaseCell")
BusinessmanMakeModelCell = class("BusinessmanMakeModelCell", baseCell)
autoImport("EffectShowDataWraper")
local posVec = LuaVector3.Zero()
local rotVec = LuaVector3.Zero()
local scaleVec = LuaVector3.Zero()
local rotationQua = LuaQuaternion.Identity()

function BusinessmanMakeModelCell:OnRemove()
  if self.itemShowWraper then
    self.itemShowWraper:Exit()
    self.itemShowWraper = nil
  end
end

function BusinessmanMakeModelCell:Init()
  BusinessmanMakeModelCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function BusinessmanMakeModelCell:FindObjs()
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.numLab = self:FindGO("NumLabel"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self.produceRate = self:FindGO("ProduceRate"):GetComponent(UILabel)
  self.modelContainer = self:FindGO("ModelContainer")
end

function BusinessmanMakeModelCell:SetData(data, showType)
  self.data = data
  if data then
    if self.itemShowWraper then
      self.itemShowWraper:Exit()
      self.itemShowWraper = nil
    end
    self.itemShowWraper = EffectShowDataWraper.new(data, nil, showType, nil)
    local obj = self.itemShowWraper:getModelObj(self.modelContainer)
    if self.itemShowWraper.showType == FloatAwardView.ShowType.ModelType then
      self:ShowItemModel(obj)
    end
    local staticData = data.staticData
    if staticData then
      self.itemName.text = staticData.NameZh
      self.desc.text = staticData.Desc
      UIUtil.WrapLabel(self.desc)
    end
  end
end

function BusinessmanMakeModelCell:ShowItemModel(obj)
  if self.itemShowWraper.itemData.equipInfo then
    LuaVector3.Better_Set(posVec, 0, 0, 0)
    LuaQuaternion.Better_Set(rotationQua, 0, 0, 0, 0)
    LuaVector3.Better_Set(scaleVec, 1, 1, 1)
    local itemModelName = self.itemShowWraper.itemData.equipInfo.equipData.Model
    local modelConfig = ModelShowConfig[itemModelName]
    if modelConfig then
      local position = modelConfig.localPosition
      LuaVector3.Better_Set(posVec, position[1], position[2], position[3])
      local rotation = modelConfig.localRotation
      LuaQuaternion.Better_Set(rotationQua, rotation[1], rotation[2], rotation[3], rotation[4])
      local scale = modelConfig.localScale
      LuaVector3.Better_Set(scaleVec, scale[1], scale[2], scale[3])
    end
    obj:ResetLocalPosition(posVec)
    LuaQuaternion.Better_GetEulerAngles(rotationQua, rotVec)
    obj:ResetLocalEulerAngles(rotVec)
    obj:ResetLocalScale(scaleVec)
  end
end

function BusinessmanMakeModelCell:SetProduceRate(data)
  if self.produceRate then
    local rate = 100
    if data then
      if data.DynamicRate == 1 then
        rate = CommonFun.calcProduceRate(Game.Myself.data, data.Type, data.Category, data.id) / 100
      end
      self.produceRate.text = string.format(ZhString.Businessman_ProduceRate, rate)
    end
    self.produceRate.gameObject:SetActive(data ~= nil)
  end
end

function BusinessmanMakeModelCell:SetProductNum(data, times)
  times = times or 0
  local canMakeNum = data:GetProductNum() * times
  if 1 < canMakeNum then
    self.numLab.gameObject:SetActive(true)
    self.numLab.text = canMakeNum
  else
    self.numLab.gameObject:SetActive(false)
  end
end
