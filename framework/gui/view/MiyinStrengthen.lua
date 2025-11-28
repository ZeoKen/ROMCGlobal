autoImport("ItemCell")
autoImport("ItemFun")
autoImport("FunctionMiyinStrengthen")
MiyinStrengthen = class("MiyinStrengthen", SubView)
MiyinStrengthen.PfbPath = "part/MiyinStrengthen"
local tempVector3 = LuaVector3.Zero()
local _TYPE = SceneItem_pb.ESTRENGTHTYPE_GUILD
local _StrengthenProxy

function MiyinStrengthen:Init()
  _StrengthenProxy = StrengthProxy.Instance
  self:Listen()
end

function MiyinStrengthen:InitUI()
  self.contaienr = self:FindGO("MiyinStrengthenParent")
  self.gameObject = self:LoadPreferb(MiyinStrengthen.PfbPath, self.contaienr, true)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:CollectGO()
  self:AddButtonClickEvent()
  self:RegisterItemViewClickEvent()
end

function MiyinStrengthen:CollectGO()
  self.chooseSiteIcon = self:FindComponent("ChooseSiteIcon", UISprite)
  self.emptyIcon = self:FindGO("EmptyIcon")
  self.goNowLevel = self:FindGO("Now")
  self.labNowLevelValue = self:FindGO("LevelValue", self.goNowLevel):GetComponent(UILabel)
  self.labNowAttributeTitle = self:FindGO("AttributeTitle", self.goNowLevel):GetComponent(UILabel)
  self.labNowAttributeValue = self:FindGO("AttributeValue", self.goNowLevel):GetComponent(UILabel)
  self.goNextLevel = self:FindGO("Next")
  self.labnextLevelTitle = self:FindGO("LevelTitle", self.goNextLevel):GetComponent(UILabel)
  self.labNextLevelValue = self:FindGO("LevelValue", self.goNextLevel):GetComponent(UILabel)
  self.labNextAttributeTitle = self:FindGO("AttributeTitle", self.goNextLevel):GetComponent(UILabel)
  self.labNextAttributeValue = self:FindGO("AttributeValue", self.goNextLevel):GetComponent(UILabel)
  self.goMaxLevel = self:FindGO("Max")
  self.labMaxLabel = self.goMaxLevel:GetComponent(UILabel)
  self.labEquipName = self:FindGO("EquipName", self.leftContent):GetComponent(UILabel)
  self.goCost = self:FindGO("CostDesc")
  self.zenyCostIcon = self:FindGO("Coin", self.goCost):GetComponent(UISprite)
  IconManager:SetItemIcon("item_100", self.zenyCostIcon)
  self.costTip = self:FindGO("costTip"):GetComponent(UILabel)
  self.costTip.text = ZhString.MiYinEquipStrength_CostTip
  self.labCost = self:FindGO("Cost", self.leftContent):GetComponent(UILabel)
  self.goMiyinCost = self:FindGO("Miyin", self.goCost)
  self.labMiyinCost = self:FindGO("Count", self.goMiyinCost):GetComponent(UILabel)
  self.miyinCostIcon = self:FindGO("Icon", self.goMiyinCost):GetComponent(UISprite)
  IconManager:SetItemIcon("item_5030", self.miyinCostIcon)
  self.StrengthAllBtn = self:FindGO("StrengthAllBtn")
  self.StrengthAllNum = self:FindGO("StrengthAllNum", self.StrengthAllBtn):GetComponent(UILabel)
  self.goAllCost = self:FindGO("CostAllDesc")
  self.zenyAllCostIcon = self:FindGO("Coin", self.goAllCost):GetComponent(UISprite)
  IconManager:SetItemIcon("item_100", self.zenyAllCostIcon)
  self.labAllCost = self:FindGO("Cost", self.goAllCost):GetComponent(UILabel)
  self.goMiyinAllCost = self:FindGO("Miyin", self.goAllCost)
  self.labMiyinAllCost = self:FindGO("Count", self.goMiyinAllCost):GetComponent(UILabel)
  self.miyinAllCostIcon = self:FindGO("Icon", self.goMiyinAllCost):GetComponent(UISprite)
  IconManager:SetItemIcon("item_5030", self.miyinAllCostIcon)
  self.strengthOneBtn = self:FindGO("StrengthOneBtn")
  self.goLevelChangeEmpty = self:FindGO("LevelChangeEmpty")
  self.goNow = self:FindGO("Now")
  self.goNext = self:FindGO("Next")
  self.spUpgradeSymbol = self:FindGO("UpgradeSp"):GetComponent(UISprite)
  self.goItemName = self:FindGO("CurrentEquipName")
  self.effectContainer = self:FindGO("EffectContainer")
