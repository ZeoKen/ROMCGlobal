EmojiCommand = class("EmojiCommand", pm.SimpleCommand)

function EmojiCommand:execute(note)
  if note.name == EmojiEvent.PlayEmoji then
    local roleid = note.body.roleid
    local emoji = note.body.emoji
    if roleid and emoji then
      if nil ~= note.body.delay and note.body.delay > 0 then
        TimeTickManager.Me():CreateOnceDelayTick(note.body.delay, function(owner, deltaTime)
          if nil == SceneCreatureProxy.FindCreature(roleid) then
            return
          end
          SceneUIManager.Instance:RolePlayEmojiById(roleid, emoji)
        end, self)
      else
        SceneUIManager.Instance:RolePlayEmojiById(roleid, emoji)
      end
    end
  end
end
