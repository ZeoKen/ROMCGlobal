autoImport("HappyShop")
autoImport("GiftItemCell")
PrestigeShopView = class("PrestigeShopView", HappyShop)
PrestigeShopView.ViewType = UIViewType.NormalLayer
ShopInfoType = {
  MyProfession = "MyProfession",
  All = "All"
}
local MAX_SUBMIT = 10

function PrestigeShopView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end

local badgeBG = "prestige_icon_bg"
local prestigeConfig = GameConfig.Prestige

function PrestigeShopView:FindObjs()
  self.moneySprite = {}
  self.moneySprite[1] = self:FindGO("goldIcon"):GetComponent(UISprite)
  self.moneySprite[2] = self:FindGO("silversIcon"):GetComponent(UISprite)
  self.moneyLabel = {}
  self.moneyLabel[1] = self:FindGO("gold"):GetComponent(UILabel)
  self.moneyLabel[2] = self:FindGO("silvers"):GetComponent(UILabel)
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.ItemScrollViewSpecial = self:FindGO("ItemScrollViewSpecial"):GetComponent(UIScrollView)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.skipBtn.gameObject:SetActive(HappyShopProxy.Instance:IsShowSkip())
  self.toggleRoot = self:FindGO("ToggleRoot")
  self.descLab = self:FindGO("desc"):GetComponent(UILabel)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.specialRoot = self:FindGO("SpecialRoot")
  self.limitLab = self:FindComponent("LimitLab", UILabel)
  self.gifting = self:FindGO("Gifting")
  self.giftPanel = self:FindGO("GiftPanel")
  self.giftGrid = self:FindGO("giftGrid", self.giftPanel):GetComponent(UIGrid)
  self.giftCtrl = UIGridListCtrl.new(self.giftGrid, GiftItemCell, "GiftItemCell")
  self.giftCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickGiftItemCell, self)
  self.descPanel = self:FindGO("DescPanel")
  self.prestigeProgress = self:FindGO("prestigeProgress"):GetComponent(UIProgressBar)
  self.prestigename = self:FindGO("prestigename"):GetComponent(UILabel)
  self.prestigeLevel = self:FindGO("prestigeLevel"):GetComponent(UILabel)
  self.prestigePercent = self:FindGO("prestigePercent"):GetComponent(UILabel)
  self.prestigeIcon = self:FindGO("prestigeIcon"):GetComponent(UISprite)
  self.prestigeDesc = self:FindGO("prestigeDesc"):GetComponent(UILabel)
  self.subcheck = self:FindGO("subcheck")
  local optionLabel = self:FindGO("optionLabel"):GetComponent(UILabel)
  optionLabel.text = string.format("x%d", MAX_SUBMIT)
  self.expectedProgress = self:FindGO("expectedProgress"):GetComponent(UIProgressBar)
  self:InitBuyItemCell()
  self.screenRoot = self:FindGO("ScreenRoot")
  self.screenCheck = self:FindGO("screenCheck", self.screenRoot)
  self.effectContainer = self:FindGO("EffectContainer")
  self.titleBg = self:FindGO("titleBg"):GetComponent(UITexture)
  self.backwardBtn = self:FindGO("BackwardBtn")
  self.searchToggle = self:FindGO("SearchToggle")
  self.searchInput = self:FindGO("SearchInput"):GetComponent(UIInput)
  self.searchInput.defaultText = ZhString.HappyShop_Search
end

