autoImport("WrapCellHelper")
autoImport("PhotoStandAlbumCombineItemCell")
autoImport("PhotoStandAlbumCell")
autoImport("PhotoStandMakeSponsorCell")
autoImport("PhotoStandSponsorListCell")
autoImport("PhotoStandAuthorInfoCell")
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
local tickInstance
local isNil = LuaGameObject.ObjectIsNull
PhotoStandPanel = class("PhotoStandPanel", BaseView)
PhotoStandPanel.ViewType = UIViewType.NormalLayer
PhotoStandPanel.ReDLPic = "PhotoStandPanel_ReDLPic"

function PhotoStandPanel:Init()
  PhotoStandPanel.super.Init(self)
  tickInstance = TimeTickManager.Me()
  self:FindObjs()
  self:AddEvents()
  self:InitData()
  self:InitShow()
end

function PhotoStandPanel:FindObjs()
  self.bbg = self:FindComponent("bpTex", UITexture, self.gameObject)
  self.bgTexName = "mall_twistedegg_bg_bottom"
  PictureManager.Instance:SetUI(self.bgTexName, self.bbg)
  PictureManager.ReFitFullScreen(self.bbg, 1)
  self.theWaiting = self:FindGO("theWaiting", self.gameObject)
  local theWaitingLabel = self:FindComponent("ServerConnectingLabel", UILabel, self.theWaiting)
  theWaitingLabel.text = ZhString.PersonalPictureCell_LoadingText
  self.main_trans = self:FindGO("MainSub")
  self.main_title_lb = self:FindComponent("Lb", UILabel, self.main_trans)
  self.main_album_btn = self:FindGO("AlbumButton", self.main_trans)
  self.main_back_btn = self:FindGO("BackButton", self.main_trans)
  self.main_close_btn = self:FindGO("CloseButton", self.main_trans)
  self.main_top_ele = self:FindGO("TopEle", self.main_trans)
  self.main_theme_switch = self:FindGO("ThemeSwitch")
  self.main_ts_c = self:FindGO("cBtn", self.main_theme_switch)
  self.main_ts_l = self:FindGO("lBtn", self.main_theme_switch)
  self.main_ts_r = self:FindGO("rBtn", self.main_theme_switch)
  self.main_ts_c_lb = self:FindComponent("Label", UILabel, self.main_ts_c)
  self.main_ts_l_lb = self:FindComponent("Label", UILabel, self.main_ts_l)
  self.main_ts_r_lb = self:FindComponent("Label", UILabel, self.main_ts_r)
  self.main_bottom_ele = self:FindGO("Anchor_Bottom", self.main_trans)
  self.main_author_lbbtn = self:FindGO("AuthorLb", self.main_trans)
  self.main_author_lbbc = self.main_author_lbbtn:GetComponent(BoxCollider)
  self.main_author_lb = self.main_author_lbbtn:GetComponent(UILabel)
  self.main_my_lbbtn = self:FindGO("MyCommitLb", self.main_trans)
  self.main_share_btn = self:FindGO("ShareButton", self.main_trans)
  self.main_commit_btn = self:FindGO("CommitButton", self.main_trans)
  self.main_letter_btn = self:FindGO("LetterButton", self.main_trans)
  self.main_letter_btn:SetActive(false)
  self.main_like_btn = self:FindGO("LikeButton", self.main_trans)
  self.main_like_st1 = self:FindGO("like1", self.main_like_btn)
  self.main_like_st2 = self:FindGO("like2", self.main_like_btn)
  self.main_like_reward_hint = self:FindGO("LikeRewardHint", self.main_trans)
  self.main_like_count_lb = self:FindComponent("LikeCountLb", UILabel, self.main_trans)
  self.main_sponsor_btn = self:FindGO("SponsorButton", self.main_trans)
  self.main_sponsor_newmark = self:FindGO("newmark", self.main_sponsor_btn)
  self.main_sponsor_count_lb = self:FindComponent("SponsorCountLb", UILabel, self.main_trans)
  self.main_pop_menu_btn = self:FindGO("MenuButton", self.main_trans)
  self.main_pop_menu = self:FindGO("PopMenu", self.main_trans)
  self.main_pop_menu_grid = self:FindComponent("Grid", UIGrid, self.main_pop_menu)
  self.main_pop_menu_clickMask = self:FindGO("Mask", self.main_pop_menu)
  self.main_pop_menu_bg = self:FindComponent("MenuSp", UISprite, self.main_pop_menu)
  self.main_author_info = self:FindGO("AuthorInfo")
  self.main_author_info_cell = PhotoStandAuthorInfoCell.new(self:FindGO("CellContainer", self.main_author_info))
  self:AddClickEvent(self.main_author_info, function()
    self:author_clickHandler()
  end)
  self.main_author_info_pop = self:FindGO("InfoHint", self.main_trans)
  self.main_author_info_lb = self:FindComponent("AuthorInfoLb", UILabel, self.main_author_info_pop)
  self.main_author_info_lb_bc = self:FindComponent("AuthorInfoLb", BoxCollider, self.main_author_info_pop)
  self.main_center_ele = self:FindGO("CenterEle", self.main_trans)
  self.main_left_btn = self:FindGO("leftIndicator", self.main_trans)
  self.main_right_btn = self:FindGO("rightIndicator", self.main_trans)
  self.main_uitex = self:FindComponent("MainTex", UITexture, self.main_trans)
  self.main_redl_btn = self:FindGO("reDLBtn", self.main_trans)
  self.hide_tween = {}
  local tween = self.main_trans.gameObject:GetComponentsInChildren(UITweener, true)
  for _, v in pairs(tween) do
    v.duration = 1
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self.hide_tween, v)
  end
  if self.hide_tween[1] then
    EventDelegate.Set(self.hide_tween[1].onFinished, function()
      if self.hide_tween[1].amountPerDelta < 0 then
        for _, v in pairs(self.hide_tween) do
          v.gameObject:SetActive(true)
        end
      else
        for _, v in pairs(self.hide_tween) do
          v.gameObject:SetActive(false)
        end
      end
    end)
  end
  self:AddClickEvent(self.main_album_btn, function()
    self:ToAlbumView()
    self:Album_RefreshView(true)
  end)
  self:AddClickEvent(self.main_close_btn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.main_share_btn, function()
    self.main_pop_menu:SetActive(false)
    self:ToShareView()
  end)
  self:AddClickEvent(self.main_author_lbbtn, function()
    self:Main_ShowAuthorInfoPopup()
  end)
  self:AddClickEvent(self.main_letter_btn, function()
    self.main_pop_menu:SetActive(false)
    self:Main_TrySendPostcard()
  end)
  self:AddClickEvent(self.main_my_lbbtn, function()
    self:ToMyPostSlideView()
  end)
  self.main_my_lbbtn:SetActive(false)
  self:AddClickEvent(self.main_redl_btn, function()
    if self.cx_pic_data then
      self.cx_pic_data:DownloadTex(true)
    end
  end)
  self.main_redl_btn:SetActive(false)
  self:AddClickEvent(self.main_commit_btn, function()
    self.main_pop_menu:SetActive(false)
    self:GotoPostPhoto()
  end)
  self:AddClickEvent(self.main_pop_menu_btn, function()
    self.main_pop_menu:SetActive(not self.main_pop_menu.activeSelf)
    self:_Main_RefreshPopMenu()
  end)
  self:AddClickEvent(self.main_pop_menu_clickMask, function()
    self.main_pop_menu:SetActive(false)
  end)
  self:AddClickEvent(self.main_like_btn, function()
    if self.cx_pic_data and self.cx_pic_data:IsDynamicObtained() then
      self.cx_pic_data.liked = not self.cx_pic_data.liked
      PhotoStandProxy.Instance:ServerCall_BoardLikePhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid, self.cx_pic_data.liked)
      local ilikethispic = self.cx_pic_data.liked
      self.main_like_st1:SetActive(not ilikethispic)
      self.main_like_st2:SetActive(ilikethispic)
      if ilikethispic then
        self.main_like_reward_hint:SetActive(false)
      end
    end
  end)
  self:AddClickEvent(self.main_sponsor_btn, function()
    if self.cx_pic_data then
      if self.cx_pic_data:IsMine() then
        if self.cx_pic_data:IsMine() and not self.cx_pic_data:IsMineInfoObtained() then
          PhotoStandProxy.Instance:ServerCall_BoardAwardListPhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid)
          self.pending_ShowReceiveSponsorPopup = true
        else
          self:ShowReceiveSponsorPopup(true)
        end
      else
        self:ShowMakeSponsorPopup(true)
      end
    end
  end)
  self:AddPressEvent(self.main_uitex.gameObject, function(go, isPress)
    self:Main_OnPressTex(isPress)
  end)
  self:AddDragEvent(self.main_uitex.gameObject, function(go, delta)
    self:Main_OnDragTex(delta.x)
  end)
  self:AddClickEvent(self.main_left_btn, function()
    self:Main_SlideSwitch(true)
    self:_Main_CancelDelayHideUI()
    self:_Main_StartDelayHideUI()
  end)
  self:AddClickEvent(self.main_right_btn, function()
    self:Main_SlideSwitch(false)
    self:_Main_CancelDelayHideUI()
    self:_Main_StartDelayHideUI()
  end)
  self:AddClickEvent(self.main_ts_l, function()
    self:Main_SlideSwitchTheme(true)
    self:_Main_CancelDelayHideUI()
    self:_Main_StartDelayHideUI()
  end)
  self:AddClickEvent(self.main_ts_r, function()
    self:Main_SlideSwitchTheme(false)
    self:_Main_CancelDelayHideUI()
    self:_Main_StartDelayHideUI()
  end)
  self.album_trans = self:FindGO("AlbumSub")
  self.album_back_btn = self:FindGO("BackButton", self.album_trans)
  self.album_close_btn = self:FindGO("CloseButton", self.album_trans)
  self.album_tab_panel = self:FindGO("TabPanel", self.album_trans)
  self.album_my_post_part = self:FindGO("MyPost", self.album_trans)
  self.album_my_post_getAll = self:FindGO("GetAllButton", self.album_my_post_part)
  self:AddClickEvent(self.album_my_post_getAll, function()
    PhotoStandProxy.Instance:ServerCall_BoardGetAwardPhotoCmd()
    PhotoStandProxy.Instance:Local_ClearAllAward()
    PhotoStandProxy.Instance.mypostHasAward = nil
    self:OnPhotoCmdBoardQueryAwardPhotoCmd()
  end)
  self.album_my_post_noreward = self:FindGO("noreward", self.album_my_post_part)
  self.album_empty_ct = self:FindGO("emptyCt", self.album_trans)
  local emptyLab = self:FindComponent("emptyDes", UILabel, self.album_empty_ct)
  emptyLab.text = ZhString.GuildScoreRankPage_Empty
  self.album_list_ct = self:FindGO("ListPage", self.album_trans)
  self.album_left_btn = self:FindGO("leftIndicator", self.album_trans)
  self.album_right_btn = self:FindGO("rightIndicator", self.album_trans)
  local itemContainer = self:FindGO("bag_itemContainer", self.album_trans)
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 4,
    cellName = "PhotoStandAlbumCombineItemCell",
    control = PhotoStandAlbumCombineItemCell,
    dir = 2
  }
  self.album_wraplist = WrapCellHelper.new(wrapConfig)
  self.album_wraplist:AddEventListener(MouseEvent.MouseClick, self.Album_WrapList_HandleClickItem, self)
  self.album_wraplist:AddEventListener(PhotoStandPanel.ReDLPic, self.Album_WrapList_PassReDLPic, self)
  self.album_scrollView = self:FindComponent("ItemScrollView", ROUIScrollView, self.album_trans)
  
  function self.album_scrollView.onDragStarted()
    self:Album_WrapList_OnScrollStart()
  end
  
  function self.album_scrollView.onStoppedMoving()
    self:Album_WrapList_OnScrollStop()
  end
  
  self.album_theme_tabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      self:Album_ThemePopList_tabClick(self.selectTabData)
    end
  end, self, self.album_scrollView:GetComponent(UIPanel).depth + 2)
  self.album_page_dot = self:FindGO("PageDot", self.album_trans)
  self.album_page_dots = {}
  table.insert(self.album_page_dots, self:FindGO("aaa1", self.album_page_dot))
  table.insert(self.album_page_dots, self:FindGO("aaa2", self.album_page_dot))
  table.insert(self.album_page_dots, self:FindGO("aaa3", self.album_page_dot))
  table.insert(self.album_page_dots, self:FindGO("aaa4", self.album_page_dot))
  table.insert(self.album_page_dots, self:FindGO("aaa5", self.album_page_dot))
  self:AddClickEvent(self.album_back_btn, function()
    self:ToDefaultSlideView()
  end)
  self:AddClickEvent(self.album_close_btn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.album_left_btn, function()
    self:Album_WrapList_ManuallyMove(true)
  end)
  self:AddClickEvent(self.album_right_btn, function()
    self:Album_WrapList_ManuallyMove(false)
  end)
  self.receive_trans = self:FindGO("Part", self:FindGO("ReceiveSponsorPop"))
  local help_go = self:FindGO("ChangeCostTip", self.receive_trans)
  self:TryOpenHelpViewById(35263, 20, help_go)
  self:AddClickEvent(self:FindGO("CloseButton", self.receive_trans), function()
    self:ShowReceiveSponsorPopup(false)
  end)
  self.receive_confirmButton = self:FindGO("ConfirmButton", self.receive_trans)
  self.receive_confirmLabel = self:FindGO("Label", self.receive_confirmButton):GetComponent(UILabel)
  self.receive_confirmButton_BC = self.receive_confirmButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.receive_confirmButton, function()
    PhotoStandProxy.Instance:ServerCall_BoardGetAwardPhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid)
    self:ShowReceiveSponsorPopup(false)
  end)
  self.receive_desc = SpriteLabel.new(self:FindGO("TotalPriceTitle", self.receive_trans), nil, nil, nil, true)
  self.receive_sum = self:FindComponent("TotalPrice", UILabel, self.receive_trans)
  self.receive_none = self:FindComponent("TotalPriceTitle222222", UILabel, self.receive_trans)
  self.receive_none.text = ZhString.PhotoStand_GetSponsor_None
  local itemGrid = self:FindComponent("ItemWrap", UIGrid, self.receive_trans)
  self.receive_gridList = UIGridListCtrl.new(itemGrid, PhotoStandSponsorListCell, "PhotoStandSponsorListCell")
  self.receive_gridList:AddEventListener(MouseEvent.MouseClick, self.receive_clickHandler, self)
