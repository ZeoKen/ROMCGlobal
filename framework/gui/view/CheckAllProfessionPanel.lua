CheckAllProfessionPanel = class("CheckAllProfessionPanel", BaseView)
CheckAllProfessionPanel.ViewType = UIViewType.PopUpLayer
autoImport("ProfessionIconCell")
autoImport("JobTreeNewCell")
autoImport("NewHappyShopBuyItemCell")
CheckAllProfessionPanel.PlusClick = "CheckAllProfessionPanel_PlusClick"
local S_ProfessionDatas = {}
local topScrollViewIconTable = {}
local ProfessionIconCellTable = {}
local IconCellTable = {}
local LineTable = {}
local tempArray = {}
local hero_ticket_shop = GameConfig.Profession.hero_ticket_shop or {
  812,
  1,
  56596
}
local TICKETPACKAGECHECK = GameConfig.PackageMaterialCheck.buy_profession

function CheckAllProfessionPanel:RecvProfessionBuyUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil then
    if data.body.success then
      local b = data.body.branch
      local boughtId = ProfessionProxy.GetBoughtProfessionIdThroughBranch(b)
      local realGetId = Table_Branch[b] and Table_Branch[b].base_id or 0
      b = ProfessionProxy.TypeBranchS2C(b)
      self.PurchaseView.gameObject:SetActive(false)
      for k, v in pairs(self.JobTreeList:GetCells()) do
        v:RecvBuyJob(boughtId)
      end
      if boughtId == 1 then
        self.humanNovice:SetRecvBuy()
      elseif boughtId == 150 then
        self.doramNovice:SetRecvBuy()
      end
      local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      S_ProfessionDatas[b] = {}
      S_ProfessionDatas[b].branch = b
      S_ProfessionDatas[b].profession = realGetId
      S_ProfessionDatas[b].joblv = 0
      S_ProfessionDatas[b].isbuy = true
      S_ProfessionDatas[b].iscurrent = false
    else
      helplog("RecvProfessionBuyUserCmd Failed reviewCode")
    end
  else
    helplog("error message From server 2")
  end
end

function CheckAllProfessionPanel:RecvProfessionChangeUserCmd(data)
end

function CheckAllProfessionPanel:RecvProfessionQueryUserCmd(data)
end

function CheckAllProfessionPanel:RecvUpdateBranchInfoUserCmd(data)
end

function CheckAllProfessionPanel:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end

