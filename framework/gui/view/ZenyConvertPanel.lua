ZenyConvertPanel = class("ZenyConvertPanel", BaseView)
ZenyConvertPanel.ViewType = UIViewType.PopUpLayer

function ZenyConvertPanel:Init()
  self.itemId = tonumber(self.viewdata.view.desc)
  helplog(self.itemId)
  self.itemData = BagProxy.Instance:GetItemByStaticID(tonumber(self.itemId))
  self.convertRatio = 1
  self.maxLimit = self.itemData and self.itemData.num or 0
  self.minLimit = 1
  self.readyConvertCount = 1
  self.isPressed = false
  self.pressTime = 0
  local panelAction = self:FindGO("pannelAction")
  local cancelBtn = self:FindGO("cancel", panelAction)
  self:AddClickEvent(cancelBtn, function(go)
    self:CloseSelf()
  end)
  local confirmBtn = self:FindGO("comfirm", panelAction)
  self:AddClickEvent(confirmBtn, function(go)
    self:TryConvertZeny()
  end)
  local convertSlider = self:FindGO("convertSlider")
  self.addBtn = self:FindGO("rightBtn", convertSlider)
  self.minuBtn = self:FindGO("leftBtn", convertSlider)
  self.progress = self:FindGO("progressback", convertSlider):GetComponent(UISlider)
  self.progress.value = self.readyConvertCount / self.maxLimit
  self:AddPressEvent(self.addBtn, function(go, isPressed)
    self:PressChange(isPressed, 1)
  end)
  self:AddPressEvent(self.minuBtn, function(go, isPressed)
    self:PressChange(isPressed, -1)
  end)
  EventDelegate.Set(self.progress.onChange, function()
    if self.isPressed == false then
      self.readyConvertCount = math.floor(self.maxLimit * self.progress.value)
      self:CheckLimit()
      self:RefreshConvertInfo()
    end
  end)
  self:SetSpritAlpha(self.minuBtn, 0.5)
  local convertInfo = self:FindGO("convertInfo")
  self.bigLabel = self:FindGO("big", convertInfo):GetComponent(UILabel)
  self.zenyLabel = self:FindGO("zeny", convertInfo):GetComponent(UILabel)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.title.text = ZhString.ConvertTitle
  self.bigIcon = self:FindGO("bigIcon"):GetComponent(UISprite)
  local config = Table_Item[self.itemId]
  if config ~= nil then
    IconManager:SetItemIcon(config.Icon, self.bigIcon)
  end
  local useEffect = Table_UseItem[self.itemId]
  if useEffect ~= nil then
    useEffect = useEffect.UseEffect
    if useEffect.type == "reward" then
      local rewardId = useEffect.id
      local rewards = ItemUtil.GetRewardItemIdsByTeamId(tonumber(rewardId))
      local realRewardIcon
      for _, v in pairs(rewards) do
        if v.id == 100 then
          realRewardIcon = Table_Item[v.id].Icon
          self.convertRatio = v.num
        end
      end
      if realRewardIcon ~= nil then
        self.zenyIcon = self:FindGO("zenyIcon"):GetComponent(UISprite)
        IconManager:SetItemIcon(realRewardIcon, self.zenyIcon)
      end
    else
      helplog("不是reward类型！！！！！")
    end
  end
end

function ZenyConvertPanel:PressChange(isPressed, changeCount)
  self.isPressed = isPressed
  if isPressed then
    if self.subtractTick == nil then
      self.subtractTick = TimeTickManager.Me():CreateTick(0, 150, function(self, deltatime)
        self.pressTime = self.pressTime + deltatime
        changeCount = 0 < changeCount and changeCount + math.floor(self.pressTime / 1000) or changeCount - math.floor(self.pressTime / 1000)
        self:UpdateCount(changeCount)
      end, self, 2)
    else
      self.subtractTick:Restart()
    end
  elseif self.subtractTick then
    self.subtractTick:StopTick()
    self.subtractTick = nil
    self.pressTime = 0
  end
end

function ZenyConvertPanel:UpdateCount(changeCount)
  self.readyConvertCount = self.readyConvertCount + changeCount
  self:CheckLimit()
  self:RefreshConvertInfo()
  self.progress.value = self.readyConvertCount / self.maxLimit
end

function ZenyConvertPanel:CheckLimit()
  if self.readyConvertCount <= self.minLimit then
    self.readyConvertCount = self.minLimit
    self:SetSpritAlpha(self.minuBtn, 0.5)
    self:SetSpritAlpha(self.addBtn, 1)
  elseif self.readyConvertCount >= self.maxLimit then
    self.readyConvertCount = self.maxLimit
    self:SetSpritAlpha(self.addBtn, 0.5)
    self:SetSpritAlpha(self.minuBtn, 1)
  elseif self.readyConvertCount > self.minLimit and self.readyConvertCount < self.maxLimit then
    self:SetSpritAlpha(self.addBtn, 1)
    self:SetSpritAlpha(self.minuBtn, 1)
  end
  if self.maxLimit <= self.minLimit then
    self:SetSpritAlpha(self.minuBtn, 0.5)
    self:SetSpritAlpha(self.addBtn, 0.5)
  end
end

function ZenyConvertPanel:SetSpritAlpha(spriteGo, alpha)
  local sprite = spriteGo:GetComponent(UISprite)
  sprite.color = Color(sprite.color.r, sprite.color.g, sprite.color.b, alpha)
end

function ZenyConvertPanel:RefreshConvertInfo()
  if MyselfProxy.Instance:GetLottery() < self.readyConvertCount then
    self.bigLabel.color = LuaGeometry.GetTempColor(0.9294117647058824, 0.047058823529411764, 0.047058823529411764, 1)
  else
    self.bigLabel.color = LuaGeometry.GetTempColor(0.14901960784313725, 0.14901960784313725, 0.14901960784313725, 1)
  end
  self.bigLabel.text = self.readyConvertCount
  self.zenyLabel.text = self.readyConvertCount * self.convertRatio
end

function ZenyConvertPanel:TryConvertZeny()
  local itemData = self.itemData
  if itemData then
    local tempUseMode = itemData.staticData.UseMode
    itemData.staticData.UseMode = nil
    FunctionItemFunc.TryUseItem(itemData, nil, self.readyConvertCount)
    itemData.staticData.UseMode = tempUseMode
    self:CloseSelf()
  else
    helplog("no item!!!!!" .. self.itemId)
  end
end

function ZenyConvertPanel:OnEnter()
  ZenyConvertPanel.super.OnEnter(self)
  EventManager.Me():AddEventListener(ServiceEvent.NUserBuyZenyCmd, self.HandleConvertResult, self)
end

function ZenyConvertPanel:OnExit()
  ZenyConvertPanel.super.OnExit(self)
  EventManager.Me():RemoveEventListener(ServiceEvent.NUserBuyZenyCmd, self.HandleConvertResult, self)
end

function ZenyConvertPanel:HandleConvertResult(data)
  self.readyConvertCount = 1
  self:CheckLimit()
  self:RefreshConvertInfo()
  self.progress.value = self.readyConvertCount / self.maxLimit
end
