autoImport("BaseTip")
autoImport("AdventureEquipComposeTreeCell")
autoImport("AdventrueResearchItemCell")
autoImport("MaterialItemCell")
autoImport("AdventureEquipChooseCell")
autoImport("AdventureEquipComposeCell")
autoImport("EquipComposeItemData")
AdventureEquipComposeTip = class("AdventureEquipComposeTip", BaseView)
local processStatus = {
  EquipCompose = 1,
  EquipUpgrade = 2,
  Compose = 3
}
local tempVector3 = LuaVector3.Zero()
local texName_NoPreviewBG = "com_bg_scene"
local texName_NoPreviewCat = "adventure_kong"
local PACKAGE_CFG = GameConfig.PackageMaterialCheck.equipcompose

function AdventureEquipComposeTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("AdventureEquipComposeTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self.transform = self.gameObject.transform
  self:Init()
end

function AdventureEquipComposeTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function AdventureEquipComposeTip:Init()
  self:InitLockBord()
  self.frontPanel = self:FindGO("FrontPanel")
  local l_tsfModelHolder = self.transform:Find("MainPanel/Top/PlayerModelContainer")
  self.modelHodler = l_tsfModelHolder.gameObject
  self.adventureValue = l_tsfModelHolder:Find("scoreCt/adventureValue"):GetComponent(UILabel)
  local l_tsfCardHolder = self.transform:Find("MainPanel/Top/CardCellHolder")
  self.cardHodler = l_tsfCardHolder.gameObject
  local l_tsfAdventureValueCt = l_tsfCardHolder:Find("adventureValueCt")
  self.adventureValueCt = l_tsfAdventureValueCt.gameObject
  self.adventureValueCt:SetActive(false)
  self.objitemmodeltexture = l_tsfModelHolder:Find("ModelTexture").gameObject
  self.itemmodeltexture = self.objitemmodeltexture:GetComponent(UITexture)
  self.ItemName = l_tsfModelHolder:Find("modelBottombg/ItemName"):GetComponent(UILabel)
  self.tsfBottomCt = self.transform:Find("BeforePanel/LockBordHolder/LockBord/BottomCt")
  self.lockTipLabel = self.tsfBottomCt:Find("LockTipLabel"):GetComponent(UILabel)
  local l_tsfCenter = self.transform:Find("MainPanel/Center")
  self.center = l_tsfCenter.gameObject
  local l_tsfScrollView = l_tsfCenter:Find("ScrollView")
  self.scrollView = l_tsfScrollView:GetComponent(UIScrollView)
  local l_tsfCenterTable = l_tsfScrollView:Find("CenterTable")
  self.centerTable = l_tsfCenterTable:GetComponent(UITable)
  local l_tsfUnlockReward = l_tsfCenterTable:Find("UnlockReward")
  self.objUnlockReward = l_tsfUnlockReward.gameObject
  self.objUnlockReward:SetActive(false)
  self.fixedAttrLabel = l_tsfUnlockReward:Find("FixAttrCt/fixedAttrLabel"):GetComponent("UILabel")
  self.LockReward = l_tsfUnlockReward:Find("LockReward"):GetComponent(UILabel)
  self.LockReward.text = ZhString.MonsterTip_LockReward
  local modelBg = l_tsfModelHolder:Find("ModelBg").gameObject
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model_Fashion2 then
      self.model_Fashion2:RotateDelta(-delta.x)
    end
    if self.model_Fashion3 then
      self.model_Fashion3:RotateDelta(-delta.x)
    end
    if not self.model then
      return
    end
    if type(self.model) == "table" and self.model.RotateDelta then
      self.model:RotateDelta(-delta.x)
      return
    end
    LuaGameObject.LocalRotateDeltaByAxisY(self.model.transform, -delta.x)
  end)
  self.mainPanel = self:FindGO("MainPanel")
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self.userdata = Game.Myself.data.userdata
  self.objNoPreview = l_tsfModelHolder:Find("NoPreview").gameObject
  self.texNoPreviewBG = self:FindComponent("NoPreviewBG", UITexture, self.objNoPreview)
  self.texNoPreviewCat = self:FindComponent("NoPreviewCat", UITexture, self.objNoPreview)
  PictureManager.Instance:SetUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:SetUI(texName_NoPreviewCat, self.texNoPreviewCat)
  self.itemIcon = self:FindGO("ItemIcon", self.mainPanel):GetComponent(UISprite)
  self:InitTreeBord()
  self.funcGrid = self.transform:Find("MainPanel/Bottom"):GetComponent(UIGrid)
  self.getWayBtn = self:FindGO("GetWayBtn")
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self.upgradeBtn_Label = self:FindGO("Label", self.upgradeBtn):GetComponent(UILabel)
  self.composeBtn = self:FindGO("ComposeBtn")
  self.equipComposeBtn = self:FindGO("EquipComposeBtn")
  self.equipComposeBtn_Label = self:FindGO("Label", self.equipComposeBtn):GetComponent(UILabel)
  self.equipComposeBtn_Label.text = ISNoviceServerType and ZhString.AdventureEquipCompose_UpgradeEquip or ZhString.EquipCompose_Title
  local itemTipContainer = self.getWayBtn:GetComponent(UISprite)
  self.getWayContainer = self:FindGO("GetWayContainer")
  self:AddClickEvent(self.getPathBtn, function()
    xdlog("当前选中查看目标", self.data.staticId)
    local sId = self.data.staticId
    if sId then
      if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
        self.gainwayCtl:OnExit()
        self.gainwayCtl = nil
      else
        self.gainwayCtl = GainWayTip.new(self.getWayContainer)
        self.gainwayCtl:SetData(sId)
      end
    end
  end)
  self:AddClickEvent(self.upgradeBtn, function()
    FunctionSecurity.Me():LevelUpEquip(function()
      if #self.upgradeLackItems > 0 then
        QuickBuyProxy.Instance:SetEquipUpgradeExLevel(lvCount)
        if QuickBuyProxy.Instance:TryOpenView(self.upgradeLackItems, QuickBuyProxy.QueryType.NoDamage) then
          return
        end
      else
        local needRecover, tipEquips = FunctionItemFunc.RecoverEquips(self.costEquips)
        if needRecover then
          return
        end
        if 0 < #tipEquips then
          MsgManager.ConfirmMsgByID(247, confirmHandler, nil, nil, tipEquips[1].equipInfo.refinelv)
          return
        end
        local maxLv = self.curChooseEquipItem.equipInfo:GetUpgradeReplaceLv()
        local curLv = self.curChooseEquipItem.equipInfo.equiplv
        local lvCount = maxLv - curLv
        ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.curChooseEquipItem.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP, nil, nil, lvCount)
      end
    end)
  end)
  self:AddClickEvent(self.composeBtn, function()
    self:DoQuickMake()
  end)
  self:AddClickEvent(self.equipComposeBtn, function()
    if ISNoviceServerType then
      self:DoEquipCompose()
    else
      EquipComposeProxy.Instance:SetTargetID(self.data.staticId)
      FuncShortCutFunc.Me():CallByID(3052)
    end
  end)
  self.noneSourceTip = self:FindGO("NoneSourceTip")
  self.noneSourceTip:SetActive(false)
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.HandleUpgradeResult, self)
  self.tempCostCell = {}
  self.curProcessStatus = 0
