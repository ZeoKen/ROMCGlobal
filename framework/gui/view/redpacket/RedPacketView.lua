autoImport("RedPacketRewardItemCell")
autoImport("RedPacketDetailPage")
RedPacketView = class("RedPacketView", ContainerView)
RedPacketView.ViewType = UIViewType.PopUpLayer
local historyInfoCellPrefab = "RedPacketHistoryInfoCell"
local grabBgName = "returnactivity_bg_red_06"
local decorationBgName = "returnactivity_bg_boli_02"
local restAreaMaxWidth = 110
local rewardLabelPosX = 222

function RedPacketView:Init()
  self:FindObjs()
  self:AddEventListener()
  self.curRedPacketId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.redPacketId
  self.senderId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.senderId
  self.senderName = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.senderName
  self.historyInfos = {}
end

function RedPacketView:FindObjs()
  self.grabPanel = self:FindGO("grab")
  self.historyPanel = self:FindGO("history")
  self.anchorRight = self:FindGO("AnchorRight")
  self.grabBg = self.grabPanel:GetComponent(UITexture)
  self.senderLabel = self:FindComponent("senderName", UILabel, self.grabPanel)
  self.grabBtn = self:FindGO("grabBtn")
  self.grabLabel = self:FindGO("grabLabel", self.grabBtn)
  self.receivedLabel = self:FindGO("receivedLabel", self.grabBtn)
  self.overLabel = self:FindGO("overLabel", self.grabBtn)
  self:AddClickEvent(self.grabBtn, function()
    self:OnGrabBtnClick()
  end)
  self:AddButtonEvent("closeCollider", function()
    self:CloseSelf()
  end)
  self.blessed = self:FindGO("blessed", self.grabPanel)
  self.receivedTitle = self:FindGO("title", self.historyPanel)
  self.notReceivedTitle = self:FindGO("title2", self.historyPanel)
  self.notReceivedTitleLabel = self.notReceivedTitle:GetComponent(UILabel)
  self.decoration = self:FindComponent("decoration", UITexture, self.historyPanel)
  self.timer = self:FindComponent("timer", UILabel, self.historyPanel)
  self.regularArea = self:FindGO("regular")
  self.grabNumGo = self:FindGO("grabNum", self.historyPanel)
  self.grabNumLabel = self.grabNumGo:GetComponent(UILabel)
  self.grabIcon = self:FindComponent("icon", UISprite, self.grabNumGo)
  self.redPacketNumLabel = self:FindComponent("redPacketNum", UILabel, self.regularArea)
  self.grid = self:FindComponent("grid", UIGrid, self.regularArea)
  self.restArea = self:FindGO("restArea")
  self.restAreaContainer = self:FindGO("Container", self.restArea)
  self.restIcon = self:FindComponent("icon", UISprite, self.restArea)
  self.restNumLabel = self:FindComponent("num", UILabel, self.restArea)
  self.rewardArea = self:FindGO("reward")
  self.rewardPanel = self:FindGO("rewardPanel", self.rewardArea)
  local rewardGrid = self:FindComponent("Grid", UIGrid, self.rewardPanel)
  self.rewardListCtrl = UIGridListCtrl.new(rewardGrid, RedPacketRewardItemCell, "RedPacketRewardItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.redPacketNumLabel2 = self:FindComponent("redPacketNum", UILabel, self.rewardArea)
  self.info2 = self:FindGO("info2", self.rewardArea)
  self.grid2 = self:FindComponent("grid", UIGrid, self.info2)
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  self.info3 = self:FindGO("info3", self.rewardArea)
  self.grid3 = self:FindComponent("grid", UIGrid, self.info3)
  self.detailBtn = self:FindGO("detailBtn")
  self:AddClickEvent(self.detailBtn, function()
    self:ShowDetailPanel()
  end)
  self.timer.gameObject:SetActive(false)
  self.rewardEmptyHint = self:FindGO("rewardEmpty")
  self.emptyHintLabel = self:FindComponent("Label", UILabel, self.rewardEmptyHint)
end

function RedPacketView:AddEventListener()
  self:AddListenEvt(ServiceEvent.ChatCmdReceiveRedPacketRet, self.OnChatCmdReceiveRedPacketRet)
end

function RedPacketView:OnChatCmdReceiveRedPacketRet(note)
  local data = note.body
  if not data.bRedPacketExist then
    redlog("redPacket not exist!!!")
    return
  end
  if data.bRedPacketUsable then
    local redPacketContent = RedPacketProxy.Instance:GetRedPacketContent(self.curRedPacketId)
    if redPacketContent then
      local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
      if redPacketConfig and redPacketConfig.thanksContext and redPacketConfig.thanksContext ~= _EmptyTable then
        local channel = ChatRoomProxy.Instance:GetChatRoomChannel()
        local contextIndex = math.random(1, #redPacketConfig.thanksContext)
        local context = redPacketConfig.thanksContext[contextIndex]
        ServiceChatCmdProxy.Instance:CallChatCmd(channel, context, self.senderId)
      end
    end
  elseif self.isFirstGrab then
    MsgManager.ShowMsgByID(42079)
  end
  self:ShowHistoryPanel()
  self.isFirstGrab = false
end

function RedPacketView:InitView()
  self:ShowGrabPanel()
  PictureManager.Instance:SetReturnActivityTexture(grabBgName, self.grabBg)
  PictureManager.Instance:SetReturnActivityTexture(decorationBgName, self.decoration)
end

function RedPacketView:ShowGrabPanel()
  self.grabPanel:SetActive(true)
  self.historyPanel:SetActive(false)
  self:InitGrabPanel()
end

function RedPacketView:ShowHistoryPanel()
  self.grabPanel:SetActive(false)
  self.historyPanel:SetActive(true)
  self:InitHistoryPanel()
  if self.isFirstGrab then
    self:sendNotification(ChatRoomEvent.UpdateCurChannel)
  end
end

function RedPacketView:InitGrabPanel()
  if self.senderName then
    self.senderLabel.text = string.format(ZhString.RedPacketSender, self.senderName)
  end
  self:RefreshGrabPanel()
end

function RedPacketView:RefreshGrabPanel()
  local isReceived = RedPacketProxy.Instance:CheckIfReceived(self.curRedPacketId)
  local isRedPacketContentExist = RedPacketProxy.Instance:IsRedPacketContentExist(self.curRedPacketId)
  local isBlessed = RedPacketProxy.Instance:IsMyselfBlessed(self.curRedPacketId)
  if isReceived then
    self.grabLabel:SetActive(false)
    self.receivedLabel:SetActive(true)
    self.overLabel:SetActive(false)
  else
    if isRedPacketContentExist then
      self.grabLabel:SetActive(false)
      self.receivedLabel:SetActive(false)
      self.overLabel:SetActive(true)
    else
      self.grabLabel:SetActive(true)
      self.receivedLabel:SetActive(false)
      self.overLabel:SetActive(false)
      self.isFirstGrab = true
    end
    self.blessed:SetActive(isBlessed)
  end
end

function RedPacketView:InitHistoryPanel()
  local redPacketContent = RedPacketProxy.Instance:GetRedPacketContent(self.curRedPacketId)
  if not redPacketContent then
    return
  end
  local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
  if not redPacketConfig then
    return
  end
  local receivedInfo = RedPacketProxy.Instance:GetReceivedInfo(self.curRedPacketId)
  if receivedInfo then
    self.receivedTitle:SetActive(true)
    self.notReceivedTitle:SetActive(false)
  else
    self.receivedTitle:SetActive(false)
    self.notReceivedTitle:SetActive(true)
    if RedPacketProxy.Instance:IsMyselfQualifiedToReceiveGVGRedPacket(self.curRedPacketId) then
      self.notReceivedTitleLabel.text = ZhString.RedPacket_NoReceived
      self.emptyHintLabel.text = ZhString.RedPacket_RunOut
    else
      self.notReceivedTitleLabel.text = ZhString.RedPacket_CannotReceive
      self.emptyHintLabel.text = ZhString.RedPacket_ReceiveCondition
    end
  end
  local reward = redPacketConfig.reward
  local isReward = false
  local grid
  if reward and 0 < #reward then
    self.regularArea:SetActive(false)
    self.rewardArea:SetActive(true)
    self.detailBtn:SetActive(false)
    self.info2:SetActive(true)
    self.info3:SetActive(false)
    self:SetRewardPanelState(true)
    local datas = ReusableTable.CreateArray()
    for i = 1, #reward do
      local data = ItemData.new("RewardItem", reward[i][1])
      data.num = reward[i][2]
      datas[#datas + 1] = data
    end
    self.rewardListCtrl:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    isReward = true
    grid = self.grid2
  else
    local receiveItems = receivedInfo and receivedInfo.receiveItems
    local multiItems = redPacketConfig.multi_item
    if multiItems and multiItems ~= _EmptyTable then
      self.regularArea:SetActive(false)
      self.rewardArea:SetActive(true)
      self.detailBtn:SetActive(true)
      self.info2:SetActive(false)
      self.info3:SetActive(true)
      isReward = true
      grid = self.grid3
      if receiveItems then
        self:SetRewardPanelState(true)
        local datas = ReusableTable.CreateArray()
        for i = 1, #receiveItems do
          local item = TableUtility.ArrayFindByPredicate(multiItems, function(v, args)
            return v.itemid == args
          end, receiveItems[i].itemid)
          if item then
            local data = ItemData.new("RewardItem", receiveItems[i].itemid)
            data.num = item.item_count * receiveItems[i].group_count
            TableUtility.InsertSort(datas, data, function(l, r)
              local lsData, rsData
              for i = 1, #multiItems do
                if multiItems[i].itemid == l.staticData.id then
                  lsData = multiItems[i]
                elseif multiItems[i].itemid == r.staticData.id then
                  rsData = multiItems[i]
                end
              end
              if lsData and rsData then
                return lsData.order < rsData.order
              end
              return l.staticData.id < r.staticData.id
            end)
          end
        end
        self.rewardListCtrl:ResetDatas(datas)
        ReusableTable.DestroyArray(datas)
      else
        self:SetRewardPanelState(false)
      end
    else
      self.regularArea:SetActive(true)
      self.rewardArea:SetActive(false)
      self.detailBtn:SetActive(false)
      do
        local config = Table_Item[redPacketConfig.moneyID]
        if not config then
          return
        end
        local receivedNum = receivedInfo and receivedInfo.receiveMoney
        self:SetNumText(self.grabNumLabel, receivedNum or 0)
        IconManager:SetItemIcon(config.Icon, self.grabIcon)
        self:SetNumText(self.restNumLabel, redPacketContent.restMoney)
        local offset = restAreaMaxWidth - self.restNumLabel.width
        local pos = self.restAreaContainer.transform.localPosition
        LuaGameObject.SetLocalPositionGO(self.restAreaContainer, pos.x + offset * 0.5, pos.y, pos.z)
        IconManager:SetItemIcon(config.Icon, self.restIcon)
        grid = self.grid
      end
    end
  end
  local restRedPacketNum = redPacketContent.restNum
  local totalRedPacketNum = redPacketContent.totalNum
  self.redPacketNumLabel.text = string.format("%s/%s", totalRedPacketNum - restRedPacketNum, totalRedPacketNum)
  self.redPacketNumLabel2.text = string.format("%s/%s", totalRedPacketNum - restRedPacketNum, totalRedPacketNum)
  self:InitHistoryInfo(redPacketContent, isReward, grid)
end

function RedPacketView:SetRewardPanelState(active)
  self.rewardPanel:SetActive(active)
  self.rewardEmptyHint:SetActive(not active)
end

function RedPacketView:OnEnter()
  self:InitView()
end

function RedPacketView:OnExit()
  TableUtility.ArrayClearByDeleter(self.historyInfos, function(child)
    Game.GOLuaPoolManager:AddToUIPool(historyInfoCellPrefab, child)
  end)
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnloadReturnActivityTexture(grabBgName, self.grabBg)
  PictureManager.Instance:UnloadReturnActivityTexture(decorationBgName, self.decoration)
end

function RedPacketView:OnGrabBtnClick()
  local channel = ChatRoomProxy.Instance:GetChatRoomChannel()
  ServiceChatCmdProxy.Instance:CallReceiveRedPacketCmd(self.curRedPacketId, self.senderId, channel)
  UIEventListener.Get(self.grabBtn).onClick = nil
end

function RedPacketView:InitHistoryInfo(redPacketContent, isReward, grid)
  local infos = redPacketContent.receivedInfos
  local redPacketConfig = Table_RedPacket[redPacketContent.redPacketCFGID]
  if not redPacketConfig then
    return
  end
  local config = Table_Item[redPacketConfig.moneyID]
  if not isReward and not config then
    return
  end
  local multiItems = redPacketConfig.multi_item
  local receivedInfoMultiItemsSortFunc = function(l, r)
    local lsData, rsData
    for i = 1, #multiItems do
      if multiItems[i].itemid == l.itemid then
        lsData = multiItems[i]
      elseif multiItems[i].itemid == r.itemid then
        rsData = multiItems[i]
      end
    end
    if lsData and rsData then
      return lsData.order < rsData.order
    end
    return l.itemid < r.itemid
  end
  for i = 1, #infos do
    local info = infos[i]
    local child = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(historyInfoCellPrefab), grid.gameObject)
    if child then
      local nameLabel = self:FindComponent("name", UILabel, child)
      local icon = self:FindComponent("icon", UISprite, child)
      local numLabel = self:FindComponent("num", UILabel, child)
      local moneyGo = self:FindGO("money", child)
      local rewardLabel = self:FindComponent("rewardLabel", UILabel, child)
      nameLabel.text = info.receivedName
      if isReward then
        moneyGo:SetActive(false)
        rewardLabel.gameObject:SetActive(true)
        if info.multi_items and #info.multi_items > 0 then
          local rewardTxt = ""
          table.sort(info.multi_items, receivedInfoMultiItemsSortFunc)
          for j = 1, #info.multi_items do
            local item = info.multi_items[j]
            local sData = Table_Item[item.itemid]
            local config = TableUtility.ArrayFindByPredicate(multiItems, function(v, args)
              return v.itemid == args
            end, item.itemid)
            local itemName = sData.NameZh
            local itemNum = config.item_count * item.group_count
            if config.highlight == 1 then
              itemName = "[c][e34f06]" .. itemName .. "[-][/c]"
            end
            rewardTxt = rewardTxt .. itemName .. "x" .. itemNum .. " "
          end
          rewardLabel.text = rewardTxt
          local pos = rewardLabel.transform.localPosition
          LuaGameObject.SetLocalPositionGO(rewardLabel.gameObject, rewardLabelPosX, pos.y, pos.z)
        end
      else
        moneyGo:SetActive(true)
        rewardLabel.gameObject:SetActive(false)
        IconManager:SetItemIcon(config.Icon, icon)
        self:SetNumText(numLabel, info.receivedMoney)
      end
      self.historyInfos[i] = child
    end
  end
  grid:Reposition()
end

function RedPacketView:UpdateRestTimer(restTime)
  if restTime <= 0 then
    TimeTickManager.Me():ClearTick(self)
    restTime = 0
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(restTime)
  self.timer.text = string.format("%02d:%02d", min, sec)
end

function RedPacketView:SetNumText(label, num)
  label.text = StringUtil.NumThousandFormat(num)
end

function RedPacketView:OnClickItem(cell)
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

function RedPacketView:ShowDetailPanel()
  local content = RedPacketProxy.Instance:GetRedPacketContent(self.curRedPacketId)
  TweenPosition.Begin(self.historyPanel, 0.1, LuaGeometry.GetTempVector3(-241, -21, 0)):SetOnFinished(function()
    if not self.detailSubView then
      self.detailSubView = self:AddSubView("RedPacketDetailPage", RedPacketDetailPage, {
        content.redPacketCFGID,
        content.restMultiItems,
        self.curRedPacketId
      })
      self.detailSubView:AddEventListener(RedPacketEvent.OnDetailPageClose, self.OnReceiverClosed, self)
    end
    self.detailSubView:Show()
  end)
end

function RedPacketView:OnReceiverClosed()
  TweenPosition.Begin(self.historyPanel, 0.1, LuaGeometry.GetTempVector3(0, -21, 0))
end
