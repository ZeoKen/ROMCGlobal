MemoryPopup = class("MemoryPopup", BaseView)
autoImport("MemoryPageCell")
autoImport("MemoryTitleCell")
autoImport("WrapInfiniteListCtrl")
MemoryPopup.ViewType = UIViewType.PopUpLayer
local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function MemoryPopup:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end

function MemoryPopup:FindObjs()
  self.frontPanel = self:FindGO("FrontPanel")
  self.funcPart = self:FindGO("FuncPart", self.frontPanel)
  self.arrow_left = self:FindGO("Arrow_Left"):GetComponent(UISprite)
  self.arrow_right = self:FindGO("Arrow_Right"):GetComponent(UISprite)
  self:AddClickEvent(self.arrow_left.gameObject, function()
    self:GoLeft()
  end)
  self:AddClickEvent(self.arrow_right.gameObject, function()
    self:GoRight()
  end)
  self.pageScrollView = self:FindGO("PageScrollView"):GetComponent(UIScrollView)
  self.pagePanel = self:FindGO("PageScrollView"):GetComponent(UIPanel)
  self.pageContainer = self:FindGO("PageContainer")
  self.wrap = self.pageContainer:GetComponent(UIWrapContent)
  local width, height, scale = UIManagerProxy.Instance:GetMyMobileScreenSize(2)
  self.wrap.itemSize = width
  local clip = self.pagePanel.baseClipRegion
  self.pagePanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, width, height)
  self.pageWrap = WrapInfiniteListCtrl.new(self.pageContainer, MemoryPageCell, "MemoryPageCell", WrapListCtrl_Dir.Horizontal, 10, true, 3)
  self.pageWrap:AddEventListener(UICellEvent.OnMidBtnClicked, self.handleClickEditBtn, self)
  self.pageWrap:AddStoppedMovingCall(self.OnCellStopMoving, self)
  self.keyPanel = self:FindGO("KeyPanel")
  self.confirmBtn = self:FindGO("ConfirmBtn", self.keyPanel)
  self.cancelBtn = self:FindGO("CancelBtn", self.keyPanel)
  self.titleScrollView = self:FindGO("TitleScrollView", self.keyPanel):GetComponent(UIScrollView)
  self.titleGrid = self:FindGO("TitleGrid", self.keyPanel):GetComponent(UIGrid)
  self.titleCtrl = UIGridListCtrl.new(self.titleGrid, MemoryTitleCell, "MemoryTitleCell")
  self.titleCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickKeyPoint, self)
  self:AddClickEvent(self.confirmBtn, function()
    xdlog("申请修改关键点", self.version, nil)
    local result1 = {}
    local cells = self.titleCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].checkMark.activeSelf then
        table.insert(result1, cells[i].id)
      end
    end
    if #result1 <= 0 then
      MsgManager.ShowMsgByID(43478)
      return
    end
    YearMemoryProxy.Instance:CallSetYearMemoryTitleUserCmd(self.version, nil, result1)
    self.keyPanel:SetActive(false)
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self.keyPanel:SetActive(false)
  end)
  self.titleCount = self:FindGO("TitleCount"):GetComponent(UILabel)
  self.shareBtn = self:FindGO("ShareBtn")
  self:AddClickEvent(self.shareBtn, function()
    xdlog("分享")
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    self:Show(self.goUIViewSocialShare)
  end)
  self.saveBtn = self:FindGO("SaveBtn")
  self:AddClickEvent(self.saveBtn, function()
    xdlog("保存图片")
    self:DoSave()
  end)
  self.shareTips = self:FindGO("ShareTips")
  self.shareIcon = self:FindGO("FirstRewardIcon", self.shareTips):GetComponent(UISprite)
  self.shareCount = self:FindGO("FirstRewardCountLbl", self.shareTips):GetComponent(UILabel)
  self.shareTexture = self:FindGO("ShareTexture"):GetComponent(UITexture)
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  if self.screenShotHelper == nil then
    self.gameObject:AddComponent(ScreenShotHelper)
    self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  end
  self:InitSharePart()
end

function MemoryPopup:InitSharePart()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  self.closeShare = self:FindGO("closeShare", self.gameObject)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
  self:AddClickEvent(self.closeShare, function()
    self:Hide(self.goUIViewSocialShare)
  end)
end

function MemoryPopup:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function MemoryPopup:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function MemoryPopup:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function MemoryPopup:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    self:sharePicture(E_PlatformType.Sina, "", contentBody)
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end

