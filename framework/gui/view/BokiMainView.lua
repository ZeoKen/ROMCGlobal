autoImport("BokiView")
autoImport("BokiSkillPage")
BokiMainView = class("BokiMainView", ContainerView)
BokiMainView.ViewType = UIViewType.NormalLayer
local _costCfg

function BokiMainView:Init()
  _costCfg = GameConfig.BoKiConfig and GameConfig.BoKiConfig.BoKiMoneyCost
  self:FindObjs()
  self:InitView()
  self:AddEvt()
end

function BokiMainView:FindObjs()
  self.tabRoot = self:FindGO("TabRoot")
end

function BokiMainView:InitView()
  self:InitCost()
  self:UpdateCoins()
  self.tabRoot = self:FindGO("TabRoot")
  self.bokiTab = self:FindGO("BokiTab")
  self.skillTab = self:FindGO("SkillTab")
  self.bokiObj = self:FindGO("BokiViewRoot")
  self.skillObj = self:FindGO("SkillViewRoot")
  self.bokiView = self:AddSubView("BokiView", BokiView)
  self.skillView = self:AddSubView("BokiSkillPage", BokiSkillPage)
  self:AddTabChangeEvent(self.bokiTab, self.bokiObj, PanelConfig.BokiView)
  self:AddTabChangeEvent(self.skillTab, self.skillObj, PanelConfig.BokiSkillPage)
end

function BokiMainView:OnEnter()
  BokiMainView.super.OnEnter(self)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    local menuid = GameConfig.BoKiConfig.menuid
    local unlock = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
    if nil ~= menuid and unlock then
      self:TabChangeHandler(PanelConfig.BokiSkillPage.tab)
      self.tabRoot:SetActive(false)
    else
      self:TabChangeHandler(PanelConfig.BokiView.tab)
    end
  end
end

function BokiMainView:TabChangeHandler(key)
  if not BokiMainView.super.TabChangeHandler(self, key) then
    return
  end
  if key == PanelConfig.BokiSkillPage.tab then
    self.skillView:Switch()
  end
end

local iconName

function BokiMainView:InitCost()
  if not _costCfg then
    redlog("波姬GameConfig BoKiMoneyCost未配置")
    return
  end
  local root = self:FindGO("MoneyRoot")
  self.money = {}
  for i = 1, #_costCfg do
    local tab = {}
    tab.Id = _costCfg[i]
    tab.Icon = self:FindComponent("Money" .. i, UISprite, root)
    tab.Icon.gameObject:SetActive(true)
    tab.Num = self:FindComponent("Lab", UILabel, tab.Icon.gameObject)
    iconName = Table_Item[tab.Id] and Table_Item[tab.Id].Icon or ""
    IconManager:SetItemIcon(iconName, tab.Icon)
    self.money[i] = tab
  end
end

function BokiMainView:UpdateCoins()
  for i = 1, #self.money do
    local cell = self.money[i]
    cell.Num.text = BagProxy.Instance:GetItemNumByStaticID(cell.Id, BokiProxy.Instance.checkPackage)
  end
  if self.bokiView then
    self.bokiView:UpdateCost()
    self.bokiView:UpdateEquip()
  end
  self:HandleSkillUpdate()
end

function BokiMainView:AddEvt()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiDataUpdatePetCmd, self.HandleUpdateBoKiData)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiEquipUpdatePetCmd, self.HandleUpdateBoKiEquip)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiSkillUpdatePetCmd, self.HandleSkillUpdate)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiSkillInUseUpdatePetCmd, self.HandleUpdateBoKiSkillInUse)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleBokiAttrSync)
  self:AddListenEvt(MyselfEvent.RemoveBoki, self.HandleClose)
end

function BokiMainView:HandleClose()
  self:CloseSelf()
end

function BokiMainView:HandleBokiAttrSync(note)
  if self.bokiView then
    self.bokiView:HandleBokiAttrSync(note)
  end
end

function BokiMainView:HandleUpdateBoKiData()
  if self.bokiView then
    self.bokiView:HandleUpdateBoKiData()
  end
end

function BokiMainView:HandleUpdateBoKiEquip()
  if self.bokiView then
    self.bokiView:HandleUpdateBoKiEquip()
  end
end

function BokiMainView:HandleSkillUpdate()
  if self.skillView then
    self.skillView:HandleSkillUpdate()
  end
end

function BokiMainView:HandleUpdateBoKiSkillInUse()
  if self.skillView then
    self.skillView:HandleUpdateBoKiSkillInUse()
  end
end
