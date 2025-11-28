local TipOffset = {210, 0}
local SHADOW_EQUIP_MAXINDEX = 6
local FullRefinePos = GameConfig.TwelvePvp.FullRefinePos
local EquipExtractionMinPos, EquipExtraxtionMaxPos, UnlockConfig
local CELL_PREFAB = "cell/RoleEquipItemCell"
autoImport("MyselfEquipItemCell")
ViceEquipPage = class("ViceEquipPage", SubView)

function ViceEquipPage:Init()
  EquipExtractionMinPos = ItemUtil.EquipExtractionMinPos
  EquipExtraxtionMaxPos = ItemUtil.EquipExtraxtionMaxPos
  UnlockConfig = GameConfig.ShadowEquip and GameConfig.ShadowEquip.PosUnlock
  self.chooseSymbol = self:FindGO("EquipChoose")
  self.normalStick = self.container.normalStick
  self:InitCtls()
  self:AddViewInterest()
end

function ViceEquipPage:InitCtls()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if self.roleEquips then
    local cachePro = self.cachePro
    if cachePro ~= nil and cachePro == myPro then
      return
    end
  end
  self.cachePro = myPro
  self:InitEquipCtl()
end

function ViceEquipPage:InitEquipCtl()
  self.equipGrid = self:FindComponent("ViceEquipGrid", UIGrid)
  self.roleEquips = {}
  for _, site in pairs(BagProxy.ViceFoldedEquipConfig) do
    local obj = self:LoadPreferb(CELL_PREFAB, self.equipGrid)
    obj.name = "ViewEquipItemCell" .. site
    self.roleEquips[site] = MyselfEquipItemCell.new(obj, site, nil, true)
    self.roleEquips[site]:AddEventListener(MouseEvent.MouseClick, self.OnClickEquip, self)
    self.roleEquips[site]:AddEventListener(MouseEvent.DoubleClick, self.OnDoubleClickEquip, self)
  end
  self.equipGrid:Reposition()
end

function ViceEquipPage:ShowHide(var)
  if var then
    self:Show(self.equipGrid)
  else
    self:Hide(self.equipGrid)
  end
end

function ViceEquipPage:OnEnter()
  ViceEquipPage.super.OnEnter(self)
  ServiceNUserProxy.Instance:CallExtractionQueryUserCmd()
  self:UpdateEquip()
end

function ViceEquipPage:OnClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if cellCtl and self.chooseEquip ~= cellCtl then
    self:SetChoose(cellCtl)
    local data = cellCtl.data
    if data and data.staticData then
      local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag, cellCtl.isfashion)
      local callback = function()
        self:CancelChoose()
      end
      local show = false
      for i = 1, #FullRefinePos do
        if FullRefinePos[i] == cellCtl.index then
          show = true
        end
      end
      local sdata = {
        itemdata = data,
        funcConfig = funcs,
        ignoreBounds = {
          cellCtl.gameObject
        },
        callback = callback,
        showButton = "equip"
      }
      local itemTip = self:ShowItemTip(sdata, self.normalStick, nil, TipOffset)
      if not cellCtl:IsEffective() then
        itemTip:GetCell(1):SetNoEffectTip(true)
      end
    else
      self:ShowItemTip()
      if cellCtl.viceForbidden then
        MsgManager.ShowMsgByID(43476)
        return
      end
      local menuid = cellCtl.siteMenu
      if menuid and not FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
        local msgId = Table_Menu[menuid].sysMsg.id or 43325
        MsgManager.ShowMsgByID(msgId)
        return
      end
      if cellCtl.index == SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1 then
        self:sendNotification(PackageEvent.ShowBord, {
          bordKey = "PersonalArtifact",
          side = NGUIUtil.AnchorSide.Right,
          tab = 2
        })
      elseif cellCtl.index == ItemUtil.EquipExtractionOffense then
        self:sendNotification(PackageEvent.ShowBord, {
          bordKey = "Extraction",
          side = NGUIUtil.AnchorSide.Right,
          tab = 2
        })
      elseif cellCtl.index == ItemUtil.EquipExtractionDefense then
        self:sendNotification(PackageEvent.ShowBord, {
          bordKey = "Extraction",
          side = NGUIUtil.AnchorSide.Right,
          tab = 3
        })
      end
    end
  else
    self:CancelChoose()
  end
end

function ViceEquipPage:SetChoose(cellCtl)
  self:SetChoosenSite()
  if cellCtl then
    local index = cellCtl.index
    if type(index) == "number" then
      BagProxy.Instance:SetToEquipPos(ItemUtil.GetEposByIndex(index))
    else
      BagProxy.Instance:SetToEquipPos()
    end
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseEquip = cellCtl
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    BagProxy.Instance:SetToEquipPos()
    self.chooseEquip = nil
  end
