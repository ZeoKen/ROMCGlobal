autoImport("BaseCell")
NoviceRechargeSignInCell = class("NoviceRechargeSignInCell", BaseCell)
autoImport("RewardGridCell")
autoImport("RechargeRewardCell")

function NoviceRechargeSignInCell:Init()
  self.days = {}
  for i = 1, 3 do
    local singleDay = {}
    local go = self:FindGO("Day" .. i)
    singleDay.go = go
    singleDay.grid = self:FindGO("Grid", go):GetComponent(UIGrid)
    singleDay.listCtrl = UIGridListCtrl.new(singleDay.grid, RechargeRewardCell, "RechargeRewardCell")
    singleDay.listCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickItem, self)
    singleDay.tipLabel = self:FindGO("TipLabel", go):GetComponent(UILabel)
    singleDay.tipBg = self:FindGO("TipBg", go):GetComponent(UISprite)
    self.days[i] = singleDay
  end
  self.funcBtn = self:FindGO("FuncBtn")
  self.funcBtn_SP = self.funcBtn:GetComponent(UISprite)
  self.funcBtn_BoxCollider = self.funcBtn:GetComponent(BoxCollider)
  self.funcBtn_Label = self:FindGO("Label", self.funcBtn):GetComponent(UILabel)
  self.redtip = self:FindGO("Redtip")
  self.seperateLine = self:FindGO("SeperateLine")
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function NoviceRechargeSignInCell:SetData(data)
  self.data = data
  self.index = self.indexInList
  if self.index == 1 then
    self.seperateLine:SetActive(false)
  end
  self.redtip:SetActive(false)
  local rewardList = data.RewardList
  for i = 1, #rewardList do
    local itemGroup = rewardList[i].Rewards
    local rewards = {}
    for j = 1, #itemGroup do
      local itemData = ItemData.new("Reward", itemGroup[j][1])
      itemData.num = itemGroup[j][2]
      table.insert(rewards, itemData)
    end
    self.days[i].listCtrl:ResetDatas(rewards)
    local tipsStr = rewardList[i].Tips
    if tipsStr and tipsStr ~= "" then
      self.days[i].tipLabel.gameObject:SetActive(true)
      self.days[i].tipLabel.text = tipsStr
      local size = self.days[i].tipLabel.printedSize
      self.days[i].tipBg.width = size.x + 26
      self.days[i].tipBg.height = size.y + 33
    else
      self.days[i].tipLabel.gameObject:SetActive(false)
    end
  end
  local loginStatus = NoviceRechargeProxy.Instance:GetLoginStatus(tostring(self.index))
  if not loginStatus then
    local depositID
    if data.Deposit and type(data.Deposit) == "table" then
      depositID = data.Deposit[1]
    elseif data.Deposit and type(data.Deposit) == "number" then
      depositID = data.Deposit
    end
    if depositID and depositID ~= 0 then
      local depositConfig = Table_Deposit[depositID]
      if depositConfig.Type == 2 then
        self.funcBtn_Label.text = ZhString.NoviceRecharge_BuyMonthlyPass
        self:AddClickEvent(self.funcBtn, function()
          MsgManager.ConfirmMsgByID(41164, function()
            FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard)
          end)
        end)
      else
        self.funcBtn_Label.text = string.format(ZhString.NoviceRecharge_Recharge, depositConfig.CurrencyType, depositConfig.Rmb)
        self:AddClickEvent(self.funcBtn, function()
          MsgManager.ConfirmMsgByID(41164, function()
            FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
          end)
        end)
      end
    elseif data.ChargeNum then
      self.funcBtn_Label.text = string.format(ZhString.NoviceRecharge_Recharge, NoviceRechargeProxy.Instance:GetCurrencyType(), data.ChargeNum)
      self:AddClickEvent(self.funcBtn, function()
        MsgManager.ConfirmMsgByID(41164, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
      end)
    end
    self.funcBtn_SP.spriteName = "new-com_btn_a"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
    self.funcBtn_BoxCollider.enabled = true
    return
  else
    self:AddClickEvent(self.funcBtn, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  end
  local curLogin = loginStatus.login_day
  local loginCount = loginStatus.reward_day
  for i = 1, loginCount do
    local rewardCells = self.days[i].listCtrl:GetCells()
    for j = 1, #rewardCells do
      rewardCells[j]:SetFinishStatus(true)
    end
    self.days[i].tipLabel.gameObject:SetActive(false)
  end
  if curLogin == loginCount then
    if loginCount == 3 then
      self.funcBtn:SetActive(false)
    else
      self.funcBtn_Label.text = ZhString.DayLogin_ReceiveTomorrow
      self.funcBtn_SP.spriteName = "new-com_btn_a_gray"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.25098039215686274, 0.26666666666666666, 0.2980392156862745, 1)
      self.funcBtn_BoxCollider.enabled = false
    end
  else
    self.funcBtn_Label.text = ZhString.ReturnActivityPanel_GetReward
    self.funcBtn_SP.spriteName = "new-com_btn_c"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1)
    self.funcBtn_BoxCollider.enabled = true
    self.redtip:SetActive(true)
  end
end

function NoviceRechargeSignInCell:handleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    local x, y, z = NGUIUtil.GetUIPositionXYZ(cellCtrl.icon.gameObject)
    if 0 < x then
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
    else
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end
