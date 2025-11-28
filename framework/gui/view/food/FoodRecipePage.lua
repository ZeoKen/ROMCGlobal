FoodRecipePage = class("FoodRecipePage", SubView)
autoImport("RecipeCell")
RecipeType_Map = {
  SceneFood_pb.ECOOKTYPE_JIANCHAO,
  SceneFood_pb.ECOOKTYPE_BARBECUE,
  SceneFood_pb.ECOOKTYPE_SOUP,
  SceneFood_pb.ECOOKTYPE_DESSERT
}

function FoodRecipePage:Init()
  self:MapEvents()
  self:InitUI()
end

function FoodRecipePage:InitUI()
  local recipeWrap = self:FindGO("RecipeWrap")
  local activeH = Game.GameObjectUtil:GetUIActiveHeight(self.gameObject)
  local pfbNum = math.ceil((activeH - 95) / 104) + 1
  local wrapConfig = {
    wrapObj = recipeWrap,
    pfbNum = pfbNum,
    cellName = "RecipeCell",
    control = RecipeCell
  }
  self.recipeCtl = WrapCellHelper.new(wrapConfig)
  self.recipeCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.recipeCells = self.recipeCtl:GetCellCtls()
  self.recipeTog = self:FindGO("RecipeTog")
  self:AddClickEvent(self.recipeTog, function(go)
    for i = 1, #self.recipeCells do
      self.recipeCells[i]:Refresh()
    end
  end)
  self.recipeTogs = {}
  for i = 1, 4 do
    local tog = self:FindGO("Tog" .. i)
    self.recipeTogs[i] = tog
    self:AddClickEvent(tog, function()
      self:UpdateRecipes(i)
    end)
  end
  self.filter = self:FindComponent("DiffFilter", UIPopupList)
  self.filter:AddItem(ZhString.FoodMakeView_Diff_All, 0)
  for i = 1, 5 do
    self.filter:AddItem(i .. ZhString.FoodMakeView_Diff_Star, i)
  end
  EventDelegate.Add(self.filter.onChange, function()
    self:UpdateRecipes(nil, self.filter.data)
  end)
  self.recipeStick = self:FindComponent("TipStick", UIWidget)
end

function FoodRecipePage:HandleClickItem(cellCtl)
  local data = cellCtl.data
  if data then
    if self.chooseRecipe ~= data then
      self:SetChooseRecipe(data)
    else
      self:ShowRecipeTip(data)
    end
  end
end

function FoodRecipePage:SetChooseRecipe(recipeData)
  self.chooseRecipe = recipeData
  local chooseid
  for i = 1, #self.recipeCells do
    chooseid = recipeData and recipeData.staticData.id or 0
    self.recipeCells[i]:SetChoose(chooseid)
  end
end

function FoodRecipePage:ShowRecipeTip(recipeData)
  TipManager.Instance:ShowFoodRecipeTip(recipeData, self.recipeStick, NGUIUtil.AnchorSide.TopLeft, {0, 0})
end

local recipes = {}
local fliterRecipes = {}

function FoodRecipePage:UpdateRecipes(recipeIndex, fliterDiff)
  if recipeIndex == nil then
    if self.recipeIndex ~= nil then
      recipeIndex = self.recipeIndex
    else
      recipeIndex = 1
    end
  end
  if fliterDiff == nil then
    if self.fliterDiff ~= nil then
      fliterDiff = self.fliterDiff
    else
      fliterDiff = 0
    end
  end
  self.recipeIndex = recipeIndex
  self.fliterDiff = fliterDiff
  local rtype = RecipeType_Map[recipeIndex]
  if rtype then
    self:SetChooseRecipe(nil)
    TableUtility.ArrayClear(recipes)
    local recipesFromProxy = FoodProxy.Instance:GetRecipesByType(rtype)
    if recipesFromProxy then
      for i = 1, #recipesFromProxy do
        if ItemUtil.CheckFoodCanMakeByTime(recipesFromProxy[i].staticData.id) then
          table.insert(recipes, recipesFromProxy[i])
        end
      end
    end
    if self.fliterDiff == 0 then
      self.recipeCtl:ResetPosition()
      self.recipeCtl:UpdateInfo(recipes)
    else
      TableUtility.ArrayClear(fliterRecipes)
      for i = 1, #recipes do
        local rData = recipes[i]
        local difflv = rData:GetDiffLevel()
        difflv = difflv / 2
        if difflv > fliterDiff - 1 and fliterDiff >= difflv then
          table.insert(fliterRecipes, rData)
        end
      end
      self.recipeCtl:ResetPosition()
      self.recipeCtl:UpdateInfo(fliterRecipes)
    end
  end
end

function FoodRecipePage:MapEvents()
  self:AddListenEvt(ServiceEvent.SceneFoodUnlockRecipeNtf, self.UpdateRecipes)
end

function FoodRecipePage:OnEnter()
  FoodRecipePage.super.OnEnter(self)
  self:UpdateRecipes(1, 0)
end

function FoodRecipePage:OnDestroy()
  self.filter.onChange = nil
  self.recipeCtl:Destroy()
  FoodRecipePage.super.OnDestroy(self)
end
