CookMasterTipCell = class("CookMasterTipCell", ItemCell)
autoImport("RewardGridCell")

function CookMasterTipCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function CookMasterTipCell:FindObjs()
  self.foodIcon = self:FindGO("FoodIcon"):GetComponent(UISprite)
  self.cookStyle = self:FindGO("CookStyle"):GetComponent(UISprite)
  self.bgTexture = self:FindGO("TextureBG"):GetComponent(UITexture)
  self.materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialCtl = UIGridListCtrl.new(self.materialGrid, RewardGridCell, "RewardGridCell")
  self.starList = self:FindGO("StarList")
  self.foodStarShow = {}
  for i = 1, 5 do
    local go = self:FindGO("FoodStar" .. i)
    self.foodStarShow[i] = self:FindGO("Show", go):GetComponent(UISprite)
  end
end

function CookMasterTipCell:SetData(data)
  self.data = data
  local recipeData = Table_Recipe[data]
  if not recipeData then
    return
  end
  local foodId = recipeData.Product
  local iconName = Table_Item[foodId].Icon
  IconManager:SetItemIcon(iconName, self.foodIcon)
  local cookStyle = recipeData.Type
  self.cookStyle.spriteName = "Disney_cwzb_icon_0" .. cookStyle
  self.foodIcon:MakePixelPerfect()
  self.foodIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1.5, 1.5, 1.5)
  local foodConfig = Table_Food[foodId]
  local cookHard = foodConfig.CookHard
  local a, b = math.modf(cookHard / 2)
  for i = 1, a + 1 do
    if i <= a then
      self.foodStarShow[i].gameObject:SetActive(true)
      self.foodStarShow[i].spriteName = "Disney_icon_star"
    elseif 0 < b then
      self.foodStarShow[i].gameObject:SetActive(true)
      self.foodStarShow[i].spriteName = "Disney_icon_star2"
    end
  end
  local material = recipeData.Material
  local datas = {}
  for i = 1, #material do
    local materialId = material[i][2]
    local itemData = Table_Item[materialId]
    if itemData then
      local data = {}
      data.itemData = ItemData.new("FoodMaterial", materialId)
      if data.itemData then
        data.num = 1
        table.insert(datas, data)
      end
    end
  end
  self.materialCtl:ResetDatas(datas)
  PictureManager.Instance:SetUI("Disney_cwzb_bg_04", self.bgTexture)
end

function CookMasterTipCell:SetSelectStatus(bool)
  self.select:SetActive(bool)
end

function CookMasterTipCell:OnDestroy()
  PictureManager.Instance:UnLoadUI("Disney_cwzb_bg_04", self.bgTexture)
end
