autoImport("RedPacketSendView")
GVGRedPacketSendView = class("GVGRedPacketSendView", RedPacketSendView)
GVGRedPacketSendView.ViewType = UIViewType.PopUpLayer
local RedPacketType = {SYS = 1, USER = 2}
local TargetEnum = {
  NONE = 0,
  FRIEND = 1,
  GUILDMEMBER = 2,
  GUILDJOB = 3
}
local decorationBg = "returnactivity_bg_boli_02"
local bg1Name = "returnactivity_bg_red_01"
local bg5Name = "returnactivity_bg_red_05"

function GVGRedPacketSendView:Init()
  self:AddEvts()
  self:FindObjs()
  self:InitData()
end

function GVGRedPacketSendView:AddEvts()
  self:AddListenEvt(RedPacketEvent.OnBlessConfirm, self.OnBlessConfirm)
  self:AddListenEvt(RedPacketEvent.OnBlessCancel, self.OnBlessCancel)
end

function GVGRedPacketSendView:FindObjs()
  self.anchorLeft = self:FindGO("AnchorLeft")
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  local helpBtn = self:FindGO("helpBtn")
  self:RegistShowGeneralHelpByHelpID(35096, helpBtn)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.bg1 = self:FindComponent("bg1", UITexture)
  self.bg5 = self:FindComponent("bg5", UITexture)
  self.decoration = self:FindComponent("decoration", UITexture)
  local channelArea = self:FindGO("channelArea")
  self.channelLabel = self:FindComponent("channel", UILabel, channelArea)
  self.channelArrow = self:FindComponent("arrow", UISprite, channelArea)
  self.redPacketNumLabel = self:FindComponent("redPacketNum", UILabel)
  self.redPacketNumPlusBtn = self:FindGO("plusBtn")
  self.redPacketNumMinusBtn = self:FindGO("minusBtn")
  self.rewardPanel = self:FindGO("rewardPanel")
  self.rewardScrollView = self.rewardPanel:GetComponent(UIScrollView)
  local grid = self:FindComponent("Grid", UIGrid, self.rewardPanel)
  self.rewardGrid = grid
  self.rewardListCtrl = UIGridListCtrl.new(grid, RedPacketRewardItemCell, "RedPacketRewardItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.sendBtn = self:FindGO("sendBtn")
  self.sendBtnDisable = self:FindGO("sendBtnDisable")
  self:AddClickEvent(self.sendBtn, function()
    self:OnSendBtnClick()
  end)
  self:AddClickEvent(self.sendBtnDisable, function()
    MsgManager.ShowMsgByID(2670)
  end)
  self.hint = self:FindGO("hint")
  local blessArea = self:FindGO("blessArea")
  self:AddClickEvent(blessArea, function()
    self:OnBlessClick()
  end)
  self.blessLabel = self:FindComponent("bless", UILabel, blessArea)
  self.blessArrow = self:FindGO("arrow", blessArea)
end

function GVGRedPacketSendView:InitData()
  GVGRedPacketSendView.super.InitData(self)
  local config = GvgProxy.GetStrongHoldStaticData(self.data.gvg_cityid)
  local cityType = config and config.CityType or 0
  local cityData = GameConfig.GvgNewConfig.citytype_data[cityType]
  self.maxBlessNum = cityData and cityData.praise_red_packet_cnt or 0
  local playerNum = self.data.gvg_charids and #self.data.gvg_charids or 0
  self.maxBlessNum = math.min(self.maxBlessNum, playerNum)
  self.curBlessNum = 0
end

function GVGRedPacketSendView:InitView()
  self:SetButtonEnabled(self.redPacketNumPlusBtn, false)
  self:SetButtonEnabled(self.redPacketNumMinusBtn, false)
  PictureManager.Instance:SetReturnActivityTexture(decorationBg, self.decoration)
  PictureManager.Instance:SetReturnActivityTexture(bg1Name, self.bg1)
  PictureManager.Instance:SetReturnActivityTexture(bg5Name, self.bg5)
  self.isRegular = false
  self.titleLabel.text = ZhString.RedPacket_Random
  local maxRedPacketNum = RedPacketProxy.Instance:GetGVGNewMaxRedPacketNum()
  local gvgPlayerNum = self.data.gvg_charids and #self.data.gvg_charids or 0
  local multiItems = self.staticData.multi_item
  if multiItems then
    local datas = ReusableTable.CreateArray()
    for i = 1, #multiItems do
      local rawNum = RedPacketProxy.Instance:GetGVGNewRedPacketMultiItemRawNum(gvgPlayerNum, self.maxBlessNum, maxRedPacketNum, multiItems[i].item_count, multiItems[i].group_count)
      if 0 < rawNum then
        local data = ItemData.new("RewardItem", multiItems[i].itemid)
        data.num = rawNum
        datas[#datas + 1] = data
      end
    end
    if #datas <= 3 then
      self.rewardScrollView.contentPivot = UIWidget.Pivot.Center
      self.rewardGrid.pivot = UIWidget.Pivot.Center
    else
      self.rewardScrollView.contentPivot = UIWidget.Pivot.TopLeft
      self.rewardGrid.pivot = UIWidget.Pivot.TopLeft
    end
    self.rewardListCtrl:ResetDatas(datas)
    self.rewardListCtrl:ResetPosition()
    ReusableTable.DestroyArray(datas)
    if self.staticData.redPacketType == RedPacketType.SYS then
      self.hint:SetActive(true)
    else
      self.hint:SetActive(false)
    end
  end
  self:InitChannelInfo()
  self:UpdateBlessInfo()
  self:SetRedPacketNum(gvgPlayerNum)
end

function GVGRedPacketSendView:OnExit()
  GVGRedPacketSendView.super.OnExit(self)
  RedPacketProxy.Instance:ClearBlessSelectState(self.curRedPacketId)
end

function GVGRedPacketSendView:UpdateBlessInfo()
  local str, colorStr
  if self.maxBlessNum > 0 then
    if self.curBlessNum == 0 then
      str = ZhString.RedPacket_BlessNotSet
      colorStr = "989898"
    else
      str = self.curBlessNum .. "/" .. self.maxBlessNum
      colorStr = "674425"
    end
  else
    str = self.maxBlessNum
    colorStr = "989898"
  end
  self.blessLabel.text = str
  local _, c = ColorUtil.TryParseHexString(colorStr)
  self.blessLabel.color = c
  self.blessArrow:SetActive(self.maxBlessNum > 0)
  self:SetSendBtnState(self.maxBlessNum == self.curBlessNum)
end

function GVGRedPacketSendView:SetRedPacketNum(num)
  self.redPacketNum = num
  self:SetNumText(self.redPacketNumLabel, num)
end

function GVGRedPacketSendView:OnBlessClick()
  if self.maxBlessNum > 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GVGGuildLeaderBlessView,
      viewdata = {
        redPacketId = self.curRedPacketId,
        maxBlessNum = self.maxBlessNum,
        curBlessNum = self.curBlessNum
      }
    })
  end
end

function GVGRedPacketSendView:OnBlessConfirm(note)
  self.blessedCharIds = note.body
  self.curBlessNum = self.blessedCharIds and #self.blessedCharIds or 0
  self:UpdateBlessInfo()
end

function GVGRedPacketSendView:OnBlessCancel()
  self.curBlessNum = 0
  self:UpdateBlessInfo()
end

function GVGRedPacketSendView:OnSendBtnClick()
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
      elseif not self.staticData.target then
        message = self.staticData.context[1]
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
    data.praise_charids = self.blessedCharIds
    ServiceChatCmdProxy.Instance:CallSendRedPacketCmd(data, self.itemData.id)
    ReusableTable.DestroyAndClearTable(data)
    self:CloseSelf()
  end)
end
