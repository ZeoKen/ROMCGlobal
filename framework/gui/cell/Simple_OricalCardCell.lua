local BaseCell = autoImport("BaseCell")
Simple_OricalCardCell = class("Simple_OricalCardCell", BaseCell)
local Frame_ColorMap = {"9595FA", "FBA4B7"}

function Simple_OricalCardCell:Init()
  self.content = self:FindGO("Content")
  self.bg = self:FindComponent("Bg", UISprite)
  self.fg = self:FindComponent("Fg", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.monsterFlag = self:FindComponent("MonsterFlag", UISprite)
  self:AddCellClickEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      self:PassEvent(MouseEvent.LongPress, {self, state})
    end
  end
end

function Simple_OricalCardCell:SetData(data)
  self.data = data
  if type(data) ~= "table" then
    self.content:SetActive(false)
    return
  end
  self.content:SetActive(true)
  local isMonsterCard = FunctionPve.IsMonsterCard(data.Type)
  local frame_c = isMonsterCard and Frame_ColorMap[1] or Frame_ColorMap[2]
  local _, frame_rc = ColorUtil.TryParseHexString(frame_c)
  self.fg.color = frame_rc
  FunctionMonster.Me():SetMonsterFlag(self.monsterFlag, data.MonsterID)
  local headIcon = data.HeadIcon
  if headIcon == nil or headIcon == "" then
    local monsterId = data.MonsterID
    local monsterData = Table_Monster[monsterId]
    headIcon = monsterData and monsterData.Icon
  end
  if headIcon then
    IconManager:SetFaceIcon(headIcon, self.icon)
  end
end

function Simple_OricalCardCell:HideContent()
  self.content:SetActive(false)
end
