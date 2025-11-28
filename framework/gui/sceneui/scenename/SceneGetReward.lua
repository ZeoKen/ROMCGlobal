SceneGetReward = reusableClass("SceneGetReward")
SceneGetReward.PoolSize = 10
SceneGetReward.ResID = ResourcePathHelper.UIPrefab_Cell("SceneGetReward")

function SceneGetReward:CreateGO()
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneGetReward.ResID, self.parent)
  local leftLabelGO = Game.GameObjectUtil:DeepFind(self.gameObject, "LeftLabel")
  self.leftLabel = leftLabelGO and leftLabelGO:GetComponent(Text)
  self.leftLabel.text = ZhString.FairyTaleRaid_GetReward
  local rewardCount = Game.GameObjectUtil:DeepFind(self.gameObject, "RewardCount")
  self.rewardCountLabel = rewardCount and rewardCount:GetComponent(Text)
  local image = Game.GameObjectUtil:DeepFind(self.gameObject, "RewardIcon")
  self.icon = image and image:GetComponent(Image)
  self.bg = Game.GameObjectUtil:DeepFind(self.gameObject, "Bg1")
  self:AddClickEvent(self.bg, function()
    if self.accessFunc then
      self.accessFunc(self.accessArgs)
    end
  end)
end

function SceneGetReward:SetData(icon, rewardCount)
  if not self.iconName then
    self.iconName = icon
    SpriteManager.SetUISprite("sceneui", icon, self.icon)
  end
  self.rewardCountLabel.text = rewardCount
end

function SceneGetReward:DoConstruct(asArray, args)
  self.parent = args and args[1]
  self.accessFunc = args and args[2]
  self.accessArgs = args and args[3]
  self:CreateGO()
end

function SceneGetReward:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneCoinCell.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.parent = nil
  self.rewardCountLabel = nil
  self.icon = nil
  self.iconName = nil
end

function SceneGetReward:AddClickEvent(obj, event)
  if event == nil then
    UGUIEventListener.Get(obj).onClick = nil
    return
  end
  UGUIEventListener.Get(obj).onClick = function(go)
    helplog("UGUIEventListener.Get(obj).onClick", event)
    if UICamera.isOverUI then
      helplog("UICamera.isOverUI return")
      return
    end
    if event then
      event(go)
    end
  end
end
