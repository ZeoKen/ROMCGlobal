autoImport("RedPacketReceiverListPage")
autoImport("RedPacketRewardItemCell")
RedPacketSendView = class("RedPacketSendView", ContainerView)
RedPacketSendView.ViewType = UIViewType.PopUpLayer
local RedPacketType = {SYS = 1, USER = 2}
local NumType = {ITEM = 1, REDPACKET = 2}
local ChannelName = {
  [ChatChannelEnum.World] = ZhString.RedPacket_World,
  [ChatChannelEnum.Guild] = ZhString.RedPacket_Guild,
  [ChatChannelEnum.GVG] = ZhString.RedPacket_GVG,
  [ChatChannelEnum.Team] = ZhString.RedPacket_Team
}
local ChannelNameColor = {
  [ChatChannelEnum.Private] = "674425",
  [ChatChannelEnum.Guild] = "0090ff",
  [ChatChannelEnum.GVG] = "239500"
}
local TargetEnum = {
  NONE = 0,
  FRIEND = 1,
  GUILDMEMBER = 2,
  GUILDJOB = 3
}
local decorationBg = "returnactivity_bg_boli_02"
local bg1Name = "returnactivity_bg_red_01"
local bg5Name = "returnactivity_bg_red_05"
local ownedMaxWidth = 110

function RedPacketSendView:Init()
  self:FindObjs()
  self:InitData()
  self.dropdownView = self:AddSubView("DropdownMessageView", DropdownMessageView)
end