function PrestigeShopView:AddViewEvts()
  PrestigeShopView.super.AddViewEvts(self)
  self.isSwitchView = false
  self:AddClickEvent(self.gifting, function(g)
    self.isSwitchView = true
    self:SwitchView()
  end)
  self:AddClickEvent(self.backwardBtn, function(g)
    self.isSwitchView = false
    self:SwitchView()
  end)
  self:AddClickEvent(self:FindGO("SubmitBtn"), function()
    if self.selectid then
      local prestigedata = self:GetPrestigeDataBySelfNPC()
      if prestigedata and prestigedata:IsGraduate() then
        MsgManager.ShowMsgByID(40001)
        return
      end
      local num = BagProxy.Instance:GetAllItemNumByStaticID(self.selectid)
      if num <= 0 then
        MsgManager.ShowMsgByID(40002)
      else
        ServiceNUserProxy.Instance:CallPrestigeGiveUserCmd(self.selectid, self.count)
      end
    end
  end)
  self.checkNum = false
  self:AddClickEvent(self:FindGO("subOption"), function()
    self.checkNum = not self.checkNum
    self.subcheck.gameObject:SetActive(self.checkNum)
    self:ResetCount(self.checkNum)
  end)
  self:AddClickEvent(self.screenCheck, function()
    self:ClickMyProfession()
  end)
  self:AddListenEvt(ServiceEvent.NUserPrestigeNtfUserCmd, self.SetPrestigeInfo)
  self:AddListenEvt(ServiceEvent.NUserPrestigeGiveUserCmd, self.HandlePrestigeGive)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.HandleManulUnlock)
end

function PrestigeShopView:InitUI()
  PrestigeShopView.super.InitUI(self)
  self.ischecked = false
  self.lastLevel = nil
  self:SetPrestigeInfo()
  self:SetGifting()
  self:SetDescLable()
  if self.giftCtrl then
    local cells = self.giftCtrl:GetCells()
    for _, v in pairs(cells) do
      v:SetChoose(false)
    end
  end
end

function PrestigeShopView:InitPrestigeInfo()
  self.isSwitchView = false
  self.checkNum = false
  self.subcheck.gameObject:SetActive(self.checkNum)
  self.selectid = nil
  self.count = 1
  self:HideGift()
  self:ShowDesc()
  self.displayList = {}
end

function PrestigeShopView:SwitchView()
  if self.isSwitchView then
    self:SetGifting()
    self:HideDesc()
    self:ShowGift()
  else
    self:SetDescLable()
    self:HideGift()
    self:ShowDesc()
  end
end

function PrestigeShopView:ResetCount(ischecked)
  local temp = 1
  self.ischecked = ischecked
  if not self.selectid then
    return
  end
  if self.checkNum and self.selectid then
    temp = BagProxy.Instance:GetItemNumByStaticID(self.selectid)
    self.count = temp < MAX_SUBMIT and temp or MAX_SUBMIT
  end
  if not ischecked then
    self.count = 1
  end
  local prestigedata = self:GetPrestigeDataBySelfNPC()
  if prestigedata then
    local pLeveldata = prestigedata:GetCurrentLevelExpData()
    local nLeveldata = prestigedata:GetNextLevelExpData()
    local gifts = prestigedata:GetGiftItems()
    local tempExp = gifts[self.selectid]
    self.expectedProgress.value = (prestigedata.exp + tempExp * self.count) / nLeveldata.NeedPre
  end
end

function PrestigeShopView:SetPrestigeInfo()
  self:SetPrestigeDetail()
  self:SetDescLable()
end

function PrestigeShopView:SetPrestigeDetail()
  local prestigedata = self:GetPrestigeDataBySelfNPC()
  if prestigedata then
    if not self.lastLevel then
      self.lastLevel = prestigedata.level
    elseif self.lastLevel ~= prestigedata.level then
      self.lastLevel = prestigedata.level
      self:ShowEffect()
    end
    if prestigedata:IsGraduate() then
      self.prestigeProgress.value = 1
      self.prestigePercent.text = "MAX"
    else
      local pLeveldata = prestigedata:GetCurrentLevelExpData()
      local nLeveldata = prestigedata:GetNextLevelExpData()
      self.prestigeProgress.value = prestigedata.exp / nLeveldata.NeedPre
      self.expectedProgress.value = prestigedata.exp / nLeveldata.NeedPre
      self.prestigePercent.text = string.format("%d/%d", prestigedata.exp, nLeveldata.NeedPre)
    end
    self.prestigename.text = prestigedata.staticData.Name
    self.prestigeLevel.text = prestigedata.level
    IconManager:SetUIIcon(prestigedata.staticData.Emblem, self.prestigeIcon)
    self.prestigeDesc.text = prestigedata.staticData.Slogan
  else
    redlog("prestigedata nil")
  end
