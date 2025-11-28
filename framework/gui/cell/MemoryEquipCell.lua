local BaseCell = autoImport("BaseCell")
MemoryEquipCell = class("MemoryEquipCell", BaseCell)

function MemoryEquipCell:Init()
  self:FindObjs()
end

function MemoryEquipCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.noneTip = self:FindGO("NoneTip")
  self.itemGO = self:FindGO("Item")
  self.itemCell = ItemCell.new(self.itemGO)
  self.posName = self:FindGO("PosName"):GetComponent(UILabel)
  self.equipBtn = self:FindGO("EquipBtn")
  self.equipLabel = self:FindGO("EquipLabel", self.equipBtn):GetComponent(UILabel)
  self:AddClickEvent(self.equipBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self:AddClickEvent(self.itemGO, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self.widget = self:FindGO("Widget"):GetComponent(UIWidget)
end

function MemoryEquipCell:SetData(data)
  self.data = data
  local itemdata = data.itemdata
  local site = data.site
  self.posName.text = GameConfig.EquipPosName and GameConfig.EquipPosName[site]
  if itemdata then
    self.itemGO:SetActive(true)
    self.itemCell:SetData(itemdata)
    self.noneTip:SetActive(false)
    self.name.text = itemdata:GetName()
    self.equipLabel.text = ZhString.EquipMemory_Replace2
  else
    self.itemGO:SetActive(false)
    self.noneTip:SetActive(true)
    self.name.text = ZhString.GuildInfoPage_Nothing
    self.equipLabel.text = ZhString.EquipMemory_Equip2
  end
end
