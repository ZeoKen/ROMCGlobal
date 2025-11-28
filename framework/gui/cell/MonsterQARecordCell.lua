local BaseCell = autoImport("BaseCell")
MonsterQARecordCell = class("MonsterQARecordCell", BaseCell)
local spriteMap = {
  [1] = "chatroom_icon_check",
  [-1] = "guild_script_bg02"
}

function MonsterQARecordCell:Init()
  self:FindObjs()
end

function MonsterQARecordCell:FindObjs()
  self.record = self:FindGO("record"):GetComponent(UISprite)
  self.record.gameObject:SetActive(false)
end

function MonsterQARecordCell:SetData(data)
  self.record.gameObject:SetActive(data ~= 0)
  self.record.spriteName = spriteMap[data]
end
