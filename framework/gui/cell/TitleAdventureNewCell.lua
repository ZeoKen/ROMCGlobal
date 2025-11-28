TitleAdventureNewCell = class("TitleAdventureNewCell", TitleCell)
local grayLabel = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
local blackLabel = Color(0.17647058823529413, 0.17647058823529413, 0.17647058823529413, 1)
local usingLabel = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function TitleAdventureNewCell:FindObjs()
  TitleAdventureNewCell.super.FindObjs(self)
  self.attrGrid = self:FindGO("AttrGrid"):GetComponent(UIGrid)
  self.attrGridCtrl = UIGridListCtrl.new(self.attrGrid, TitleAdventureAttrCell, "TitleAdventureAttrCell")
end

function TitleAdventureNewCell:SetData(data)
  TitleAdventureNewCell.super.SetData(self, data)
  local staticData = Table_Appellation[self.id]
  if not staticData then
    return
  end
  local attrList = {}
  local config = TitleProxy.Instance.allTitleConfig[self.id]
  local previewTitles = config and config.previewTitles
  if previewTitles and 0 < #previewTitles then
    local propDatas = {}
    for i = 1, #previewTitles do
      local propList = TitleProxy.Instance:GetPropsListByTitleId(previewTitles[i])
      for k, v in pairs(propList) do
        if not propDatas[k] then
          propDatas[k] = v
        else
          propDatas[k] = propDatas[k] + v
        end
      end
    end
    local prop = staticData.BaseProp
    for k, v in pairs(prop) do
      local single = {name = k, value = v}
      if not propDatas[k] then
        propDatas[k] = v
      else
        propDatas[k] = propDatas[k] + v
      end
    end
    for k, v in pairs(propDatas) do
      local single = {name = k, value = v}
      table.insert(attrList, single)
    end
  else
    local prop = staticData.BaseProp
    for k, v in pairs(prop) do
      local single = {name = k, value = v}
      table.insert(attrList, single)
    end
  end
  self.attrGridCtrl:ResetDatas(attrList)
  local cells = self.attrGridCtrl:GetCells()
  local curID = Game.Myself.data:GetAchievementtitle()
  if curID == self.id and self.unlocked then
    self.titleName.color = usingLabel
    for i = 1, #cells do
      cells[i]:SetColor(blackLabel)
    end
  elseif self.unlocked then
    self.titleName.color = blackLabel
    for i = 1, #cells do
      cells[i]:SetColor(blackLabel)
    end
  else
    self.titleName.color = grayLabel
    for i = 1, #cells do
      cells[i]:SetColor(grayLabel)
    end
  end
end

autoImport("BaseCell")
TitleAdventureAttrCell = class("TitleAdventureAttrCell", BaseCell)

function TitleAdventureAttrCell:Init()
  TitleAdventureAttrCell.super.Init(self)
  self:FindObjs()
end

function TitleAdventureAttrCell:FindObjs()
  self.attrLabel = self:FindGO("AttrLabel"):GetComponent(UILabel)
end

function TitleAdventureAttrCell:SetData(data)
  self.data = data
  self.attrLabel.text = tostring(data.name) .. "+" .. tostring(data.value)
end

function TitleAdventureAttrCell:SetColor(color)
  self.attrLabel.color = color
end
