autoImport("DojoRewardCell")
CookMasterResultView = class("CookMasterResultView", BaseView)
CookMasterResultView.ViewType = UIViewType.CheckLayer

function CookMasterResultView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:AddListenEvts()
  self:InitShow()
end

function CookMasterResultView:InitData()
  self.tickMg = TimeTickManager.Me()
  self.leftTime = 10
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.playerFoodId = viewdata and viewdata.playerFoodId or 551019
  self.enemyFoodId = viewdata and viewdata.enemyFoodId or 551019
  self.difficulty = viewdata and viewdata.difficulty or 1
  self.enemyId = viewdata and viewdata.enemyId or 817407
  self.inMode7Context = viewdata and viewdata.inMode7Context
  xdlog("FoodID", self.playerFoodId, self.enemyFoodId)
end

function CookMasterResultView:FindObjs()
  self.title = self:FindGO("Title")
  self.title_TweenScale = self.title:GetComponent(TweenScale)
  self.title_TweenAlpha = self.title:GetComponent(TweenAlpha)
  self.title_TweenScale:ResetToBeginning()
  self.title_TweenAlpha:ResetToBeginning()
  self.resultLabel = self:FindGO("Label", self.title):GetComponent(UILabel)
  self.resultLabel_EN = self:FindGO("Label_EN", self.title):GetComponent(UILabel)
  self.titleTexture1 = self:FindGO("Texture1", self.title):GetComponent(UITexture)
  self.titleTexture2 = self:FindGO("Texture2", self.title):GetComponent(UITexture)
  self.myselfFood = self:FindGO("MyselfFood")
  self.myselfName = self:FindGO("PlayerName", self.myselfFood):GetComponent(UILabel)
  self.myselfStarList = self:FindGO("StarList", self.myselfFood)
  self.myselfStars = {}
  for i = 1, 6 do
    self.myselfStars[i] = {}
    self.myselfStars[i].go = self:FindGO("FoodStar" .. i, self.myselfStarList)
    self.myselfStars[i].showIconGO = self:FindGO("Show", self.myselfStars[i].go)
    self.myselfStars[i].showIcon = self.myselfStars[i].showIconGO:GetComponent(UISprite)
  end
  self.myselfFoodName = self:FindGO("FoodName", self.myselfFood):GetComponent(UILabel)
  self.myselfFoodModelTexture = self:FindGO("ModelContainer", self.myselfFood):GetComponent(UITexture)
  self.enemyFood = self:FindGO("EnemyFood")
  self.enemyName = self:FindGO("EnemyName", self.enemyFood):GetComponent(UILabel)
  self.enemyStarList = self:FindGO("StarList", self.enemyFood)
  self.enemyStars = {}
  for i = 1, 6 do
    self.enemyStars[i] = {}
    self.enemyStars[i].go = self:FindGO("FoodStar" .. i, self.enemyStarList)
    self.enemyStars[i].showIconGO = self:FindGO("Show", self.enemyStars[i].go)
    self.enemyStars[i].showIcon = self.enemyStars[i].showIconGO:GetComponent(UISprite)
  end
  self.enemyFoodName = self:FindGO("FoodName", self.enemyFood):GetComponent(UILabel)
  self.enemyFoodModelTexture = self:FindGO("ModelContainer", self.enemyFood):GetComponent(UITexture)
  local closeBtn = self:FindGO("CloseButton")
  self.closeBtnLabel = self:FindGO("Label", closeBtn):GetComponent(UILabel)
  local bg = self:FindGO("Background")
  self.bgTexture1 = self:FindGO("Texture", bg):GetComponent(UITexture)
  self.bgTexture2 = self:FindGO("Texture2", bg):GetComponent(UITexture)
end

function CookMasterResultView:AddEvts()
end

function CookMasterResultView:InitView()
end

function CookMasterResultView:AddListenEvts()
end