end

function AdventureEquipComposeTip:InitTreeBord()
  self.treePart = self:FindGO("TreePart", self.gameObject)
  if not self.step3Cell then
    local step3ItemGO = self:FindGO("Step3Item", self.treePart)
    self.step3Line = self:FindGO("FinalTop", self.treePart):GetComponent(UISprite)
    self.step3VertLine = self:FindGO("Step3VerticalLine", self.treePart)
    local step3Obj = self:LoadPreferb("cell/AdventrueResearchItemCell", step3ItemGO)
    self.step3Cell = AdventrueResearchItemCell.new(step3Obj)
    
    function self.step3Cell.setIsSelected()
    end
    
    self.step3Cell:AddEventListener(MouseEvent.MouseClick, self.HandleShowItemTip, self)
  end
  self.treeTable = self:FindGO("TreeTable", self.treePart):GetComponent(UITable)
  self.composeTreeList = UIGridListCtrl.new(self.treeTable, AdventureEquipComposeTreeCell, "AdventureEquipComposeTreeHorizontalCell")
  self.composeTreeList:AddEventListener(MouseEvent.MouseClick, self.HandleShowItemTip, self)
  self.chooseSymbol = self:FindGO("ChooseSymbol", self.treePart)
end

function AdventureEquipComposeTip:InitLockBord()
  local l_tsfLockBordHolder = self.transform:Find("BeforePanel/LockBordHolder")
  self.lockBord = l_tsfLockBordHolder.gameObject
  local l_tsfLockBord = l_tsfLockBordHolder:Find("LockBord")
  local objLockBord
  if l_tsfLockBord then
    objLockBord = l_tsfLockBord.gameObject
  else
    objLockBord = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    objLockBord.name = "LockBord"
    l_tsfLockBord = objLockBord.transform
    l_tsfLockBord.localPosition = LuaGeometry.Const_V3_zero
    l_tsfLockBord.localScale = LuaGeometry.Const_V3_one
  end
  self.sprLock = l_tsfLockBord:Find("BottomCt/Sprite (1)"):GetComponent(UISprite)
  self.sprLock.gameObject:SetActive(false)
  l_tsfLockBord:Find("BottomCt/LockTipLabel"):GetComponent(UILabel).onChange = function()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  self.getPathBtn = l_tsfLockBord:Find("getPathBtn").gameObject
  self.lockLabel = l_tsfLockBord:Find("LockTitle"):GetComponent(UILabel)
  self.lockTip = l_tsfLockBord:Find("LockTip"):GetComponent(UILabel)
  local l_tsfScrollView = self.transform:Find("MainPanel/Center/ScrollView")
  local grid = l_tsfScrollView:Find("CenterTable/UnlockReward/LockInfoGrid"):GetComponent(UIGrid)
  self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell")
  self.bottomCt = l_tsfLockBord:Find("BottomCt").gameObject
  self.tsfFixAttrCtrl = l_tsfScrollView:Find("CenterTable/UnlockReward/FixAttrCt")
  self.modelBottombg = self.transform:Find("MainPanel/Top/PlayerModelContainer/modelBottombg").gameObject
  self.bottomCt:SetActive(false)
  self.modelBottombg:SetActive(true)
