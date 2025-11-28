autoImport("EquipChooseBord")
autoImport("EquipRecoverCell")
EquipRecoverView = class("EquipRecoverView", BaseView)
EquipRecoverView.BrotherView = EquipRecoverCombinedView
EquipRecoverView.ViewType = UIViewType.NormalLayer

function EquipRecoverView:OnEnter()
  EquipRecoverView.super.OnEnter(self)
  if self.npcdata then
    local npcRootTrans = self.npcdata.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
end

function EquipRecoverView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipRecoverView:OnExit()
  self:CameraReset()
  EquipRecoverView.super.OnExit(self)
end

function EquipRecoverView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function EquipRecoverView:FindObjs()
  self.addItemButton = self:FindGO("AddItemButton")
  self.left = self:FindGO("LeftBg")
  self.targetBtn = self:FindGO("TargetCell")
  self.totalCost = self:FindGO("TotalCost"):GetComponent(UILabel)
  local sprite = self:FindComponent("Sprite", UISprite, self.totalCost.gameObject)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, sprite)
  self.materialPart = self:FindGO("MaterialsPart")
  local ePath = ResourcePathHelper.UIEffect("55EquipStreng_UI_3")
  ePath = ResourcePathHelper.Effect(ePath)
  local go = self:LoadPreferb_ByFullPath(ePath, self:FindGO("RightBg"))
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 163, 0)
  self.effContainer = self:FindGO("EffectContainer") or self:FindGO("RightBg")
  local helpBtn = self:FindGO("HelpBtn")
  if helpBtn then
    self:RegistShowGeneralHelpByHelpID(682, helpBtn)
  end
end

local cardids = {}

function EquipRecoverView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  local recoverButton = self:FindGO("RecoverButton")
  self:AddClickEvent(recoverButton, function()
    if self.clickTimeStamp and self.clickTimeStamp + 1 > ServerTime.CurServerTime() / 1000 then
      return
    end
    if self.nowdata then
      if MyselfProxy.Instance:GetROB() < tonumber(self.totalCost.text) then
        MsgManager.ShowMsgByID(1)
        return
      end
      local cells = self.recoverCtl:GetCells()
      local enchant = false
      local upgrade = false
      local quench = false
      local refine = false
      local equipMemory = false
      TableUtility.ArrayClear(cardids)
      if 0 < #cells then
        for i = 1, #cells do
          if cells[i].type == EquipRecoverProxy.RecoverType.Card and cells[i].toggle.value then
            TableUtility.ArrayPushBack(cardids, cells[i].data.id)
          end
          if cells[i].type == EquipRecoverProxy.RecoverType.Upgrade then
            upgrade = cells[i].toggle.value
          end
          if cells[i].type == EquipRecoverProxy.RecoverType.Enchant then
            enchant = cells[i].toggle.value
          end
          if cells[i].type == EquipRecoverProxy.RecoverType.Quench then
            quench = cells[i].toggle.value
          end
          if cells[i].type == EquipRecoverProxy.RecoverType.Refine then
            refine = cells[i].toggle.value
          end
          if cells[i].type == EquipRecoverProxy.RecoverType.EquipMemory then
            equipMemory = cells[i].toggle.value
          end
        end
      end
      local cardCount = #cardids
      local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.MainBag)
      if cardCount > bagData:GetSpaceItemNum() then
        MsgManager.ShowMsgByID(3101)
        return
      end
      if 0 < cardCount or enchant or upgrade or quench or refine or equipMemory then
        do
          local callFunc = function()
            local showRefineConfirm = false
            local refinelv = self.nowdata and self.nowdata.equipInfo and self.nowdata.equipInfo.refinelv
            if refine and refinelv and refinelv > GameConfig.Item.material_max_refine then
              showRefineConfirm = true
            end
            local quenchConfirmFunc = function()
              if quench then
                local curProcess = self.nowdata:GetQuenchPer() or 0
                local sites = self.nowdata.equipInfo.site
                local config = GameConfig.ShadowEquip.Upgrade
                local posCostConfig = config and config[sites[1]]
                if not posCostConfig then
                  redlog("缺少Upgrade pos配置", sites[1])
                  return
                end
                local returnRate
                local items = {}
                for k, costs in pairs(posCostConfig) do
                  if k <= curProcess then
                    local materials = costs.Material
                    local returnPer = costs.ReturnPer or 50
                    returnRate = returnRate or returnPer
                    for i = 1, #materials do
                      if not items[materials[i][1]] then
                        items[materials[i][1]] = math.ceil(materials[i][2] * returnPer / 100)
                      else
                        items[materials[i][1]] = items[materials[i][1]] + math.ceil(materials[i][2] * returnPer / 100)
                      end
                    end
                  end
                end
                local result = {}
                for itemid, num in pairs(items) do
                  if itemid ~= 100 then
                    local itemData = ItemData.new("Return", itemid)
                    itemData.num = num
                    table.insert(result, itemData)
                  end
                end
                local confirmStr = string.format(ZhString.EquipQuench_ConfirmTip, returnRate .. "%")
                UIUtil.PopUpItemConfirmYesNoView("", confirmStr, result, function()
                  self.clickTimeStamp = ServerTime.CurServerTime() / 1000
                  self:PlayRecoverEffect()
                  TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
                    ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.nowdata.id, false, cardids, enchant, upgrade, false, nil, true, refine, equipMemory)
                  end, self, 1)
                end, nil, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
              else
                self.clickTimeStamp = ServerTime.CurServerTime() / 1000
                self:PlayRecoverEffect()
                TimeTickManager.Me():CreateOnceDelayTick(800, function(owner, deltaTime)
                  ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.nowdata.id, false, cardids, enchant, upgrade, false, nil, false, refine, equipMemory)
                end, self, 1)
              end
            end
            if showRefineConfirm then
              local sysmsgData = Table_Sysmsg[401]
              local text = sysmsgData and sysmsgData.Text
              local str = string.format(text, refinelv)
              UIUtil.PopUpConfirmYesNoView(sysmsgData.Title, str, function()
                quenchConfirmFunc()
              end, nil, nil, sysmsgData.button, sysmsgData.buttonF)
            else
              quenchConfirmFunc()
            end
          end
          if enchant or quench or refine then
            FunctionSecurity.Me():NormalOperation(function()
              callFunc()
            end)
          else
            callFunc()
          end
        end
      end
    end
  end)
