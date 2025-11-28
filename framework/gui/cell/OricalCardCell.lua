local Name_Color = {"9595fa", "f794aa"}
local BaseCell = autoImport("BaseCell")
OricalCardCell = class("OricalCardCell", BaseCell)
autoImport("Simple_OricalCardCell")

function OricalCardCell:Init()
  local cardCellGO = self:FindGO("CardCell")
  self.simpleCardCell = Simple_OricalCardCell.new(cardCellGO)
  self.name = self:FindComponent("name", UILabel)
  self.desc = self:FindComponent("desc", UILabel)
  self.instructions = self:FindComponent("Instructions", UILabel)
  self.monsterFlag = self:FindComponent("MonsterFlag", UISprite)
  self:AddCellClickEvent()
end

function OricalCardCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  local id, num
  if type(data) == "number" then
    id, num = data, 1
  elseif type(data) == "table" then
    id, num = data.id, data.num
  end
  if id == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.data = {id = id, num = num}
  local sdata = Table_PveCard and Table_PveCard[id]
  if sdata == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  local isMonsterCard = FunctionPve.IsMonsterCard(sdata.Type)
  self.name.text = string.format("%s x%s", sdata.Name, num)
  local color = isMonsterCard and Name_Color[1] or Name_Color[2]
  local _, c = ColorUtil.TryParseHexString(color)
  self.name.color = c
  self.desc.text = string.format(ZhString.Pve_PveCard_desc, sdata.Message)
  self.instructions.text = sdata.Instructions or ""
  FunctionMonster.Me():SetMonsterFlag(self.monsterFlag, sdata.MonsterID)
  self.simpleCardCell:SetData(sdata)
end
