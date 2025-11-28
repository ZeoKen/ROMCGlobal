autoImport("EquipStrengthExtraAttriBord")
autoImport("EquipStrengthenAttrCell")
EquipStrengthen = class("EquipStrengthen", SubView)
EquipStrengthen.PfbPath = "part/EquipStrengthen_New"
local _StrengthenProxy
local _TYPE = SceneItem_pb.ESTRENGTHTYPE_NORMAL
local ViewConfig = {
  pos = {
    Right = {0, 0},
    Mid = {-147, 0}
  },
  color = {
    Color(0.3176470588235294, 0.30980392156862746, 0.4823529411764706, 1),
    Color(1.0, 0.3764705882352941, 0.12941176470588237, 1)
  }
}

function EquipStrengthen:Init()
  _StrengthenProxy = StrengthProxy.Instance
  self:Listen()
end

function EquipStrengthen:InitUI()
  local contaienr = self:FindGO("EquipStrengthen")
  self.gameObject = self:LoadPreferb(EquipStrengthen.PfbPath, contaienr, true)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self.effectContainer = self:FindGO("EffectRoot")
  self:CollectGO()
  self:InitCtl()
  self:AddButtonClickEvent()
end

function EquipStrengthen:InitCtl()
  local attrGrid = self:FindComponent("AttrGrid", UIGrid)
  self.attrList = UIGridListCtrl.new(attrGrid, EquipStrengthenAttrCell, "EquipStrengthenAttrCell")
end

function EquipStrengthen:SetRollBackTab(tab)
  if not self.container.viewdata.viewdata then
    self.container.viewdata.viewdata = {tab = tab}
  else
    self.container.viewdata.viewdata.tab = tab
  end
end

function EquipStrengthen:CollectGO()
  self.chooseSiteIcon = self:FindComponent("ChooseSiteIcon", UISprite)
  self.emptySite = self:FindGO("EmptySite")
  self.goMax = self:FindGO("Max")
  self.labEquipName = self:FindGO("EquipName"):GetComponent(UILabel)
  self.currentEquipRoot = self:FindGO("CurrentEquipName")
  self.goCost = self:FindGO("CostOneDesc")
  self.labCost = self:FindGO("CostOnceLab", self.goCost):GetComponent(UILabel)
  local s_zenyIcon = self:FindComponent("Coin", UISprite, self.goCost)
  IconManager:SetItemIcon(Table_Item[100].Icon, s_zenyIcon)
  self.goCosts = self:FindGO("CostMulityDesc")
  self.labCosts = self:FindGO("CostMulityLab", self.goCosts):GetComponent(UILabel)
  local m_zenyIcon = self:FindComponent("Coin", UISprite, self.goCosts)
  IconManager:SetItemIcon(Table_Item[100].Icon, m_zenyIcon)
  self.strengthMulityBtn = self:FindGO("StrengthMulityBtn")
  self.strengthMulity_Lab = self:FindComponent("StrengthMulity", UILabel, self.strengthMulityBtn)
  self.strengthMulity_Lab.text = ZhString.EquipStrength_StrengthAll
  self.strengthOneBtn = self:FindGO("StrengthOneBtn")
  self.goLevelChangeEmpty = self:FindGO("LevelChangeEmpty")
  self.operationRoot = self:FindGO("OperationRoot")
  self.mulityOperation = self:FindGO("MulityOperation")
  self.onceOperation = self:FindGO("OnceOperation")
  self.attrRoot = self:FindGO("AttrRoot")
  self.leftContent = self:FindGO("LeftContent")
  self.extraAttriButton = self:FindGO("ExtraAttriButton")
  self.extraAttriContainer = self:FindGO("EffectContainer", self.extraAttriButton)
  self.quickEnter = self:FindGO("QuickEnter")
  self.refineButton = self:FindGO("RefineButton")
  self:RegisterGuideTarget(ClientGuide.TargetType.packageview_refinebutton, self.refineButton)
  self:AddClickEvent(self.refineButton, function(go)
    if Game.MapManager:IsRaidMode(true) then
      local isSpecial = false
      local exceptRaid = GameConfig.EquipRefine.RefineRaidMap
      if exceptRaid then
        local raidID = Game.MapManager:GetRaidID()
        if 0 ~= TableUtility.ArrayFindIndex(exceptRaid, raidID) then
          isSpecial = true
        end
      end
      if not isSpecial then
        MsgManager.ShowMsgByIDTable(43193)
        return
      end
    end
    self.setedPush = true
    self:SetRollBackTab(2)
    self.container:SetPushToStack(true)
    FunctionNpcFunc.Refine(nil, nil, nil, true)
  end)
  self.enchantButton = self:FindGO("EnchantButton")
  self:RegisterGuideTarget(ClientGuide.TargetType.packageview_enchantbutton, self.enchantButton)
  self:AddClickEvent(self.enchantButton, function(go)
    if Game.MapManager:IsRaidMode(true) then
      local isSpecial = false
      local exceptRaid = GameConfig.EquipRefine.RefineRaidMap
      if exceptRaid then
        local raidID = Game.MapManager:GetRaidID()
        if 0 ~= TableUtility.ArrayFindIndex(exceptRaid, raidID) then
          isSpecial = true
        end
      end
      if not isSpecial then
        MsgManager.ShowMsgByIDTable(43193)
        return
      end
    end
    self.setedPush = true
    self:SetRollBackTab(2)
    self.container:SetPushToStack(true)
    FunctionNpcFunc.SeniorEnchant(nil, nil, nil, true)
  end)
  self:AddOrRemoveGuideId(self.strengthOneBtn.gameObject, 1004)
