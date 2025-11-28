local BaseCell = autoImport("BaseCell")
ERModeCell = class("ERModeCell", BaseCell)

function ERModeCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ERModeCell:FindObjs()
  self.select = self:FindGO("Select")
  self.label = self:FindComponent("Label", UILabel)
  self:Select(false)
end

function ERModeCell:SetData(data)
  self.data = data
  self.label.text = data.data
end

function ERModeCell:Select(isSelect)
  self.select:SetActive(isSelect)
  local config = GameConfig.Servant.EquipRecommend_SelectColor
  if not config then
    LogUtility.Error(string.format("[%s] Select() Error : GameConfig.Servant.EquipRecommend_SelectColor == nil!", self.__cname))
    return nil
  end
  local color = config[isSelect and 2 or 1]
  self.label.color = LuaGeometry.GetTempColorByHtml(color)
end
