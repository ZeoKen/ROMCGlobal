PostView = class("MainView", ContainerView)
PostView.ViewType = UIViewType.NormalLayer
autoImport("PostCell")
autoImport("PostItemCell")
PostView.ClickCell = "PostView_ClickCell"
PostView.ColorCfg = {
  {
    spriteName = "new-com_btn_red",
    effectColor = LuaColor.New(0.7019607843137254, 0.2549019607843137, 0.2549019607843137),
    zhstring = ZhString.Post_Delete
  },
  {
    spriteName = "new-com_btn_c",
    effectColor = LuaColor.New(0.7686274509803922, 0.5254901960784314, 0),
    zhstring = ZhString.Post_Receive
  }
}
PostView.Gray = {
  spriteName = "new-com_btn_a_gray",
  effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
}
local SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
local Fixed_YAxis_Value = 84
local Fixed_XAxis_Value = 280

function PostView:Init()
  self:InitPostTrackData()
  self:FindObj()
  self:AddUIEvts()
  self:InitUI()
  self:AddViewInterest()
  self:InitFilter()
  self:RefreshPostView(true)
  self:UpdatePostCount()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function PostView:InitFilter()
  if not self.rangeList then
    self.rangeList = PostProxy.Instance:GetFilter()
    for i = 1, #self.rangeList do
      local rangeData = GameConfig.PostFilter[self.rangeList[i]]
      self.postFilter:AddItem(rangeData, self.rangeList[i])
    end
  end
  if #self.rangeList > 0 then
    local range = self.rangeList[1]
    self.areaFilterData = range
    local rangeData = GameConfig.PostFilter[range]
    self.postFilter.value = rangeData
  end
end

function PostView:InitUI()
  self:Hide(self.delPos)
  self.postCountTip = self:FindComponent("UnreadTip", UILabel)
  self.postCountTipBg = self:FindComponent("UnreadTipBg", UIWidget)
  local postContainer = self:FindGO("PostContainer")
  local wrapConfig = {
    wrapObj = postContainer,
    cellName = "PostCell",
    control = PostCell,
    pfbNum = 5
  }
  self.postWrapHelper = WrapCellHelper.new(wrapConfig)
  self.postWrapHelper:AddEventListener(PostView.ClickCell, self.OnClickPostCell, self)
  local grid = self:FindComponent("AttachGrid", UIGrid)
  self.attachCtl = UIGridListCtrl.new(grid, PostItemCell, "PostItemCell")
  self:DelModel(false)
end

local EMAILBG_TEX = "new_email_bg_decoration_No-mail01"
local EmptyLogo_Cirlce = "new_taskmanual_bg_bottom02"

