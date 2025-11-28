autoImport("InheritSkillCostPointCell")
autoImport("InheritSkillMaterialCell")
autoImport("InheritSkillCostPointAttrDetailCell")
InheritSkillExtendCostPointPopUp = class("InheritSkillExtendCostPointPopUp", ContainerView)
InheritSkillExtendCostPointPopUp.ViewType = UIViewType.PopUpLayer

function InheritSkillExtendCostPointPopUp:Init()
  self.lackMats = {}
  self:FindObjs()
  self:AddListenEvts()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function InheritSkillExtendCostPointPopUp:FindObjs()
  self:AddCloseButtonEvent()
  self.costPointLabel = self:FindComponent("CostPointLabel", UILabel)
  self.materialTitleLabel = self:FindComponent("MaterialTitle", UILabel)
  local grid = self:FindComponent("CostPointGrid", UIGrid)
  self.costPointListCtrl = UIGridListCtrl.new(grid, InheritSkillCostPointCell, "InheritSkillCostPointCell")
  grid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialListCtrl = UIGridListCtrl.new(grid, InheritSkillMaterialCell, "InheritSkillMaterialCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterial, self)
  self.tipLabel = self:FindComponent("tip", UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  grid = self:FindComponent("AttrGrid", UIGrid)
  self.attrListCtrl = UIGridListCtrl.new(grid, InheritSkillCostPointAttrDetailCell, "InheritSkillCostPointAttrDetailCell")
  self.materialPart = self:FindGO("MaterialPart")
  self.maxLvTip = self:FindGO("MaxLvTip")
  self.materialProgressBar = self:FindComponent("MaterialBar", UIProgressBar)
  self.progressLabel = self:FindComponent("Progress", UILabel)
  self.barSp = self:FindComponent("Foreground", UIMultiSprite)
end

function InheritSkillExtendCostPointPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SkillExtendInheritSkillCmd, self.HandleExtendCostPoint)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function InheritSkillExtendCostPointPopUp:OnEnter()
  self:RefreshView()
end

function InheritSkillExtendCostPointPopUp:HandleExtendCostPoint()
  self:RefreshView()
  local cells = self.costPointListCtrl:GetCells()
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  local extendedCostPoints = InheritSkillProxy.Instance:GetExtendedCostPoints()
  local cell = cells[initPoint + extendedCostPoints]
  if cell then
    cell:PlayEffect(EffectMap.UI.SkillInherit_CostPointUnlock)
  end
end

function InheritSkillExtendCostPointPopUp:HandleItemUpdate()
  self:RefreshMaterial()
end

function InheritSkillExtendCostPointPopUp:RefreshView()
  self:RefreshCostPoint()
  self:RefreshMaterial()
  self:RefreshAttr()
end

function InheritSkillExtendCostPointPopUp:RefreshCostPoint()
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  local extendPointCost = GameConfig.SkillInherit and GameConfig.SkillInherit.PointExtendCost
  local max = initPoint + (extendPointCost and #extendPointCost or 0)
  local extendedCostPoints = InheritSkillProxy.Instance:GetExtendedCostPoints()
  local curCostPoint = extendedCostPoints + initPoint
  self.costPointLabel.text = string.format(ZhString.InheritSkill_CurCostPoint, curCostPoint, max)
  self.materialPart:SetActive(max > curCostPoint)
  self.maxLvTip:SetActive(max <= curCostPoint)
  local datas = {}
  for i = 1, max do
    local state = curCostPoint >= i and 1 or 3
    datas[#datas + 1] = state
  end
  self.costPointListCtrl:ResetDatas(datas)
end

local NormalColor = Color(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
local LackColor = Color(0.9333333333333333, 0.3568627450980392, 0.3568627450980392, 1)

function InheritSkillExtendCostPointPopUp:RefreshMaterial()
  local datas = {}
  local extendPointCost = GameConfig.SkillInherit and GameConfig.SkillInherit.PointExtendCost
  local extendedCostPoints = InheritSkillProxy.Instance:GetExtendedCostPoints()
  if extendPointCost and extendedCostPoints < #extendPointCost then
    local config = extendPointCost[extendedCostPoints + 1]
    if config then
      local checkPackage = GameConfig.PackageMaterialCheck.inherit_skill
      if config.Items then
        local totalNum = 0
        local count = config.Count or 0
        local str = ""
        for i = 1, #config.Items do
          local itemId = config.Items[i]
          local itemData = ItemData.new("", itemId)
          local num = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
          itemData.num = num
          datas[#datas + 1] = itemData
          totalNum = totalNum + num
          local name = itemData:GetName()
          str = str .. name
          if i < #config.Items then
            str = str .. "/"
          end
        end
        self.materialListCtrl:ResetDatas(datas)
        self.materialTitleLabel.text = string.format(ZhString.InheritSkill_MaterialTip, str, count)
        TableUtility.ArrayClear(self.lackMats)
        local isLack = count > totalNum
        local cells = self.materialListCtrl:GetCells()
        local names = ""
        for i = 1, #cells do
          local cell = cells[i]
          cell:SetNumLabelState(isLack)
          if isLack then
            self.lackMats[#self.lackMats + 1] = {
              id = cell.data.id,
              count = cell.data.needNum
            }
          end
        end
        local firstItem = cells[1].data:GetName()
        local secondItem = string.sub(str, string.find(str, "/") + 1)
        self.tipLabel.text = string.format(ZhString.InheritSkill_CostPointTip, firstItem, secondItem)
        self.materialProgressBar.value = math.clamp(totalNum / count, 0, 1)
        self.progressLabel.text = string.format("%d/%d", totalNum, count)
        self.progressLabel.color = isLack and LackColor or NormalColor
        self.barSp.CurrentState = isLack and 0 or 1
      end
    end
  end
end

local StrFormat = "%d%%"

function InheritSkillExtendCostPointPopUp:RefreshAttr()
  local datas = {}
  local curAttrs = InheritSkillProxy.Instance:GetCurCostPointAttrs()
  local extendedCostPoints = InheritSkillProxy.Instance:GetExtendedCostPoints()
  local nextAttrs = InheritSkillProxy.Instance:GetCostPointAttrs(extendedCostPoints + 1)
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  for i = 1, 3 do
    local data = {}
    if i == 1 then
      data.name = ZhString.InheritSkill_CostPointUpgrade
      data.curValue = initPoint + extendedCostPoints
      data.nextValue = nextAttrs and initPoint + extendedCostPoints + 1
    else
      local curName = curAttrs[i - 1].name
      local curValue = curAttrs[i - 1].value
      if nextAttrs and nextAttrs[i - 1].name ~= curAttrs[i - 1].name then
        curName = nextAttrs[i - 1].name
        curValue = 0
      end
      local config = Game.Config_PropName[curName]
      data.name = config and config.PropName .. ":" or ""
      if config and config.IsPercent == 1 then
        data.curValue = string.format(StrFormat, curValue * 100)
        data.nextValue = nextAttrs and string.format(StrFormat, nextAttrs[i - 1].value * 100)
      else
        data.curValue = curValue
        data.nextValue = nextAttrs and nextAttrs[i - 1].value
      end
    end
    datas[#datas + 1] = data
  end
  self.attrListCtrl:ResetDatas(datas)
end

function InheritSkillExtendCostPointPopUp:OnClickMaterial(cell)
  self.tipData.itemdata = cell.data
  self:ShowItemTip(self.tipData, cell.bg, NGUIUtil.AnchorSide.Right, {200, 0})
end

function InheritSkillExtendCostPointPopUp:OnUpgradeBtnClick()
  if #self.lackMats > 0 then
    MsgManager.ShowMsgByID(43609)
    return
  end
  ServiceSkillProxy.Instance:CallExtendInheritSkillCmd()
end
