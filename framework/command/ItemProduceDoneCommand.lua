ItemProduceDoneCommand = class("ItemProduceDoneCommand", pm.SimpleCommand)

function ItemProduceDoneCommand:execute(note)
  local data = note.body
  local dtype = data.type
  local npcguid, itemid, playerid, delay, count = data.npcid, data.itemid, data.charid, data.delay, data.count
  if type(delay) == "number" and 0 < delay then
    TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
      self:_ProcessCmd(dtype, npcguid, itemid, playerid, count)
    end, self)
  else
    self:_ProcessCmd(dtype, npcguid, itemid, playerid, count)
  end
end

function ItemProduceDoneCommand:_ProcessCmd(dtype, npcguid, itemid, playerid, count)
  if dtype == SceneItem_pb.EPRODUCETYPE_HEAD then
    self:PlayFashionProduceDoneAnim(npcguid, itemid, playerid)
  elseif dtype == SceneItem_pb.EPRODUCETYPE_EQUIP or dtype == SceneItem_pb.EPRODUCETYPE_COMMON then
    self:PlayEquipProduceDoneAnim(dtype, npcguid, itemid, playerid, count)
  end
end

local tempV3 = LuaVector3()

function ItemProduceDoneCommand._PlayUIEffect(effectHandle, itemData)
  if effectHandle then
    local effectGO = effectHandle.gameObject
    LuaVector3.Better_Set(tempV3, 0, 30, 0)
    effectGO.transform.localPosition = tempV3
    local itemSprite = effectGO:GetComponentInChildren(UISprite)
    if itemSprite then
      IconManager:SetItemIcon(itemData.staticData.Icon, itemSprite)
    end
  end
end

function ItemProduceDoneCommand:PlayFashionProduceDoneAnim(npcguid, itemid, playerid)
  local npcRole = SceneCreatureProxy.FindCreature(npcguid)
  local itemData = ItemData.new("Temp", itemid)
  if npcRole then
    local sceneUI = npcRole:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:PlaySceneUIEffect(GameConfig.Produce.npcSuccessEffect, true, ItemProduceDoneCommand._PlayUIEffect, itemData)
    end
    local successActionId = GameConfig.Produce.npcSuccessAction
    local successAnimName = Table_ActionAnime[successActionId] and Table_ActionAnime[successActionId].Name
    npcRole:Client_PlayAction(successAnimName, nil, false)
    local npcEmojiData = {
      roleid = npcRole.data.id,
      emoji = GameConfig.Produce.npcSuccessExpression
    }
    GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, npcEmojiData)
  end
  local playerRole = SceneCreatureProxy.FindCreature(playerid)
  if playerRole then
    local emojiData = {
      roleid = playerRole.data.id,
      emoji = GameConfig.Produce.userSuccessExpression
    }
    GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, emojiData)
  end
end

local params = {}

function ItemProduceDoneCommand:PlayEquipProduceDoneAnim(dtype, npcguid, itemid, playerid, count)
  local npcRole = SceneCreatureProxy.FindCreature(npcguid)
  local itemData = ItemData.new("Temp", itemid)
  if npcRole then
    local successActionId = GameConfig.EquipMake.npc_action
    local successAnimName = Table_ActionAnime[successActionId] and Table_ActionAnime[successActionId].Name
    npcRole:Client_PlayAction(successAnimName, nil, false)
    local npcEmojiData = {
      roleid = npcRole.data.id,
      emoji = GameConfig.EquipMake.success_emoji
    }
    GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, npcEmojiData)
  end
  if dtype == SceneItem_pb.EPRODUCETYPE_COMMON then
    return
  end
end
