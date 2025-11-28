autoImport("HeadIconCell")
QuestMiniGame3HeadIconCell = class("QuestMiniGame3HeadIconCell", HeadIconCell)

function QuestMiniGame3HeadIconCell:SetData(data)
  local monsterId = data
  local monsterIcon = monsterId and Table_Monster[monsterId].Icon
  if monsterIcon then
    self:SetSimpleIcon(monsterIcon)
  end
  self:SetBeat(false)
end

function QuestMiniGame3HeadIconCell:SetBeat(active)
  if active then
    ColorUtil.WhiteUIWidget(self.simpleIcon)
  else
    ColorUtil.ShaderLightGrayUIWidget(self.simpleIcon)
  end
end

function QuestMiniGame3HeadIconCell:SetNext(active)
  if not self.nextMark then
    self.buffMask.color = LuaGeometry.GetTempColor(1, 1, 0, 1)
    self.nextMark = self.buffMask.gameObject
  end
  self.nextMark:SetActive(active)
end
