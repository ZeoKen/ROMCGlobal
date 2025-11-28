autoImport("MaterialItemNewCell")
autoImport("ComodoBuildingUpgradeAttrListCell")
ComodoBuildingUpgradeListCell = class("ComodoBuildingUpgradeListCell", CoreView)
local btnAvailableEffectColor, btnUnavailableEffectColor = LuaColor.New(0.7686274509803922, 0.5254901960784314, 0), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
local shopIns, buildingIns

function ComodoBuildingUpgradeListCell:ctor(obj)
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    buildingIns = ComodoBuildingProxy.Instance
  end
  ComodoBuildingUpgradeListCell.super.ctor(self, obj)
  self:Init()
end

function ComodoBuildingUpgradeListCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.switch = self:FindComponent("Switch", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.currentPart = self:FindGO("Current")
  self.allEff = self:FindGO("AllEff")
  self.desc = self:FindComponent("Desc", UILabel)
  self.matCtl = ListCtrl.new(self:FindComponent("MatTable", UITable), MaterialItemNewCell, "ComodoBuildingUpgradeMaterialCell")
  self.matCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterial, self)
  self.matCells = self.matCtl:GetCells()
  self.max = self:FindGO("Max")
  self.attrCtl = ListCtrl.new(self:FindComponent("AttrTable", UITable), ComodoBuildingUpgradeAttrListCell, "ComodoBuildingUpgradeAttrListCell")
  self.attrCells = self.attrCtl:GetCells()
  self.attrWidth = 120
  self.upgradeBg = self:FindComponent("UpgradeBg", UIMultiSprite)
  self.upgradeLabel = self:FindComponent("UpgradeLabel", UILabel)
  self:AddClickEvent(self.switch.gameObject, function()
    self:Switch()
  end)
  self:AddButtonEvent("UpgradeBtn", function()
    self:Upgrade()
  end)
  self.isShowingAllEff = false
end

function ComodoBuildingUpgradeListCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:Update()
end

function ComodoBuildingUpgradeListCell:Switch()
  self.isShowingAllEff = not self.isShowingAllEff
  self:Update()
end

function ComodoBuildingUpgradeListCell:Update()
  self.buildingId = self:GetBuildingIdFromData(self.data)
  self.name.text = buildingIns:GetNameOfFuncType(self.buildingId, self.data.funcType)
  self.curLv = buildingIns:GetBuildingFuncLevelByType(self.buildingId, self.data.funcType)
  local nextLvCfg = self.data[self.curLv + 1]
  if not nextLvCfg then
    self.isShowingAllEff = true
  end
  local cfg = nextLvCfg or self.data[1]
  IconManager:SetUIIcon(cfg.Icon, self.icon)
  self.switch.flip = self.isShowingAllEff and 1 or 0
  self.currentPart:SetActive(not self.isShowingAllEff)
  self.allEff:SetActive(self.isShowingAllEff)
  if self.isShowingAllEff then
    self.max:SetActive(not nextLvCfg)
    self.attrCtl:ResetDatas(self.data)
    self:SetWidthOfAttrLabel()
  else
    self.desc.text = buildingIns:GetAssetEffectDescs(cfg.BuildId, cfg.FuncType, cfg.Level)
    self.mats = self.mats or {}
    local cost, c, data = cfg.ItemCost
    for i = 1, #cost do
      c = cost[i]
      data = self.mats[i] or ItemData.new()
      data:ResetData(MaterialItemCell.MaterialType.Material, c[1])
      data.num = shopIns:GetItemNum(c[1])
      data.neednum = c[2]
      self.mats[i] = data
    end
    for i = #cost + 1, #self.mats do
      self.mats[i] = nil
    end
    self.matCtl:ResetDatas(self.mats)
    for _, cell in pairs(self.matCells) do
      cell:UpdateNumLabel(string.format(cell.data.num >= cell.data.neednum and "%s" or "[c][FF6021]%s[-][/c]", cell.data.neednum))
    end
    self.upgradeBg.CurrentState = self:CheckMats() and 1 or 0
    self.upgradeLabel.effectColor = self:CheckMats() and btnAvailableEffectColor or btnUnavailableEffectColor
  end
end

function ComodoBuildingUpgradeListCell:Upgrade()
  if not self:CheckMats() then
    MsgManager.ShowMsgByID(8)
    return
  end
  ComodoBuildingProxy.Upgrade(self.data.funcType)
end

function ComodoBuildingUpgradeListCell:CheckMats()
  local cfg = self.data[self.curLv + 1]
  if not cfg then
    return false
  end
  local cost, enough, id, neednum, num = cfg.ItemCost, true
  for i = 1, #cost do
    id, neednum = cost[i][1], cost[i][2]
    num = shopIns:GetItemNum(id)
    enough = enough and neednum <= num
  end
  return enough
end

function ComodoBuildingUpgradeListCell:GetBuildingIdFromData(data)
  if not data then
    return
  end
  for k, v in pairs(data) do
    if type(k) == "number" then
      return v.BuildId
    end
  end
end

function ComodoBuildingUpgradeListCell:OnClickMaterial(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end

function ComodoBuildingUpgradeListCell:SetWidthOfAttrLabel(width)
  self.attrWidth = width or self.attrWidth
  for _, c in pairs(self.attrCells) do
    c:SetLabelWidth(self.attrWidth)
  end
  self.attrCtl:ResetPosition()
end