end

function PhotoStandPanel:AddEvents()
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardTopicPhotoCmd, self.OnServer_BoardTopicPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardRotateListPhotoCmd, self.OnServer_BoardRotateListPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardListPhotoCmd, self.OnServer_BoardListPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardQueryDetailPhotoCmd, self.OnServer_BoardQueryDetailPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardQueryDataPhotoCmd, self.OnServer_BoardQueryDataPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardMyListPhotoCmd, self.OnServer_BoardMyListPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardAwardListPhotoCmd, self.OnServer_BoardAwardListPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardLikePhotoCmd, self.OnServer_BoardLikePhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardAwardPhotoCmd, self.OnServer_BoardAwardPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.BoardGetAwardPhotoCmd, self.OnServer_BoardGetAwardPhotoCmd)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.Alert_ServerConsoleChangedData, self.OnAlert_ServerConsoleChangedData)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadSucc, self.OnDL_PhotoDonwloadSucc)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadFailed, self.OnDL_PhotoDonwloadFailed)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_PhotoDonwloadTerminated, self.OnDL_PhotoDonwloadTerminated)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.OnOnHandleQueryUserInfo)
  self:AddListenEvt(ServiceEvent.PhotoCmdBoardQueryAwardPhotoCmd, self.OnPhotoCmdBoardQueryAwardPhotoCmd)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt)
  EventManager.Me():AddEventListener(AppStateEvent.Pause, self.OnAppPauseQuitStage, self)
  self:HighResTex_AddEventListener()