end

function MiyinStrengthen:AddButtonClickEvent()
  self:AddClickEvent(self.strengthOneBtn, function(go)
    self:OnButtonStrengthOnceClick()
  end)
  self:AddClickEvent(self.StrengthAllBtn, function(go)
    self:OnButtonStrengthOnceClick(self.maxupgradelv)
  end)
end

function MiyinStrengthen:RegisterItemViewClickEvent()
  self.goBC = self:FindGO("BC", self.contaienr)
  self:AddClickEvent(self.goBC, function(go)
    self:OnClickForViewItem(go)
  end)
end

function MiyinStrengthen:Listen()
  self:AddListenEvt(ItemEvent.GuildStrengthLvUpdate, self.OnGuildStrengthenLvUpdate)
  self:AddListenEvt(ItemEvent.StrengthLvReinit, self.HandleStrenghtLvReinit)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnReceiveItemUpdate)
end

function MiyinStrengthen:OnGuildStrengthenLvUpdate()
  self:RefreshSelf()
  self:PlayUIEffect(EffectMap.UI.upgrade_success, self.chooseSiteIcon.gameObject, true, MiyinStrengthen.Upgrade_successEffectHandle, self)
end

function MiyinStrengthen:HandleStrenghtLvReinit()
  self:RefreshSelf()
end

function MiyinStrengthen:GetItemDataFromPartIndex(index)
  local equipsData = BagProxy.Instance.roleEquip.siteMap
  return equipsData[index]
end

local buildingType = 4

function MiyinStrengthen:UpdateInfo()
  local siteData = self.siteData
  if not siteData then
    return
  end
  local site = siteData.site
  local spname = (site == 5 or site == 6) and "bag_equip_6" or "bag_equip_" .. site
  IconManager:SetUIIcon(spname, self.chooseSiteIcon)
  local levelMax = _StrengthenProxy:MaxStrengthLevel(_TYPE)
  local currentLv = siteData.lv
  local strLevelValue = currentLv .. "/" .. levelMax
  self.labNowLevelValue.text = strLevelValue
  local strAttributeName
  local separator = ":"
  local iAttributeValue = 0
  local attrDetail = ItemFun.calcStrengthAttr(siteData.site, currentLv)
  local attrID
  for k, v in pairs(attrDetail) do
    attrID = k
    iAttributeValue = v
    break
  end
  self.attrID = attrID
  strAttributeName = Table_RoleData[attrID].PropName
  self.labNowAttributeTitle.text = strAttributeName .. separator
  self.labNowAttributeValue.text = iAttributeValue
  local levelIsReachMax = levelMax <= currentLv
  if levelIsReachMax then
    self.levelReachMax = true
    self.labnextLevelTitle.enabled = false
    self.labNextLevelValue.enabled = false
    self.labNextAttributeTitle.enabled = false
    self.labNextAttributeValue.enabled = false
    self.goMaxLevel:SetActive(true)
    LuaVector3.Better_Set(tempVector3, -129, -300, 0)
    self.strengthOneBtn.transform.localPosition = tempVector3
    self.StrengthAllBtn:SetActive(false)
  else
    self.levelReachMax = false
    self.labnextLevelTitle.enabled = true
    self.labNextLevelValue.enabled = true
    self.labNextAttributeTitle.enabled = true
    self.labNextAttributeValue.enabled = true
    self.goMaxLevel:SetActive(false)
    local iUpgradeAttrValue = 0
    local nextLv = currentLv + 1
    self.upgradeLevel = nextLv
    attrDetail = ItemFun.calcStrengthAttr(siteData.site, nextLv)
    for k, v in pairs(attrDetail) do
      attrID = k
      iUpgradeAttrValue = v
      break
    end
    self.labNextLevelValue.text = nextLv
    strAttributeName = Table_RoleData[attrID].PropName
    self.labNextAttributeTitle.text = strAttributeName .. separator
    self.labNextAttributeValue.text = iUpgradeAttrValue
  end
  self.labEquipName.text = siteData:GetName()
  if levelIsReachMax then
    self.goCost:SetActive(false)
    self.goAllCost:SetActive(false)
    self.costTip.gameObject:SetActive(false)
  else
    self.goCost:SetActive(true)
    self.goAllCost:SetActive(true)
    self.costTip.gameObject:SetActive(true)
  end
