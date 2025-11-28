local _endlessLayer = {
  Factor = 10,
  Min = 10,
  Senior = 70,
  Max = 100
}
local _GrayUIWidget = ColorUtil.GrayUIWidget
local _WhiteUIWidget = ColorUtil.WhiteUIWidget
local launchConfig = GameConfig.EndlessTower.Launch
PveViewEndlessPopUp = class("PveViewEndlessPopUp", ContainerView)
PveViewEndlessPopUp.ViewType = UIViewType.PopUpLayer

function PveViewEndlessPopUp:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:AddEvt()
  self:InitView()
end

function PveViewEndlessPopUp:FindObjs()
  self.endlessLaunchLab = self:FindComponent("Name", UILabel, self.endlessLaunchPanel)
  self.endlessLaunchLab.text = ZhString.Pve_Launch
  self.endlessLaunchTitleLab = self:FindComponent("Title", UILabel, self.endlessLaunchPanel)
  self.endlessLaunchTitleLab.text = ZhString.Pve_Launch_Title
  self.endlessLaunchTipLab = self:FindComponent("Tip", UILabel, self.endlessLaunchPanel)
  self.endlessLaunchConditionLab = self:FindComponent("Condition", UILabel, self.endlessLaunchPanel)
  self.endlessLaunchConditionLab.text = ZhString.Pve_Launch_Condition
  self.cancelLaunchBtn = self:FindGO("CancelLaunchBtn", self.endlessLaunchPanel)
  self.cancelLaunchBtnLab = self:FindComponent("Label", UILabel, self.cancelLaunchBtn)
  self.cancelLaunchBtnLab.text = ZhString.UniqueConfirmView_CanCel
  self.confirmLaunchBtn = self:FindComponent("ConfirmLaunchBtn", UISprite, self.endlessLaunchPanel)
  self.confirmLaunchColider = self.confirmLaunchBtn.gameObject:GetComponent(BoxCollider)
  self.confirmLaunchLab = self:FindComponent("Label", UILabel, self.confirmLaunchBtn.gameObject)
  self.confirmLaunchLab.text = ZhString.UniqueConfirmView_Confirm
  self.costIcon = self:FindComponent("CostIcon", UISprite)
  self.costLab = self:FindComponent("CostLab", UILabel)
  self.endlessPlusBtn = self:FindComponent("Plus", UISprite, self.endlessLaunchPanel)
  self.endlessPlusBtnSp = self:FindComponent("Sprite", UISprite, self.endlessPlusBtn.gameObject)
  self.endlessMinusBtn = self:FindComponent("Minus", UISprite, self.endlessLaunchPanel)
  self.endlessMinusBtnSp = self:FindComponent("Sprite", UISprite, self.endlessMinusBtn.gameObject)
  self.endlessLayerLab = self:FindComponent("LayerLab", UILabel, self.endlessLaunchPanel)
end

function PveViewEndlessPopUp:AddUIEvts()
  self:AddClickEvent(self.cancelLaunchBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.confirmLaunchBtn.gameObject, function()
    if self.lackCost then
      MsgManager.ShowMsgByID(8)
      return
    end
    if self.endlessLaunchLayer == _endlessLayer.Max then
      if BranchMgr.IsJapan() then
        OverseaHostHelper:GachaUseComfirm(self.launchCostNum, function()
          ServiceInfiniteTowerProxy.Instance:CallTowerLaunchCmd(self.endlessLaunchLayer)
        end)
      else
        MsgManager.ConfirmMsgByID(43431, function()
          ServiceInfiniteTowerProxy.Instance:CallTowerLaunchCmd(self.endlessLaunchLayer)
        end, nil, nil, tostring(self.launchCostNum))
      end
    else
      ServiceInfiniteTowerProxy.Instance:CallTowerLaunchCmd(self.endlessLaunchLayer)
    end
  end)
  self:AddClickEvent(self.endlessPlusBtn.gameObject, function()
    self:OnEndlessLayerChange(true)
  end)
  self:AddClickEvent(self.endlessMinusBtn.gameObject, function()
    self:OnEndlessLayerChange(false)
  end)
end

function PveViewEndlessPopUp:OnEndlessLayerChange(forward)
  if forward then
    if self.endlessLaunchLayer >= _endlessLayer.Max then
      return
    end
    if self.endlessLaunchLayer == _endlessLayer.Senior then
      self.endlessLaunchLayer = _endlessLayer.Max
    else
      self.endlessLaunchLayer = self.endlessLaunchLayer + _endlessLayer.Factor
    end
  else
    if self.endlessLaunchLayer <= _endlessLayer.Min then
      return
    end
    if self.endlessLaunchLayer == _endlessLayer.Max then
      self.endlessLaunchLayer = _endlessLayer.Senior
    else
      self.endlessLaunchLayer = self.endlessLaunchLayer - _endlessLayer.Factor
    end
  end
  self:UpdateLayer()