end

function PrestigeShopView:ShowEffect()
  self:PlayUIEffect(EffectMap.UI.Exp_Shine, self.effectContainer, false)
end

function PrestigeShopView:SetDescLable()
  local prestigedata = self:GetPrestigeDataBySelfNPC()
  if prestigedata then
    local pLeveldata = prestigedata:GetCurrentLevelExpData()
    self.descLab.text = pLeveldata.PreDialog ~= "" and pLeveldata.PreDialog or ZhString.HappyShop_defaultDesc
  else
    self.descLab.text = ZhString.HappyShop_defaultDesc
  end
end

function PrestigeShopView:SetGifting()
  local prestigedata = self:GetPrestigeDataBySelfNPC(false)
  if prestigedata then
    local gifts = prestigedata:GetGiftItems()
    local giftlist = {}
    for itemid, v in pairs(gifts) do
      local single = {}
      single.itemid = itemid
      single.icon = Table_Item[single.itemid] and Table_Item[single.itemid].Icon or ""
      single.count = BagProxy.Instance:GetItemNumByStaticID(itemid)
      table.insert(giftlist, single)
    end
    self.giftCtrl:ResetDatas(giftlist)
  end
end

function PrestigeShopView:HideGift()
  self.giftPanel:SetActive(false)
end

function PrestigeShopView:HideDesc()
  self.descPanel:SetActive(false)
end

function PrestigeShopView:ShowGift()
  self.giftPanel:SetActive(true)
  local cells = self.giftCtrl:GetCells()
  if cells and cells[1] then
    self:ClickGiftItemCell(cells[1])
  end
end

function PrestigeShopView:ShowDesc()
  self.descPanel:SetActive(true)
end

function PrestigeShopView:ClickGiftItemCell(cell)
  self.selectid = cell.data.itemid
  if self.ischecked then
    temp = BagProxy.Instance:GetItemNumByStaticID(self.selectid)
    self.count = temp < MAX_SUBMIT and temp or MAX_SUBMIT
  else
    self.count = 1
  end
  local cells = self.giftCtrl:GetCells()
  for _, v in pairs(cells) do
    v:SetChoose(self.selectid == v.data.itemid)
  end
  local prestigedata = self:GetPrestigeDataBySelfNPC()
  if prestigedata then
    if prestigedata:IsGraduate() then
      return
    end
    local pLeveldata = prestigedata:GetCurrentLevelExpData()
    local nLeveldata = prestigedata:GetNextLevelExpData()
    local gifts = prestigedata:GetGiftItems()
    local tempExp = gifts[self.selectid]
    if self.checkNum and self.selectid then
      temp = BagProxy.Instance:GetItemNumByStaticID(self.selectid)
      self.count = temp < MAX_SUBMIT and temp or MAX_SUBMIT
    end
    self.prestigeProgress.value = prestigedata.exp / nLeveldata.NeedPre
    self.expectedProgress.value = (prestigedata.exp + tempExp * self.count) / nLeveldata.NeedPre
  end
end

function PrestigeShopView:OnEnter()
  PrestigeShopView.super.OnEnter(self)
  self:InitPrestigeInfo()
  self:InitUI()
  PictureManager.Instance:SetUI(badgeBG, self.titleBg)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.npcguid = self.npcdata.data.id
end

function PrestigeShopView:OnExit()
  self.lastplayTime = nil
  PrestigeShopView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(badgeBG, self.titleBg)
end