end

function EquipRecoverView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ItemRestoreEquipItemCmd, self.HandleRecover)
end

function EquipRecoverView:InitView()
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord.new(chooseContaienr, function()
    return EquipRecoverProxy.Instance:GetRecoverEquips()
  end)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.targetCell = BaseItemCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local recoverGrid = self:FindComponent("RecoverGrid", UITable)
  self.recoverCtl = UIGridListCtrl.new(recoverGrid, EquipRecoverCell, "EquipRecoverCell")
  self.recoverCtl:AddEventListener(EquipRecoverEvent.Select, self.HandleSelect, self)
end

function EquipRecoverView:ChooseItem(itemData)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  self.recoverCtl:ResetDatas(EquipRecoverProxy.Instance:GetRecoverToggle(itemData))
  self.chooseBord:Hide()
  self.targetBtn:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
  self.materialPart:SetActive(itemData ~= nil)
end

function EquipRecoverView:ClickTargetCell()
  if self.clickTimeStamp and self.clickTimeStamp + 1 > ServerTime.CurServerTime() / 1000 then
    return
  end
  local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
  if 0 < #equipdatas then
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:Show(false)
    self.left:SetActive(false)
  else
    MsgManager.ShowMsgByIDTable(390)
    self.chooseBord:Hide()
    self.left:SetActive(true)
  end
end

function EquipRecoverView:HandleSelect(cellctl)
  local totalCost = 0
  local cells = self.recoverCtl:GetCells()
  for i = 1, #cells do
    if cells[i].toggle.value then
      totalCost = totalCost + tonumber(cells[i].cost.text)
    end
  end
  self.totalCost.text = totalCost
end

function EquipRecoverView:HandleRecover()
  local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
  self.chooseBord:ResetDatas(equipdatas, true)
  self:ChooseItem()
  self.left:SetActive(true)
  MsgManager.ShowMsgByID(408)
end

function EquipRecoverView:PlayRecoverEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess_Old, self.effContainer, true)
  self:PlayUISound(AudioMap.UI.EnchantSuc)
end