function RedPacketSendView:FindObjs()
  self.anchorLeft = self:FindGO("AnchorLeft")
  self.anchorRight = self:FindGO("AnchorRight")
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  local help_go = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(35096, help_go)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.bg1 = self:FindComponent("bg1", UITexture)
  self.bg5 = self:FindComponent("bg5", UITexture)
  self.decoration = self:FindComponent("decoration", UITexture)
  local channelArea = self:FindGO("channelArea")
  self:AddClickEvent(channelArea, function()
    self:OnChannelBtnClick()
  end)
  self.channelLabel = self:FindComponent("channel", UILabel, channelArea)
  self.channelArrow = self:FindComponent("arrow", UISprite, channelArea)
  self.messageGo = self:FindGO("message")
  self.messageLabel = self.messageGo:GetComponent(UILabel)
  self:AddClickEvent(self.messageGo, function()
    self:OnDropdownBtnClick()
  end)
  self.dropArrow = self:FindComponent("arrow", UISprite, self.messageGo)
  self.dropdown = self:FindGO("dropdown")
  local closeScript = self.dropdown:GetComponent(CloseWhenClickOtherPlace)
  if closeScript then
    function closeScript.callBack()
      self.dropArrow.flip = 2
    end
  end
  self.dropdown:SetActive(false)
  self.itemNumArea = self:FindGO("itemNum")
  self.itemNumInput = self.itemNumArea:GetComponent(UIInput)
  self.itemNumLabel = self.itemNumArea:GetComponent(UILabel)
  self.itemNumPlusBtn = self:FindGO("plusBtn", self.itemNumArea)
  self.itemNumMinusBtn = self:FindGO("minusBtn", self.itemNumArea)
  self.totalItemIcon = self:FindComponent("icon", UISprite, self.itemNumArea)
  EventDelegate.Set(self.itemNumInput.onChange, function()
    self:OnItemNumInputChange()
  end)
  UIEventListener.Get(self.itemNumArea).onSelect = function(go, state)
    if not state then
      self:OnItemNumInputChange()
    end
  end
  self:AddPressEvent(self.itemNumPlusBtn, function(obj, isPressed)
    self:OnItemNumPlusPress(isPressed)
  end)
  self:AddPressEvent(self.itemNumMinusBtn, function(obj, isPressed)
    self:OnItemNumMinusPress(isPressed)
  end)
  local redPacketNumArea = self:FindGO("redPacketNum")
  self.redPacketNumInput = redPacketNumArea:GetComponent(UIInput)
  self.redPacketNumLabel = redPacketNumArea:GetComponent(UILabel)
  self.redPacketNumPlusBtn = self:FindGO("plusBtn", redPacketNumArea)
  self.redPacketNumMinusBtn = self:FindGO("minusBtn", redPacketNumArea)
  EventDelegate.Set(self.redPacketNumInput.onChange, function()
    self:OnRedPacketNumInputChange()
  end)
  UIEventListener.Get(redPacketNumArea).onSelect = function(go, state)
    if not state then
      self:OnRedPacketNumInputChange()
    end
  end
  self:AddPressEvent(self.redPacketNumPlusBtn, function(obj, isPressed)
    self:OnRedPacketNumPlusPress(isPressed)
  end)
  self:AddPressEvent(self.redPacketNumMinusBtn, function(obj, isPressed)
    self:OnRedPacketNumMinusPress(isPressed)
  end)
  self.rewardPanel = self:FindGO("rewardPanel")
  local grid = self:FindComponent("Grid", UIGrid, self.rewardPanel)
  self.rewardListCtrl = UIGridListCtrl.new(grid, RedPacketRewardItemCell, "RedPacketRewardItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.hint = self:FindGO("hint")
  self.owned = self:FindGO("owned")
  self.ownedContainer = self:FindGO("Container", self.owned)
  self.ownedTitle = self:FindGO("title", self.owned)
  self.sendTitle = self:FindGO("title2", self.owned)
  self.itemIcon = self:FindComponent("icon", UISprite, self.owned)
  self.ownedNum = self:FindComponent("num", UILabel, self.owned)
  self.sendBtn = self:FindGO("sendBtn")
  self.sendBtnDisable = self:FindGO("sendBtnDisable")
  self:AddClickEvent(self.sendBtn, function()
    self:OnSendBtnClick()
  end)
end

function RedPacketSendView:InitView()
  if not self.staticData then
    return
  end
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.hint)
  if self.staticData.hideContext == 1 then
    self.messageGo:SetActive(false)
    y = -107.8
  else
    self.messageGo:SetActive(true)
    local messages = self.staticData.context
    if messages and 0 < #messages then
      self.messageLabel.text = messages[1]
    end
    y = -329.3
  end
  LuaGameObject.SetLocalPositionGO(self.hint, x, y, z)
  local maxNumLimit = self:GetMaxRedPacketNum()
  local minNumLimit = self:GetMinRedPacketNum()
  if maxNumLimit <= minNumLimit then
    self:SetButtonEnabled(self.redPacketNumPlusBtn, false)
  else
    self:SetButtonEnabled(self.redPacketNumPlusBtn, true)
  end
  self:SetButtonEnabled(self.redPacketNumMinusBtn, false)
  self:SetRedPacketNum(minNumLimit)
  if self.data.minMoneyLimit and self.data.maxMoneyLimit then
    if self.data.minMoneyLimit >= self.data.maxMoneyLimit then
      self:SetButtonEnabled(self.itemNumPlusBtn, false)
    else
      self:SetButtonEnabled(self.itemNumPlusBtn, true)
    end
    self:SetButtonEnabled(self.itemNumMinusBtn, false)
    self:SetItemNum(self.data.minMoneyLimit)
  end
  local itemId = self.staticData.moneyID
  local itemData = Table_Item[itemId]
  if itemData then
    IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
    IconManager:SetItemIcon(itemData.Icon, self.totalItemIcon)
    local num = 0
    if self.staticData.redPacketType == RedPacketType.SYS then
      self.ownedContainer:SetActive(false)
      self.sendTitle:SetActive(true)
      num = self.data.minNumLimit
    else
      self.ownedContainer:SetActive(true)
      self.sendTitle:SetActive(false)
      local ref = GameConfig.Wallet.MoneyRef[itemId]
      if ref then
        num = Game.Myself.data.userdata:Get(UDEnum[ref])
      else
        num = BagProxy.Instance:GetItemNumByStaticID(itemId)
      end
    end
    self:SetNumText(self.ownedNum, num)
    local offset = ownedMaxWidth - self.ownedNum.width
    local pos = self.ownedContainer.transform.localPosition
    LuaGameObject.SetLocalPositionGO(self.ownedContainer, pos.x + offset * 0.5, pos.y, pos.z)
  end
  self.dropdownView:InitView(self.staticData)
  PictureManager.Instance:SetReturnActivityTexture(decorationBg, self.decoration)
  PictureManager.Instance:SetReturnActivityTexture(bg1Name, self.bg1)
  PictureManager.Instance:SetReturnActivityTexture(bg5Name, self.bg5)
  local reward = self.staticData.reward
  if reward and 0 < #reward then
    self.isRegular = true
    self.titleLabel.text = ZhString.RedPacket_Regular
    self.rewardPanel:SetActive(true)
    self.itemNumArea:SetActive(false)
    self.owned:SetActive(false)
    local datas = ReusableTable.CreateArray()
    for i = 1, #reward do
      local data = ItemData.new("RewardItem", reward[i][1])
      data.num = reward[i][2]
      datas[#datas + 1] = data
    end
    self.rewardListCtrl:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    if self.staticData.redPacketType == RedPacketType.SYS then
      self.hint:SetActive(true)
    else
      self.hint:SetActive(false)
    end
  else
    self.isRegular = false
    self.titleLabel.text = ZhString.RedPacket_Random
    local multiItems = self.staticData.multi_item
    if multiItems and multiItems ~= _EmptyTable then
      self.rewardPanel:SetActive(true)
      self.itemNumArea:SetActive(false)
      self.owned:SetActive(false)
      local datas = ReusableTable.CreateArray()
      for i = 1, #multiItems do
        local data = ItemData.new("RewardItem", multiItems[i].itemid)
        data.num = multiItems[i].item_count * multiItems[i].group_count
        datas[#datas + 1] = data
      end
      self.rewardListCtrl:ResetDatas(datas)
      ReusableTable.DestroyArray(datas)
      if self.staticData.redPacketType == RedPacketType.SYS then
        self.hint:SetActive(true)
      else
        self.hint:SetActive(false)
      end
    else
      self.rewardPanel:SetActive(false)
      self.itemNumArea:SetActive(true)
      self.owned:SetActive(true)
      self.hint:SetActive(false)
    end
  end
  self:InitChannelInfo()
  self:SetSendBtnState(not self.staticData.target or self.staticData.target == TargetEnum.NONE)
end

function RedPacketSendView:InitData()
  self.itemData = self.viewdata and self.viewdata.viewdata
  self.data = self.itemData and self.itemData.redPacketData
  self.curRedPacketId = self.data and self.data.staticId
  self.staticData = Table_RedPacket[self.curRedPacketId]
  self.curChannel = ChatRoomProxy.Instance:GetChatRoomChannel()
end

function RedPacketSendView:OnEnter()
  self:InitView()
  self:sendNotification(ChatRoomEvent.OnRedPacketSendViewEnter)
end

function RedPacketSendView:OnExit()
  PictureManager.Instance:UnloadReturnActivityTexture(decorationBg, self.decoration)
  PictureManager.Instance:UnloadReturnActivityTexture(bg1Name, self.bg1)
  PictureManager.Instance:UnloadReturnActivityTexture(bg5Name, self.bg5)
  self:sendNotification(ChatRoomEvent.OnRedPacketSendViewExit)
end

function RedPacketSendView:OnMessageSelected(message)
  self.messageLabel.text = message
  self:HideDropdownPanel()
  self.dropArrow.flip = 2
end

function RedPacketSendView:SetItemNum(num)
  self.itemNum = num
  self.itemNumInput.value = self.itemNum
  self:SetNumText(self.itemNumLabel, num)
end

function RedPacketSendView:SetRedPacketNum(num)
  self.redPacketNum = num
  self.redPacketNumInput.value = self.redPacketNum
  self:SetNumText(self.redPacketNumLabel, num)
end

function RedPacketSendView:SetButtonEnabled(button, enable)
  local sp = button:GetComponent(UISprite)
  local collider = button:GetComponent(BoxCollider)
  if enable then
    sp.alpha = 1
    collider.enabled = true
  else
    sp.alpha = 0.5
    collider.enabled = false
  end
end

function RedPacketSendView:OnDropdownBtnClick()
  self:ShowDropdownPanel()
  self.dropArrow.flip = 0
end

function RedPacketSendView:OnItemNumPlusPress(isPressed)
  if not self.staticData then
    return
  end
  if isPressed then
    local num = self.itemNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnPlusUpdate(NumType.ITEM, self.itemNumPlusBtn, self.itemNumMinusBtn, num, self.data.maxMoneyLimit)
    end, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function RedPacketSendView:OnItemNumMinusPress(isPressed)
  if not self.staticData then
    return
  end
  if isPressed then
    local num = self.itemNum
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnMinusUpdate(NumType.ITEM, self.itemNumPlusBtn, self.itemNumMinusBtn, num, self.data.minMoneyLimit)
    end, self, 2)
  else
    TimeTickManager.Me():ClearTick(self, 2)
  end
end

function RedPacketSendView:OnRedPacketNumPlusPress(isPressed)
  if not self.staticData then
    return
  end
  if isPressed then
    local num = self.redPacketNum
    local maxNumLimit = self:GetMaxRedPacketNum(self.targetNum)
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnPlusUpdate(NumType.REDPACKET, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, num, maxNumLimit)
    end, self, 3)
  else
    TimeTickManager.Me():ClearTick(self, 3)
  end