function PrestigeShopView:InitScreen()
  if HappyShopProxy.Instance:GetScreen() then
    self.infoType = ShopInfoType.MyProfession
    self.screenRoot:SetActive(true)
    self.screenCheck:SetActive(true)
  else
    self.infoType = ShopInfoType.All
    self.screenRoot:SetActive(false)
  end
end

function PrestigeShopView:InitShowtoggle()
end

function PrestigeShopView:InitServantList()
end

function PrestigeShopView:ClickMyProfession()
  self.infoType = ShopInfoType.MyProfession
  self:UpdateShopInfo(true)
end

function PrestigeShopView:ClickAll()
  self.infoType = ShopInfoType.All
  self:UpdateShopInfo(true)
end

function PrestigeShopView:GetPrestigeDataBySelfNPC(needResetSelfNpcId)
  if needResetSelfNpcId == nil then
    needResetSelfNpcId = true
  end
  if needResetSelfNpcId then
    self.npcid = HappyShopProxy.Instance:GetNPCStaticid()
  end
  return PrestigeProxy.Instance:GetPrestigeDataByNPC(self.npcid)
end

function PrestigeShopView:HandleItemUpdate()
  self:SetGifting()
  self:UpdateMoney()
end

function PrestigeShopView:HandlePrestigeGive()
  self:SetGifting()
  local prestigedata = self:GetPrestigeDataBySelfNPC()
  if prestigedata then
    local pLeveldata = prestigedata:GetCurrentLevelExpData()
    local nLeveldata = prestigedata:GetNextLevelExpData()
    local gifts = prestigedata:GetGiftItems()
    local tempExp = gifts[self.selectid]
    self.expectedProgress.value = (prestigedata.exp + tempExp * self.count) / nLeveldata.NeedPre
    local deltatime = 0
    if self.lastplayTime then
      deltatime = (ServerTime.CurServerTime() - self.lastplayTime) / 1000
    end
    if not self.lastplayTime or deltatime > prestigeConfig.dialogcolddown then
      self.play_lock = false
    else
      self.play_lock = true
    end
    if not self.play_lock then
      local displaydata = prestigedata:GetCurrentDisplayByNPC(self.npcid)
      self.displayList[#self.displayList + 1] = displaydata
      self.lastplayTime = ServerTime.CurServerTime()
    end
    self:DisplayNPCPerformance()
  end
end

function PrestigeShopView:DisplayNPCPerformance()
  local currentDisplay = self.displayList[1]
  if not currentDisplay then
    return
  end
  if self.npcguid and self.npcdata then
    if self.npcdata then
      local sceneUI = self.npcdata:GetSceneUI()
      if sceneUI then
        if currentDisplay.emoji then
          sceneUI.roleTopUI:PlayEmojiById(currentDisplay.emoji)
        end
        if currentDisplay.dialog then
          sceneUI.roleTopUI:Speak(currentDisplay.dialog)
        end
      end
    end
    if currentDisplay.actionname then
      self.npcdata:Client_PlayAction(currentDisplay.actionname, nil, false)
    end
  end
  table.remove(self.displayList, 1)
end

function PrestigeShopView:ResetView()
  local cells = self.giftCtrl:GetCells()
  for _, v in pairs(cells) do
    v:SetChoose(false)
  end
  self.checkNum = false
  self.subcheck.gameObject:SetActive(self.checkNum)
  self.count = 1
  self.ischecked = false
end

function PrestigeShopView:HandleManulUnlock(note)
  if not note or not note.body then
    return
  end
  local list = note.body.list
  local shopData = HappyShopProxy.Instance:GetShopData()
  local flag = false
  if shopData then
    local goods = shopData:GetGoods()
    for k, v in pairs(goods) do
      for i = 1, #list do
        if list[i] == v.MenuID then
          flag = flag or true
          v.lock = false
        end
      end
    end
    if flag then
      self:UpdateShopInfo(true)
    end
  end
end