end

function PhotoStandPanel:HandleEvt()
  self:CloseSelf()
end

function PhotoStandPanel:OnEnter()
  PhotoStandPanel.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  self.npcid = viewdata.npcTarget and viewdata.npcTarget.data and viewdata.npcTarget.data.staticData.id
  self.usage_mypost = viewdata.usage == "mypost"
  if self.usage_mypost then
    PhotoStandProxy.Instance.mypostList:GetTheFxxkin_totalcount()
    self.relThemeList = {
      PhotoStandProxy.Instance.mypostList
    }
    self.npcid = 0
    self:ToAlbumView()
    self:Album_RefreshView(true)
    return
  end
  self.relThemeList = PhotoStandProxy.Instance:GetThemeListByNpc(self.npcid)
  for i = 1, #self.relThemeList do
    self.relThemeList[i]:GetTheFxxkin_totalcount()
  end
  local _slide_info = FunctionPhotoStand.Me().slide_info[self.npcid]
  PhotoStandProxy.Instance.slideList[self.npcid]:SetCurSpotPicIndex(_slide_info.spot_idx)
  self:ToDefaultSlideView()
  ServiceNUserProxy.Instance:CallUserActionNtf(Game.Myself.data.id, FunctionPhotoStand.ShowViewPhotoStandEmoji, SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION)
  ServicePhotoCmdProxy.Instance:CallBoardOpenPhotoCmd(self.npcid)
end

function PhotoStandPanel:OnExit()
  PhotoStandPanel.super.OnExit(self)
  self.album_theme_tabs:Destroy()
  self.album_theme_tabs = nil
  tickInstance:ClearTick(self)
  self.album_scrollUpdateTick = nil
  self.hide_delay_tt = nil
  if self.usage_mypost then
    if self.cx_list_data then
      self.cx_list_data:SetActiveOnShow(false)
    end
  else
    if self.cx_list_data and self.cx_list_data ~= PhotoStandProxy.Instance.slideList[self.npcid] then
      self.cx_list_data:SetActiveOnShow(false)
    end
    if FunctionPhotoStand.Me().isRunning then
      PhotoStandProxy.Instance.slideList[self.npcid]:SetUsageTag("scene")
      PhotoStandProxy.Instance.slideList[self.npcid]:SetActiveOnShow(true)
    end
    ServiceNUserProxy.Instance:CallUserActionNtf(Game.Myself.data.id, FunctionPhotoStand.HideViewPhotoStandEmoji, SceneUser2_pb.EUSERACTIONTYPE_EXPRESSION)
  end
  if self.bgTexName then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bbg)
  end
  self:HighResTex_Dispose()
  PhotoStandPicData.LRU_UI_Dispose()
end

function PhotoStandPanel:InitData()
end

function PhotoStandPanel:InitShow()
end

function PhotoStandPanel:OpenUrlView(url)
  Application.OpenURL(url)
end

function PhotoStandPanel:GotoPostPhoto()
  local _themeData = self.relThemeList[self.album_index]
  local uploadurl = _themeData and _themeData.uploadurl
  local can = uploadurl ~= nil and uploadurl ~= ""
  if can then
    self:OpenUrlView(uploadurl)
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.CupMode_NotOpen)
  end
end

function PhotoStandPanel:ToShareView()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  if self.main_uitex.mainTexture then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PhotoStandShareView,
      viewdata = self.main_uitex.mainTexture
    })
  end
end

function PhotoStandPanel:ToAlbumView()
  self.album_trans:SetActive(true)
  self.main_trans:SetActive(false)
end

function PhotoStandPanel:ToMainView()
  self.album_trans:SetActive(false)
  self.main_trans:SetActive(true)
  self:_Main_CancelDelayHideUI()
  self:_Main_StartDelayHideUI()
end