end

function RedPacketSendView:OnRedPacketNumMinusPress(isPressed)
  if not self.staticData then
    return
  end
  if isPressed then
    local num = self.redPacketNum
    local minNumLimit = self:GetMinRedPacketNum(self.targetNum)
    TimeTickManager.Me():CreateTick(0, 100, function(owner, deltaTime)
      self:OnMinusUpdate(NumType.REDPACKET, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, num, minNumLimit)
    end, self, 4)
  else
    TimeTickManager.Me():ClearTick(self, 4)
  end
end

function RedPacketSendView:OnPlusUpdate(type, plusButton, minusButton, originNum, max)
  local num = type == NumType.ITEM and self.itemNum or self.redPacketNum
  if num >= originNum + 10 and num < originNum + 20 then
    num = self:AddNum(num, 1, 2, max)
  elseif num >= originNum + 20 then
    num = self:AddNum(num, 1, 10, max)
  else
    num = self:AddNum(num, 1, 1, max)
  end
  if type == NumType.ITEM then
    self:SetItemNum(num)
  else
    self:SetRedPacketNum(num)
  end
  if max <= num then
    self:SetButtonEnabled(plusButton, false)
  else
    self:SetButtonEnabled(plusButton, true)
  end
  self:SetButtonEnabled(minusButton, true)
