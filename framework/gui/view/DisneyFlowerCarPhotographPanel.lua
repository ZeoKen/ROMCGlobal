autoImport("DisneyFlowerCarInteractCDCell")
autoImport("PhotographPanel")
DisneyFlowerCarPhotographPanel = class("DisneyFlowerCarPhotographPanel", PhotographPanel)
DisneyFlowerCarPhotographPanel.ViewType = UIViewType.FocusLayer

function DisneyFlowerCarPhotographPanel:initView()
  DisneyFlowerCarPhotographPanel.super.initView(self)
  local actionBtnGroup = self:FindChild("FlowerCarActionBtnGroup")
  actionBtnGroup:SetActive(true)
  self.action1Button = self:FindChild("Action1Btn", actionBtnGroup)
  local action1Icon = self:FindComponent("Sprite", UISprite, self.action1Button)
  self.action2Button = self:FindChild("Action2Btn", actionBtnGroup)
  local action2Icon = self:FindComponent("Sprite", UISprite, self.action2Button)
  self.action3Button = self:FindChild("Action3Btn", actionBtnGroup)
  local action3Icon = self:FindComponent("Sprite", UISprite, self.action3Button)
  self.actionBtns = {
    self:FindChild("Action1Btn", actionBtnGroup),
    self:FindChild("Action2Btn", actionBtnGroup),
    self:FindChild("Action3Btn", actionBtnGroup)
  }
  self.flowerCarGetOffButton = self:FindChild("FlowerCarGetOffButton")
  self.servantEmojiButton:SetActive(false)
  self.flowerCarGetOffButton:SetActive(true)
  self:AddClickEvent(self.flowerCarGetOffButton, function(go)
    self:GetOffFlowerCar()
  end)
  self:AddListenEvt(InteractNpcEvent.FlowerCarPhotographActionCDUpdate, self.RefreshActionCD)
end

function DisneyFlowerCarPhotographPanel:initData()
  DisneyFlowerCarPhotographPanel.super.initData(self)
  self.interactid = self.viewdata.viewdata.interactid
  self:BindInteractButtons()
  self.disableRotateMyself = true
  self.tabForbid = {1, 3}
end

function DisneyFlowerCarPhotographPanel:OnExit()
  self:ClearActionCDCtrl()
  self.interactCDCell = nil
  DisneyFlowerCarPhotographPanel.super.OnExit(self, self.super)
end

function DisneyFlowerCarPhotographPanel:BindInteractButtons()
  local interactions = {}
  self.interactCDCell = {}
  for k, v in pairs(GameConfig.Interact.InteractAction) do
    if v.interactid == self.interactid then
      table.insert(interactions, k)
    end
  end
  for i = 1, #self.actionBtns do
    if i > #interactions then
      self.actionBtns[i]:SetActive(false)
    else
      self.actionBtns[i]:SetActive(true)
      table.insert(self.interactCDCell, DisneyFlowerCarInteractCDCell.new(self.actionBtns[i], interactions[i], GameConfig.Interact.InteractAction[interactions[i]]))
    end
  end
end

function DisneyFlowerCarPhotographPanel:GetOffFlowerCar()
  Game.InteractNpcManager:MyselfManualGetOff()
end

function DisneyFlowerCarPhotographPanel:RefreshActionCD()
  for i = 1, #self.interactCDCell do
    self.interactCDCell[i]:TryStartCd()
  end
end

function DisneyFlowerCarPhotographPanel:ClearActionCDCtrl()
  for i = 1, #self.interactCDCell do
    self.interactCDCell[i]:CDCtrl_End()
  end
end