end

function MiyinStrengthen:CalcMaxUpgradeLv(currentlv, maxlv)
  local zenyenough, miyinenough, needmiyin, needzeny, need = true, true, 0, 0
  local updatelevel = currentlv
  local myROB, myMiyin = MyselfProxy.Instance:GetROB(), BagProxy.Instance:GetItemNumByStaticID(5030), BagProxy.Instance:GetItemNumByStaticID(5030)
  while true do
    updatelevel = updatelevel + 1
    zenyenough, need = self:CheckCost(updatelevel)
    need = need or 0
    need = math.floor(need)
    if zenyenough then
      needzeny = needzeny + need
    end
    miyinenough, need = self:CheckCost_Miyin(updatelevel)
    need = need or 0
    need = math.floor(need)
    if miyinenough then
      needmiyin = needmiyin + need
    end
    if not (zenyenough and miyinenough) or maxlv < updatelevel or myMiyin < needmiyin or myROB < needzeny then
      break
    end
  end
  if needzeny ~= 0 and needmiyin ~= 0 then
    local _, lastneed1 = self:CheckCost(updatelevel)
    local _, lastneed2 = self:CheckCost_Miyin(updatelevel)
    return updatelevel - 1 - currentlv, needzeny - lastneed1, needmiyin - lastneed2
  else
    return 0
  end
end

function MiyinStrengthen:OnButtonStrengthOnceClick(count)
  if self.buildingIsPlayingStrengthenAnim then
    return
  end
  local site = self.site
  if site == nil then
    MsgManager.ShowMsgByIDTable(216)
    return
  end
  if self.levelReachMax then
    MsgManager.ShowMsgByIDTable(210)
    return
  end
  local curlv = self.siteData.lv
  if count then
    self:CallEquipStrength(site, curlv + count)
    return
  end
  local enough, need = self:CheckCost()
  if not enough then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  local enough, need = self:CheckCost_Miyin()
  if not enough then
    local needItemsList = ReusableTable.CreateArray()
    local needItem = ReusableTable.CreateTable()
    needItem.id = 5030
    needItem.count = need
    TableUtility.ArrayPushBack(needItemsList, needItem)
    QuickBuyProxy.Instance:TryOpenView(needItemsList)
    ReusableTable.DestroyArray(needItemsList)
    return
  end
  self:CallEquipStrength(site, curlv + 1)
end

function MiyinStrengthen:CallEquipStrength(site, count)
  _StrengthenProxy:DoStrenghten(site, count)
  self.buildingIsPlayingStrengthenAnim = true
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.EquipRefine.delay_time, function(owner, deltaTime)
    self.buildingIsPlayingStrengthenAnim = false
  end, self)
end

function MiyinStrengthen:CheckCost(updatelevel)
  updatelevel = updatelevel or self.upgradeLevel
  local siteData = self.siteData
  if siteData ~= nil then
    return CostUtil.CheckMiyinStrengthCost_Zeny(siteData.site, updatelevel)
  end
  return false, 0, 0
end

function MiyinStrengthen:CheckCost_Miyin(updatelevel)
  updatelevel = updatelevel or self.upgradeLevel
  local siteData = self.siteData
  if siteData ~= nil then
    return CostUtil.CheckMiyinStrengthCost_Miyin(siteData.site, updatelevel)
  end
  return false, 0, 0
end