end

function AdventureEquipComposeTip:SetData(itemData)
  self.data = itemData
  self:adjustPanelDepth(4)
  self.staticData = self.data and self.data.staticData
  self:SetLockState()
  self.scrollView:ResetPosition()
  self:SetTreeInfo(itemData)
  self:UpdateAttriText()
  self:UpdateTopInfo()
  self:UpdateTopModel()
  self:UpdateBottomFuncs()
  self:UpdateGetWayBtn()
end

function AdventureEquipComposeTip:SetLockState()
end

function AdventureEquipComposeTip:SetTreeInfo(itemData)
  local itemData = itemData or self.data
  self.equipInfo = itemData.equipInfo or itemData.itemdata.equipInfo
  if self.equipInfo then
    local myClass = MyselfProxy.Instance:GetMyProfession()
    local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
    local equipStaticData = self.equipInfo.equipData
    if equipStaticData then
      self.step3Cell:SetData(itemData)
      local result = {}
      if Table_EquipCompose[equipStaticData.id] then
        local config = Table_EquipCompose[equipStaticData.id]
        local materials = config and config.Material or {}
        for i = 1, #materials do
          local materialItemData = ItemData.new("Material_" .. i, materials[i].id)
          materialItemData.equipInfo.equiplv = materials[i].lv or 0
          table.insert(result, materialItemData)
        end
      else
        local srdIDs, srcType = BagProxy.GetSurceEquipIds(equipStaticData.id)
        if srdIDs and 0 < #srdIDs then
          for i = 1, #srdIDs do
            local newSrdIDs, newSrcType = BagProxy.GetSurceEquipIds(srdIDs[i])
            if newSrcType == 2 then
              local targetItemId = math.min(unpack(newSrdIDs))
              local targetItemData = ItemData.new("UpgradeSource", targetItemId)
              table.insert(result, targetItemData)
              break
            end
          end
        end
      end
      self.treePart:SetActive(0 < #result)
      self.composeTreeList:ResetDatas(result, true)
      local cells = self.composeTreeList:GetCells()
      if cells and 1 < #cells then
        self.step3Line.gameObject:SetActive(true)
        self.step3VertLine:SetActive(true)
        local y_end = cells[#cells].gameObject.transform.localPosition.y
        local y_start = cells[1].gameObject.transform.localPosition.y
        self.step3Line.width = y_start - y_end + 1
      elseif cells and #cells == 1 then
        self.step3Line.gameObject:SetActive(false)
        self.step3VertLine:SetActive(true)
      else
        self.step3Line.gameObject:SetActive(false)
        self.step3VertLine:SetActive(false)
      end
      local materialLine = #result or 0
      local height = materialLine * 100
      local x, y, z = LuaGameObject.GetLocalPosition(self.table.gameObject.transform)
      LuaVector3.Better_Set(tempVector3, x, -height - 30, z)
      self.table.gameObject.transform.localPosition = tempVector3
      local maxUpLv = self.equipInfo.upgrade_MaxLv
      local canUpgrade, lv = self.equipInfo:CanUpgrade_ByClassDepth(classDepth, maxUpLv + 1)
      self.lockTip.gameObject:SetActive(not canUpgrade and lv ~= nil and true or false)
      if lv then
        self.lockTip.text = string.format(ZhString.ItemTip_NoUpgradeTip, "EFDF96", ZhString.ChinaNumber[lv])
      else
        self.lockTip.text = ""
      end
    end
  else
    redlog("没有装备信息")
  end
end

function AdventureEquipComposeTip:UpdateAttriText()
  self.attriCtl:ResetDatas()
  local contextDatas = {}
  local equipInfo = self.data.equipInfo
  local singleData
  singleData = ItemTipBaseCell.GetEquipDecomposeTip(equipInfo)
  if singleData then
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = ItemTipBaseCell.GetItemType(self.staticData)
  if singleData then
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = ItemTipBaseCell.GetEquipBaseAttriByItemData(self.data, true)
  if singleData then
    singleData.tiplabel = ZhString.MonsterTip_EquipInfo
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = ItemTipBaseCell.GetEquipSpecial(equipInfo, true)
  if singleData then
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, true)
  if singleData then
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = ItemTipBaseCell.GetEquipProfession(equipInfo)
  if singleData then
    singleData.hideline = true
    table.insert(contextDatas, singleData)
  end
  singleData = self:GetMakeMaterial()
  if singleData then
    table.insert(contextDatas, singleData)
  end
  self.attriCtl:ResetDatas(contextDatas)
end

function AdventureEquipComposeTip:GetDescription()
  local desc = {}
  if self.staticData.Desc ~= "" then
    desc.label = self.staticData.Desc
    desc.hideline = true
    return desc
  end
end

function AdventureEquipComposeTip:GetMakeMaterial()
  xdlog("staticid", self.data.staticId)
  local table_ItemBeTransformedWay = EquipMakeProxy.Instance:GetBeTransformedWayTable()
  if table_ItemBeTransformedWay[self.data.staticId] then
    local cid = table_ItemBeTransformedWay[self.data.staticId]
    local table_compose = EquipMakeProxy.Instance:GetComposeTable()
    local composeData = table_compose[cid]
    if composeData then
      local costItem = composeData.BeCostItem
      local temp = {
        labelType = AdventureDataProxy.LabelType.Count
      }
      temp.hideline = true
      temp.tiplabel = ZhString.MonsterTip_MakeMaterial
      temp.label = {}
      for i = 1, #costItem do
        local itemId = costItem[i].id
        local need = costItem[i].num
        local itemData = Table_Item[itemId]
        if itemData then
          local label = {}
          local checkBagType = BagProxy.MaterialCheckBag_Type.adventureProduce
          if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
            checkBagType = BagProxy.MaterialCheckBag_Type.Furniture
          end
          local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(checkBagType)
          local itemDatas = BagProxy.Instance:GetMaterialItems_ByItemId(itemId, bagtype)
          local exsitNum = 0
          if itemDatas and 0 < #itemDatas then
            for j = 1, #itemDatas do
              local single = itemDatas[j]
              exsitNum = exsitNum + single.num
            end
          end
          local formatStr = "[url=%s;%d][u][c][0000FF]%s[-][/c][/u][/url]"
          local nameStr = string.format(formatStr, itemData.id, 0, itemData.NameZh)
          label = {
            text = nameStr,
            exist = exsitNum,
            need = need
          }
          table.insert(temp.label, label)
        end
      end
      
      function temp.clickurlcallback(url)
        local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
        local itemId = tonumber(split[1])
        local upgradeLv = tonumber(split[2] or 0)
        self:OnItemUrlClicked(itemId, upgradeLv)
      end
      
      if #temp.label > 0 then
        return temp
      end
    end
  else
    local composeConfig = Table_EquipCompose[self.data.staticId]
    if composeConfig then
      xdlog("魔能灌注")
      local temp = {
        labelType = AdventureDataProxy.LabelType.Count
      }
      temp.hideline = true
      temp.tiplabel = ISNoviceServerType and ZhString.EquipComposeTip_MakeMaterial_Novice or ZhString.EquipComposeTip_MakeMaterial
      temp.label = {}
      self.curComposeData = EquipComposeNewItemData.new(composeConfig)
      self.equipComposeBtn:SetActive(true)
      local cost = {}
      local commonMats = self.curComposeData.material
      for k, v in pairs(commonMats) do
        local singleData = {id = k, num = v}
        table.insert(cost, singleData)
      end
      table.sort(cost, function(l, r)
        local l_isEquip = ItemData.CheckIsEquip(l.id) and 1 or 0
        local r_isEquip = ItemData.CheckIsEquip(r.id) and 1 or 0
        if l_isEquip ~= r_isEquip then
          return l_isEquip > r_isEquip
        end
      end)
      if cost and 0 < #cost then
        local compose_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
        for i = 1, #cost do
          local id = cost[i].id
          if ItemData.CheckIsEquip(id) then
            local needNum = cost[i].num
            local existNum = 0
            local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, nil, compose_checkBagTypes)
            for j = 1, #equips do
              if self:matCheckFunc(equips[j]) then
                existNum = existNum + equips[j].num
              end
            end
            local itemStaticData = Table_Item[id]
            local formatStr = "[url=%s;%d][u][c][0000FF]%s[-][/c][/u][/url]"
            local nameStr = string.format(formatStr, itemStaticData.id, 0, itemStaticData.NameZh)
            local label = {
              text = nameStr,
              exist = existNum,
              need = needNum
            }
            table.insert(temp.label, label)
          else
            local existNum = BagProxy.Instance:GetItemNumByStaticID(id, GameConfig.PackageMaterialCheck.equipcompose)
            local needNum = cost[i].num
            local itemStaticData = Table_Item[id]
            local formatStr = "[url=%s;%d][u][c][0000FF]%s[-][/c][/u][/url]"
            local nameStr = string.format(formatStr, itemStaticData.id, 0, itemStaticData.NameZh)
            local label = {
              text = nameStr,
              exist = existNum,
              need = needNum
            }
            table.insert(temp.label, label)
          end
        end
      end
      
      function temp.clickurlcallback(url)
        local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
        local itemId = tonumber(split[1])
        local upgradeLv = tonumber(split[2] or 0)
        self:OnItemUrlClicked(itemId, upgradeLv)
      end
      
      if #temp.label > 0 then
        return temp
      end
    end
  end