function PhotoStandPanel:ToDefaultSlideView()
  self:ToMainView()
  self.main_my_lbbtn:SetActive(true)
  self.main_commit_btn:SetActive(true)
  local _data = PhotoStandProxy.Instance.slideList[self.npcid]
  if not self.usage_mypost then
    _data:SetUsageTag("slide")
  end
  self:SetViewContext(_data)
  self:Main_RefreshView()
end

function PhotoStandPanel:ToThemeSlideView(_, cur_idx)
  self:ToMainView()
  if self.cx_list_data then
    self.cx_list_data:SetCurSpotPicIndex(cur_idx)
    if not self.usage_mypost then
      self.cx_list_data:SetTagAsSlide(true)
    end
    self:SetViewContext(self.cx_list_data)
    self:Main_RefreshView()
  end
end

function PhotoStandPanel:ToMyPostSlideView()
  self:ToMainView()
  self.main_my_lbbtn:SetActive(false)
  self.main_commit_btn:SetActive(false)
  local _data = PhotoStandProxy.Instance.mypostList
  _data:SetCurSpotPicIndex(1)
  self:SetViewContext(_data)
  self:Main_RefreshView()
end

function PhotoStandPanel:ShowMakeSponsorPopup(isShow)
  if isShow then
    if self.sponsor_popup == nil then
      self.sponsor_popup = PhotoStandMakeSponsorCell.new(self:FindGO("Part", self:FindGO("MakeSponsorPop")))
    end
    self.sponsor_popup:SetData({
      id = self.cx_pic_data.id,
      accid = self.cx_pic_data.accid
    })
  end
  if self.sponsor_popup ~= nil then
    self.sponsor_popup.gameObject:SetActive(isShow)
  end
end

function PhotoStandPanel:ShowReceiveSponsorPopup(isShow)
  if isShow then
    PhotoStandProxy.Instance:ServerCall_BoardQueryDataPhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid)
    self:UpdateReceiveCollections()
    self.receive_desc:SetText(string.format(ZhString.PhotoStand_GetSponsor_Can, StringUtil.NumThousandFormat(self.cx_pic_data.unawardzeny or 0)))
    self.receive_sum.text = StringUtil.NumThousandFormat(self.cx_pic_data.totalzeny or 0)
  else
    if self.cx_pic_data and self.cx_pic_data:IsMine() then
      self.cx_pic_data:ForceClearMineInfoObtained()
    end
    self:Main_RefreshView()
  end
  self.receive_trans.gameObject:SetActive(isShow)
end

function PhotoStandPanel:OnServer_BoardTopicPhotoCmd(data)
  self:Album_RefreshThemePopList()
end

function PhotoStandPanel:OnServer_BoardRotateListPhotoCmd(data)
  if self.main_trans and self.main_trans.activeSelf and self.cx_list_data.usageTag == "slide" and self.cx_pic_data == nil then
    self:SetViewContext()
    self:Main_RefreshView()
  end
end

function PhotoStandPanel:OnServer_BoardListPhotoCmd(data)
  if self.album_trans and self.album_trans.activeSelf then
    self:Album_RefreshWrapCellList_EachCell()
  end
  if self.main_trans and self.main_trans.activeSelf then
    self:SetViewContext()
    self:Main_RefreshView()
  end
end

function PhotoStandPanel:OnServer_BoardQueryDetailPhotoCmd(data)
  self:_RefreshAlbumIndex()
  self:Main_RefreshDetail()
end

function PhotoStandPanel:OnServer_BoardQueryDataPhotoCmd(data)
  self:Main_RefreshDynamic()
end

function PhotoStandPanel:OnServer_BoardMyListPhotoCmd(data)
  if self.main_trans and self.main_trans.activeSelf then
    if self.cx_list_data.usageTag == "mypost" and self.cx_pic_data == nil then
      self:SetViewContext()
      self:Main_RefreshView()
    else
      self:_Main_RefreshMyPostBtn()
    end
  elseif self.album_trans and self.album_trans.activeSelf then
    self:Album_RefreshView()
  end
end

function PhotoStandPanel:OnServer_BoardAwardListPhotoCmd(data)
  if self.pending_ShowReceiveSponsorPopup then
    self.pending_ShowReceiveSponsorPopup = nil
    self:ShowReceiveSponsorPopup(true)
    return
  end
  if self.receive_trans and self.receive_trans.activeSelf then
    self:UpdateReceiveCollections()
  end
end

function PhotoStandPanel:OnServer_BoardLikePhotoCmd(data)
  self:Main_RefreshView()
end

function PhotoStandPanel:OnServer_BoardAwardPhotoCmd(data)
  self:Main_RefreshView()
end

function PhotoStandPanel:OnServer_BoardGetAwardPhotoCmd(data)
  if self.receive_trans and self.receive_trans.activeSelf then
    self.receive_trans:SetActive(false)
  end
end

function PhotoStandPanel:OnDL_PhotoDonwloadSucc(data)
  if self.album_trans and self.album_trans.activeSelf then
    local cells = self.album_wraplist:GetCellCtls()
    for c = 1, #cells do
      local single = cells[c]:GetCells()
      for j = 1, #single do
        if single[j].data and single[j].data.id == data.body.id and single[j].data.accid == data.body.accid then
          single[j]:RefreshCellView()
          return
        end
      end
    end
  elseif self.main_trans and self.main_trans.activeSelf and self.cx_pic_data and self.cx_pic_data.id == data.body.id and self.cx_pic_data.accid == data.body.accid then
    self:_Main_SetMainTex()
  end
end

function PhotoStandPanel:OnDL_PhotoDonwloadFailed(data)
  if self.album_trans and self.album_trans.activeSelf then
    local cells = self.album_wraplist:GetCellCtls()
    for c = 1, #cells do
      local single = cells[c]:GetCells()
      for j = 1, #single do
        if single[j].data and single[j].data.id == data.body.id and single[j].data.accid == data.body.accid then
          single[j]:RefreshCellView()
          return
        end
      end
    end
  elseif self.main_trans and self.main_trans.activeSelf and self.cx_pic_data and self.cx_pic_data.id == data.body.id and self.cx_pic_data.accid == data.body.accid then
    self:_Main_SetMainTex()
  end
end

function PhotoStandPanel:OnDL_PhotoDonwloadTerminated(data)
  if self.album_trans and self.album_trans.activeSelf then
    local cells = self.album_wraplist:GetCellCtls()
    for c = 1, #cells do
      local single = cells[c]:GetCells()
      for j = 1, #single do
        if single[j].data and single[j].data.id == data.body.id and single[j].data.accid == data.body.accid then
          single[j]:RefreshCellView()
          return
        end
      end
    end
  elseif self.main_trans and self.main_trans.activeSelf and self.cx_pic_data and self.cx_pic_data.id == data.body.id and self.cx_pic_data.accid == data.body.accid then
    self:_Main_SetMainTex()
  end
