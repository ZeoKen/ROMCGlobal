local baseCell = autoImport("BaseCell")
TechTreeBuildingCell = class("TechTreeBuildingCell", baseCell)
local dibanTexName, lockColor, picIns = "tree_bg_diban", LuaColor.New(0.14901960784313725, 0.16862745098039217, 0.26666666666666666, 0.6)

function TechTreeBuildingCell:Init()
  if not picIns then
    picIns = PictureManager.Instance
  end
  self.title = self:FindComponent("Title", UILabel)
  self.dibanTex = self:FindComponent("Diban", UITexture)
  self.buildingTex = self:FindComponent("Building", UITexture)
  self.chooseWidget = self:FindComponent("Choose", UIWidget)
  self:AddCellClickEvent()
end

function TechTreeBuildingCell:SetData(data)
  if not self.dibanTexLoaded then
    picIns:SetUI(dibanTexName, self.dibanTex)
    self.dibanTexLoaded = true
  end
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    local isUnlock = self:GetUnlock()
    self.title.text = isUnlock and data.Name or "????????"
    if self.buildingTexName ~= data.Icon then
      self:TryUnloadBuildingTex()
      self.buildingTexName = data.Icon
      if self.buildingTexName then
        picIns:SetUI(self.buildingTexName, self.buildingTex)
      end
    end
    self.buildingTex.color = isUnlock and ColorUtil.NGUIWhite or lockColor
  end
  self:UpdateChoose()
end

function TechTreeBuildingCell:SetChooseId(id)
  self.chooseId = id
  self:UpdateChoose()
end

function TechTreeBuildingCell:UpdateChoose()
  local isChoose = self.chooseId and self.data and self.chooseId == self.data.id
  self.chooseWidget.alpha = isChoose and 1 or 0.001
end

function TechTreeBuildingCell:GetUnlock()
  return self.data ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(self.data.MenuID)
end

function TechTreeBuildingCell:OnCellDestroy()
  self:TryUnloadBuildingTex()
  if self.dibanTexLoaded then
    picIns:UnLoadUI(dibanTexName, self.dibanTex)
  end
end

function TechTreeBuildingCell:TryUnloadBuildingTex()
  if self.buildingTexName then
    picIns:UnLoadUI(self.buildingTexName, self.buildingTex)
  end
end