function CheckAllProfessionPanel:initView()
  self.PurchaseView = self:FindGO("PurchaseView")
  self.Bg = self:FindGO("Bg", self.PurchaseView)
  self.Btns = self:FindGO("Btns", self.Bg)
  self.CancelBtn = self:FindGO("CancelBtn", self.Btns)
  self.ConfirmBtn = self:FindGO("ConfirmBtn", self.Btns)
  self.icon_zeny = self:FindGO("icon_zeny", self.PurchaseViewBg)
  self.icon_gold = self:FindGO("icon_gold", self.PurchaseViewBg)
  self.icon_gold_UISprite = self:FindGO("icon_gold", self.PurchaseViewBg):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.icon_gold_UISprite)
  self.icon_zenyUILabel = self:FindGO("Label", self.icon_zeny):GetComponent(UILabel)
  self.icon_goldUILabel = self:FindGO("Label", self.icon_gold):GetComponent(UILabel)
  self.contentUILabel = self:FindGO("content", self.PurchaseView):GetComponent(UILabel)
  self.PurchaseView.gameObject:SetActive(false)
  self.Collider = self:FindGO("Collider", self.PurchaseView)
  local tipData = Table_Sysmsg[26110]
  if tipData then
    self.contentUILabel.text = tipData.Text
  else
    helplog("策划没配！！！！！26110")
  end
  self.Anchor_TopRight = self:FindGO("Anchor_TopRight")
  self.scaleButton = self:FindGO("ScaleButton", self.Anchor_TopRight)
  self.scaleButton_Symbol = self:FindComponent("Symbol", UISprite, self.scaleButton)
  self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
  self.islarge = true
  self.mapBord = self:FindGO("MapBord")
  self.centerTarget = Game.GameObjectUtil:DeepFindChild(self.mapBord, "CenterTarget")
  self.centerTarget = self.centerTarget.transform
  self.scrollView = self:FindComponent("ScrollView", UIScrollViewEx)
  self.mapScale = 1
  self.mPanel = self.scrollView.panel
  
  function self.mPanel.onClipMove()
    self:UpdateCenterScreen()
  end
  
  local panel_worldCorners = self.mPanel.worldCorners
  local worldCenterV3 = (panel_worldCorners[1] + panel_worldCorners[3]) * 0.5
  self.worldCenter = LuaVector3()
  self.worldCenter:Set(worldCenterV3[1], worldCenterV3[2], worldCenterV3[3])
  self.localCenter = LuaVector3()
  self.scrollBound = Game.GameObjectUtil:DeepFindChild(self.mapBord, "ScrollBound")
  self.scrollBoundWidget = self.scrollBound:GetComponent(UIWidget)
  self.AttriIInfoButton = self:FindGO("AttriIInfoButton")
  self.AttriIInfoButtonLabel_UILabel = self:FindGO("Label", self.AttriIInfoButton):GetComponent(UILabel)
  self.AttriIInfoButtonLabel_UILabel.fontSize = GameConfig.Profession.RightTopFontSize ~= nil and GameConfig.Profession.RightTopFontSize or 14
  self.JobTreeScrollView = Game.GameObjectUtil:DeepFindChild(self.mapBord, "JobTreeScrollView")
  self.JobTreeScrollView.gameObject:SetActive(true)
  self.JobTreeBord = Game.GameObjectUtil:DeepFindChild(self.JobTreeScrollView, "JobTreeBord")
  self.JobTreeTable = self.JobTreeBord:GetComponent(UITable)
  self.JobTreeList = UIGridListCtrl.new(self.JobTreeTable, JobTreeNewCell, "JobTreeNewCell")
  tempArray = CheckAllProfessionProxy.Instance:GetCellFirstRowTable(false)
  self.JobTreeList:ResetDatas(tempArray)
  local jobtreecells = self.JobTreeList:GetCells()
  for k, v in pairs(jobtreecells) do
    local icontable = v:GetIconTable()
    for m, n in pairs(icontable) do
      n:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
      n:AddEventListener(MouseEvent.MouseClick, self.clickIconHandler, self)
    end
    local heroIcon = v:GetHeroIcon()
    for m, n in pairs(heroIcon) do
      n:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
      n:AddEventListener(MouseEvent.MouseClick, self.clickIconHandler, self)
    end
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.JobTreeTable.gameObject.transform)
  xdlog("bound x ", bound.size.x)
  self.scrollBoundWidget.width = math.max(2000, bound.size.x + 160)
  self.humanLineTop = self:FindComponent("HumanLineTop", UISprite)
  self.humanNovice = ProfessionIconCell.CreateNew(ProfessionProxy.humanNovice, self:FindGO("HumanTopIcon"))
  self.humanNovice:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
  self.doramLineTop = self:FindComponent("DoramLineTop", UISprite)
  if not ProfessionProxy.IsDoramForbidden() then
    self.doramNovice = ProfessionIconCell.CreateNew(ProfessionProxy.doramNovice, self:FindGO("DoramTopIcon"))
    self.doramNovice:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
    self.doramLineTop.gameObject:SetActive(true)
  else
    self.doramLineTop.gameObject:SetActive(false)
  end
  self:UpdateNoviceIcon()
  self.humanLineTop.gameObject:SetActive(false)
  self.doramLineTop.gameObject:SetActive(false)
  local celldata
  local doram1, doram2, human1, human2 = 0, 0, 0, 0
  for i = 1, #tempArray do
    celldata = tempArray[i]
    if celldata.Race == 1 then
      if human1 == 0 then
        human1, human2 = i, i
      else
        human2 = i
      end
    elseif doram1 == 0 then
      doram1, doram2 = i, i
    else
      doram2 = i
    end
  end
  local x1, x2
  if 0 < doram1 then
    self.doramLineTop.gameObject:SetActive(true)
    x1 = jobtreecells[doram1].gameObject.transform.localPosition.x
    x2 = jobtreecells[doram2].gameObject.transform.localPosition.x
    self.doramLineTop.width = x2 - x1 + 1
    local pos = self.doramLineTop.gameObject.transform.localPosition
    self.doramLineTop.gameObject.transform.localPosition = LuaGeometry.GetTempVector3((x1 + x2) / 2, pos.y, pos.z)
  end
  if 0 < human1 then
    self.humanLineTop.gameObject:SetActive(true)
    x1 = jobtreecells[human1].gameObject.transform.localPosition.x
    x2 = jobtreecells[human2].gameObject.transform.localPosition.x
    self.humanLineTop.width = x2 - x1 + 1
    local pos = self.humanLineTop.gameObject.transform.localPosition
    self.humanLineTop.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x1, pos.y, pos.z)
  end
  self.HelpButton = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(127, self.HelpButton)
  local Astrolabe_PlateZoom_Param = 2
  self:ZoomScrollView(0.7, 0.1, function()
    self.islarge = true
    self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
  end)
  self:AddClickEvent(self.scaleButton, function(go)
    if self.islarge then
      self:ZoomScrollView(Astrolabe_PlateZoom_Param, 0.4, function()
        self.islarge = false
        self.scaleButton_Symbol.spriteName = "com_btn_narrow"
      end)
    else
      self:ZoomScrollView(0.7, 0.4, function()
        self.islarge = true
        self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
      end)
    end
  end)
  self.ticket = self:FindGO("Ticket")
  self.ticketIcon = self:FindGO("TicketIcon", self.ticket):GetComponent(UISprite)
  self.ticketCount = self:FindGO("TicketCount", self.ticket):GetComponent(UILabel)
  local ticketID = GameConfig.Profession.all_profession_ticket or 6553
  local ticketData = Table_Item[ticketID]
  if ticketData then
    IconManager:SetItemIcon(ticketData.Icon, self.ticketIcon)
  end
  local ticketNum = BagProxy.Instance:GetItemNumByStaticID(ticketID, TICKETPACKAGECHECK)
  self:handleItemUpdate()
  self:CreateShopItemCell()
  self.mapBg = self:FindGO("MapBg"):GetComponent(UITexture)