end

function PhotoStandPanel:OnAlert_ServerConsoleChangedData(data)
  self:CloseSelf()
end

function PhotoStandPanel:OnAppPauseQuitStage()
end

function PhotoStandPanel:OnPhotoCmdBoardQueryAwardPhotoCmd(data)
  if PhotoStandProxy.Instance.mypostHasAward then
    self.album_my_post_getAll:SetActive(true)
    self.album_my_post_noreward:SetActive(false)
  else
    self.album_my_post_getAll:SetActive(false)
    self.album_my_post_noreward:SetActive(true)
  end
end

function PhotoStandPanel:SetViewContext(list_data)
  if list_data then
    if self.cx_list_data ~= list_data then
      if self.cx_list_data then
        self.cx_list_data:SetActiveOnShow(false)
      end
      if list_data then
        list_data:SetActiveOnShow(true)
      end
    end
    self.cx_list_data = list_data
  end
  self.cx_spot_idx = self.cx_list_data.curSpotPicIndex
  self.cx_pic_data = self.cx_list_data:TryGetCurSpotPicData()
  self:_RefreshAlbumIndex()
end

function PhotoStandPanel:Main_RefreshView()
  if not self.main_trans.activeSelf then
    return
  end
  if not self.cx_pic_data then
    self.theWaiting:SetActive(true)
    return
  else
    self.theWaiting:SetActive(false)
  end
  self:Main_RefreshDetail()
  self:Main_RefreshDynamic()
  self:_Main_SetAuthorInfoCell()
  local enable_sponsor = not PhotoStandProxy.IsForbidSponsor() and self.cx_pic_data.accid ~= nil and self.cx_pic_data.accid > 0
  self.main_sponsor_btn:SetActive(enable_sponsor)
  self.main_sponsor_count_lb.gameObject:SetActive(enable_sponsor)
  self:_Main_SetMainTex()
  local npchaslikereward = GameConfig.PhotoBoard.LikeDailyReward
  npchaslikereward = npchaslikereward and self.npcid and npchaslikereward[self.npcid] ~= nil
  local iliketoday = (MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_PHOTO_BOARD_LIKE) or 1) == 1
  local icansponsor = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_PHOTO_BOARD_AWARD) or 0
  self.main_like_reward_hint:SetActive(npchaslikereward and not iliketoday)
  if self.cx_list_data.usageTag == "scene" or self.cx_list_data.usageTag == "slide" or self.cx_list_data.usageTag == "theme_slide" then
    self.main_album_btn:SetActive(true)
    self.main_back_btn:SetActive(false)
    self.main_title_lb.gameObject:SetActive(false)
    self.main_theme_switch:SetActive(true)
  elseif self.cx_list_data.usageTag == "mypost" then
    self.main_album_btn:SetActive(true)
    self.main_back_btn:SetActive(false)
    self.main_title_lb.gameObject:SetActive(false)
    self.main_theme_switch:SetActive(true)
  end
  self:_Main_RefreshMyPostBtn()
  self:_Main_RefreshShareBtn()
  self:_Main_RefreshCommitBtn()
  self:_Main_RefreshThemeSwitch()
  self:_Main_RefreshPopMenu()
end

function PhotoStandPanel:Main_RefreshDetail()
  if not self.cx_pic_data:IsDetailObtained() then
    PhotoStandProxy.Instance:ServerCall_BoardQueryDetailPhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid)
  end
  local topic = PhotoStandProxy.Instance:GetThemeByTopic(self.cx_pic_data.topic)
  self.main_title_lb.text = topic and topic.name or "-"
  if self.cx_pic_data.official == false and self.cx_pic_data:Author_IsHaveIntro() then
    self.main_author_lbbc.enabled = true
    self.main_author_lbbtn:SetActive(true)
  else
    self.main_author_lbbc.enabled = false
    self.main_author_lbbtn:SetActive(false)
  end
  if self.cx_pic_data.official == nil then
    self.main_author_lb.text = ""
  else
    self.main_author_lb.text = self.cx_pic_data.official and GameConfig.PhotoBoard.OUploadText or ZhString.PhotoStand_UUpload
  end
  if self.cx_pic_data.official then
    self.main_letter_btn:SetActive(true)
  else
    self.main_letter_btn:SetActive(false)
  end
  self.main_sponsor_newmark:SetActive(not self.cx_pic_data:IsMine() or self.cx_pic_data.newaward or false)
end

function PhotoStandPanel:Main_RefreshDynamic()
  if not self.cx_pic_data:IsDynamicObtained() then
    PhotoStandProxy.Instance:ServerCall_BoardQueryDataPhotoCmd(self.cx_pic_data.id, self.cx_pic_data.accid)
  end
  self.main_like_count_lb.text = self.cx_pic_data.like or "-"
  self.main_sponsor_count_lb.text = self.cx_pic_data.lottery or "-"
  local ilikethispic = self.cx_pic_data.liked or false
  self.main_like_st1:SetActive(not ilikethispic)
  self.main_like_st2:SetActive(ilikethispic)
  self.main_sponsor_newmark:SetActive(not self.cx_pic_data:IsMine() or self.cx_pic_data.newaward or false)
end

function PhotoStandPanel:_Main_RefreshMyPostBtn()
  self.main_my_lbbtn:SetActive(false)
  do return end
  local hasMyPost = PhotoStandProxy.Instance.mypostList and PhotoStandProxy.Instance.mypostList.sum and PhotoStandProxy.Instance.mypostList.sum > 0
  local isMyPostView = self.cx_list_data and self.cx_list_data.usageTag == "mypost"
  self.main_my_lbbtn:SetActive(hasMyPost == true and isMyPostView == false)
end

function PhotoStandPanel:_Main_RefreshShareBtn()
  self.main_share_btn:SetActive(self.main_uitex.mainTexture ~= nil)
end

function PhotoStandPanel:_Main_RefreshCommitBtn()
  local _themeData = self.relThemeList[self.album_index]
  local uploadurl = _themeData and _themeData.uploadurl
  local can = uploadurl ~= nil and uploadurl ~= ""
  self.main_commit_btn:SetActive(can)
end

function PhotoStandPanel:_Main_RefreshPopMenu()
  local showCnt = 0
  if self.main_share_btn.activeSelf then
    showCnt = showCnt + 1
  end
  if self.main_commit_btn.activeSelf then
    showCnt = showCnt + 1
  end
  if self.main_letter_btn.activeSelf then
    showCnt = showCnt + 1
  end
  self.main_pop_menu_bg.height = 46 + showCnt * 70
  self.main_pop_menu_grid:Reposition()
  self.main_pop_menu_btn:SetActive(0 < showCnt)