end

function AdventureEquipComposeTip:OnItemUrlClicked(id, upgradeLv)
  if not self.itemClickUrlTipData then
    self.itemClickUrlTipData = {}
  end
  if not self.itemClickUrlTipData.itemdata then
    self.itemClickUrlTipData.itemdata = ItemData.new("AdventureEquipComposeTip", id)
  else
    self.itemClickUrlTipData.itemdata:ResetData("AdventureEquipComposeTip", id)
  end
  if self.itemClickUrlTipData.itemdata.equipInfo then
    self.itemClickUrlTipData.itemdata.equipInfo.equiplv = upgradeLv
  end
  if not self.clickItemUrlTipOffset then
    self.clickItemUrlTipOffset = {420, -220}
  end
  self:ShowItemTip(self.itemClickUrlTipData, self.epModelTexture, NGUIUtil.AnchorSide.Right, self.clickItemUrlTipOffset)
end

function AdventureEquipComposeTip:GetComposeEquips(staticID, includeReplace)
  local result = {}
  local equipList = {}
  if includeReplace then
    local replaceEquipIds = BagProxy.GetReplaceEquipIds(staticID)
    if replaceEquipIds and 0 < #replaceEquipIds then
      for i = 1, #replaceEquipIds do
        table.insert(equipList, replaceEquipIds[i])
      end
    else
      table.insert(equipList, staticID)
    end
  else
    table.insert(equipList, staticID)
  end
  for i = 1, #equipList do
    local bagEquips = BagProxy.Instance:GetMaterialItems_ByItemId(equipList[i], PACKAGE_CFG)
    local curData = self.curComposeData
    local lackLvEquip
    if bagEquips then
      for j = 1, #bagEquips do
        local equipInfo = bagEquips[j].equipInfo
        if equipInfo then
          local equipLv = equipInfo.equiplv
          local isDamage = equipInfo.damage
          local lvLimited = curData and curData:GetMatLimitedLv(bagEquips[j].staticData.id) or equipInfo:GetUpgradeReplaceLv()
          if not isDamage and nil ~= equipLv then
            result[#result + 1] = bagEquips[j]
          end
        end
      end
    end
  end
  return result, lackLvEquip
end

function AdventureEquipComposeTip:InsertOrAddNum(array, item, idKey, numKey)
  if type(array) ~= "table" or type(item) ~= "table" then
    return
  end
  idKey = idKey or "id"
  numKey = numKey or "num"
  local element
  for i = 1, #array do
    element = array[i]
    if element[idKey] == item[idKey] then
      element[numKey] = element[numKey] + item[numKey]
      return
    end
  end
  local copy = {}
  copy.GetName = item.GetName
  TableUtility.TableShallowCopy(copy, item)
  TableUtility.ArrayPushBack(array, copy)
end

local qMakeEquipProductMap, qMakeFuncConfig = {}, {70}

function AdventureEquipComposeTip:HandleShowItemTip(cellCtrl)
  TipsView.Me():HideCurrent()
  if not self.tipOffset then
    self.tipOffset = {200, 0}
  end
  local data = cellCtrl.data
  local itemId = data.staticData.id
  self.itemTipData = self.itemTipData or {
    itemdata = ItemData.new()
  }
  self.itemTipData.itemdata:ResetData(itemId, itemId)
  local equipInfo = self.itemTipData.itemdata.equipInfo
  if equipInfo and equipInfo:IsNextGen() then
    equipInfo.isRandomPreview = true
  end
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  if not next(qMakeEquipProductMap) and ItemData.CheckIsEquip(itemId) then
    for _, d in pairs(table_compose) do
      if d.Type == 2 and d.Category == 1 and d.Product and d.Product.id and FunctionUnLockFunc.Me():CheckCanOpen(d.MenuID) then
        qMakeEquipProductMap[d.Product.id] = true
      end
    end
  end
  self.itemTipData.showUpTip = false
  self.itemTipData.funcConfig = qMakeEquipProductMap[itemId] and qMakeFuncConfig or _EmptyTable
  TipManager.Instance:ShowItemFloatTip(self.itemTipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, self.tipOffset)
end

function AdventureEquipComposeTip:DoCompose()
  if not self.curComposeData then
    return
  end
  local curData = self.curComposeData
  local lackItems = self:TryGetCurrentLackItems()
  if 0 < #lackItems then
    QuickBuyProxy.Instance:TryOpenView(lackItems, QuickBuyProxy.QueryType.NoDamage, true)
    return
  end
  local config = Table_EquipCompose[self.data.staticId]
  if not config then
    return
  end
  if curData:IsCostLimited() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if curData:IsMatLimited() then
    MsgManager.ShowMsgByID(40013)
    return
  end
  local chooseMat = curData:GetChooseMatArray()
  MsgManager.ConfirmMsgByID(26001, function()
    ServiceItemProxy.Instance:CallEquipComposeItemCmd(curData.composeID, chooseMat)
  end, nil, nil)
end

function AdventureEquipComposeTip:DoQuickMake()
  local composeID = self.data.staticId
  xdlog("合成目标", composeID)
  GameFacade.Instance:sendNotification(AdventureDataEvent.ClearExitEvent)
  FunctionNpcFunc.JumpPanel(PanelConfig.CommonCombineView, {
    npcdata = nil,
    index = 1,
    tabs = {
      PanelConfig.EquipMfrView
    },
    equipid = composeID,
    toggleSelfProfession = false,
    from_AdventureEquipComposeTip = composeID
  })
end

function AdventureEquipComposeTip:DoEquipCompose()
  local curData = self.curComposeData
  if not curData then
    redlog("无composeData")
    return
  end
  local composeID = curData.composeID
  local mainMatID = curData.mainMatID
  local limitLv = curData.mainMatLv or 0
  if mainMatID then
    if mainMatID < 100000 then
      mainMatID = mainMatID + 100000
    end
    local items = BagProxy.Instance:GetItemsByStaticID(mainMatID)
    if not items then
      if 100000 < mainMatID then
        mainMatID = mainMatID % 100000
      else
        mainMatID = mainMatID + 100000
      end
      xdlog("复测其他孔位装备", mainMatID)
      items = BagProxy.Instance:GetItemsByStaticID(mainMatID)
      if not items then
        local sysmsgData = Table_Sysmsg[9000]
        local str = string.format(sysmsgData.Text, Table_Item[mainMatID].NameZh)
        MsgManager.FloatMsg(sysmsgData.Title, str)
        return
      end
    end
  end
  local targetItem
  targetItem = ItemData.new("FakeItem", mainMatID)
  targetItem.equipInfo.equiplv = limitLv
  GameFacade.Instance:sendNotification(AdventureDataEvent.ClearExitEvent)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "EquipIntegrateView",
    viewdata = {
      itemdata = targetItem,
      index = 3,
      from_AdventureEquipComposeTip = composeID
    }
  })
