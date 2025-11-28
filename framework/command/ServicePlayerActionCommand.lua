ServicePlayerActionCommand = class("ServicePlayerActionCommand", pm.SimpleCommand)

function ServicePlayerActionCommand:execute(note)
  local data = note.body
  if data ~= nil then
    local type = data.type
    local value = data.value
    local delay = data.delay and tonumber(data.delay)
    local once = data.once
    if delay and 0 < delay then
      TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
        self:DoServerPlayerBeheavior(data.charid, type, value, once, data.box_opened)
      end, self)
    else
      self:DoServerPlayerBeheavior(data.charid, type, value, once, data.box_opened)
    end
  end
end

function ServicePlayerActionCommand:DoServerPlayerBeheavior(playerid, type, value, once, boxOpened)
  local player
  if 0 == playerid then
    player = Game.Myself
  else
    player = SceneCreatureProxy.FindCreature(playerid)
  end
  if not player then
    return
  end
  if player.data then
    player.data.boxOpened = boxOpened
  end
  if type == SceneUser2_pb.EUSERACTIONTYPE_ADDHP then
    player:PlayHpUp()
    if player == Game.Myself then
      local pos = LuaVector3.Zero()
      LuaVector3.Better_Set(pos, player.assetRole:GetEPOrRootPosition(RoleDefines_EP.Chest))
      SkillLogic_Base.ShowDamage_Single(CommonFun.DamageType.Normal, value, pos, HurtNumType.HealNum, HurtNumColorType.Treatment, player, nil, player)
      LuaVector3.Destroy(pos)
    end
    GameFacade.Instance:sendNotification(SceneUserEvent.EatHp, value)
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION then
    local emojiLength = #Table_Expression
    local emojiId = tonumber(value)
    if emojiId == FunctionPhotoStand.ShowViewPhotoStandEmoji then
      local role = SceneCreatureProxy.FindCreature(player.data.id)
      if role then
        local sceneUI = role:GetSceneUI()
        if sceneUI then
          sceneUI.roleTopUI:ShowViewPhotoStandEmoji()
        end
      end
    elseif emojiId == FunctionPhotoStand.HideViewPhotoStandEmoji then
      local role = SceneCreatureProxy.FindCreature(player.data.id)
      if role then
        local sceneUI = role:GetSceneUI()
        if sceneUI then
          sceneUI.roleTopUI:HideViewPhotoStandEmoji()
        end
      end
    elseif emojiId then
      if Table_Expression[emojiId] == nil then
        if 700 < emojiId then
          emojiId = emojiId - 700
        end
        if emojiLength < emojiId then
          emojiId = emojiId % emojiLength
          if emojiId <= 0 then
            emojiId = 1
          end
        end
      end
      GameFacade.Instance:sendNotification(EmojiEvent.PlayEmoji, {
        emoji = emojiId,
        roleid = player.data.id
      })
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_MOTION then
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:Server_PlayActionCmd(actionName, nil, not once)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION then
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:Server_PlayActionCmd(actionName, nil, false)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_GEAR_ACTION then
    local actionid = tonumber(value)
    if actionid then
      local actionName = orginStringFormat("state%d", actionid)
      player:Server_PlayActionCmd(actionName, nil, false)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_DIALOG then
    if playerid == Game.Myself.data.id then
      GameFacade.Instance:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(value))
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_ANIMATION then
    local animid = tonumber(value)
    if animid and Table_SceneBossAnime[animid] then
      local objId = Table_SceneBossAnime[animid].ObjID
      local anim = Table_SceneBossAnime[animid].Name
      Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:PlayAnimation(objId, anim)
    end
  elseif type == SceneUser2_pb.EUSERACTIONTYPE_WALKACTION then
    xdlog("Recv--->WALKACTION")
    local actionid = tonumber(value)
    if actionid and Table_ActionAnime[actionid] then
      local actionName = Table_ActionAnime[actionid].Name
      player:SetDefaultWalkAnime(actionName)
      xdlog("变更默认移动动画", actionName)
    end
  end
end
