local IsNull = Slua.IsNull
SceneDoubleActionReady = reusableClass("SceneDoubleActionReady")
SceneDoubleActionReady.PoolSize = 18
SceneDoubleActionReady.ResID = ResourcePathHelper.UIPrefab_Cell("SceneDoubleActionReady")
local buffCfg, actionTable

function SceneDoubleActionReady:Update(buffId)
  if buffId then
    self.buffId = buffId
  end
  self:_Update()
end

function SceneDoubleActionReady:_Update()
  local actionId = self:GetActionId()
  self:SetIcon(actionId and actionTable and actionTable[actionId] and actionTable[actionId].Name)
end

function SceneDoubleActionReady:GetActionId()
  return buffCfg and self.buffId and buffCfg[self.buffId]
end

function SceneDoubleActionReady:GetEventListener()
  return UGUIEventListener.Get(self.gameObject)
end

function SceneDoubleActionReady:SetIcon(iconName)
  self:SetActive(iconName ~= nil)
  if iconName and iconName ~= self.iconName then
    SpriteManager.SetUISprite("sceneuieffect", iconName, self.icon)
  end
  self.iconName = iconName
end

function SceneDoubleActionReady:SetActive(isActive)
  isActive = isActive and true or false
  if self.objActive == isActive then
    return
  end
  self.objActive = isActive
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(self.objActive)
  end
end

function SceneDoubleActionReady:OnPress(isPressing)
  if UICamera.isOverUI then
    return
  end
  if isPressing then
    self.tween:PlayForward()
    self.tween:ResetToBeginning()
    self.tween:PlayForward()
  else
    self.tween:PlayReverse()
    self.tween:ResetToBeginning()
    self.tween:PlayReverse()
    local aId, creature = self:GetActionId(), SceneCreatureProxy.FindCreature(self.id)
    if aId and creature and creature.data then
      local cfg = GameConfig.TwinsAction
      if cfg.race and TableUtility.ArrayFindIndex(cfg.race, aId) > 0 and not PlayerData.CheckRace(creature.data:GetProfesstion(), MyselfProxy.Instance:GetMyRace()) then
        MsgManager.ShowMsgByID(42114)
      elseif cfg.body and 0 < TableUtility.ArrayFindIndex(cfg.body, aId) and Asset_Role.CheckBodyGender(Game.Myself.assetRole, creature.assetRole) then
        MsgManager.ShowMsgByID(27104)
      else
        ServiceUserEventProxy.Instance:CallDoubleAcionEvent(self.id, aId)
      end
    else
      LogUtility.WarningFormat("Cannot find action Id of SceneDoubleActionReady from creature {0}", self.id)
    end
  end
end

function SceneDoubleActionReady:DoConstruct(asArray, args)
  if not buffCfg then
    buffCfg = Game.Config_DoubleActionBuff
    actionTable = Table_ActionAnime
  end
  local parent = args[1]
  if IsNull(parent) then
    return
  end
  local scale = 0.8
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneDoubleActionReady.ResID, parent.transform)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 25)
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.gameObject:SetActive(true)
  self.objActive = true
  self:GetEventListener().onPress = function(go, isPressing)
    self:OnPress(isPressing)
  end
  self.icon = Game.GameObjectUtil:DeepFind(self.gameObject, "Icon"):GetComponent(Image)
  self.tween = self.gameObject:GetComponent(TweenScale)
  self.tween.from = LuaGeometry.GetTempVector3(scale, scale, scale)
  scale = scale * 0.95
  self.tween.to = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.id = args[2]
  self.buffId = args[3]
  TimeTickManager.Me():CreateTick(0, 1000, self._Update, self)
end

function SceneDoubleActionReady:DoDeconstruct(asArray)
  if not IsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneDoubleActionReady.ResID, self.gameObject)
  end
  TimeTickManager.Me():ClearTick(self)
  self:GetEventListener().onPress = nil
  self.gameObject = nil
  self.icon = nil
  self.tween = nil
  self.id = nil
  self.buffId = nil
  self.iconName = nil
end
