autoImport("MaterialItemNewCell")
ComodoBuildingSmithingListCell = class("ComodoBuildingSmithingListCell", CoreView)
local countdownTickIdBase, shopIns, buildingIns, tickManager, config = 395

function ComodoBuildingSmithingListCell:ctor(obj)
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    buildingIns = ComodoBuildingProxy.Instance
    config = GameConfig.Manor
    tickManager = TimeTickManager.Me()
  end
  ComodoBuildingSmithingListCell.super.ctor(self, obj)
  self:Init()
end

function ComodoBuildingSmithingListCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.unlockParent = self:FindGO("Unlock")
  self.lockParent = self:FindGO("Lock")
  self.matPanel = self:FindComponent("MatPanel", UIPanel)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  self.matPanel.depth = upPanel.depth + 11
  self.matCtl = ListCtrl.new(self:FindComponent("MatTable", UITable), MaterialItemNewCell, "ComodoBuildingUpgradeMaterialCell")
  self.matCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterial, self)
  self.matCells = self.matCtl:GetCells()
  self.getBtn = self:FindGO("GetBtn")
  self.getBg = self:FindComponent("BtnBg", UISprite, self.getBtn)
  self.smithingBtn = self:FindGO("SmithingBtn")
  self.working = self:FindGO("Working")
  self.fakeUnlockBtn = self:FindGO("FakeUnlockBtn")
  IconManager:SetUIIcon("tab_icon_86", self:FindComponent("WorkingSp", UISprite))
  self:AddClickEvent(self.getBtn, function()
    self:DoRecv()
  end)
  self:AddClickEvent(self.smithingBtn, function()
    self:DoSmithing()
  end)
  self:AddClickEvent(self.fakeUnlockBtn, function()
    MsgManager.ShowMsgByID(42005)
  end)
end

function ComodoBuildingSmithingListCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local descCfg = config.ManorForgeDesc[self.data]
  IconManager:SetUIIcon(descCfg.Icon, self.icon)
  self.name.text = descCfg.Name
  local isUnlocked = buildingIns.unlockedSmithingPartMap[self.data] or false
  self.unlockParent:SetActive(isUnlocked)
  self.lockParent:SetActive(not isUnlocked)
  local tickId = countdownTickIdBase + tonumber(self.data)
  tickManager:ClearTick(self, tickId)
  if isUnlocked then
    tickManager:CreateTick(0, 300, self.UpdateCountdown, self, tickId)
    self.mats = self.mats or {}
    local cost, c, item = config.ManorForgeItemCost[self.data]
    for i = 1, #cost do
      c = cost[i]
      item = self.mats[i] or ItemData.new()
      item:ResetData(MaterialItemCell.MaterialType.Material, c[1])
      item.num = shopIns:GetItemNum(c[1])
      item.neednum = c[2]
      self.mats[i] = item
    end
    for i = #cost + 1, #self.mats do
      self.mats[i] = nil
    end
    self.matCtl:ResetDatas(self.mats)
    for _, cell in pairs(self.matCells) do
      cell:UpdateNumLabel(string.format(cell.data.num >= cell.data.neednum and "%s" or "[c][FF6021]%s[-][/c]", cell.data.neednum))
    end
  else
    self.desc.text = string.format(ZhString.QuestManual_Unlock, descCfg.Name)
  end
end

function ComodoBuildingSmithingListCell:CheckMats()
  if not self.data then
    return false
  end
  local cost, enough, id, neednum, num = config.ManorForgeItemCost[self.data], true
  for i = 1, #cost do
    id, neednum = cost[i][1], cost[i][2]
    num = shopIns:GetItemNum(id)
    enough = enough and neednum <= num
  end
  return enough
end

function ComodoBuildingSmithingListCell:OnClickMaterial(cell)
  self:PassEvent(HappyShopEvent.SelectIconSprite, cell)
end

function ComodoBuildingSmithingListCell:DoSmithing()
  if not self:CheckMats() then
    MsgManager.ShowMsgByID(8)
    return
  end
  ComodoBuildingProxy.Smithing(self.data)
end

function ComodoBuildingSmithingListCell:DoRecv()
  self:PassEvent(MouseEvent.MouseClick, self)
  ComodoBuildingProxy.Smithing(self.data, true)
end

function ComodoBuildingSmithingListCell:UpdateCountdown()
  local countdown = buildingIns:GetSmithingCountdownByPartId(self.data)
  self.getBtn:SetActive(countdown == 0)
  self.smithingBtn:SetActive(countdown < 0)
  self.working:SetActive(0 < countdown)
  self.desc.text = 0 <= countdown and string.format(ZhString.ComodoBuilding_SmithingCountdownFormat, self:MakeTimeStr(countdown)) or config.ManorForgeDesc[self.data].Name
end

function ComodoBuildingSmithingListCell:MakeTimeStr(time)
  if time < 0 then
    time = 0
  end
  local h = math.floor(time / 3600)
  local min = math.floor(time / 60 - h * 60)
  local s = time - h * 3600 - min * 60
  return string.format("%02d:%02d:%02d", h, min, s)
end

function ComodoBuildingSmithingListCell:OnCellDestroy()
  tickManager:ClearTick(self)
end