function PostView:FindObj()
  self.menuBtn = self:FindComponent("MenuBtn", UISprite)
  self.receiveAllBtn = self:FindComponent("ReceiveAllBtn", UISprite)
  self.receiveAllLab = self:FindComponent("Label", UIWidget, self.receiveAllBtn.gameObject)
  self.delPos = self:FindGO("DelPos")
  self.confirmDelBtn = self:FindGO("ConfirmDelBtn", self.delPos)
  self.returnBtn = self:FindGO("ReturnBtn", self.delPos)
  self.chooseAllToggle = self:FindComponent("ChooseAllToggle", UISprite, self.delPos)
  self.infoPos = self:FindGO("InfoPos")
  self.postName = self:FindComponent("PostName", UILabel, self.infoPos)
  self.attachFixedLab = self:FindComponent("AttachFixedLab", UILabel, self.infoPos)
  self.attachFixedLab.text = ZhString.Post_AttachFixedLab
  self.senderName = self:FindComponent("SenderName", UILabel, self.infoPos)
  self.receiveTime = self:FindComponent("ReceiveTime", UILabel, self.infoPos)
  local postCheckObj = self:FindGO("PostCheckBtn", self.infoPos)
  self.postCheckBtn = postCheckObj:GetComponent(UISprite)
  self.postCheckLab = self:FindComponent("Label", UILabel, postCheckObj)
  self.packSaleBtn = self:FindGO("PackSaleBtn", self.infoPos)
  local saleLab = self:FindComponent("Label", UILabel, self.packSaleBtn)
  saleLab.text = ZhString.Post_Sale
  self.contentScrollview = self:FindComponent("contentScrollView", UIScrollView, self.infoPos)
  local postContentObj = self:FindGO("Content", self.contentScrollview.gameObject)
  self.postContentSL = SpriteLabel.new(postContentObj, nil, nil, nil, true)
  self.clickUrl = postContentObj:GetComponent(UILabelClickUrl)
  
  function self.clickUrl.callback(url)
    if nil ~= tonumber(url) then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.Bag,
        viewdata = {
          autoClickID = tonumber(url)
        }
      })
    else
      self:_AddTrackClickUrlCount()
      ApplicationInfo.OpenUrl(url)
      self:TrackEvent(url)
    end
  end
  
  self.emptyLogo = self:FindGO("EmptyLogo")
  self.emptyCircleLogo = self:FindComponent("EmptyCircle", UITexture, self.emptyLogo)
  self.rightBg = self:FindComponent("RightBg", UITexture)
  self.rightBg1 = self:FindComponent("RightBg1", UITexture, self.rightBg.gameObject)
  self.postviewScrollView = self:FindComponent("PostViewScrollView", UIScrollView)
  self.emptyMailLab = self:FindComponent("EmptyMailLab", UILabel)
  self.emptyMailLab.text = ZhString.Post_Empty
  self.attachScrollView = self:FindComponent("AttachScrollView", UIScrollView)
  PictureManager.Instance:SetUI(EMAILBG_TEX, self.rightBg)
  PictureManager.Instance:SetUI(EMAILBG_TEX, self.rightBg1)
  PictureManager.Instance:SetUI(EmptyLogo_Cirlce, self.emptyCircleLogo)
  self.postFilter = self:FindComponent("PostFilter", UIPopupList)
  self.filterPanel = self:FindGO("filterPanel")
  self.chooseAllBtn = self:FindGO("ChooseAll")
  local fixedAllLabel = self:FindComponent("FixedAllLabel", UILabel)
  fixedAllLabel.text = ZhString.Post_ChooseAll
end

function PostView:SortPost(a, b)
  if a == nil or b == nil then
    return false
  end
  if a.sortID == b.sortID then
    return a.time > b.time
  else
    return a.sortID < b.sortID
  end
end

function PostView:AddUIEvts()
  self:AddClickEvent(self.receiveAllBtn.gameObject, function()
    self:OnClickReceiveAll()
  end)
  self:AddClickEvent(self.menuBtn.gameObject, function()
    self:OnClickMenuBtn()
  end)
  self:AddClickEvent(self.returnBtn, function()
    self:OnClickReturnBtn()
  end)
  self:AddClickEvent(self.confirmDelBtn, function()
    self:OnClickConfirmDel()
  end)
  self:AddClickEvent(self.postCheckBtn.gameObject, function()
    self:OnClickPostCheckBtn()
  end)
  self:AddClickEvent(self.packSaleBtn, function()
    if self.curPost and self.curPost.isPackageMail then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CollectSaleConfirmPopUp,
        viewdata = {
          PackMailId = self.curPost.id,
          PackMailItems = self.curPost.postItems
        }
      })
    end
  end)
  EventDelegate.Add(self.postFilter.onChange, function()
    if not self.postFilter.data then
      return
    end
    if self.areaFilterData ~= self.postFilter.data then
      self:ResetCurPost()
      local allData = PostProxy.Instance:SetFilterData()
      local id = tonumber(self.postFilter.data)
      self.viewDatas = id == 0 and PostProxy.Instance:GetPostArray() or allData[id]
      self.areaFilterData = self.postFilter.data
      self.curFilterValue = self.postFilter.value
      PostProxy.Instance:ResetMultiChoosePosts()
      for i = 1, #self.viewDatas do
        PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
      end
      self:RefreshPostView(true)
      self.postWrapHelper:ResetPosition()
      self.postviewScrollView:ResetPosition()
    end
  end)
  self:AddClickEvent(self.chooseAllToggle.gameObject, function()
    self.chooseAllBtn:SetActive(not self.chooseAllBtn.activeSelf)
    if self.chooseAllBtn.activeSelf then
      PostProxy.Instance:ResetMultiChoosePosts()
      for i = 1, #self.viewDatas do
        PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
      end
    else
      PostProxy.Instance:ResetMultiChoosePosts()
    end
    self.postWrapHelper:ResetDatas(self.viewDatas)
  end)