function MemoryPopup:InitShow()
  self.pages = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.pages or {}
  local version = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.version
  self.version = version
  self.activityID = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.activityid
  local index = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.index or 1
  local hasSummary = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.includeSummary
  local firstShow = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.firstShow
  if firstShow then
    self:PlayEnterTween()
  end
  YearMemoryProxy.Instance:CallQueryYearMemoryUserCmd(self.version)
  local staticData = YearMemoryProxy.Instance:GetVersionData(version)
  local unlockData = YearMemoryProxy.Instance:GetMemoryStatus(version)
  if self.pages and #self.pages > 0 then
    xdlog("页数", self.pages[1])
  else
    redlog("没有带页数，则显示当前解锁的所有页签")
    if not hasSummary then
      local process = unlockData and unlockData.process or 0
      if 0 < process then
        self.pages = {}
        for i = 1, process do
          table.insert(self.pages, i)
        end
      else
        self:CloseSelf()
      end
    else
      table.insert(self.pages, 0)
    end
  end
  local datas = {}
  for i = 1, #self.pages do
    table.insert(datas, {
      version = version,
      page = self.pages[i],
      summary = self.pages[i] == 0 and 1 or nil,
      firstShow = firstShow
    })
  end
  self.pageWrap:ResetDatas(datas)
  self.pageWrap:SetStartPositionByIndex(index)
  self.curPage = index
  self:UpdateArrow()
  local shareReward = staticData and staticData.share_reward
  if shareReward then
    local itemData = Table_Item[shareReward[1]]
    IconManager:SetItemIcon(itemData and itemData.Icon, self.shareIcon)
    self.shareIcon:MakePixelPerfect()
    self.shareIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
    self.shareCount.text = "x " .. shareReward[2]
  end
  self.shareValid = hasSummary
  if hasSummary then
    self:UpdateGottedReward()
  else
    self.shareTips:SetActive(false)
  end
end

function MemoryPopup:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3YearMemoryProcessUserCmd, self.handleProcessUpdate, self)
  self:AddListenEvt(ServiceEvent.ActivityCmdYearMemoryActInfoCmd, self.handleProcessUpdate, self)
  self:AddListenEvt(ServiceEvent.SceneUser3QueryYearMemoryUserCmd, self.InitShow, self)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function MemoryPopup:UpdateGottedReward()
  if not self.shareValid then
    return
  end
  if not self.activityID then
    self.shareTips:SetActive(false)
    return
  end
  local actValid = ActivityIntegrationProxy.Instance:CheckActPersinalActValid(self.activityID)
  if not actValid then
    self.shareTips:SetActive(false)
    return
  end
  local unlockData = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
  local gottedReward = unlockData and unlockData.gotten_share_reward
  self.shareTips:SetActive(not gottedReward)
end

function MemoryPopup:OnCellStopMoving(curCell)
  local page = curCell.page
  xdlog("停止所在页", page)
  self.curPage = page
  self.pageWrap:ScrollTowardsCell(curCell)
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, page)
end

function MemoryPopup:GoLeft()
  if not self.curPage then
    return
  end
  self.curPage = self.curPage - 1
  if self.curPage < 1 then
    self.curPage = 1
  end
  local cells = self.pageWrap:GetCells()
  for _, cell in pairs(cells) do
    if cell and cell.page and cell.page == self.curPage then
      self.pageWrap:ScrollTowardsCell(cell)
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, cell.page)
      break
    end
  end
  self:UpdateArrow()
end

function MemoryPopup:GoRight()
  if not self.curPage then
    return
  end
  self.curPage = self.curPage + 1
  if self.curPage > #self.pages then
    self.curPage = #self.pages
  end
  local cells = self.pageWrap:GetCells()
  for _, cell in pairs(cells) do
    if cell and cell.page and cell.page == self.curPage then
      self.pageWrap:ScrollTowardsCell(cell)
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, cell.page)
      break
    end
  end
  self:UpdateArrow()
end

function MemoryPopup:UpdateArrow()
  if #self.pages == 1 then
    self.arrow_left.alpha = 0
    self.arrow_right.alpha = 0
    return
  end
  if self.curPage == 1 then
    self.arrow_left.alpha = 0.4
  else
    self.arrow_left.alpha = 1
  end
  if self.curPage == #self.pages then
    self.arrow_right.alpha = 0.4
  else
    self.arrow_right.alpha = 1
  end
end

function MemoryPopup:handleClickEditBtn()
  xdlog("点击编辑")
  self.keyPanel:SetActive(true)
  if not self.initedKeyPoint then
    self.initedKeyPoint = true
    local result = {}
    local validIndexes = YearMemoryProxy.Instance:GetValidIndexesByVersion(self.version)
    if validIndexes and #validIndexes then
      for i = 1, #validIndexes do
        local id = validIndexes[i]
        local info = Table_YearMemoryLine[validIndexes[i]]
        if info and info.Preview and info.Preview ~= "" then
          table.insert(result, id)
        end
      end
    end
    self.titleCtrl:ResetDatas(result)
  end
  local data = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
  local serverData = data and data.keypoints or {}
  local totalCount = 0
  local cells = self.titleCtrl:GetCells()
  for i = 1, #cells do
    local isChoose = 0 < TableUtility.ArrayFindIndex(serverData, cells[i].id)
    cells[i]:SetChoose(isChoose)
    if isChoose then
      totalCount = totalCount + 1
    end
  end
  for i = 1, #cells do
    local isChoose = 0 < TableUtility.ArrayFindIndex(serverData, cells[i].id)
    cells[i]:SetStatus(isChoose and true or totalCount < 3 and true or false)
  end
  self.titleCount.text = totalCount .. "/3"
