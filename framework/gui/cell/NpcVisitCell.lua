local BaseCell = autoImport("BaseCell")
NpcVisitCell = class("NpcVisitCell", BaseCell)

function NpcVisitCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function NpcVisitCell:FindObjs()
  self.npcName = self:FindGO("NpcName"):GetComponent(UILabel)
  self.actionIcon = self:FindGO("ActionIcon"):GetComponent(UIMultiSprite)
  self.bgSp = self:FindComponent("Sprite", UISprite)
end

function NpcVisitCell:SetData(data)
  self.npcid = data.npcid
  self.staticData = Table_Npc[self.npcid]
  local count = data.count
  local extendStr = count and 1 < count and "x" .. count or ""
  self.npcName.text = self.staticData and self.staticData.NameZh and OverSea.LangManager.Instance():GetLangByKey(self.staticData.NameZh) .. extendStr
  self.actionIcon.CurrentState = data.state - 1
  self.actionIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.6, 0.6, 0.6)
end

function NpcVisitCell:RegisterHotKeyTip()
  Game.HotKeyTipManager:RegisterHotKeyTip(5, self.bgSp, NGUIUtil.AnchorSide.TopRight, {-10, -10})
end

function NpcVisitCell:RemoveHotKeyTip()
  Game.HotKeyTipManager:RemoveHotKeyTip(5, self.bgSp)
end

function NpcVisitCell:OnCellDestroy()
  self:RemoveHotKeyTip()
end
