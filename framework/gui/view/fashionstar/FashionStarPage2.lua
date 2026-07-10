autoImport("FashionStarColorCell")
FashionStarPage2 = class("FashionStarPage2", SubView)

function FashionStarPage2:Init()
  self:InitUI()
end

function FashionStarPage2:InitUI()
  self.colorList = self:FindComponent("ColorList", UIGrid)
  self.colorListCtrl = UIGridListCtrl.new(self.colorList, FashionStarColorCell, "FashionStarColorCell")
  self.colorListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickColor, self)
end

function FashionStarPage2:InitView()
  if self.staticEquips then
    return
  end
  local bodyConfig = self.container.currentStaticData and self.container.currentStaticData.Param and self.container.currentStaticData.Param.Body
  if bodyConfig then
    local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
    local field = gender == 1 and "Male" or "Female"
    local config = bodyConfig[field]
    if config then
      self.staticEquips = config
    end
  end
  if not self.staticEquips then
    return
  end
  self.data = {}
  if self.staticEquips then
    for i = 1, #self.staticEquips do
      self.data[i] = {
        equipId = self.staticEquips[i][1],
        color = self.staticEquips[i][2],
        headId = self.staticEquips[i][3],
        index = i
      }
    end
  end
  self.colorListCtrl:ResetDatas(self.data)
end

function FashionStarPage2:OnShow()
  self:InitView()
  self.selectedColorIndex = 1
  self:UpdateCharacterModel()
end

function FashionStarPage2:OnClickColor(cell)
  if self.selectedColorIndex == cell.data.index then
    return
  end
  self.selectedColorIndex = cell.data.index
  self:UpdateCharacterModel()
end

function FashionStarPage2:UpdateColorList()
  local cells = self.colorListCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:SetChoosen(self.selectedColorIndex)
  end
end

function FashionStarPage2:UpdateCharacterModel()
  self:UpdateColorList()
  local data = self.data[self.selectedColorIndex]
  if data then
    self.container:ChangeBodyPart(data.equipId, data.headId)
  end
end

function FashionStarPage2:OnHide()
  self.container:Revert2DefaultModel()
end