end

function CheckAllProfessionPanel:UpdateNoviceIcon()
  local humanNovice = ProfessionProxy.humanNovice
  if ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(humanNovice) then
    self.humanNovice:SetState(0, humanNovice)
  elseif ProfessionProxy.Instance:IsThisIdKeGouMai(humanNovice) then
    self.humanNovice:SetState(3, humanNovice)
  else
    self.humanNovice:SetState(4, humanNovice)
  end
  if not ProfessionProxy.IsDoramForbidden() then
    local doramNovice = ProfessionProxy.doramNovice
    if ProfessionProxy.Instance:IsThisNoviceIdYiGouMai(doramNovice) then
      self.doramNovice:SetState(1, doramNovice)
    elseif ProfessionProxy.Instance:IsThisIdKeGouMai(doramNovice) then
      self.doramNovice:SetState(3, doramNovice)
    else
      self.doramNovice:SetState(4, doramNovice)
    end
  end
end

function CheckAllProfessionPanel:UpdateCenterScreen()
  local x, y, z = LuaGameObject.InverseTransformPointByVector3(self.mapBord.transform, self.worldCenter)
  self.localCenter:Set(x, y, z)
end

local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3()
local tempV3_3 = LuaVector3()

function CheckAllProfessionPanel:ZoomScrollView(endScale, time, onfinish)
  time = time or 1
  tempV3_1:Set(self.mapScale, self.mapScale, self.mapScale)
  tempV3_3:Set(endScale, endScale, 1)
  self.centerTarget.transform.localPosition = self.localCenter
  tempV3_2:Set(LuaGameObject.GetPosition(self.centerTarget))
  local mTrans = self.scrollView.transform
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateTickFromTo(0, 0, 1, time * 1000, function(owner, deltaTime, curValue)
    self.mapBord.transform.localScale = LuaVector3.Lerp(tempV3_1, tempV3_3, curValue)
    local before = self.centerTarget.transform.position
    local after = LuaVector3.Lerp(tempV3_2, self.worldCenter, curValue)
    local offset = after - before
    local mlPosition = mTrans.localPosition
    mTrans.position = mTrans.position + offset
    self.mPanel.clipOffset = self.mPanel.clipOffset - (mTrans.localPosition - mlPosition)
    local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.scrollBound.transform)
    local calOffset = self.mPanel:CalculateConstrainOffset(b.min, b.max)
    if calOffset.magnitude >= 0.01 then
      mTrans.localPosition = mTrans.localPosition + calOffset
      self.mPanel.clipOffset = self.mPanel.clipOffset - LuaVector2(calOffset.x, calOffset.y)
    end
  end, self):SetCompleteFunc(function(owner, id)
    if onfinish then
      onfinish()
    end
    self.mapScale = endScale
  end)
