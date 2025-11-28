AppStoreCodeRewardPopup = class("AppStoreCodeRewardPopup", ContainerView)
AppStoreCodeRewardPopup.ViewType = UIViewType.SystemOpenLayer

function AppStoreCodeRewardPopup.CanShow()
  if GameConfig.ForbidAppStoreRedemptionCode then
    return false
  end
  local restorePays = FunctionLogin.Me():getRestorePays()
  if restorePays and next(restorePays) then
    return true
  end
  return false
end

function AppStoreCodeRewardPopup:Init()
  self:InitData()
  self:InitView()
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function AppStoreCodeRewardPopup:InitData()
  self.waitingRewards = {}
  local restorePays = FunctionLogin.Me():getRestorePays()
  for k, _ in pairs(restorePays) do
    table.insert(self.waitingRewards, k)
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function AppStoreCodeRewardPopup:InitView()
  self.title1 = self:FindComponent("title1", UILabel)
  self.title2 = self:FindComponent("title2", UILabel)
  self.getBtn = self:FindGO("BtnGetReward")
  self.postponeBtn = self:FindGO("BtnPostpone")
  self.getLb = self:FindComponent("Label", UILabel, self.getBtn)
  self.postponeLb = self:FindComponent("Label", UILabel, self.postponeBtn)
  self.rewardGird = self:FindComponent("rewardContainer", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(self.rewardGird, BagItemCell, "BagItemCell")
  self.norewardInfoLb = self:FindComponent("norewardInfo", UILabel)
  self.rewardItemList = ReusableTable.CreateArray()
  self:AddClickEvent(self.getBtn, function()
    self:GetReward()
  end)
  self:AddClickEvent(self.postponeBtn, function()
    self:Postpone()
  end)
  self.title1.text = ZhString.AppStoreCode_title1
  self.title2.text = ZhString.AppStoreCode_title2
  self.postponeLb.text = ZhString.AppStoreCode_postponeLb
  self.getLb.text = ZhString.AppStoreCode_getLb
  self.norewardInfoLb.text = ZhString.AppStoreCode_norewardInfo
end

function AppStoreCodeRewardPopup:GetReward()
  self:DoRestorePay(self.orderId)
  self:Postpone()
end

function AppStoreCodeRewardPopup:Postpone()
  FunctionLogin.Me():delRestoredPayment(self.orderId)
  table.remove(self.waitingRewards)
  self:UpdateView()
end

function AppStoreCodeRewardPopup:UpdateView()
  if self.waitingRewards and #self.waitingRewards > 0 then
    TableUtility.TableClear(self.rewardItemList)
    self.orderId = self.waitingRewards[#self.waitingRewards]
    local restorePays = FunctionLogin.Me():getRestorePays()
    if restorePays and restorePays[self.orderId] then
      local Product_Id = restorePays[self.orderId].Product_Id
      local depositItem = self:GetDepositInfoByProductId(Product_Id)
      if not depositItem then
        redlog("无法获取到兑换码单中指定的商品", "orderId", self.orderId, "Product_Id", Product_Id)
        self:Postpone()
        return
      end
      local itemid = depositItem.ItemId
      local num = depositItem.Count
      if not itemid then
        self:Show(self.norewardInfoLb.gameObject)
      else
        self:Hide(self.norewardInfoLb.gameObject)
        local item = ItemData.new("Reward", itemid)
        if num and 1 < num then
          item:SetItemNum(num)
        end
        table.insert(self.rewardItemList, item)
        self.rewardCtl:ResetDatas(self.rewardItemList)
      end
    else
      self:Postpone()
    end
  else
    self:CloseSelf()
  end
end

function AppStoreCodeRewardPopup:CloseSelf()
  local c = coroutine.create(function()
    Yield(WaitForSeconds(0.1))
    AppStoreCodeRewardPopup.super.CloseSelf(self)
  end)
  coroutine.resume(c)
end

function AppStoreCodeRewardPopup:OnEnter()
  AppStoreCodeRewardPopup.super.OnEnter(self)
  self:UpdateView()
end

function AppStoreCodeRewardPopup:OnExit()
  ReusableTable.DestroyAndClearArray(self.rewardItemList)
  AppStoreCodeRewardPopup.super.OnExit(self)
end

function AppStoreCodeRewardPopup:GetDepositInfoByProductId(Product_Id)
  for _, v in pairs(Table_Deposit) do
    if Product_Id == v.ProductID then
      return v
    end
  end
end

function AppStoreCodeRewardPopup:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Up)
  end
end

local gReusableTable = {}

function AppStoreCodeRewardPopup:DoRestorePay(Order_Id)
  local productConf = self:GetDepositInfoByProductId(FunctionLogin.Me():getRestorePays()[self.orderId].Product_Id)
  if not productConf then
    return
  end
  local productID = productConf.ProductID
  if productID then
    local productName = productConf.Desc
    local productPrice = productConf.Rmb
    local productCount = 1
    local roleID = Game.Myself and Game.Myself.data and Game.Myself.data.id or nil
    if roleID then
      local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
      local roleName = roleInfo and roleInfo.name or ""
      local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
      local roleBalance = MyselfProxy.Instance:GetROB() or 0
      local server = FunctionLogin.Me():getCurServerData()
      local serverID = server ~= nil and server.serverid or nil
      if serverID then
        local currentServerTime = ServerTime.CurServerTime() / 1000
        local runtimePlatform = ApplicationInfo.GetRunPlatform()
        if BranchMgr.IsChina() and runtimePlatform == RuntimePlatform.IPhonePlayer and FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.XD then
          TableUtility.TableClear(gReusableTable)
          gReusableTable.productGameID = tostring(productConf.id)
          gReusableTable.serverID = tostring(serverID)
          gReusableTable.accid = tostring(FunctionLogin.Me():getLoginData().accid)
          local ext = json.encode(gReusableTable)
          if not BackwardCompatibilityUtil.CompatibilityMode_V81 then
            FunctionSDK.Instance:XDSDKResotrePay(self.orderId, productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext)
          else
            FunctionXDSDK.Ins:ResotrePay(self.orderId, productName, productID, productPrice * 100, serverID, tostring(roleID), "", ext)
          end
        else
          MsgManager.ShowMsgByID(800)
        end
      end
    end
  end
end
