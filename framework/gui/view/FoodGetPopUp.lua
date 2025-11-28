FoodGetPopUp = class("FoodGetPopUp", BaseView)
FoodGetPopUp.ViewType = UIViewType.Show3D2DLayer

function FoodGetPopUp:Init()
  self:InitView()
  self:MapEvent()
  self:InitData()
end

function FoodGetPopUp:InitView()
  self.shareLab = self:FindComponent("ShareLabel", UILabel)
  self.nameLab = self:FindComponent("NameLabel", UILabel)
  self.countLab = self:FindComponent("CountLabel", UILabel)
  self.typeLab = self:FindComponent("TypeLabel", UILabel)
  self.effectLab = self:FindComponent("EffectLabel", UILabel)
  self.modelContainer = self:FindComponent("ModelContainer", Transform)
  self.modelTexture = self:FindComponent("ModelContainer", UITexture)
  self.effectContainer = self:FindGO("EffectContainer")
  self.skipBtn = self:FindGO("skipBtn")
  self.bg = self:FindComponent("Bg", UITexture)
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("CookSmoke"))
  go.transform.localPosition = LuaGeometry.GetTempVector3(218, -219, 0)
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function()
    self:OnEnter()
  end)
  self.shareButton = self:FindGO("ShareButton")
  self:AddClickEvent(self.shareButton, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GeneralShareView
    })
  end)
  self:AddClickEvent(self.skipBtn, function()
    self:Log("skipBtn AddClickEvent")
    self:CloseSelf()
  end)
  self.shareButton:SetActive(false)
  self.foodStars = {}
  self.foodStars[0] = self:FindGO("FoodStars")
  if self.foodStars[0] then
    for i = 1, 5 do
      self.foodStars[i] = self:FindComponent(tostring(i), UISprite, self.foodStars[0])
    end
  end
end

function FoodGetPopUp:InitData()
  local items = self.viewdata.viewdata.items
  table.sort(items, function(x, y)
    local sidX = x.staticData.id
    local food_SdataX = sidX and Table_Food[sidX]
    local CookHardX = food_SdataX.CookHard
    if sidX == 551019 then
      CookHardX = 0
    end
    local sidY = y.staticData.id
    local food_SdataY = sidY and Table_Food[sidY]
    local CookHardY = food_SdataY.CookHard
    if sidY == 551019 then
      CookHardY = 0
    end
    return CookHardX < CookHardY
  end)
end