end

function RedPacketSendView:OnMinusUpdate(type, plusButton, minusButton, originNum, min)
  local num = type == NumType.ITEM and self.itemNum or self.redPacketNum
  if num > originNum - 20 and num <= originNum - 10 then
    num = self:ReduceNum(num, 1, 2, min)
  elseif num <= originNum - 20 then
    num = self:ReduceNum(num, 1, 10, min)
  else
    num = self:ReduceNum(num, 1, 1, min)
  end
  if type == NumType.ITEM then
    self:SetItemNum(num)
  else
    self:SetRedPacketNum(num)
  end
  if min >= num then
    self:SetButtonEnabled(minusButton, false)
  else
    self:SetButtonEnabled(minusButton, true)
  end
  self:SetButtonEnabled(plusButton, true)
end

function RedPacketSendView:AddNum(num, step, ratio, maxLimit)
  num = num + step * ratio
  num = math.min(num, maxLimit)
  return num
end

function RedPacketSendView:ReduceNum(num, step, ratio, minLimit)
  num = num - step * ratio
  num = math.max(num, minLimit)
  return num
end

function RedPacketSendView:OnItemNumInputChange()
  if not self.staticData then
    return
  end
  local min = self.data.minMoneyLimit
  local max = self.data.maxMoneyLimit
  self:OnInputChange(NumType.ITEM, self.itemNumInput, self.itemNumPlusBtn, self.itemNumMinusBtn, min, max)
end

function RedPacketSendView:OnRedPacketNumInputChange()
  if not self.staticData then
    return
  end
  local min = self:GetMinRedPacketNum(self.targetNum)
  local max = self:GetMaxRedPacketNum(self.targetNum)
  self:OnInputChange(NumType.REDPACKET, self.redPacketNumInput, self.redPacketNumPlusBtn, self.redPacketNumMinusBtn, min, max)
end

function RedPacketSendView:OnInputChange(type, input, plusBtn, minusBtn, min, max)
  local value = tonumber(input.value)
  if not value then
    return
  end
  value = math.clamp(value, min, max)
  if type == NumType.ITEM then
    self:SetItemNum(value)
  else
    self:SetRedPacketNum(value)
  end
  if max <= value then
    self:SetButtonEnabled(plusBtn, false)
  else
    self:SetButtonEnabled(plusBtn, true)
  end
  if min >= value then
    self:SetButtonEnabled(minusBtn, false)
  else
    self:SetButtonEnabled(minusBtn, true)
  end