end

function CheckAllProfessionPanel:addViewListener()
  self:AddClickEvent(self.Collider.gameObject, function(go)
    self.PurchaseView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.CancelBtn.gameObject, function(go)
    self.PurchaseView.gameObject:SetActive(false)
  end)
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd, self.RecvProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd, self.RecvProfessionChangeUserCmd)
  self:AddListenEvt(ServiceEvent.NUserUpdateBranchInfoUserCmd, self.RecvUpdateBranchInfoUserCmd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
end

function CheckAllProfessionPanel:initData()
  S_ProfessionDatas = {}
  topScrollViewIconTable = {}
  ProfessionIconCellTable = {}
  IconCellTable = {}
  LineTable = {}
end

function CheckAllProfessionPanel:OnExit()
  CheckAllProfessionPanel.super.OnExit(self)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  PictureManager.Instance:UnLoadUI("skill_bg_bottom4", self.mapBg)
end

function CheckAllProfessionPanel:OnEnter()
  CheckAllProfessionPanel.super.OnEnter(self)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  local viewdata = self.viewdata and self.viewdata.viewdata
  local curClass = viewdata and viewdata.class
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:TweenToTargetClass(curClass)
  end, self, 5)
  PictureManager.Instance:SetUI("skill_bg_bottom4", self.mapBg)
  self:RefitFullScreenWidgetSize(self.mapBg, true)
end

function CheckAllProfessionPanel:GetMaxBranchCount()
  local i = 0
  for k, v in pairs(Table_Class) do
    if ProfessionProxy.GetJobDepth(v.id) == 2 then
      i = i + 1
      if v.gender ~= nil and v.gender ~= ProfessionProxy.Instance:GetCurSex() or v.IsOpen ~= 1 then
        i = i - 1
      end
    end
  end
  for k = 1, #ProfessionProxy.specialJobs do
    if Table_Class[ProfessionProxy.specialJobs[k]] ~= nil then
      i = i + 1
    end
  end
  return i
end

function CheckAllProfessionPanel:GetThisIdForwardBranch(id, branchnumber)
  local forward = id - 10
  local classData = Table_Class[forward]
  if forward == 1 then
    return 0
  end
  if classData then
    local addNumber = #classData.AdvanceClass
    for k, v in pairs(classData.AdvanceClass) do
      if Table_Class[v] and (Table_Class[v].IsOpen == 0 or Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex()) then
        addNumber = addNumber - 1
      end
    end
    branchnumber = self:GetThisIdForwardBranch(forward, branchnumber) + addNumber
    return branchnumber
  else
    return 0
  end