function MiyinStrengthen:UpdateCost()
  local siteData = self.siteData
  if not siteData then
    return
  end
  if self.levelReachMax then
    return
  end
  local enough, need = self:CheckCost()
  need = need or 0
  need = math.floor(need)
  self.labCost.text = need
  if enough then
    self.labCost.color = ColorUtil.NGUIWhite
  else
    self.labCost.color = Color(1, 0, 0, 1)
  end
  enough, need = self:CheckCost_Miyin()
  need = need or 0
  need = math.floor(need)
  self.labMiyinCost.text = need
  if enough then
    self.labMiyinCost.color = ColorUtil.NGUIWhite
  else
    self.labMiyinCost.color = Color(1, 0, 0, 1)
  end
  local levelMax = _StrengthenProxy:MaxStrengthLevel(_TYPE)
  local currentLv = siteData.lv
  local maxupgradelv, costzeny, costmiyin = self:CalcMaxUpgradeLv(currentLv, levelMax)
  if maxupgradelv <= 1 then
    self.goAllCost:SetActive(false)
    self.StrengthAllBtn:SetActive(false)
    LuaVector3.Better_Set(tempVector3, -129, -300, 0)
    self.strengthOneBtn.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, -132, -206, 0)
    self.goCost.transform.localPosition = tempVector3
  else
    LuaVector3.Better_Set(tempVector3, 10, -300, 0)
    self.strengthOneBtn.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 10, -206, 0)
    self.goCost.transform.localPosition = tempVector3
    self.goAllCost:SetActive(true)
    self.StrengthAllBtn:SetActive(true)
    self.labAllCost.text = costzeny
    self.labMiyinAllCost.text = costmiyin
    self.maxupgradelv = maxupgradelv
    self.StrengthAllNum.text = string.format(ZhString.MiYinEquipStrength_Mulity, maxupgradelv)
  end
end

function MiyinStrengthen.Upgrade_successEffectHandle(effectHandle, owner)
  NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end

function MiyinStrengthen:Show()
  if not self.init then
    self.init = true
    self:InitUI()
  end
  self:UpdateCost()
  self.gameObject:SetActive(true)
  self.eff = self:PlayUIEffect(EffectMap.UI.MiyinEquipStreng, self.effectContainer, false)
end

function MiyinStrengthen:Hide()
  if self.init then
    self.gameObject:SetActive(false)
    self:DestroyEff()
  end
end

function MiyinStrengthen:DestroyEff()
  if nil == self.eff then
    return
  end
  local oldEffect = self.eff
  self.eff = nil
  if oldEffect:Alive() then
    oldEffect:Destroy()
  end
end

function MiyinStrengthen:Refresh(site)
  if not site then
    return
  end
  self.site = site
  self.siteData = _StrengthenProxy:GetStrengthenData(_TYPE, site)
  if self.siteData then
    self:DoApplyRefresh()
  end
end

function MiyinStrengthen:DoApplyRefresh()
  self:SetNormal()
  self:UpdateInfo()
  self:UpdateCost()
end

function MiyinStrengthen:RefreshSelf()
  if self.site then
    self:Refresh(self.site)
  end
end

function MiyinStrengthen:SetEmpty()
  self.goNow:SetActive(false)
  self.goNext:SetActive(false)
  self.goMaxLevel:SetActive(false)
  self.spUpgradeSymbol.enabled = false
  self.goLevelChangeEmpty:SetActive(true)
  self.labCost.text = ""
  self.labAllCost.text = ""
  self.goItemName:SetActive(false)
  self.goCost:SetActive(false)
  self.goAllCost:SetActive(false)
  self.strengthOneBtn:SetActive(false)
  self.StrengthAllBtn:SetActive(false)
  self.emptyIcon:SetActive(true)
  self.costTip.gameObject:SetActive(false)
end

function MiyinStrengthen:SetNormal()
  self.goNow:SetActive(true)
  self.goNext:SetActive(true)
  self.goMaxLevel:SetActive(true)
  self.spUpgradeSymbol.enabled = true
  self.goLevelChangeEmpty:SetActive(false)
  self.goItemName:SetActive(true)
  self.goCost:SetActive(true)
  self.goAllCost:SetActive(true)
  self.strengthOneBtn:SetActive(true)
  self.emptyIcon:SetActive(false)
end

function MiyinStrengthen:OnReceiveItemUpdate()
  self:UpdateCost()
  self:RefreshSelf()
end

function MiyinStrengthen:OnExit()
  self.super.OnExit(self)
end

function MiyinStrengthen:OnClickForViewItem(go)
  UIViewControllerMiyinStrengthen.instance:LoadView_EquipChooseBoard()
end

function MiyinStrengthen:CaculateDeltaAdditionalAttrValue(lv, upgrade_lv)
  local site = self.site
  if not site then
    return
  end
  local additionalAttrValue
  local additionalAttrs = ItemFun.calcStrengthAttr(site, lv)
  for _, v in pairs(additionalAttrs) do
    additionalAttrValue = v
    break
  end
  local upgradeAdditionalAttrValue
  additionalAttrs = ItemFun.calcStrengthAttr(site, upgrade_lv)
  for _, v in pairs(additionalAttrs) do
    upgradeAdditionalAttrValue = v
    break
  end
  return upgradeAdditionalAttrValue - additionalAttrValue
end
