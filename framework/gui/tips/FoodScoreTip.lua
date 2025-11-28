autoImport("BaseTip")
FoodScoreTip = class("FoodScoreTip", BaseView)
autoImport("TipLabelCell")

function FoodScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("FoodScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end

function FoodScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function FoodScoreTip:Init()
  self.itemName = self:FindComponent("itemName", UILabel)
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  local monoComp = self.gameObject:GetComponent(RelateGameObjectActive)
  if monoComp then
    function monoComp.enable_Call()
      self:OnEnable()
    end
    
    function monoComp.disable_Call()
      self:OnDisable()
    end
  end
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self:initLockBord()
  self:AddButtonEvent("PutFoodBtn", function()
    local data = self.data
    local sdata = data and data.itemData.staticData
    if sdata then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AdventurePutFoodPopUp,
        viewdata = {
          itemid = sdata.id
        }
      })
    end
  end)
  self:AddButtonEvent("CookBtn", function()
    local data = self.data
    local sdata = data and data.itemData.staticData
    if sdata then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AdventureMakeFoodPopUp,
        viewdata = {
          itemid = sdata.id
        }
      })
    end
  end)
end

function FoodScoreTip:initLockBord()
  local obj = self:FindGO("LockBord")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    obj.name = "LockBord"
  end
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.sprLock = self:FindComponent("Sprite (1)", UISprite, obj)
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  
  function self.lockTipLabel.onChange()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  
  local LockTitle = self:FindComponent("LockTitle", UILabel)
  LockTitle.text = ZhString.MonsterTip_LockTitle
  self.modelBottombg = self:FindGO("modelBottombg")
end

function FoodScoreTip:SetData(foodData)
  self.data = foodData
  self:initData()
  self:SetLockState()
  self:UpdateTopInfo()
  self:UpdateAttriText()
  self:adjustPanelDepth(4)
  self:UpdateNumLabel()
end

function FoodScoreTip:initData()
  self.scrollview:ResetPosition()
end

function FoodScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    self.isUnlock = self.data.status ~= SceneFood_pb.EFOODSTATUS_MIN
    self.lockTipLabel.text = self.data.itemData.staticData.NameZh
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  self.lockBord.gameObject:SetActive(not self.isUnlock)
  if not self.isUnlock then
    self.itemName.text = "????"
  end
  if self.isUnlock then
    self:Show(self.modelBottombg)
  else
    self:Hide(self.modelBottombg)
  end
  return self.isUnlock
end

function FoodScoreTip:UpdateTopInfo()
  local data = self.data
  local sdata = data and data.itemData.staticData
  if sdata then
    self.itemName.text = sdata.NameZh
  end
end

function FoodScoreTip:UpdateNumLabel()
  local data = self.data
  local sdata = data and data.itemData.staticData
  if sdata then
    self.numLabel.text = string.format(ZhString.FoodScoreTip_CurNumFormat, BagProxy.Instance:GetItemNumByStaticID(sdata.id, BagProxy.BagType.Food) or 0)
  end
end

function FoodScoreTip:Show3DModel()
  local foodData = Table_Food[self.data.itemid]
  if foodData and foodData.NpcId then
    local sdata = Table_Npc[foodData.NpcId]
    if sdata then
      UIModelUtil.Instance:ResetTexture(self.modeltexture)
      do
        local otherScale = 1
        if sdata.Shape then
          otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
        else
          helplog(string.format("Npc:%s Not have Shape", sdata.id))
        end
        if sdata.Scale then
          otherScale = sdata.Scale
        end
        UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id, nil, function(obj)
          self.model = obj
          local showPos = sdata.LoadShowPose
          if showPos and #showPos == 3 then
            self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
          end
          if sdata.LoadShowRotate then
            self.model:SetEulerAngleY(sdata.LoadShowRotate)
          end
          if sdata.LoadShowSize then
            otherScale = sdata.LoadShowSize
          end
          self.model:SetScale(otherScale)
          self.model:PlayAction_Simple("state1001")
        end)
      end
    end
  end
end