end

function PostView:AddViewInterest()
  self:AddListenEvt(PostEvent.PostAdd, self.RefreshPostView)
  self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdatePostCount)
  self:AddListenEvt(PostEvent.PostUpdate, self.HandleUpdate)
  self:AddListenEvt(PostEvent.PostDelete, self.HandleDelPost)
  self:AddListenEvt(PostEvent.PostExpire, self.HandleExpire)
  EventManager.Me():AddEventListener(AppStateEvent.Pause, self.OnOpenUrlPause, self)
  EventManager.Me():AddEventListener(AppStateEvent.Focus, self.OnOpenUrlBack2Focus, self)
end

function PostView:OnClickMenuBtn()
  local data = PostProxy.Instance:GetPostArray()
  if not data or #data <= 0 then
    return
  end
  local canDelDatas = PostProxy.Instance:GetAttachPost()
  if #canDelDatas <= 0 then
    MsgManager.ShowMsgByID(33101)
    return
  end
  self:DelModel(true)
  self:ResetCurPost()
  self:RefreshPostView(true)
  PostProxy.Instance:ResetMultiChoosePosts()
  for i = 1, #self.viewDatas do
    PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
  end
  self:RefreshChooseAllBtn()
  self.postWrapHelper:ResetDatas(self.viewDatas)
  self.postviewScrollView:ResetPosition()
end