end

function EquipStrengthen:AddButtonClickEvent()
  self:AddClickEvent(self.strengthMulityBtn, function(go)
    self:OnButtonStrengthOnceClick(self.strengthMaxLv)
  end)
  self:AddClickEvent(self.strengthOneBtn, function(go)
    self:OnButtonStrengthOnceClick()
  end)
  self:AddClickEvent(self.extraAttriButton, function(go)
    self:ShowExtraAttriBord()
  end)
end

function EquipStrengthen:Listen()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCost)
  self:AddListenEvt(ItemEvent.StrengthLvUpdate, self.HandleStrenghtLvUpdate)
  self:AddListenEvt(ItemEvent.StrengthLvReinit, self.HandleStrenghtLvReinit)
  self:AddListenEvt(ServiceEvent.SceneTipGameTipCmd, self.RefreshExtraAttriRedTip)
end

function EquipStrengthen:UpdateInfo()
  local siteData = self.siteData
  TableUtil.Print(siteData)
  self.labEquipName.text = siteData:GetName()
  local site = siteData.site
  local spname = (site == 5 or site == 6) and "bag_equip_6" or "bag_equip_" .. site
  IconManager:SetUIIcon(spname, self.chooseSiteIcon)
  self.chooseSiteIcon:MakePixelPerfect()
  local isMax = siteData:IsMax()
  self.operationRoot:SetActive(not isMax)
  self.goMax:SetActive(isMax)
  self.attrList:ResetDatas(self.siteData:GetUpgradeInfo(), true)
end

function EquipStrengthen:OnButtonStrengthOnceClick(count)
  count = count or 1
  local siteData = self.siteData
  if not siteData then
    MsgManager.ShowMsgByIDTable(216)
    return
  end
  if siteData:IsMax() then
    MsgManager.ShowMsgByIDTable(210)
    return
  end
  local _, _, maxLv = StrengthProxy.CheckEquipCost(siteData.lv, siteData.site)
  if maxLv < 1 then
    if BranchMgr.IsJapan() then
      return
    end
    MsgManager.ConfirmMsgByID(41326, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
    end)
    return
  end
  _StrengthenProxy:DoStrenghten(siteData.site, count + siteData:GetLv())
  self:sendNotification(HomeEvent.WorkbenchStartWork)
end

function EquipStrengthen:UpdateCost()
  if not self.container.equipStrengthenIsShow then
    return
  end
  local siteData = self.siteData
  if not siteData then
    return
  end
  local oneNeed, maxNeed, maxLv = StrengthProxy.CheckEquipCost(siteData.lv, siteData.site)
  self.strengthMaxLv = maxLv
  self.labCost.text = oneNeed
  local costEnough = 0 < maxLv
  self.labCosts.text = costEnough and maxNeed or oneNeed
  self.labCosts.color = costEnough and ViewConfig.color[1] or ViewConfig.color[2]
  self.labCost.color = costEnough and ViewConfig.color[1] or ViewConfig.color[2]
  local hasMaxLv = self.strengthMaxLv > 0
  local posConfig = hasMaxLv and ViewConfig.pos.Right or ViewConfig.pos.Mid
  self.mulityOperation:SetActive(hasMaxLv)
  self.onceOperation.transform.localPosition = LuaGeometry.GetTempVector3(posConfig[1], posConfig[2])
end