end

function CheckAllProfessionPanel:clickPlusHandler(id)
  if ProfessionProxy.IsHero(id) then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(id)
    SaveInfoProxy.Instance:SetSavedLastBranchID(typeBranch)
    GameFacade.Instance:sendNotification(MultiProfessionEvent.ChooseProfession, typeBranch)
    self:CloseSelf()
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    local purchaseFunc = function()
      local shopData = ShopProxy.Instance:GetShopDataByTypeId(hero_ticket_shop[1], hero_ticket_shop[2])
      local shopItemData
      if shopData then
        local goods = shopData:GetGoods()
        for k, good in pairs(goods) do
          if good.id == hero_ticket_shop[3] then
            shopItemData = good
            break
          end
        end
      end
      if shopItemData then
        self:ShowShopPurchaseCell(shopItemData)
        HappyShopProxy.Instance:SetSelectId(shopItemData.id)
      end
    end
    ProfessionProxy.Instance:PurchaseFunc(id, purchaseFunc)
  end)
end

function CheckAllProfessionPanel:clickIconHandler(id)
  local professionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local typeBranch = ProfessionProxy.GetTypeBranchFromProf(id)
  local targetBranchInfo = professionDatas and professionDatas[typeBranch]
  if targetBranchInfo and targetBranchInfo.profession then
    GameFacade.Instance:sendNotification(MultiProfessionEvent.ChooseProfession, typeBranch)
    self:CloseSelf()
  end
end

function CheckAllProfessionPanel:handleItemUpdate()
  local ticketID = GameConfig.Profession.all_profession_ticket or 6553
  local ticketNum = BagProxy.Instance:GetItemNumByStaticID(ticketID, TICKETPACKAGECHECK)
  self.ticketCount.text = ticketNum
end

function CheckAllProfessionPanel:CreateShopItemCell()
  self.shopItemCellGO = self:LoadPreferb("cell/NewHappyShopBuyItemCell", self.gameObject, true)
  self.shopItemCellGO.transform.localPosition = LuaGeometry.GetTempVector3(100, 22)
  self.shopItemCellGO:SetActive(false)
end

function CheckAllProfessionPanel:ShowShopPurchaseCell(shopItemData)
  local itemData = Table_Item[shopItemData.goodsID]
  if shopItemData.isDeposit then
    itemData = Table_Item[shopItemData.itemID]
  end
  if itemData then
    if not self.shopItemCell then
      self.shopItemCell = NewHappyShopBuyItemCell.new(self.shopItemCellGO)
    end
    self.shopItemCell:SetData(shopItemData)
  end
end

function CheckAllProfessionPanel:TweenToTargetClass(classid)
  if not classid then
    return
  end
  local branch = ProfessionProxy.GetTypeBranchFromProf(classid)
  self.scrollView:RestrictWithinBounds(true)
  local targetCell
  if classid == ProfessionProxy.humanNovice then
    targetCell = self.humanLineTop
  elseif classid == ProfessionProxy.doramNovice then
    targetCell = self.doramLineTop
  end
  if not targetCell then
    local jobtreecells = self.JobTreeList:GetCells()
    for i = 1, #jobtreecells do
      local jobtreecell = jobtreecells[i]
      local classicClass = jobtreecell:GetIconTable()
      for j = 1, #classicClass do
        if classicClass[j]:Getid() == classid then
          targetCell = jobtreecell
          break
        end
      end
      local heroClass = jobtreecell:GetHeroIcon()
      for j = 1, #heroClass do
        if heroClass[j]:Getid() == classid then
          targetCell = jobtreecell
          break
        end
      end
    end
  end
  if targetCell then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.mPanel.cachedTransform, targetCell.gameObject.transform)
    local offset = self.mPanel:CalculateConstrainOffset(bound.min, bound.max)
    local posX = targetCell.gameObject.transform.localPosition[1]
    offset = Vector3(offset.x, 0, 0)
    self.scrollView:MoveRelative(offset)
  end
end