function CookMasterResultView:InitShow()
  self:UpdateFoodInfo()
  self.closeBtnLabel.text = string.format(ZhString.CookMaster_CountDown, self.leftTime)
  self.tickMg:ClearTick(self)
  self.tickMg:CreateTick(0, 1000, self.updateCountDownTime, self)
end

function CookMasterResultView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
end

function CookMasterResultView:UpdateFoodInfo()
  self:DestroyModel()
  self.myselfName.text = Game.Myself.data:GetName()
  local playerFoodId = self.playerFoodId
  local playerfood_Sdata = playerFoodId and Table_Food[playerFoodId]
  self.myselfFoodName.text = playerfood_Sdata.Name
  if playerFoodId then
    local npcId = playerfood_Sdata.NpcId
    if npcId then
      local bodyid = Table_Npc[npcId] and Table_Npc[npcId].Body
      local scale = Table_Npc[npcId] and Table_Npc[npcId].Scale or 1
      self.playerFoodModel = UIModelUtil.Instance:SetRolePartModelTexture(self.myselfFoodModelTexture, Asset_Role.PartIndex.Body, bodyid, scale, self.ModelCreateCall, self)
      UIModelUtil.Instance:SetCellTransparent(self.myselfFoodModelTexture)
      local container = UIModelUtil.Instance:GetContainerObj(self.myselfFoodModelTexture)
      if container then
        container.transform.localRotation = Quaternion.Euler(30, 170, 8)
      end
      self.playerFoodModel:RegisterWeakObserver(self)
    end
  end
  local playerCookHard = playerfood_Sdata.CookHard
  if playerfood_Sdata.id == 551019 then
    playerCookHard = 0
  end
  local a, b = math.modf(playerCookHard / 2)
  xdlog("playerCookHard", a, b)
  for i = 1, a + 1 do
    if a >= i then
      self.myselfStars[i].showIconGO:SetActive(true)
      self.myselfStars[i].showIcon.spriteName = "Disney_icon_star"
    elseif 0 < b then
      self.myselfStars[i].showIconGO:SetActive(true)
      self.myselfStars[i].showIcon.spriteName = "Disney_icon_star2"
    end
  end
  local enemyData = Table_Npc[self.enemyId]
  self.enemyName.text = enemyData and enemyData.NameZh
  local enemyFoodId = self.enemyFoodId
  local enemyfood_Sdata = enemyFoodId and Table_Food[enemyFoodId]
  self.enemyFoodName.text = enemyfood_Sdata.Name
  if enemyFoodId then
    local npcid = enemyfood_Sdata.NpcId
    if npcid then
      local bodyid = Table_Npc[npcid] and Table_Npc[npcid].Body
      local scale = Table_Npc[npcid] and Table_Npc[npcid].Scale or 1
      self.enemyFoodModel = UIModelUtil.Instance:SetRolePartModelTexture(self.enemyFoodModelTexture, Asset_Role.PartIndex.Body, bodyid, scale, self.ModelCreateCall, self)
      UIModelUtil.Instance:SetCellTransparent(self.enemyFoodModelTexture)
      local container = UIModelUtil.Instance:GetContainerObj(self.enemyFoodModelTexture)
      if container then
        container.transform.localRotation = Quaternion.Euler(30, 170, 8)
      end
      self.enemyFoodModel:RegisterWeakObserver(self)
    end
  end
  local enemyCookHard = enemyfood_Sdata.CookHard
  if enemyfood_Sdata.id == 551019 then
    enemyCookHard = 0
  end
  if 0 < self.difficulty then
    enemyCookHard = enemyCookHard + (self.difficulty - 1)
  end
  local c, d = math.modf(enemyCookHard / 2)
  xdlog("enemyCookHard", c, d)
  for i = 1, c + 1 do
    if c >= i then
      self.enemyStars[i].showIconGO:SetActive(true)
      self.enemyStars[i].showIcon.spriteName = "Disney_icon_star"
    elseif 0 < d then
      self.enemyStars[i].showIconGO:SetActive(true)
      self.enemyStars[i].showIcon.spriteName = "Disney_icon_star2"
    end
  end
  if self.inMode7Context then
    if self.inMode7Context.isWin then
      playerCookHard = 514
      enemyCookHard = 114
    else
      playerCookHard = 114
      enemyCookHard = 514
    end
  end
  if playerCookHard > enemyCookHard then
    self.resultLabel.text = ZhString.CookMaster_Win
    self.resultLabel.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(1, 0.5764705882352941, 0.49411764705882355, 1)
    self.resultLabel_EN.text = "V  I  C  T  O  R  Y"
    self.resultLabel_EN.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
  else
    if playerCookHard == enemyCookHard then
      self.resultLabel.text = ZhString.CookMaster_Draw
      self.resultLabel_EN.text = "D  R  A  W"
    else
      self.resultLabel.text = ZhString.CookMaster_Lose
      self.resultLabel_EN.text = "F  A  I  L  U  R  E"
    end
    self.resultLabel.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(0.6392156862745098, 0.7450980392156863, 0.9647058823529412, 1)
    self.resultLabel_EN.gradientTop = LuaGeometry.GetTempColor()
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
  end
  self.result = playerCookHard > enemyCookHard