function EquipStrengthen:HandleStrenghtLvUpdate(note)
  if not self.container.equipStrengthenIsShow then
    return
  end
  self:RefreshSelf()
  self:PlayUIEffect(EffectMap.UI.upgrade_success, self.chooseSiteIcon.gameObject, true, EquipStrengthen.Upgrade_successEffectHandle, self)
end

function EquipStrengthen:HandleStrenghtLvReinit()
  if not self.container.equipStrengthenIsShow then
    return
  end
  self:RefreshSelf()
end

function EquipStrengthen.Upgrade_successEffectHandle(effectHandle, owner)
  NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end

function EquipStrengthen:Show()
  if not self.init then
    self.init = true
    self:InitUI()
  end
  self.gameObject:SetActive(true)
  self.eff = self:PlayUIEffect(EffectMap.UI.MiyinEquipStreng, self.effectContainer, false)
  self:RefreshExtraAttriRedTip()
  if self.container.viewdata and self.container.viewdata.viewdata then
    local hideTab = self.container.viewdata.viewdata.hideTab or false
    self.quickEnter:SetActive(not hideTab)
  else
    self.quickEnter:SetActive(true)
  end
end

function EquipStrengthen:Hide()
  if self.init then
    self:HideExtraAttriBord()
    self.gameObject:SetActive(false)
    UIUtil.StopEightTypeMsg()
    self:DestroyEff()
  end
end

function EquipStrengthen:AfterContainerTabChangeHandler()
  if self.container and self.container.viewdata.viewdata and self.container.viewdata.viewdata.params and self.container.viewdata.viewdata.params.OnClickChooseBordCell_index then
    self:Refresh(self.container.viewdata.viewdata.params.OnClickChooseBordCell_index)
    self.container.viewdata.viewdata.params.OnClickChooseBordCell_index = nil
  end
end

function EquipStrengthen:DestroyEff()
  if nil == self.eff then
    return
  end
  local oldEffect = self.eff
  self.eff = nil
  if oldEffect:Alive() then
    oldEffect:Destroy()
  end
end

function EquipStrengthen:Refresh(index)
  self.index = index
  self.siteData = _StrengthenProxy:GetStrengthenData(_TYPE, index)
  if self.siteData then
    self:DoApplyRefresh()
  end
end

function EquipStrengthen:DoApplyRefresh()
  self:SetNormalOrEmpty(true)
  self:UpdateInfo()
  self:UpdateCost()
end

function EquipStrengthen:RefreshSelf()
  if self.index then
    self:Refresh(self.index)
  end
end

function EquipStrengthen:SetNormalOrEmpty(isNormal)
  if not isNormal then
    self.index = nil
  end
  self.currentEquipRoot:SetActive(isNormal)
  self.goMax:SetActive(isNormal)
  self.goLevelChangeEmpty:SetActive(not isNormal)
  self.attrRoot:SetActive(isNormal)
  self.operationRoot:SetActive(isNormal)
  self.chooseSiteIcon.gameObject:SetActive(isNormal)
  self.emptySite:SetActive(not isNormal)
end

function EquipStrengthen:OnEnter()
  self.super.OnEnter(self)
  if self.setedPush then
    self.container:SetPushToStack(nil)
    self.setedPush = nil
  end
end

function EquipStrengthen:OnExit()
  StrengthProxy.Instance:ResetStrengthType(nil)
  self.super.OnExit(self)
end

function EquipStrengthen:RefreshExtraAttriRedTip()
  if self.extraAttriContainer then
    self.extraAttriContainer:SetActive(RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_STRENGTH_ACCUMULATE_REWARD))
  end
end

function EquipStrengthen:ShowExtraAttriBord()
  if not self.extraAttriBord then
    self.extraAttriBord = EquipStrengthExtraAttriBord.CreateInstance(self:FindGO("ExtraAttrriBordContainer"))
    self.extraAttriBord:AddEventListener(EquipStrengthExtraAttriBord.ShowEvent, self.HandleExtraAttriBordShow, self)
    self.extraAttriBord:AddEventListener(EquipStrengthExtraAttriBord.HideEvent, self.HandleExtraAttriBordHide, self)
  end
  self.extraAttriBord:ShowBord()
end

function EquipStrengthen:HandleExtraAttriBordShow()
  self.leftContent:SetActive(false)
  self.effectContainer:SetActive(false)
end

function EquipStrengthen:HandleExtraAttriBordHide()
  self.leftContent:SetActive(true)
  self.effectContainer:SetActive(true)
end

function EquipStrengthen:HideExtraAttriBord()
  if not self.extraAttriBord then
    return
  end
  self.extraAttriBord:HideBord()
end