end

function PhotoStandPanel:_Main_SetAuthorInfoCell()
  self.main_author_info_cell:SetData(self.cx_pic_data)
end

function PhotoStandPanel:_RefreshAlbumIndex()
  self.album_index = self:_GetCurrentInAlbumIndex()
end

function PhotoStandPanel:_GetCurrentInAlbumIndex()
  if not self.cx_pic_data then
    return
  end
  if self.usage_mypost then
    return 1
  end
  local curInTheme = self.cx_pic_data.topic
  for i = 1, #self.relThemeList do
    if self.relThemeList[i].topic == curInTheme then
      return i
    end
  end
end

function PhotoStandPanel:_Main_RefreshThemeSwitch()
  local max_index = #self.relThemeList
  local cur_in_album_index = self.album_index
  if max_index == 0 or not cur_in_album_index then
    self.main_ts_c:SetActive(false)
    self.main_ts_l:SetActive(false)
    self.main_ts_r:SetActive(false)
    return
  end
  local r_album_index = max_index <= cur_in_album_index and 1 or cur_in_album_index + 1
  local l_album_index = cur_in_album_index <= 1 and max_index or cur_in_album_index - 1
  if max_index == 1 then
    self.main_ts_c:SetActive(true)
    self.main_ts_l:SetActive(false)
    self.main_ts_r:SetActive(false)
  elseif max_index == 2 then
    self.main_ts_c:SetActive(true)
    self.main_ts_l:SetActive(false)
    self.main_ts_r:SetActive(true)
  else
    self.main_ts_c:SetActive(true)
    self.main_ts_l:SetActive(true)
    self.main_ts_r:SetActive(true)
  end
  local tData = self.relThemeList[cur_in_album_index]
  self.main_ts_c_lb.text = tData.name
  tData = self.relThemeList[l_album_index]
  self.main_ts_l_lb.text = tData.name
  tData = self.relThemeList[r_album_index]
  self.main_ts_r_lb.text = tData.name
end

function PhotoStandPanel:_Main_SetMainTex(pic_data)
  self.main_redl_btn:SetActive(false)
  self.theWaiting:SetActive(false)
  pic_data = pic_data or self.cx_pic_data
  if pic_data:HasHighResTex() then
    self:HighResTex_TrySet()
    return
  end
  local tex = pic_data:GetTex()
  if not tex then
    if pic_data.fs_status == PhotoStandPicData.Status.Pending then
      self.theWaiting:SetActive(true)
    else
      self.main_redl_btn:SetActive(true)
    end
  end
  self.main_uitex.mainTexture = tex
  if tex then
    PictureManager.ReFitManualHeight(self.main_uitex)
    self:HighResTex_TrySet()
  end
end

local open_cd, open_last_ts = 3000, 0

function PhotoStandPanel:Main_ShowAuthorInfoPopup(isShow)
  if isShow == nil then
    isShow = not self.main_author_info_pop.activeSelf
  end
  if not isShow then
    self.main_author_info_pop:SetActive(false)
  elseif self.cx_pic_data and self.cx_pic_data:Author_IsHaveIntro() then
    self.main_author_info_pop:SetActive(true)
    self:Main_SetAuthorInfo()
  else
    self.main_author_info_pop:SetActive(false)
  end
end

function PhotoStandPanel:Main_SetAuthorInfo()
  if not self.cx_pic_data and not self.cx_pic_data:Author_IsHaveIntro() then
    return false
  end
  local ainfo = ""
  if self.cx_pic_data.title and self.cx_pic_data.title ~= "" then
    if ainfo ~= "" then
      ainfo = ainfo .. "\n"
    end
    ainfo = ainfo .. ZhString.PhotoStand_ThemePrefix .. (self.cx_pic_data.title or "-")
  end
  if ainfo ~= "" then
    ainfo = ainfo .. "\n"
  end
  if self.main_author_info_cell then
    self.main_author_info_lb_bc.enabled = false
  elseif self.cx_pic_data:Author_CanCheckDetail() then
    self.main_author_info_lb_bc.enabled = true
    ainfo = ainfo .. ZhString.PhotoStand_AuthorPrefix .. "[u]" .. (self.cx_pic_data:Author_GetAuthorName() or GameConfig.PhotoBoard.NoNameText) .. "[/u]"
  else
    self.main_author_info_lb_bc.enabled = false
    ainfo = ainfo .. ZhString.PhotoStand_AuthorPrefix .. (self.cx_pic_data:Author_GetAuthorName() or GameConfig.PhotoBoard.NoNameText)
  end
  if self.cx_pic_data.desc and self.cx_pic_data.desc ~= "" then
    if ainfo ~= "" then
      ainfo = ainfo .. "\n"
    end
    ainfo = ainfo .. ZhString.PhotoStand_GWordPrefix .. (self.cx_pic_data.desc or "-")
  end
  self.main_author_info_lb.text = ainfo
  return true
end

local hide_delay_ttid = 393932
local hide_delay_duration = 15000
local slide_trigger_min_x = 20

function PhotoStandPanel:Main_OnPressTex(isPress)
  if isPress ~= self.maintex_hold then
    if not isPress then
      if self.maintex_slidex > slide_trigger_min_x then
        self:Main_SlideSwitch(true)
      elseif self.maintex_slidex < slide_trigger_min_x * -1 then
        self:Main_SlideSwitch(false)
      end
    end
    self.maintex_slidex = 0
    self.maintex_hold = isPress
  end
  if isPress then
    self:_Main_CancelDelayHideUI()
  else
    self:_Main_StartDelayHideUI()
  end
end

function PhotoStandPanel:Main_OnDragTex(delta_x)
  if self.maintex_hold then
    self.maintex_slidex = delta_x + self.maintex_slidex
  end
end

function PhotoStandPanel:_Main_StartDelayHideUI()
  if self.hide_delay_tt == nil then
    local dd = GameConfig.PhotoBoard.FadeDuration and GameConfig.PhotoBoard.FadeDuration * 1000 or hide_delay_duration
    self.hide_delay_tt = tickInstance.Me():CreateOnceDelayTick(dd, function(owner, deltaTime)
      self:_Main_HideUI()
      self.hide_delay_tt = nil
    end, self, hide_delay_ttid)
  end
end

function PhotoStandPanel:_Main_CancelDelayHideUI()
  tickInstance:ClearTick(self, hide_delay_ttid)
  self.hide_delay_tt = nil
  self:_Main_HideUI(false)
end