end

function CookMasterResultView:DestroyModel()
  if self.playerFoodModel then
    local t = self.playerFoodModel:GetTransform()
    if t then
      local cps, cp = t:GetComponentsInChildren(TweenRotation)
      for i = 1, #cps do
        cp = cps[i]
        GameObject.Destroy(cp)
      end
    end
    if self.myselfFoodModelTexture then
      UIModelUtil.Instance:ResetTexture(self.myselfFoodModelTexture)
    end
    self.playerFoodModel = nil
  end
  if self.enemyFoodModel then
    local t = self.enemyFoodModel:GetTransform()
    if t then
      local cps, cp = t:GetComponentsInChildren(TweenRotation)
      for i = 1, #cps do
        cp = cps[i]
        GameObject.Destroy(cp)
      end
    end
    if self.enemyFoodModelTexture then
      UIModelUtil.Instance:ResetTexture(self.enemyFoodModelTexture)
    end
    self.enemyFoodModel = nil
  end
end

function CookMasterResultView:updateCountDownTime()
  self.leftTime = self.leftTime - 1
  if self.leftTime < 0 then
    self:CloseSelf()
    return
  end
  self.closeBtnLabel.text = string.format(ZhString.CookMaster_CountDown, self.leftTime)
end

function CookMasterResultView.ModelCreateCall(rolePart, self)
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

function CookMasterResultView:ObserverDestroyed(model)
  if model ~= nil and model == self.model then
    model:ResetLocalScaleXYZ(1, 1, 1)
    model:ResetParent(nil)
  end
end

function CookMasterResultView:OnEnter()
  CookMasterResultView.super.OnEnter(self)
  PictureManager.Instance:SetUI("Disney_cwzb_bg_02", self.bgTexture1)
  PictureManager.Instance:SetUI("Disney_cwzb_bg_02", self.bgTexture2)
  PictureManager.Instance:SetUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:SetUI("Japanesecopy_bg_light", self.titleTexture2)
end

function CookMasterResultView:OnExit()
  self.tickMg:ClearTick(self)
  self:DestroyModel()
  self.myselfFoodModelTexture = nil
  self.enemyFoodModelTexture = nil
  CookMasterResultView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("Disney_cwzb_bg_02", self.bgTexture1)
  PictureManager.Instance:UnLoadUI("Disney_cwzb_bg_02", self.bgTexture2)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_light", self.titleTexture2)
end

function CookMasterResultView:CloseSelf()
  CookMasterManager.Me():CheckGuideQuest(self.result)
  CookMasterResultView.super.CloseSelf(self)
end
