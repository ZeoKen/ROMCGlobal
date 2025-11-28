autoImport("ItemNewCell")
MaterialChooseCell = class("MaterialChooseCell", ItemNewCell)
MaterialChooseCell.PfbPath = "cell/MaterialItemNewCell"

function MaterialChooseCell:Init()
  MaterialChooseCell.super.Init(self)
  self:initView()
  self:AddViewEvents()
end

function MaterialChooseCell:initView()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.favoriteMask = self:FindGO("FavoriteMask")
end

function MaterialChooseCell:AddViewEvents()
  local long = self.gameObject:GetComponent(UILongPress)
  long = long or self.gameObject:AddComponent(UILongPress)
  if long then
    long.pressTime = 1.0
    
    function long.pressEvent(obj, isPress)
      if isPress then
        self:PassEvent(MouseEvent.LongPress, self)
      end
    end
  end
  self:AddCellClickEvent()
end

function MaterialChooseCell:SetData(data)
  MaterialChooseCell.super.SetData(self, data)
  self:UpdateChoose()
  self:UpdateFavoriteMask()
  self:UpdateBagType()
end

function MaterialChooseCell:SetChooseIds(chooseIds)
  self.chooseIds = chooseIds
  self:UpdateChoose()
end

function MaterialChooseCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  if self.data and self.chooseIds and #self.chooseIds > 0 then
    for i = 1, #self.chooseIds do
      local id = self.chooseIds[i]
      if self.data.id == id then
        self.chooseSymbol:SetActive(BagProxy.Instance:CheckIfFavoriteCanBeMaterial(self.data) ~= false)
        return
      end
    end
  end
  self.chooseSymbol:SetActive(false)
end

function MaterialChooseCell:UpdateFavoriteMask()
  if not self.favoriteMask then
    return
  end
  self.favoriteMask:SetActive(false)
  if not self.data then
    return
  end
  self.favoriteMask:SetActive(BagProxy.Instance:CheckIfFavoriteCanBeMaterial(self.data) == false)
end