end

function RedPacketSendView:SetSendBtnState(state)
  self.sendBtn:SetActive(state)
  self.sendBtnDisable:SetActive(not state)
end

function RedPacketSendView:OnSendBtnClick()
  MsgManager.DontAgainConfirmMsgByID(42081, function()
    if self.staticData.moneyID and self.staticData.redPacketType == RedPacketType.USER then
      local myItemNum = 0
      local ref = GameConfig.Wallet.MoneyRef[self.staticData.moneyID]
      if ref then
        myItemNum = Game.Myself.data.userdata:Get(UDEnum[ref])
      else
        myItemNum = BagProxy.Instance:GetItemNumByStaticID(self.staticData.moneyID)
      end
      if myItemNum < self.itemNum then
        MsgManager.ShowMsgByID(42078)
        return
      end
    end
    local message
    if self.staticData.hideContext == 1 then
      if self.staticData.target == TargetEnum.GUILDMEMBER then
        message = string.format(self.staticData.context[1], self.itemData.staticData.NameZh, self.channelLabel.text)
      elseif self.staticData.target == TargetEnum.GUILDJOB then
        local myMemberData = GuildProxy.Instance.myGuildData:GetMemberByGuid(Game.Myself.data.id)
        message = string.format(self.staticData.context[1], myMemberData:GetJobName(), self.itemData.staticData.NameZh, self.channelLabel.text)
      end
    else
      message = self.messageLabel.text
    end
    local data = ReusableTable.CreateTable()
    data.redPacketCFGID = self.curRedPacketId
    data.str = message
    data.totalMoney = self.itemNum
    data.totalNum = self.redPacketNum
    data.channel = self.curChannel
    data.target_id = self.targetId
    data.guild_job = self.targetJob
    ServiceChatCmdProxy.Instance:CallSendRedPacketCmd(data, self.itemData.id)
    ReusableTable.DestroyAndClearTable(data)
    self:CloseSelf()
  end)
end

function RedPacketSendView:ShowDropdownPanel()
  self.dropdown:SetActive(true)
end

function RedPacketSendView:HideDropdownPanel()
  self.dropdown:SetActive(false)
end

function RedPacketSendView:SetNumText(label, num)
  label.text = StringUtil.NumThousandFormat(num)
end

function RedPacketSendView:InitChannelInfo()
  if self.staticData.target and self.staticData.target ~= TargetEnum.NONE then
    self.channelLabel.pivot = UIWidget.Pivot.Left
    local _, color = ColorUtil.TryParseHexString("bfb8a3")
    self.channelLabel.color = color
    self.channelArrow.gameObject:SetActive(true)
    if self.curChannel == ChatChannelEnum.Private and self.staticData.target == TargetEnum.FRIEND then
      self.channelLabel.text = ZhString.RedPacket_ChooseFriend
    elseif self.curChannel == ChatChannelEnum.Guild or self.curChannel == ChatChannelEnum.GVG then
      if self.staticData.target == TargetEnum.GUILDJOB then
        self.channelLabel.text = ZhString.RedPacket_ChooseGuildJob
      elseif self.staticData.target == TargetEnum.GUILDMEMBER then
        self.channelLabel.text = ZhString.RedPacket_ChooseGuildMember
      end
    end
  else
    self.channelLabel.text = ChannelName[self.curChannel]
    self.channelLabel.pivot = UIWidget.Pivot.Center
    local _, color = ColorUtil.TryParseHexString("674425")
    self.channelLabel.color = color
    self.channelArrow.gameObject:SetActive(false)
  end
end

function RedPacketSendView:OnChannelBtnClick()
  if not self.staticData.target or self.staticData.target == TargetEnum.NONE then
    return
  end
  self.channelArrow.flip = 2
  self:ShowReceiverPanel(self.curChannel)
end

function RedPacketSendView:ShowReceiverPanel(channel)
  TweenPosition.Begin(self.anchorLeft, 0.1, LuaGeometry.GetTempVector3(-241, 0, 0)):SetOnFinished(function()
    if not self.receiverSubView then
      self.receiverSubView = self:AddSubView("RedPacketReceiverListPage", RedPacketReceiverListPage)
      self.receiverSubView:AddEventListener(RedPacketEvent.OnChooseReceiver, self.OnReceiverSelected, self)
      self.receiverSubView:AddEventListener(RedPacketEvent.OnReceiverListPageClose, self.OnReceiverClosed, self)
    end
    self.receiverSubView:Show(channel, self.staticData.target)
  end)