end

function AdventureEquipComposeTip:TryGetCurrentLackItems()
  local lackItems = {}
  local curData = self.curComposeData
  local curDataCostMat = curData.material
  local composeID = self.data.staticId
  local config = Table_EquipCompose[composeID]
  if not config then
    redlog("缺少合成配置", composeID)
    return
  end
  local equipMat = config.Material
  for i = 1, #equipMat do
    local targetId = equipMat[i].id
    if not curData.chooseMat[targetId] or curData.chooseMat[targetId] == 0 then
      redlog("未选择素材  尝试购买所有合成资源", targetId)
      local equipdatas = self:GetComposeEquips(targetId)
      if #equipdatas <= 0 then
        local targetLv = equipMat[i].lv
        if targetLv then
          local result = EquipUtil.CalcEquipUpgradeCost(targetId, targetLv)
          for j = 1, #result do
            local own = BagProxy.Instance:GetItemNumByStaticID(result[j].id, PACKAGE_CFG)
            local costNum = result[j].num
            if own < costNum then
              local lackItem = {
                id = result[j].id,
                count = costNum - own
              }
              lackItems[#lackItems + 1] = lackItem
            end
          end
        end
      end
    end
  end
  for i = 1, #curDataCostMat do
    local costStaticID = curDataCostMat[i].staticData.id
    local costNum = curDataCostMat[i].num
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costStaticID, PACKAGE_CFG)
    if costNum > ownNum then
      local lackItem = {
        id = costStaticID,
        count = costNum - ownNum
      }
      lackItems[#lackItems + 1] = lackItem
    end
  end
  return lackItems
end

function AdventureEquipComposeTip:HandleUpgradeResult()
  xdlog("HandleUpdateresult")
  self:UpdateAttriText()
end

function AdventureEquipComposeTip:UpdateTopInfo(data)
  local data = data or self.data
  if data then
    local qInt = data.staticData.Quality
    if self.equipTip then
      self.equipTip:SetActive(data.equiped == 1)
    end
    self:UpdateGetPathBtn(data)
    self.ItemName.text = data:GetName()
  end
end

function AdventureEquipComposeTip:UpdateGetPathBtn(data)
  if self.getPathBtn and data.staticData then
    local gainData = GainWayTipProxy.Instance:GetDataByStaticID(data.staticData.id)
    self.getPathBtn:SetActive(gainData ~= nil and 0 < #gainData)
  end
end

function AdventureEquipComposeTip:UpdateTopModel()
  UIMultiModelUtil.Instance:RemoveModels()
  UIMultiModelUtil.Instance:ResetModelCell()
  self:Show3DModel(function(success)
    if not success then
      self:Show2DCell()
    else
      self:Hide(self.itemIcon.gameObject)
    end
  end)
end

function AdventureEquipComposeTip:Show2DCell(chooseState)
  self.modelId = self.data.staticData.id
  PictureManager.Instance:SetPetRenderTexture("Bg_beijing", self.itemmodeltexture)
  IconManager:SetItemIcon(self.data.staticData.Icon, self.itemIcon)
  self:Show(self.itemIcon.gameObject)
end

function AdventureEquipComposeTip:Show3DModel(callBack)
  local data = self.data
  if data and data.staticData then
    local type = data.staticData.Type
    local key = TableUtil.FindKeyByValue(GameConfig.ManualShowItemType, type)
    if key then
      if data.equipInfo and data.equipInfo.equipData then
        self:SetNormalModel(data, function(result)
          self:Show3DModelCallBack(callBack, result)
        end)
      elseif callBack then
        callBack(false)
      end
    elseif callBack then
      callBack(false)
    end
  end
end

function AdventureEquipComposeTip:Show3DModelCallBack(callBack, success)
  xdlog("Show3DModelCallBack", success)
  if callBack then
    callBack(success)
  end
end

function AdventureEquipComposeTip:SetNormalModel(data, callBack)
  local sData = data.staticData
  local GroupID = data.equipInfo and data.equipInfo.equipData.GroupID
  if GroupID then
    local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
    if not equipDatas or #equipDatas == 0 then
      if callBack then
        callBack(false)
      end
      return
    end
    sData = Table_Item[self.curSelectGroupItemCell.staticId]
  end
  local canEquip = data.equipInfo and data.equipInfo.equipData.CanEquip
  local config = GameConfig.ManualModelHide
  if config and canEquip then
    local typeConfig = config[sData.Type]
    if typeConfig then
      for i = 1, #typeConfig do
        if #canEquip == #typeConfig[i] then
          local allSame = true
          for j = 1, #canEquip do
            if TableUtility.ArrayFindIndex(typeConfig[i], canEquip[j]) == 0 then
              allSame = false
              break
            end
          end
          if allSame then
            if callBack then
              callBack(false)
            end
            return
          end
        end
      end
    end
  end
  if self.modelId == sData.id then
    return
  end
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  self.modelId = sData.id
  local failCallback = function()
    if callBack then
      callBack(false)
    end
  end
  UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, sData.id, nil, function(obj, id, assetRolePart)
    self.model = assetRolePart
    local replaceID = math.floor(sData.id % 100000)
    local replaceData
    if replaceID ~= 0 then
      replaceData = Table_Item[replaceID]
    end
    local showPos = sData.LoadShowPose
    if showPos and showPos[1] then
      self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
    else
      local isfashion = BagProxy.fashionType[sData.Type]
      if isfashion then
        self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(0, 0.5))
      elseif replaceData and replaceData.LoadShowPose then
        showPos = replaceData.LoadShowPose
        self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
      end
    end
    local showRot = sData.LoadShowRotate
    if not showRot and replaceData then
      showRot = replaceData.LoadShowRotate
    end
    local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId] or GameConfig.ItemLoadShowRotateXZ[replaceID]
    self.model:ResetLocalEulerAnglesXYZ(xzEulerConfig and xzEulerConfig[1] or 0, showRot or 0, xzEulerConfig and xzEulerConfig[2] or 0)
    local size = sData.LoadShowSize
    if not size and replaceData then
      size = replaceData and replaceData.LoadShowSize or 1
    end
    self.model:ResetLocalScale(LuaGeometry.GetTempVector3(size, size, size))
    if callBack then
      callBack(self.model ~= nil)
    end
  end, sData.id, failCallback)