function PhotoStandPanel:_Main_HideUI(isTrue)
  if isTrue ~= false then
    isTrue = true
  end
  for i = 1, #self.hide_tween do
    self.hide_tween[i].gameObject:SetActive(true)
    self.hide_tween[i].enabled = true
    if isTrue then
      self.hide_tween[i].duration = 1
      self.hide_tween[i]:PlayForward()
    else
      self.hide_tween[i].duration = 0.2
      self.hide_tween[i]:PlayReverse()
    end
  end
end

function PhotoStandPanel:Main_SlideSwitch(is_left)
  if self.cx_list_data then
    if self.cx_list_data.usageTag == "theme_slide" then
      local curIndex = self.cx_list_data.curSpotPicIndex
      local sum = self.cx_list_data.sum
      local album_sum, new_album_index = #self.relThemeList
      if is_left and curIndex <= 1 then
        new_album_index = 1 >= self.album_index and album_sum or self.album_index - 1
        local _data = self.relThemeList[new_album_index]
        self:SetViewContext(_data)
        self:ToThemeSlideView(self.album_index, 0)
        return
      elseif not is_left and curIndex >= sum then
        new_album_index = album_sum <= self.album_index and 1 or self.album_index + 1
        local _data = self.relThemeList[new_album_index]
        self:SetViewContext(_data)
        self:ToThemeSlideView(self.album_index, 1)
        return
      end
    end
    self.cx_list_data:SetCurSpotPicIndex(self.cx_list_data.curSpotPicIndex + (is_left and -1 or 1))
    self:SetViewContext(self.cx_list_data)
    self:Main_RefreshView()
  end
end

function PhotoStandPanel:Main_SlideSwitchTheme(is_left)
  local album_sum, new_album_index = #self.relThemeList
  if is_left then
    new_album_index = self.album_index <= 1 and album_sum or self.album_index - 1
  else
    new_album_index = album_sum <= self.album_index and 1 or self.album_index + 1
  end
  local _data = self.relThemeList[new_album_index]
  self:SetViewContext(_data)
  self:ToThemeSlideView(self.album_index, 1)
end

function PhotoStandPanel:Album_RefreshView(check)
  if not self.album_index then
    self.album_index = 1
  end
  if #self.relThemeList == 0 then
    return
  elseif self.album_index > #self.relThemeList then
    self.album_index = 1
  end
  self:Album_ShowAlbumThisIndex()
  if self.usage_mypost then
    self.album_back_btn:SetActive(false)
    self.album_tab_panel:SetActive(false)
    self.album_my_post_part:SetActive(true)
    self.album_my_post_getAll:SetActive(false)
    self.album_my_post_noreward:SetActive(false)
    if check then
      ServicePhotoCmdProxy.Instance:CallBoardQueryAwardPhotoCmd()
    end
  else
    self.album_back_btn:SetActive(true)
    self.album_tab_panel:SetActive(true)
    self.album_my_post_part:SetActive(false)
    self:Album_RefreshThemePopList()
  end
end

function PhotoStandPanel:Album_RefreshWrapCellList()
  self.album_wraplist:ResetDatas(ReUniteCellData(self.cx_list_data.briefList, 3), true)
end

function PhotoStandPanel:Album_RefreshThemePopList()
  local list = {}
  for _, v in pairs(self.relThemeList) do
    list[#list + 1] = {
      id = #list + 1,
      Name = v.name,
      data = v,
      forceHideRedTip = true
    }
  end
  self.album_theme_tabs:SetData(list)
end

function PhotoStandPanel:Album_ThemePopList_tabClick(aaa)
  self.album_index = self.selectTabData.id
  self:Album_ShowAlbumThisIndex()
end

function PhotoStandPanel:Album_ShowAlbumThisIndex()
  local _data = self.relThemeList[self.album_index]
  _data:SetCurSpotPicIndex(1)
  if not self.usage_mypost then
    _data:SetUsageTag("theme")
  end
  self:SetViewContext(_data)
  if _data.sum == 0 or _data.sum == nil then
    self.album_empty_ct:SetActive(true)
    self.album_list_ct:SetActive(false)
    self.album_page_dot:SetActive(false)
    self.album_left_btn:SetActive(false)
    self.album_right_btn:SetActive(false)
  else
    self.album_empty_ct:SetActive(false)
    self.album_list_ct:SetActive(true)
    if _data.sum <= 9 then
      self.album_page_dot:SetActive(false)
      self.album_left_btn:SetActive(false)
      self.album_right_btn:SetActive(false)
    else
      self.album_page_dot:SetActive(true)
      self.album_left_btn:SetActive(true)
      self.album_right_btn:SetActive(true)
      self:Album_RefreshPageDot(0)
    end
    self:Album_RefreshWrapCellList()
  end
end

function PhotoStandPanel:Album_RefreshPageDot(pct)
  for i = 1, #self.album_page_dots do
    self.album_page_dots[i]:SetActive(true)
  end
  if pct < 0.8 then
    self.album_page_dots[5]:SetActive(false)
  end
  if pct < 0.6 then
    self.album_page_dots[4]:SetActive(false)
  end
  if pct < 0.4 then
    self.album_page_dots[3]:SetActive(false)
  end
  if pct < 0.2 then
    self.album_page_dots[2]:SetActive(false)
  end
end

function PhotoStandPanel:Album_WrapList_OnScrollStart()
  self.album_scrollUpdateTick = tickInstance:CreateTick(0, 500, self.Album_WrapList_OnScrollUpdate, self, 998)
end

function PhotoStandPanel:Album_WrapList_OnScrollStop()
  tickInstance:ClearTick(self, 998)
end

local offset_left = -227
local offset_each = 338