end

function RedPacketSendView:OnClickItem(cell)
  local data = cell.data
  if not data then
    return
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = {
      cell.gameObject
    }
  }
  self:ShowItemTip(sdata, cell:GetBgSprite(), NGUIUtil.AnchorSide.Left, {-200, 0})
end

function RedPacketSendView:OnReceiverSelected(cell)
  if not cell.data then
    return
  end
  self.targetId = cell.id
  self.targetJob = cell.job
  self.targetNum = cell.num
  self.channelLabel.text = cell.data.name
  self.curChannel = cell.data.channel or self.curChannel
  local colorStr = ChannelNameColor[self.curChannel]
  if self.staticData.target == TargetEnum.GUILDMEMBER then
    colorStr = ChannelNameColor[ChatChannelEnum.Private]
  end
  local _, color = ColorUtil.TryParseHexString(colorStr)
  self.channelLabel.color = color
  local num = self:GetMaxRedPacketNum(self.targetNum)
  self:SetRedPacketNum(num)
  self:SetButtonEnabled(self.redPacketNumPlusBtn, false)
  self:SetSendBtnState(true)
end

function RedPacketSendView:OnReceiverClosed()
  TweenPosition.Begin(self.anchorLeft, 0.1, LuaGeometry.GetTempVector3(0, 0, 0))
  self.channelArrow.flip = 0
end

function RedPacketSendView:GetMaxRedPacketNum(memberNum)
  if not self.data.multiItems or #self.data.multiItems == 0 then
    return self.data.maxNumLimit
  else
    local totalItemNum = 0
    for i = 1, #self.data.multiItems do
      totalItemNum = totalItemNum + self.data.multiItems[i].group_count
    end
    local staticMaxNum = self.staticData.totalNumLimit[2]
    if memberNum then
      return math.min(math.min(staticMaxNum, totalItemNum), memberNum)
    else
      return math.min(staticMaxNum, totalItemNum)
    end
  end
end

function RedPacketSendView:GetMinRedPacketNum(memberNum)
  if not self.data.multiItems or #self.data.multiItems == 0 then
    return self.data.minNumLimit
  else
    local maxRedPacketNum = self:GetMaxRedPacketNum(memberNum)
    local staticMinNum = self.staticData.totalNumLimit[1]
    if memberNum then
      return math.min(math.min(staticMinNum, memberNum), maxRedPacketNum)
    else
      return math.min(staticMinNum, maxRedPacketNum)
    end
  end
end

local dropdownCellPrefab = "RedPacketContextCell"
DropdownMessageView = class("DropdownMessageView", SubView)
local maxBgHeight = 176

function DropdownMessageView:Init()
  self.children = {}
  self:FindObjs()
end

function DropdownMessageView:FindObjs()
  self.grid = self:FindComponent("grid", UIGrid)
  self.bg = self:FindComponent("bg", UISprite, self.container.dropdown)
end

function DropdownMessageView:OnExit()
  TableUtility.ArrayClearByDeleter(self.children, function(child)
    Game.GOLuaPoolManager:AddToUIPool(dropdownCellPrefab, child)
  end)
end

function DropdownMessageView:InitView(data)
  if not data then
    return
  end
  if data.context then
    local bgHeight = 0
    for i = 1, #data.context do
      local message = data.context[i]
      local child = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(dropdownCellPrefab), self.grid.gameObject)
      if child then
        local label = child:GetComponent(UILabel)
        local selectLabel = self:FindComponent("selectMsg", UILabel, child)
        label.text = message
        selectLabel.text = message
        self:AddClickEvent(child, function()
          self:OnContextClick(i)
        end)
        self.children[i] = child
        bgHeight = bgHeight + label.height
      end
    end
    self.grid:Reposition()
    bgHeight = math.min(bgHeight, maxBgHeight)
    self.bg.height = bgHeight
  end
end

function DropdownMessageView:OnContextClick(index)
  local child = self.children[index]
  local selectMsg = child:GetComponent(UILabel).text
  self.container:OnMessageSelected(selectMsg)
end
