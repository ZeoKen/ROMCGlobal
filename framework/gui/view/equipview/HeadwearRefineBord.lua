autoImport("EquipRefineBord")
HeadwearRefineBord = class("HeadwearRefineBord", EquipRefineBord)
local tempArr, bagIns = {}

function HeadwearRefineBord:ctor(go)
  if not bagIns then
    bagIns = BagProxy.Instance
  end
  HeadwearRefineBord.super.super.ctor(self, go)
  self:Init()
end

function HeadwearRefineBord:Init()
  self:InitData()
  self:InitBord()
end

function HeadwearRefineBord:InitData()
  self.maxRefineLv = 0
  self.refine_cost_Rob = 0
end

function HeadwearRefineBord:InitBord()
  HeadwearRefineBord.super.InitBord(self)
  self.refineBord:SetActive(false)
  self.hRefineBord = self:FindGO("HeadwearRefineBord")
  self.hRefineBord:SetActive(true)
  self.hRefineAttr = self:FindGO("RefineAttr", self.hRefineBord)
  self.currentRefineLevel = self:FindComponent("CurrentRefineLevel", UILabel, self.hRefineAttr)
  self.nextRefineLevel = self:FindComponent("NextRefineLevel", UILabel, self.hRefineAttr)
  self.refineEffect = self:FindComponent("RefineEffect", UILabel, self.hRefineAttr)
  self.nowEffect = self:FindComponent("NowEffect", UILabel, self.hRefineAttr)
  self.nextEffect = self:FindComponent("NextEffect", UILabel, self.hRefineAttr)
  local cellParent = self:FindGO("MatItem", self.hRefineBord)
  self.matCell = MaterialItemNewCell.new(self:LoadPreferb("cell/MaterialItemNewCell", cellParent))
  self.matCell:AddEventListener(MouseEvent.MouseClick, self.ClickMatCell, self)
  self.hRefineFull = self:FindGO("RefineFull", self.hRefineBord)
  self.hRefineButton = self:FindGO("RefineBtn", self.hRefineBord)
  self.hRefineButton_Sp = self.hRefineButton:GetComponent(UISprite)
  self.hRefineButton_Label = self:FindComponent("Label", UILabel, self.hRefineButton)
  self:AddClickEvent(self.hRefineButton, function()
    self:ClickRefine()
  end)
end

local matTipOffset = {-270, 0}

function HeadwearRefineBord:ClickMatCell()
  if not self.itemData then
    return
  end
  self.matTipItemData = self.matTipItemData or {}
  self.matTipItemData.itemdata = self.matCell.data
  self:ShowItemTip(self.matTipItemData, self.tipStick, NGUIUtil.AnchorSide.Left, matTipOffset)
end

function HeadwearRefineBord:DoRefine(nowData)
  local equipInfo = nowData.equipInfo
  if self.matCell.data.num <= 0 then
    TableUtility.ArrayClear(tempArr)
    TableUtility.ArrayPushBack(tempArr, self.matCell.data.staticData.NameZh)
    MsgManager.ShowMsgByIDTable(1282, tempArr)
    return
  end
  if equipInfo.refinelv >= self.maxRefineLv then
    MsgManager.ShowMsgByIDTable(1358)
    return
  end
  if equipInfo.damage then
    MsgManager.ShowMsgByIDTable(228)
    return
  end
  local id = nowData.id
  MsgManager.ConfirmMsgByID(42137, function()
    self:_Refine(id)
  end, nil, nil, string.format("+%s", self.maxRefineLv))
end

function HeadwearRefineBord:_Refine(nowId)
  TableUtility.ArrayClear(tempArr)
  TableUtility.ArrayPushBack(tempArr, nowId)
  ServiceItemProxy.Instance:CallItemUse(self.matCell.data, nil, nil, nil, tempArr)
  local matId = self.matCell.data.staticData.id
  TableUtility.ArrayClear(tempArr)
  TableUtility.ArrayPushBack(tempArr, matId)
  TableUtility.ArrayPushBack(tempArr, matId)
  TableUtility.ArrayPushBack(tempArr, 1)
  MsgManager.ShowMsgByIDTable(75, tempArr)
  self:PassEvent(EquipRefineBord_Event.DoRefine, self)
end

function HeadwearRefineBord:Refresh()
  local nowData = self.itemData
  local flag = nowData ~= nil
  self.targetCellContent:SetActive(flag)
  self.targetAddIcon:SetActive(not flag)
  self.itemName.gameObject:SetActive(flag)
  self.emptyBord:SetActive(not flag)
  self.hRefineBord:SetActive(flag)
  if nowData ~= nil then
    local succ = IconManager:SetItemIcon(nowData.staticData.Icon, self.targetCellIcon)
    if not succ then
      IconManager:SetItemIcon("item_45001", self.targetCellIcon)
    end
    self.itemName.text = nowData:GetName(nil, true)
    self:UpdateRefineInfo()
  end
end

function HeadwearRefineBord:UpdateRefineInfo()
  local equipInfo = self.itemData.equipInfo
  local currentLv = equipInfo.refinelv
  local equipMaxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(self.itemData.staticData)
  local biggerThanEquipMaxRefineLv = currentLv >= equipMaxRefineLv
  self.hRefineFull:SetActive(biggerThanEquipMaxRefineLv)
  self.hRefineButton:SetActive(not biggerThanEquipMaxRefineLv)
  self:SetRefineBtnActive(not biggerThanEquipMaxRefineLv)
  if biggerThanEquipMaxRefineLv then
    return
  end
  self.maxRefineLv = self.outset_maxrefine
  local biggerThanMaterialRefineLv = currentLv >= self.maxRefineLv
  self:SetRefineBtnActive(not biggerThanMaterialRefineLv)
  local nextRefineLv = biggerThanMaterialRefineLv and currentLv + 1 or self.maxRefineLv
  self.currentRefineLevel.text = string.format("+%s", currentLv)
  self.nextRefineLevel.text = string.format("+%s", nextRefineLv)
  local proName
  proName, self.nowEffect.text, self.nextEffect.text = ItemUtil.GetRefineAttrPreview(equipInfo, nextRefineLv)
  if not StringUtil.IsEmpty(proName) then
    self.refineEffect.text = proName
  end
end

function HeadwearRefineBord:UpdateRefineMaterials()
end

function HeadwearRefineBord:SetIncludeTradeItem(include)
  if self.refineTipCt then
    self.refineTipCt:SetActive(not include)
  end
end

function HeadwearRefineBord:SetMaterial(materialId)
  if not materialId then
    return false
  end
  local material = bagIns:GetItemByStaticID(materialId)
  local itemData
  if material then
    itemData = material:Clone()
    itemData.neednum = 1
  elseif self.matCell.data then
    itemData = self.matCell.data
    itemData.num = 0
  end
  self.matCell:SetData(itemData)
  self.matCell:ActiveClickTip(false)
  self:Refresh()
  return material ~= nil
end

local inactiveBtnLabelColor, activeBtnLabelEffectColor, inactiveBtnLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.27058823529411763, 0.37254901960784315, 0.6823529411764706), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)

function HeadwearRefineBord:SetRefineBtnActive(isActive)
  isActive = isActive and true or false
  self.hRefineButton_Sp.spriteName = isActive and "new-com_btn_a" or "new-com_btn_a_gray"
  self.hRefineButton_Label.color = isActive and LuaGeometry.GetTempColor() or inactiveBtnLabelColor
  self.hRefineButton_Label.effectColor = isActive and activeBtnLabelEffectColor or inactiveBtnLabelEffectColor
end