end

function ViceEquipPage:SetChoosenSite(cellCtl)
  if cellCtl then
    local index = cellCtl.index
    local go = cellCtl.gameObject
    if go then
      self.chooseSymbol:SetActive(true)
      self.chooseSymbol.transform:SetParent(go.transform, false)
    else
      self.chooseSymbol:SetActive(false)
      self.chooseSymbol.transform:SetParent(go.transform, false)
      self.chooseSymbol.transform:SetParent(self.trans, false)
    end
    self.chooseSite = index
  else
    self.chooseSymbol:SetActive(false)
    self.chooseSymbol.transform:SetParent(self.trans, false)
    self.chooseSite = nil
  end
end

function ViceEquipPage:OnDoubleClickEquip(cellCtl)
  if self.container.markingFavoriteMode then
    return
  end
  local packageView = self.container
  if packageView.equipStrengthenIsShow then
    return
  end
  local data = cellCtl.data
  local index = cellCtl.index
  if type(index) == "number" then
    BagProxy.Instance:SetToEquipPos(ItemUtil.GetEposByIndex(index))
  end
  if data and data.staticData then
    local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag)
    if funcs then
      for _, funcid in ipairs(funcs) do
        local config = GameConfig.ItemFunction[funcid]
        if config and FunctionItemFunc.Me():CheckFuncState(config.type, data) == ItemFuncState.Active then
          local tipfunc = FunctionItemFunc.Me():GetFuncById(funcid)
          if type(tipfunc) == "function" then
            tipfunc(data)
            break
          end
        end
      end
    end
  end
  self:SetChoose()
  TipManager.Instance:CloseItemTip()
  BagProxy.Instance:SetToEquipPos()
end

function ViceEquipPage:_updateShadowEquip()
  local shadow_equipdata = BagProxy.Instance.shadowBagData.siteMap
  for i = 1, SHADOW_EQUIP_MAXINDEX do
    local equipCell = self.roleEquips[i]
    if equipCell then
      equipCell:SetData(shadow_equipdata[i])
    end
  end
end

function ViceEquipPage:_updateExtractionEquip()
  local proxy = AttrExtractionProxy.Instance
  for site = EquipExtractionMinPos, EquipExtraxtionMaxPos do
    local cell = self.roleEquips[site]
    if cell then
      local data = proxy:GetActiveItemDataByEquipPos(site)
      cell:SetData(data)
    end
  end
end

function ViceEquipPage:_updateArtifact()
  local equipDataMap = BagProxy.Instance.roleEquip.siteMap
  for site, _ in pairs(BagProxy.ActifactSite) do
    local cell = self.roleEquips[site]
    if cell then
      cell:SetData(equipDataMap[site])
    end
  end
end

function ViceEquipPage:UpdateEquip()
  if StrengthProxy.Instance:IsPackageStrengthenShow() then
    return
  end
  self:_updateShadowEquip()
  self:_updateArtifact()
  self:_updateExtractionEquip()
end

function ViceEquipPage:AddViewInterest()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateEquip)
  self:AddListenEvt(ServiceEvent.ItemEquipPosDataUpdate, self.UpdateEquip)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateEquip)
  self:AddListenEvt(ItemEvent.Equip, self.CancelChoose)
  self:AddListenEvt(ServiceEvent.NUserExtractionQueryUserCmd, self._updateExtractionEquip)
  self:AddListenEvt(ServiceEvent.NUserExtractionOperateUserCmd, self._updateExtractionEquip)
  self:AddListenEvt(ServiceEvent.NUserExtractionActiveUserCmd, self._updateExtractionEquip)
  self:AddListenEvt(ServiceEvent.NUserExtractionRemoveUserCmd, self._updateExtractionEquip)
end

function ViceEquipPage:CancelChoose()
  self.chooseSymbol:SetActive(false)
  self.chooseSymbol.transform:SetParent(self.trans, false)
  self:ShowItemTip()
  self:SetChoose()
end

function ViceEquipPage:ClearEquipEffectCountdown()
  local _FunctionCDCommand = FunctionCDCommand.Me()
  local cdCtrl = _FunctionCDCommand:GetCDProxy(EquippedEffectCDRefresher)
  if cdCtrl ~= nil then
    cdCtrl:RemoveAll()
    _FunctionCDCommand:TryDestroy(EquippedEffectCDRefresher)
  end
end

function ViceEquipPage:OnExit()
  self:CancelChoose()
  self:ClearEquipEffectCountdown()
  ViceEquipPage.super.OnExit(self)
end