function FoodGetPopUp:UpdateFoodInfo()
  local sid = self.foodItem.staticData.id
  if sid then
    local food_Sdata = self.foodItem:GetFoodSData()
    local npcid = food_Sdata.NpcId
    if npcid then
      self:DestroyModel()
      local bodyid = Table_Npc[npcid] and Table_Npc[npcid].Body
      local scale = Table_Npc[npcid] and Table_Npc[npcid].Scale or 1
      self.model = UIModelUtil.Instance:SetRolePartModelTexture(self.modelTexture, Asset_Role.PartIndex.Body, bodyid, scale, self.ModelCreateCall, self)
      UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
      local container = UIModelUtil.Instance:GetContainerObj(self.modelTexture)
      if container then
        container.transform.localRotation = Quaternion.Euler(30, 170, 8)
      end
      self.model:RegisterWeakObserver(self)
    end
    local desc = ""
    local effectDesc = self.foodItem:GetFoodEffectDesc()
    if effectDesc then
      desc = ZhString.FoodGetPopUp_EffectTip .. effectDesc
    end
    desc = desc .. [[


]]
    local cacheSHP_desc = ""
    local hpStr, spStr
    if food_Sdata.SaveHP then
      hpStr = string.format(ZhString.FoodGetPopUp_SavePower_Desc, "Hp", food_Sdata.SaveHP)
    end
    if food_Sdata.SaveSP then
      spStr = string.format(ZhString.FoodGetPopUp_SavePower_Desc, "Sp", food_Sdata.SaveSP)
    end
    if hpStr and spStr then
      cacheSHP_desc = hpStr .. ZhString.FoodGetPopUp_SavePower_And .. spStr
    else
      cacheSHP_desc = hpStr and hpStr or spStr
    end
    if cacheSHP_desc ~= nil then
      desc = desc .. ZhString.FoodGetPopUp_SaveHSpTip .. cacheSHP_desc
      desc = desc .. "\n"
    end
    desc = desc .. "\n"
    self.effectLab.text = desc
    self.nameLab.text = self.foodItem:GetName()
    if 1 < self.foodItem.num then
      self.countLab.text = "X " .. self.foodItem.num
    else
      self.countLab.text = ""
    end
    if Game.Myself then
      self.shareLab.text = string.format(ZhString.FoodGetPopUp_MakeTip, Game.Myself.data:GetName())
    end
    local foodType = FunctionFood.Me():GetLastPotType() or 1
    self.typeLab.text = ZhString["FoodGetPopUp_FoodType" .. foodType]
    local cookHard = food_Sdata.CookHard
    if cookHard and 0 < cookHard then
      self.foodStars[0]:SetActive(true)
      local num = math.floor(cookHard / 2)
      for i = 1, 5 do
        if i <= num then
          self.foodStars[i].gameObject:SetActive(true)
          self.foodStars[i].spriteName = "food_icon_08"
        elseif i == num + 1 and cookHard % 2 == 1 then
          self.foodStars[i].gameObject:SetActive(true)
          self.foodStars[i].spriteName = "food_icon_09"
        else
          self.foodStars[i].gameObject:SetActive(false)
        end
      end
    else
      self.foodStars[0]:SetActive(false)
    end
    local recipeData = FunctionFood.Me():GetRecipeByFoodId(sid)
    self.effectContainer:SetActive(recipeData ~= nil and recipeData.Type ~= 4)
  end
end

function FoodGetPopUp.ModelCreateCall(rolePart, self, assetRolePart)
  if rolePart then
    local nameHash = ActionUtility.GetNameHash("state1002")
    rolePart:PlayAction(nameHash, nameHash, 1, 0)
    local tr = rolePart.transform
    if tr then
      tr = tr.gameObject:AddComponent(TweenRotation)
      tr.to = LuaGeometry.GetTempVector3(0, 360, 0)
      tr.duration = 8
      tr.style = 1
    end
  end
end

function FoodGetPopUp:ObserverDestroyed(model)
  if model ~= nil and model == self.model then
    model:ResetLocalScaleXYZ(1, 1, 1)
    model:ResetParent(nil)
  end
end

function FoodGetPopUp:MapEvent()
end

function FoodGetPopUp:OnEnter()
  FoodGetPopUp.super.OnEnter(self)
  PictureManager.Instance:SetUI("food_bg_01", self.bg)
  local viewdata = self.viewdata.viewdata
  local items = viewdata and viewdata.items
  local foodTotalCount = FoodProxy.Instance.foodGetCount
  if 1 <= foodTotalCount then
    self.foodItem = items and items[foodTotalCount]
    FoodProxy.Instance.foodGetCount = foodTotalCount - 1
    self:UpdateFoodInfo()
    self:sendNotification(FoodEvent.FoodGetPopUp_Enter)
  else
    self:CloseSelf()
  end
end

function FoodGetPopUp:DestroyModel()
  if self.model then
    local t = self.model:GetTransform()
    if t then
      local cps, cp = t:GetComponentsInChildren(TweenRotation)
      for i = 1, #cps do
        cp = cps[i]
        GameObject.Destroy(cp)
      end
    end
    self.model = nil
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
  end
end

function FoodGetPopUp:OnExit()
  self:DestroyModel()
  self.modelTexture = nil
  PictureManager.Instance:UnLoadUI("food_bg_01", self.bg)
  self:sendNotification(FoodEvent.FoodGetPopUp_Exit)
  if FoodProxy.Instance.adventureFoodCookPreparing then
    ServiceSceneFoodProxy.Instance:CallPrepareCook(false)
    FoodProxy.Instance.adventureFoodCookPreparing = nil
  end
  FoodGetPopUp.super.OnExit(self)
end