end

function MemoryPopup:handleClickKeyPoint(cellCtrl)
  local isActive = cellCtrl.checkMark.activeSelf
  local totalCount = 0
  local cells = self.titleCtrl:GetCells()
  for i = 1, #cells do
    local isChoose = cells[i].checkMark.activeSelf
    if isChoose then
      totalCount = totalCount + 1
    end
  end
  if isActive then
    totalCount = totalCount - 1
    cellCtrl:SetChoose(false)
  elseif 3 <= totalCount then
    redlog("已满")
  else
    cellCtrl:SetChoose(true)
    totalCount = totalCount + 1
  end
  for i = 1, #cells do
    local isChoose = cells[i].checkMark.activeSelf
    cells[i]:SetStatus(isChoose and true or totalCount < 3 and true or false)
  end
  self.titleCount.text = totalCount .. "/3"
end

function MemoryPopup:handleProcessUpdate(note)
  xdlog("数据更新")
  local cells = self.pageWrap:GetCells()
  for _, cell in pairs(cells) do
    if cell and cell.isSummary then
      cell:SetData(cell.data)
    end
  end
  self:UpdateGottedReward()
end

function MemoryPopup:DoShare(bool)
  xdlog("分享")
  if bool then
    self:Hide(self.goUIViewSocialShare)
    self.funcPart:SetActive(false)
    self.shareTexture.gameObject:SetActive(true)
  else
    self.funcPart:SetActive(true)
    self.shareTexture.gameObject:SetActive(false)
  end
  local cells = self.pageWrap:GetCells()
  for _, cell in pairs(cells) do
    cell:SetScreenShotMode(bool)
  end
end

function MemoryPopup:DoSave()
  xdlog("保存")
  self:savePicture()
end

function MemoryPopup:sharePicture(platform_type, content_title, content_body)
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:DoShare(true)
  if self.shareValid then
    YearMemoryProxy.Instance:CallYearMemoryGetShareRewardCmd(self.version)
    self.shareTips:SetActive(false)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:DoShare(false)
    self.shareTips:SetActive(false)
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    if self.texture ~= nil then
      texture = self.texture
    else
      xdlog("没有获得 texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    if not BranchMgr.IsChina() then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      if platform_type ~= "fb" then
        xdlog("startSharePicture", platform_type .. "分享")
        if platform_type == "twitter" then
          content_title = OverseaHostHelper.TWITTER_MSG
        end
        overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
          redlog("msg" .. msg)
          ROFileUtils.FileDelete(path)
          if msg == "1" then
            Debug.Log("success")
          else
            MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
          end
        end)
        return
      end
      xdlog("startSharePicture", "fb 分享图片")
      overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
        end
      end)
      return
    end
    SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
      helplog("StarView Share success")
      ROFileUtils.FileDelete(path)
      if platform_type == E_PlatformType.Sina then
        MsgManager.ShowMsgByIDTable(566)
      end
    end, function(failCode, failMsg)
      helplog("StarView Share failure")
      ROFileUtils.FileDelete(path)
      local errorMessage = failMsg or "error"
      if failCode ~= nil then
        errorMessage = failCode .. ", " .. errorMessage
      end
      MsgManager.ShowMsg("", errorMessage, 0)
    end, function()
      helplog("StarView Share cancel")
      ROFileUtils.FileDelete(path)
    end)
  end, gmCm, ui)
end

function MemoryPopup:savePicture()
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:DoShare(true)
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:DoShare(false)
    self.shareTips:SetActive(false)
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    if self.texture ~= nil then
      texture = self.texture
    else
      xdlog("没有获得 texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    if BranchMgr.IsJapan() and RuntimePlatform.IPhonePlayer == Application.platform then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      overseasManager:SetSavePhotoCallback(function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          Debug.Log("success")
        else
          MsgManager.FloatMsg("", OverseaHostHelper.SAVE_FAILED)
        end
      end)
    end
    FunctionSaveToDCIM.Me():TrySavePicToDCIM(path)
  end, gmCm, ui)
end

function MemoryPopup:SetScreenShotMode(bool)
end

function MemoryPopup:PlayEnterTween()
  self.funcPart:SetActive(false)
  TimeTickManager.Me():CreateOnceDelayTick(4500, function(owner, deltaTime)
    self.funcPart:SetActive(true)
  end, self, 1)
end

function MemoryPopup:OnEnter()
  MemoryPopup.super.OnEnter(self)
  PictureManager.ReFitFullScreen(self.shareTexture)
end

function MemoryPopup:OnExit()
  MemoryPopup.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