end

function AdventureEquipComposeTip:GetRefineLv()
  local equipInfo = self.data and self.data.equipInfo
  local groupID = equipInfo and equipInfo.equipData.GroupID
  if groupID then
    return 0
  end
  for _k, v in pairs(self.data.savedItemDatas) do
    return v.equipInfo and v.equipInfo.refinelv or 0
  end
  return 0
end

function AdventureEquipComposeTip:UpdateBottomFuncs()
  self.getPathBtn:SetActive(false)
  self.upgradeBtn:SetActive(false)
  self.composeBtn:SetActive(false)
  self.equipComposeBtn:SetActive(false)
  local table_ItemBeTransformedWay = EquipMakeProxy.Instance:GetBeTransformedWayTable()
  if table_ItemBeTransformedWay[self.data.staticId] then
    self.composeBtn:SetActive(true)
  elseif Table_EquipCompose[self.data.staticId] then
    self.equipComposeBtn:SetActive(true)
  end
  self.funcGrid:Reposition()
end

function AdventureEquipComposeTip:UpdateGetWayBtn()
  local gainData = GainWayTipProxy.Instance:GetDataByStaticID(self.data.staticId)
  self.getPathBtn:SetActive(gainData ~= nil and 0 < #gainData)
end

function AdventureEquipComposeTip:OnExit()
  self.composeTreeList:RemoveAll()
  if self.step3Cell then
    xdlog("RemoveStep3Cell")
    GameObject.DestroyImmediate(self.step3Cell.gameObject)
    self.step3Cell = nil
  end
  self.attriCtl:ResetDatas()
  if self.gainwayCtl then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
  PictureManager.Instance:UnLoadUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:UnLoadUI(texName_NoPreviewCat, self.texNoPreviewCat)
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
  self.model = nil
  UIMultiModelUtil.Instance:RemoveModels()
  UIMultiModelUtil.Instance:ResetModelCell()
  EquipComposeProxy.Instance:SetCurrentData()
  EquipComposeProxy.Instance:ResetCategoryActive()
  self.curChooseMat = nil
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.HandleUpgradeResult, self)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  AdventureEquipComposeTip.super.OnExit(self)
end

function AdventureEquipComposeTip:matCheckFunc(item)
  if not item then
    return false
  end
  local equipInfo = item.equipInfo
  local hasenchant = item.enchantInfo and item.enchantInfo:HasAttri() or false
  local hasupgrade = equipInfo.equiplv > 0
  local hasCard = false
  local equipedCards = item.equipedCardInfo
  if equipedCards then
    for i = 1, item.cardSlotNum do
      if equipedCards[i] then
        hasCard = true
        break
      end
    end
  end
  if hasenchant or hasupgrade or hasCard then
    redlog("装备非白版 需要检测")
    return false
  end
  return true
end