function PhotoStandPanel:Album_WrapList_OnScrollUpdate()
  local maxShowIdx = 0
  local minShowIdx = 9999999
  local cells = self.album_wraplist:GetCellCtls()
  for c = 1, #cells do
    local single = cells[c]:GetCells()
    for j = 1, #single do
      if single[j].gameObject.activeSelf and single[j].data then
        if maxShowIdx < single[j].data.idx then
          maxShowIdx = single[j].data.idx
        end
        if minShowIdx > single[j].data.idx then
          minShowIdx = single[j].data.idx
        end
      end
    end
  end
  local total = #self.cx_list_data.briefList
  local pct = maxShowIdx / total
  self:Album_RefreshPageDot(pct)
  local offset_right = (#self.album_wraplist.datas - 3) * offset_each + offset_left
  local current = self.album_scrollView.panel.clipOffset.x
  self.album_left_btn:SetActive(current > offset_left + 20)
  self.album_right_btn:SetActive(current < offset_right - 20)
  local spidx = math.floor((minShowIdx + maxShowIdx) / 2)
  spidx = math.floor((spidx - 1) / 3) * 3 + 1
  self.cx_list_data:SetCurSpotPicIndex(spidx)
end

function PhotoStandPanel:Album_RefreshWrapCellList_EachCell()
  local cells = self.album_wraplist:GetCellCtls()
  for c = 1, #cells do
    local single = cells[c]:GetCells()
    for j = 1, #single do
      single[j]:RefreshCellView()
    end
  end
end

function PhotoStandPanel:Album_WrapList_HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  if data and cellctl.status == PhotoStandAlbumCell.PhotoStatus.Success then
    self:ToThemeSlideView(self.album_index, data.idx)
  end
end

function PhotoStandPanel:Album_WrapList_PassReDLPic(cellctl)
  local data = cellctl and cellctl.data
  if data then
    local picData = PhotoStandProxy.Instance:_GetPicData(data.id, data.accid)
    if picData then
      picData:DownloadTex()
    end
  end
end

function PhotoStandPanel:Album_WrapList_ManuallyMove(is_left)
  local offset_right = (#self.album_wraplist.datas - 3) * offset_each + offset_left
  local current = self.album_scrollView.panel.clipOffset.x
  local next = current + (is_left and -1 or 1) * offset_each
  next = math.clamp(next, offset_left, offset_right)
  local offset = Vector3(current - next, 0, 0)
  self.album_scrollView:DisableSpring()
  self.album_scrollView:MoveRelative(offset)
  self:Album_WrapList_OnScrollUpdate()
end

function PhotoStandPanel:UpdateReceiveCollections()
  if self.cx_pic_data then
    local uz = self.cx_pic_data.unawardzeny or 0
    local collections = self.cx_pic_data.laoyelists
    self.receive_gridList:ResetDatas(collections)
    if not collections or #collections == 0 then
      self.receive_none.gameObject:SetActive(true)
    else
      self.receive_none.gameObject:SetActive(false)
    end
    if uz == 0 then
      self.receive_confirmButton_BC.enabled = false
      self:SetTextureGrey(self.receive_confirmButton)
      self.receive_confirmLabel.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
      self.receive_confirmLabel.effectColor = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
    else
      self.receive_confirmButton_BC.enabled = true
      self:SetTextureWhite(self.receive_confirmButton)
      self.receive_confirmLabel.color = LuaColor(1, 1, 1)
      self.receive_confirmLabel.effectColor = LuaColor(0.6196078431372549, 0.33725490196078434, 0)
    end
  else
    self.receive_gridList:ResetDatas({})
    self.receive_none.gameObject:SetActive(true)
  end
end

function PhotoStandPanel:receive_clickHandler(cellCtl)
  local cellData = cellCtl.data
  if cellCtl == self.curCell or cellData.charid == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(cellCtl.data.charid)
end

function PhotoStandPanel:author_clickHandler()
  if not self.cx_pic_data then
    return
  end
  local data = self.cx_pic_data:Author_GetAuthorInfoRaw()
  self.curCell = self.main_author_info_cell
  if data then
    self:_Main_ShowPlayerTip(data)
  end
end

function PhotoStandPanel:OnOnHandleQueryUserInfo(note)
  local data = note.body
  if self.cx_pic_data and self.cx_pic_data.charid == data.data.guid then
    self.cx_pic_data:Author_SetAuthorInfo(data.data)
    self:_Main_SetAuthorInfoCell()
  end
  if self.curCell == nil then
    return
  end
  self:_Main_ShowPlayerTip(data)
end

function PhotoStandPanel:_Main_ShowPlayerTip(data)
  if not data then
    return
  end
  local playerTipFunc = {"AddFriend", "ShowDetail"}
  local playerTipFunc_Friend = {"ShowDetail"}
  local stick = self.curCell
  local playerTipOffset = {-400, 0}
  if self.curCell ~= self.main_author_info_cell then
    stick = self.curCell.nameLb
    playerTipOffset = {-20, 14}
  else
    stick = self.main_author_info_cell.simpleInfoLb
    playerTipOffset = {-20, -100}
  end
  local _playerTipData = PlayerTipData.new()
  _playerTipData:SetBySocialData(data.data or data)
  FunctionPlayerTip.Me():CloseTip()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(stick, NGUIUtil.AnchorSide.TopRight, playerTipOffset)
  local playerTipInitData = {}
  playerTipInitData.playerData = _playerTipData
  playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(_playerTipData.id) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(playerTipInitData)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:OnExit()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function PhotoStandPanel:HighResTex_AddEventListener()
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadSucc, self.HighResTex_OnPhotoDonwloadSucc)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadFailed, self.HighResTex_OnPhotoDonwloadFailed)
  self:AddListenEvt(PhotoStandProxy.TEMP_Server.DL_HighRes_PhotoDonwloadTerminated, self.HighResTex_OnPhotoDonwloadTerminated)
end

function PhotoStandPanel:HighResTex_OnPhotoDonwloadSucc(data)
  if self.main_trans and self.main_trans.activeSelf and self.cx_pic_data and self.cx_pic_data.id == data.body.id and self.cx_pic_data.accid == data.body.accid then
    self:HighResTex_TrySet()
  end
end

function PhotoStandPanel:HighResTex_OnPhotoDonwloadFailed(data)
end

function PhotoStandPanel:HighResTex_OnPhotoDonwloadTerminated(data)
end

function PhotoStandPanel:HighResTex_TrySet()
  if not self.cx_pic_data then
    return
  end
  if self.high_tex and self.high_tex_id == self.cx_pic_data.id and self.high_tex_accid == self.cx_pic_data.accid then
    redlog("high_tex already set")
    return
  end
  local _tex = self.cx_pic_data:GetHighResTex()
  if _tex then
    self.main_uitex.mainTexture = _tex
    PictureManager.ReFitManualHeight(self.main_uitex)
    self:HighResTex_Dispose()
    self.high_tex = _tex
    self.high_tex_id = self.cx_pic_data.id
    self.high_tex_accid = self.cx_pic_data.accid
  end
end

function PhotoStandPanel:HighResTex_Dispose()
  if not isNil(self.high_tex) then
    Object.DestroyImmediate(self.high_tex)
    self.high_tex = nil
  end
  self.high_tex_id = nil
  self.high_tex_accid = nil
end

function PhotoStandPanel:Main_TrySendPostcard()
  local url = self.cx_pic_data:GetPhotoUrl(false)
  url = PhotoAdpter.Ins():GetCDNUrl(url)
  local local_path = self.cx_pic_data:GetLocalResPath(true) or self.cx_pic_data:GetLocalResPath()
  local source = EPOSTCARDPHOTOSOURCE.EPHOTO_SOURCE_PHOTO_BOARD
  PostcardView.ViewType = UIViewType.PopUpLayer
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PostcardView,
    viewdata = {
      usageType = 1,
      pendingSelectTarget = true,
      url = url,
      source = source,
      local_path = local_path
    }
  })
end
