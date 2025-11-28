local BaseCell = autoImport("BaseCell")
ERLevelCell = class("ERLevelCell", BaseCell)

function ERLevelCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ERLevelCell:FindObjs()
  self.select = self:FindGO("Select")
  self.label = self:FindComponent("Label", UILabel)
  self:Select(false)
end

function ERLevelCell:SetData(data)
  self.data = data
  self.label.text = string.format("%s-%s", tostring(data.min), tostring(data.max))
end

function ERLevelCell:Select(isSelect)
  self.select:SetActive(isSelect)
  local config = GameConfig.Servant.EquipRecommend_SelectColor
  if not config then
    LogUtility.Error(string.format("[%s] Select() Error : GameConfig.Servant.EquipRecommend_SelectColor == nil!", self.__cname))
    return nil
  end
  local color = config[isSelect and 2 or 1]
  self.label.color = LuaGeometry.GetTempColorByHtml(color)
end