end

function PveViewEndlessPopUp:UpdateLayer()
  self.endlessLayerLab.text = tostring(self.endlessLaunchLayer)
  self.endlessLaunchTipLab.text = string.format(ZhString.Pve_Launch_Tip, self.endlessLaunchLayer)
  if self.endlessLaunchLayer == _endlessLayer.Max then
    _GrayUIWidget(self.endlessPlusBtn)
    _GrayUIWidget(self.endlessPlusBtnSp)
  else
    _WhiteUIWidget(self.endlessPlusBtn)
    _WhiteUIWidget(self.endlessPlusBtnSp)
  end
  if self.endlessLaunchLayer == _endlessLayer.Min then
    _GrayUIWidget(self.endlessMinusBtn)
    _GrayUIWidget(self.endlessMinusBtnSp)
  else
    _WhiteUIWidget(self.endlessMinusBtn)
    _WhiteUIWidget(self.endlessMinusBtnSp)
  end
  if self.endlessLaunchLayer > self.myMaxLaunchLayer then
    self:Show(self.endlessLaunchConditionLab)
    self.confirmLaunchColider.enabled = false
    self.confirmLaunchBtn.spriteName = "com_btn_13"
    self.confirmLaunchLab.effectStyle = UILabel.Effect.None
  else
    self:Hide(self.endlessLaunchConditionLab)
    self.confirmLaunchColider.enabled = true
    self.confirmLaunchBtn.spriteName = "com_btn_3"
    self.confirmLaunchLab.effectStyle = UILabel.Effect.Outline
  end
  self:UpdateCost()
  IconManager:SetItemIcon(Table_Item[self.launchCostId].Icon, self.costIcon)
  self.costLab.text = tostring(self.launchCostNum)
  self.lackCost = self.launchCostNum > BagProxy.Instance:GetItemNumByStaticID(self.launchCostId, GameConfig.PackageMaterialCheck.default)
  self.costLab.color = self.lackCost and ColorUtil.Red or Color(0, 0, 0, 1)
end

function PveViewEndlessPopUp:UpdateCost()
  self.maxLaunchLayerIndex = nil
  if self.endlessLaunchLayer > launchConfig[#launchConfig].max then
    local config = GameConfig.EndlessTower.LaunchTopCost
    if config then
      self.launchCostId, self.launchCostNum = config[1], config[2]
    end
  else
    for i = #launchConfig, 1, -1 do
      if self.endlessLaunchLayer >= launchConfig[i].min and self.endlessLaunchLayer <= launchConfig[i].max then
        self.maxLaunchLayerIndex = i
        break
      end
    end
    if nil ~= self.maxLaunchLayerIndex then
      local config, minLayer, maxLayer, costid, costNum
      local costMap = {}
      for i = self.maxLaunchLayerIndex, 1, -1 do
        config = GameConfig.EndlessTower.Launch[i]
        minLayer = config.min
        maxLayer = config.max
        costid = config.cost[1]
        costNum = config.cost[2]
        if not costMap[costid] then
          costMap[costid] = 0
        end
        local allPass = true
        local layerInfo
        for j = minLayer, maxLayer do
          layerInfo = EndlessTowerProxy.Instance:GetMyLayersInfo(j)
          if not layerInfo or not layerInfo.rewarded then
            allPass = false
            break
          end
        end
        if not allPass then
          costMap[costid] = costMap[costid] + costNum
        end
      end
      self.launchCostId, self.launchCostNum = next(costMap)
    end
  end
end

function PveViewEndlessPopUp:InitView()
  self.myMaxLaunchLayer = EndlessTowerProxy.Instance:GetMaxLaunchLayer()
  if self.myMaxLaunchLayer <= 10 then
    self.endlessLaunchLayer = 10
  else
    for i = #launchConfig, 1, -1 do
      if self.myMaxLaunchLayer >= launchConfig[i].min and self.myMaxLaunchLayer <= launchConfig[i].max then
        self.endlessLaunchLayer = launchConfig[i - 1].max
        break
      end
    end
    if nil == self.endlessLaunchLayer then
      self.endlessLaunchLayer = launchConfig[#launchConfig].max
    end
  end
  self:UpdateLayer()
end

function PveViewEndlessPopUp:AddEvt()
  self:AddListenEvt(ServiceEvent.InfiniteTowerTowerLaunchCmd, self.HandleLaunch)
end

function PveViewEndlessPopUp:HandleLaunch(note)
  if note.body.success then
    self:CloseSelf()
  end
end