function PostView:RefreshChooseAllBtn()
  self.chooseAllBtn:SetActive(nil ~= self.viewDatas and 0 ~= #self.viewDatas and #PostProxy.Instance.multiChoosePost == #self.viewDatas)
end

function PostView:OnClickReturnBtn()
  self:DelModel(false)
  self.postFilter.value = GameConfig.PostFilter[0]
  self:UpdateReveiveAllBtn()
end

function PostView:OnClickPostCheckBtn()
  if not self.curPost then
    return
  end
  if self.curPost.isPackageMail then
    ServiceItemProxy.Instance:CallPackMailActionItemCmd(SceneItem_pb.EPACKMAILACTION_GET, self.curPost.id)
    return
  end
  local array = ReusableTable.CreateArray()
  TableUtility.ArrayPushBack(array, self.curPost.id)
  if self.curPost:CheckAttachValid() then
    PostView.CallAttach(array)
  else
    ServiceSessionMailProxy.Instance:CallMailRemove(array)
  end
  ReusableTable.DestroyAndClearArray(array)
end

function PostView:OnClickConfirmDel()
  if #PostProxy.Instance.multiChoosePost <= 0 then
    MsgManager.ShowMsgByID(33102)
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(33100)
  if nil == dont then
    MsgManager.DontAgainConfirmMsgByID(33100, function()
      PostProxy.Instance:RemovePosts()
    end, nil, nil, #PostProxy.Instance.multiChoosePost)
  else
    PostProxy.Instance:RemovePosts()
  end
end

function PostView:OnClickReceiveAll()
  if PostProxy.Instance:CheckAllReceived() or self.DEL_MOD then
    return
  end
  self:_GatherTrackUnreadReceiveCount()
  local mailIDlist = ReusableTable.CreateArray()
  local postDatas = PostProxy.Instance:GetPostArray()
  for i = 1, #postDatas do
    if not postDatas[i]:IsAttachStatus() then
      TableUtility.ArrayPushBack(mailIDlist, postDatas[i].id)
    end
  end
  PostView.CallAttach(mailIDlist)
  ReusableTable.DestroyAndClearArray(mailIDlist)
  ServiceItemProxy.Instance:CallPackMailActionItemCmd(SceneItem_pb.EPACKMAILACTION_GET, 0)
end

function PostView:DelModel(enterDelMod)
  self.DEL_MOD = enterDelMod
  if enterDelMod then
    self.areaFilterData = nil
    self:Show(self.delPos)
    self:Hide(self.filterPanel)
    self.menuBtn.gameObject:SetActive(false)
  else
    self:Hide(self.delPos)
    self:Show(self.filterPanel)
    self.menuBtn.gameObject:SetActive(true)
    PostProxy.Instance:ResetMultiChoosePosts()
  end
  self:ResetCurPost()
  self:ShowMultiBox(enterDelMod)
end

function PostView:ResetCurPost()
  self:SetCurPost(nil)
  local cellCtls = self.postWrapHelper:GetCellCtls()
  for _, cell in pairs(cellCtls) do
    cell:SetChooseId()
  end
end

function PostView:ShowMultiBox(var)
  local cellCtls = self.postWrapHelper:GetCellCtls()
  for _, cell in pairs(cellCtls) do
    cell:ShowMultiBox(var)
  end
end

function PostView:RefreshInfoView()
  local data = self.curPost
  if not data or true == self.DEL_MOD then
    self:Hide(self.infoPos)
    self:Show(self.emptyLogo)
    return
  end
  self:Show(self.infoPos)
  self:Hide(self.emptyLogo)
  self.postName.text = data.title
  if data.isPackageMail then
    local _packageMailMaxCount = 500
    local _, packageMailCount = PostProxy.Instance:GetMailCount()
    self.postContentSL:SetText(string.format(data.msg, _packageMailMaxCount - packageMailCount))
  else
    self.postContentSL:SetText(data.msg)
  end
  if data:IsRealAttach() then
    self:Show(self.receiveTime)
    self.receiveTime.text = string.format(ZhString.Post_ReceiveTime, os.date("%Y-%m-%d", data.attachtime))
  else
    self:Hide(self.receiveTime)
  end
  self.attachScrollView.gameObject:SetActive(data:HasPostItems())
  self.attachFixedLab.gameObject:SetActive(data:HasPostItems())
  self.senderName.text = data.sendername
  if data.isPackageMail then
    self.postCheckBtn.transform.localPosition = LuaGeometry.GetTempVector3(87, -278, 0)
    self.packSaleBtn:SetActive(true)
  else
    self.postCheckBtn.transform.localPosition = LuaGeometry.GetTempVector3(280, -278, 0)
    self.packSaleBtn:SetActive(false)
  end
  local cfg = data:CheckAttachValid() and PostView.ColorCfg[2] or PostView.ColorCfg[1]
  self.postCheckBtn.spriteName = cfg.spriteName
  self.postCheckLab.effectColor = cfg.effectColor
  self.postCheckLab.text = cfg.zhstring
  self:TryGrayCheckBtn()
  self.attachCtl:ResetDatas(data.postItems)
  self.attachScrollView:ResetPosition()
  self.contentScrollview:ResetPosition()
  self.contentScrollview.panel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
  SetLocalPositionGO(self.contentScrollview.gameObject, Fixed_XAxis_Value, Fixed_YAxis_Value, 0)
end

function PostView:RefreshPostView(sort)
  local allPost = PostProxy.Instance:GetPostArray()
  local allData = PostProxy.Instance:SetFilterData()
  local id = tonumber(self.postFilter.data)
  if self.DEL_MOD then
    self.viewDatas = PostProxy.Instance:GetAttachPost()
    PostProxy.Instance:ResetMultiChoosePosts()
    for i = 1, #self.viewDatas do
      PostProxy.Instance:SetMultiChoosePosts(self.viewDatas[i].id)
    end
    self:RefreshChooseAllBtn()
  else
    self.viewDatas = id == 0 and allPost or allData[id]
  end
  if sort then
    table.sort(self.viewDatas, function(a, b)
      return self:SortPost(a, b)
    end)
  end
  local hasMail = #self.viewDatas > 0
  self.postviewScrollView.enabled = hasMail
  self.emptyMailLab.gameObject:SetActive(not hasMail)
  self.postWrapHelper:ResetDatas(self.viewDatas)
  self.postWrapHelper:ResetPosition()
  self:UpdateReveiveAllBtn()
  self:RefreshInfoView()
end

function PostView:UpdateReveiveAllBtn()
  if PostProxy.Instance:CheckAllReceived() or self.DEL_MOD then
    self.receiveAllLab.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
    self.receiveAllLab.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
    self.receiveAllBtn.spriteName = "new-com_btn_a_gray"
  else
    self.receiveAllLab.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
    self.receiveAllLab.color = ColorUtil.NGUIWhite
    self.receiveAllBtn.spriteName = "new-com_btn_c"
  end
end

function PostView:HandleUpdate(note)
  local needSort = note.body
  if needSort then
    self:ResetCurPost()
    self:RefreshPostView(true)
  else
    self.postWrapHelper:ResetDatas(self.viewDatas)
    self:UpdateReveiveAllBtn()
    self:RefreshInfoView()
  end
end

function PostView:HandleExpire(note)
  local mailId = note.body
  if self.curPost and mailId == self.curPost.id then
    self:TryGrayCheckBtn()
  end
end

function PostView:TryGrayCheckBtn()
  if self.curPost and self.curPost:CheckAttachValid() and PostProxy.Instance:IsExpire(self.curPost.id) then
    self.postCheckBtn.spriteName = PostView.Gray.spriteName
    self.postCheckLab.effectColor = PostView.Gray.effectColor
  end
end

function PostView:HandleDelPost()
  self:ResetCurPost()
  self:RefreshPostView(true)
end

local lastDayMailList = {}
local recursiveAskForRenew
local execRenew = function(id)
  LogUtility.Info("execRenew started.")
  local productConf = Table_Deposit[id]
  local productID = productConf.ProductID
  local payFailedCallback = function(str_result)
    LogUtility.Info("Pay Failed")
    PurchaseDeltaTimeLimit.Instance():End(productID)
    recursiveAskForRenew()
  end
  if ApplicationInfo.IsPcWebPay() then
    if productConf.PcEnable == 1 then
      MsgManager.ConfirmMsgByID(43467, function()
        ApplicationInfo.OpenPCRechargeUrl()
      end, nil, nil, nil)
    else
      MsgManager.ShowMsgByID(43466)
    end
    return
  end
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {
      [1] = function(str_result)
        if BranchMgr.IsJapan() then
          local currency = productConf and productConf.Rmb or 0
          ChargeComfirmPanel:ReduceLeft(tonumber(currency))
          NewRechargeProxy.CDeposit:SetFPRFlag2(productID)
          xdlog(NewRechargeProxy.CDeposit:IsFPR(productID))
        end
        EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
        LogUtility.Info("Pay Success")
        recursiveAskForRenew()
      end,
      [2] = payFailedCallback,
      [3] = payFailedCallback,
      [4] = payFailedCallback,
      [5] = payFailedCallback
    }
    FuncPurchase.Instance():Purchase(id, callbacks)
    local interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
    PurchaseDeltaTimeLimit.Instance():Start(productID, interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function recursiveAskForRenew()
  local mail = lastDayMailList[#lastDayMailList]
  if mail then
    local mailid = mail.mailid
    table.remove(lastDayMailList)
    local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(PostProxy.Instance.lastDayMailSingleDepositMap[mailid])
    if info and info.batch_alreadyBought and info.batch_DailyCount > 1 then
      recursiveAskForRenew()
      return
    end
    local depositId = GameConfig.BatchLuckyBagMail[mailid]
    if not ShopProxy.Instance:IsThisItemCanBuyNow(depositId) then
      LogUtility.WarningFormat("Cannot buy monthly Deposit data with mailid = {0} and depositid = {1}", mailid, depositId)
      recursiveAskForRenew()
      return
    end
    LogUtility.InfoFormat("Found Deposit data with mailid = {0} and depositid = {1}", mailid, depositId)
    local monthlyDepositData = Table_Deposit[depositId]
    local id, desc = monthlyDepositData.id, monthlyDepositData.Desc
    MsgManager.ConfirmMsgByID(41492, function()
      execRenew(id)
    end, recursiveAskForRenew, nil, desc)
  end
end

function PostView.CallAttach(ids, skipRenew)
  if skipRenew then
    ServiceSessionMailProxy.Instance:CallGetMailAttach(ids)
    return
  end
  TableUtility.TableClear(lastDayMailList)
  local staticLastDayMailMap, postMap, mail = PostProxy.Instance.lastDayMailSingleDepositMap, PostProxy.Instance.postDatas
  for i = 1, #ids do
    mail = postMap[ids[i]]
    if mail:CheckAttachValid() and mail.mailid and staticLastDayMailMap[mail.mailid] then
      TableUtility.ArrayPushBack(lastDayMailList, mail)
    end
  end
  PostView.CallAttach(ids, true)
  recursiveAskForRenew()
end

local INTERVAL = GameConfig.PostClickInterval or 1

function PostView:OnClickPostCell(cellCtl)
  local ctlID = cellCtl.data and cellCtl.data.id
  if ctlID then
    local ctl = self.postWrapHelper:GetCellCtls()
    if self.DEL_MOD then
      PostProxy.Instance:SetMultiChoosePosts(ctlID)
      for _, cell in pairs(ctl) do
        cell:UpdateMultiChoose()
      end
      self:RefreshChooseAllBtn()
    elseif not self.curPost or self.curPost.id ~= ctlID then
      if cellCtl.data.unread then
        local now = UnityUnscaledTime
        if self._refreshTime and now - self._refreshTime < INTERVAL then
          return
        else
          self._refreshTime = now
        end
      end
      self:SetCurPost(cellCtl.data)
      for _, cell in pairs(ctl) do
        cell:SetChooseId(self.curPost.id)
      end
      self:RefreshInfoView()
      if self.curPost.unread then
        if self.curPost.isPackageMail then
          ServiceItemProxy.Instance:CallPackMailActionItemCmd(SceneItem_pb.EPACKMAILACTION_READ, ctlID)
        else
          ServiceSessionMailProxy.Instance:CallMailRead(ctlID)
        end
      end
    end
  end
end

local COLOR_OVERFLOW = "[FF0000]%s[-]"
local COLOR_NORMAL = "[FFFFFF]%s[-]"

function PostView:UpdatePostCount()
  local MAX_MAIL_NUM = GameConfig.System.mail_show_max or 150
  local mailNum = PostProxy.Instance:GetMailCount()
  local curNum = MAX_MAIL_NUM < mailNum and string.format(COLOR_OVERFLOW, mailNum) or string.format(COLOR_NORMAL, mailNum)
  self.postCountTip.text = curNum .. string.format(COLOR_NORMAL, "/" .. MAX_MAIL_NUM)
  self.postCountTipBg:ResetAndUpdateAnchors()
end

function PostView:OnExit()
  PictureManager.Instance:UnLoadUI(EMAILBG_TEX, self.rightBg)
  PictureManager.Instance:UnLoadUI(EMAILBG_TEX, self.rightBg1)
  PictureManager.Instance:UnLoadUI(EmptyLogo_Cirlce, self.emptyCircleLogo)
  self:SendTrackEvent()
  PostView.super.OnExit(self)
end

function PostView:OnOpenUrlPause()
  self:SendTrackEvent()
end

function PostView:OnOpenUrlBack2Focus()
  self:_StartTrackViewTime()
end

function PostView:SetCurPost(post)
  self.curPost = post
  self:_EndTrackViewTime()
  self:_StartTrackViewTime()
end

function PostView:InitPostTrackData()
  self.postTrackData = {}
end

function PostView:SendTrackEvent()
  self:_EndTrackViewTime()
  self:__SEA_NA_EU_TrackPostEvent()
end

function PostView:__SEA_NA_EU_TrackPostEvent()
  if not self.postTrackData then
    return
  end
  local eventName
  if self.postTrackData.unreadReceiveCount then
    eventName = PostProxy.PostTrackEvent.UNREAD_RECEIVE_COUNT .. self.postTrackData.unreadReceiveCount
    PostView._TXWYTrackEvent(eventName)
  end
  for k, v in pairs(self.postTrackData) do
    if type(k) == "number" then
      if v.clickUrlCount then
        eventName = PostProxy.PostTrackEvent.CLICK_URL_COUNT .. k .. " " .. v.clickUrlCount
        PostView._TXWYTrackEvent(eventName)
      end
      if v.totalViewTime then
        eventName = PostProxy.PostTrackEvent.STAY_TIME .. k .. " " .. v.totalViewTime
        PostView._TXWYTrackEvent(eventName)
        if v.totalViewTime > 5 then
          ServiceSceneUser3Proxy.Instance:CallActionStatUserCmd(EACTIONSTATTYPE.EACTIONSTATTYPE_READ_MAIL, k, v.totalViewTime)
        end
      end
    end
  end
end

function PostView._TXWYTrackEvent(eventName)
  do return end
  if not BranchMgr.IsSEA() and not BranchMgr.IsNA() and not BranchMgr.IsEU() then
    return
  end
  OverseaHostHelper:TXWYTrackEvent(eventName)
end

function PostView:_StartTrackViewTime()
  if self.curPost and self.curPost.id and PostProxy.Instance.track_mail_ids and TableUtility.ArrayFindIndex(PostProxy.Instance.track_mail_ids, self.curPost.id) > 0 then
    self.curPostTrackData = self.postTrackData[self.curPost.id]
    if not self.curPostTrackData then
      self.curPostTrackData = {}
      self.postTrackData[self.curPost.id] = self.curPostTrackData
    end
    self.curPostTrackData.thisStartViewTime = ServerTime.CurServerTime() / 1000
  else
    self.curPostTrackData = nil
  end
end

function PostView:_EndTrackViewTime()
  if self.curPostTrackData and self.curPostTrackData.thisStartViewTime then
    if not self.curPostTrackData.totalViewTime then
      self.curPostTrackData.totalViewTime = 0
    end
    local time = ServerTime.CurServerTime() / 1000 - self.curPostTrackData.thisStartViewTime
    self.curPostTrackData.totalViewTime = self.curPostTrackData.totalViewTime + math.max(time, 0)
    self.curPostTrackData.thisStartViewTime = nil
  end
end

function PostView:_AddTrackClickUrlCount()
  if self.curPostTrackData then
    if not self.curPostTrackData.clickUrlCount then
      self.curPostTrackData.clickUrlCount = 1
    else
      self.curPostTrackData.clickUrlCount = 1 + self.curPostTrackData.clickUrlCount
    end
  end
end

function PostView:_GatherTrackUnreadReceiveCount()
  if not PostProxy.Instance.track_mail_ids then
    return
  end
  if not self.postTrackData.unreadReceiveCount then
    self.postTrackData.unreadReceiveCount = 0
  end
  local postDatas = PostProxy.Instance:GetPostArray()
  for i = 1, #postDatas do
    if 0 < TableUtility.ArrayFindIndex(PostProxy.Instance.track_mail_ids, postDatas[i].id) and postDatas[i].unread and postDatas[i]:HasPostItems() then
      self.postTrackData.unreadReceiveCount = self.postTrackData.unreadReceiveCount + 1
    end
  end
end

function PostView:TrackEvent(url)
  ServiceSceneUser3Proxy.Instance:CallActionStatUserCmd(EACTIONSTATTYPE.EACTIONSTATTYPE_CLICK_MAIL_LINK, url)
end

function PostView:_Test()
  self.infoPos:SetActive(true)
  self:Hide(self.emptyLogo)
  self.postContentSL:SetText("内容[c][0000FF][u][url=www.我是网址.com]此处文字显示为超链接[/url][/u][-][/c]内容内容+v:客服kkp2023{quickcopyicon=客服kkp2023}啊啊啊啊啊啊啊啊")
end