function FoodScoreTip:UpdateAttriText()
  local data = self.data.itemData
  if data then
    local sdata = data.staticData
    self:Show3DModel()
    local content = {}
    local foodTipTb = {}
    foodTipTb.label = {}
    foodTipTb.hideline = true
    table.insert(foodTipTb.label, ZhString.FoodScoreTip_Effect)
    local food_Sdata = data:GetFoodSData()
    local desc
    desc = data:GetFoodEffectDesc()
    if desc ~= nil then
      table.insert(foodTipTb.label, ZhString.ItemTip_Food_EffectTip .. desc)
    end
    if food_Sdata.Duration then
      desc = string.format(ZhString.ItemTip_Food_FullProgressTip, math.floor(food_Sdata.Duration / 60))
      table.insert(foodTipTb.label, desc)
    end
    desc = nil
    hpStr, spStr = nil, nil
    local hpStr, spStr
    if food_Sdata.SaveHP then
      hpStr = string.format(ZhString.ItemTip_SavePower_Desc, "Hp", food_Sdata.SaveHP)
    end
    if food_Sdata.SaveSP then
      spStr = string.format(ZhString.ItemTip_SavePower_Desc, "Sp", food_Sdata.SaveSP)
    end
    if hpStr and spStr then
      desc = hpStr .. ZhString.ItemTip_SavePower_And .. spStr
    else
      desc = hpStr and hpStr or spStr
    end
    if desc ~= nil then
      table.insert(foodTipTb.label, ZhString.Itemtip_SavePower .. ZhString.ItemTip_SavePower_Add .. desc)
    end
    local cookHard = food_Sdata.CookHard
    if cookHard then
      desc = ""
      local starNum = math.floor(cookHard / 2)
      for i = 1, starNum do
        desc = desc .. "{uiicon=food_icon_08}"
      end
      if cookHard % 2 == 1 then
        desc = desc .. "{uiicon=food_icon_09}"
      end
      if desc ~= "" then
        table.insert(foodTipTb.label, ZhString.ItemTip_Food_CookHardTip .. desc)
      end
    end
    local height = food_Sdata.Height
    if height then
      desc = nil
      if 0 < height then
        desc = ZhString.ItemTip_Food_HeightTip_Add
      elseif height < 0 then
        desc = ZhString.ItemTip_Food_HeightTip_Minus
      end
      if desc then
        for i = 1, math.abs(height) do
          desc = desc .. "{uiicon=food_icon_10}"
        end
      end
      table.insert(foodTipTb.label, desc)
    end
    local weight = food_Sdata.Weight
    if weight then
      desc = nil
      if 0 < weight then
        desc = ZhString.ItemTip_Food_WeightTip_Add
      elseif weight < 0 then
        desc = ZhString.ItemTip_Food_WeightTip_Minus
      end
      if desc then
        for i = 1, math.abs(weight) do
          desc = desc .. "{uiicon=food_icon_10}"
        end
      end
      table.insert(foodTipTb.label, desc)
    end
    local cookInfo = FoodProxy.Instance:Get_FoodCookExpInfo(sdata.id)
    if cookInfo and 0 < cookInfo.level and 0 < food_Sdata.CookerExp then
      local level = cookInfo.level
      local exp = ""
      if level < 10 then
        exp = cookInfo.exp * 10 .. "%"
      end
      desc = string.format(ZhString.FoodScoreTip_CurCookExpLv, sdata.NameZh, level, exp)
      table.insert(foodTipTb.label, desc)
    end
    local tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(sdata.id)
    if tasteInfo and 0 < tasteInfo.level and 0 < food_Sdata.TasterExp then
      local level = tasteInfo.level
      local exp = ""
      if level < 10 then
        exp = tasteInfo.exp * 10 .. "%"
      end
      desc = string.format(ZhString.FoodScoreTip_CurTasteExpLv, sdata.NameZh, level, exp)
      table.insert(foodTipTb.label, desc)
    end
    content[#content + 1] = foodTipTb
    desc = sdata.Desc
    if self.data.status ~= SceneFood_pb.EFOODSTATUS_MIN and desc ~= "" then
      foodTipTb = {}
      foodTipTb.label = {}
      foodTipTb.hideline = true
      foodTipTb.labelType = AdventureDataProxy.LabelType.Common
      table.insert(foodTipTb.label, desc)
      content[#content + 1] = foodTipTb
    end
    foodTipTb = {}
    foodTipTb.label = {}
    foodTipTb.tiplabel = ZhString.FoodScoreTip_Recipe
    foodTipTb.hideline = true
    foodTipTb.labelType = AdventureDataProxy.LabelType.Count
    local table_Recipe = Table_Recipe
    local material
    for _, single in pairs(table_Recipe) do
      if single.Product == food_Sdata.id then
        material = single.Material
        break
      end
    end
    local bagProxy = BagProxy.Instance
    if material and 0 < #material then
      for i = 1, #material do
        local m = material[i]
        local sData = Table_Item[m[2]]
        if m[1] == 1 then
          local bagNum = bagProxy:GetItemNumByStaticID(m[2], BagProxy.BagType.Food)
          local singleLabel = {
            text = sData.NameZh,
            exist = bagNum,
            need = m[3]
          }
          table.insert(foodTipTb.label, singleLabel)
        elseif m[1] == 2 then
          local itype = m[2]
          local itypeName = Table_ItemType[m[2]] and Table_ItemType[m[2]].Name
          local bagNum = 0
          local items = bagProxy:GetBagItemsByType(itype, BagProxy.BagType.Food)
          for j = 1, #items do
            bagNum = bagNum + items[j].num
          end
          local singleLabel = {
            text = itypeName,
            exist = bagNum,
            need = m[3]
          }
          table.insert(foodTipTb.label, singleLabel)
        end
      end
    end
    if sdata.id == 551019 then
      helplog("黑")
      local singleLabel = {text = "??????????"}
      table.insert(foodTipTb.label, singleLabel)
      foodTipTb.labelType = 1
    end
    content[#content + 1] = foodTipTb
    foodTipTb = {}
    foodTipTb.label = {}
    foodTipTb.hideline = true
    foodTipTb.tiplabel = ZhString.FoodScoreTip_UnlockRecipeTitle
    foodTipTb.labelType = AdventureDataProxy.LabelType.Status
    local AdventureValue = sdata.AdventureValue or 0
    local singleLabel = {
      text = string.format(ZhString.FoodScoreTip_UnlockRecipe, sdata.NameZh, AdventureValue),
      unlock = self.isUnlock or false
    }
    table.insert(foodTipTb.label, singleLabel)
    content[#content + 1] = foodTipTb
    foodTipTb = {}
    foodTipTb.label = {}
    foodTipTb.hideline = true
    foodTipTb.tiplabel = ZhString.FoodScoreTip_UnlockLv
    foodTipTb.labelType = AdventureDataProxy.LabelType.Status
    local cookLv = GameConfig.Food.MaxCookFoodLv
    local tasteLv = GameConfig.Food.MaxTasterFoodLv
    local formatStr = ZhString.FoodScoreTip_UnlockCookLv
    desc = ""
    cookInfo = Table_Food[self.data.itemid]
    local roleData
    local CookLvAttr = cookInfo.CookLvAttr
    local TasteLvAttr = cookInfo.TasteLvAttr
    for k, v in pairs(CookLvAttr) do
      local attrConfig = Game.Config_PropName[k]
      if attrConfig then
        if attrConfig.IsPercent == 1 then
          desc = desc .. attrConfig.PropName .. "+" .. v * 100 .. "%"
        else
          desc = desc .. attrConfig.PropName .. "+" .. v
        end
      end
      local singleLabel = {
        text = string.format(ZhString.FoodScoreTip_UnlockCookLv, cookLv, desc),
        unlock = cookLv <= self.data.level or false
      }
      table.insert(foodTipTb.label, singleLabel)
    end
    tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(self.data.itemid)
    local curTasteLv = tasteInfo.level
    formatStr = ZhString.FoodScoreTip_UnlockTasteLv
    desc = ""
    for k, v in pairs(TasteLvAttr) do
      local attrConfig = Game.Config_PropName[k]
      if attrConfig then
        if attrConfig.IsPercent == 1 then
          desc = desc .. attrConfig.PropName .. "+" .. v * 100 .. "%"
        else
          desc = desc .. attrConfig.PropName .. "+" .. v
        end
      end
      local singleLabel = {
        text = string.format(ZhString.FoodScoreTip_UnlockTasteLv, tasteLv, desc),
        unlock = tasteLv <= curTasteLv or false
      }
      table.insert(foodTipTb.label, singleLabel)
    end
    if foodTipTb then
      content[#content + 1] = foodTipTb
    end
    self.attriCtl:ResetDatas(content)
  end
end

function FoodScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  UIModelUtil.Instance:ResetTexture(self.modeltexture)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  FoodScoreTip.super.OnExit(self)
end
