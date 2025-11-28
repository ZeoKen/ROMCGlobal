autoImport("RewardEffectCell")
autoImport("RewardEffectTabCell")
RewardEffectView = class("RewardEffectView", SubView)
RewardEffectView.ViewType = UIViewType.NormalLayer
local SUB_VIEW_PATH = ResourcePathHelper.UIView("RewardEffectView")

function RewardEffectView:Init()
  self:AddEvts()
  self.pageInited = false
end

function RewardEffectView:LoadSubView()
  self.objRoot = self:FindGO("RewardEffectView")
  local obj = self:LoadPreferb_ByFullPath(SUB_VIEW_PATH, self.container.composeObj, true)
  obj.name = "RewardEffectView"
end

function RewardEffectView:FindObjs()
  self:ReLoadPerferb("view/RewardEffectView", true)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.noneTip = self:FindComponent("NoChooseTip", UILabel)
  self.noneTip.text = ZhString.Warband_RewardEff_Empty
  self.effecTabs = self:FindGO("effecTabs"):GetComponent(UIGrid)
  self.tabCtl = UIGridListCtrl.new(self.effecTabs, RewardEffectTabCell, "ItemTabCell")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEffectTab, self)
  local panel = self.container.gameObject:GetComponent(UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  self.videoGO = self:FindGO("movietexture")
  self.videoPlayerNGUI = self.videoGO:GetComponent(VideoPlayerNGUI)
  self.playVideoBtn = self:FindGO("playBtn", self.videoGO)
  
  function self.videoPlayerNGUI.onStarted()
    self.videoGO:SetActive(true)
    self.playVideoBtn:SetActive(false)
  end
  
  function self.videoPlayerNGUI.onReadyToPlay()
    self.videoGO:SetActive(true)
    self.playVideoBtn:SetActive(false)
  end
  
  function self.videoPlayerNGUI.onError()
    self.playVideoBtn:SetActive(false)
  end
  
  self:AddClickEvent(self.videoGO, function()
    self:PlayVideo(false)
  end)
  self:AddClickEvent(self.playVideoBtn, function()
    self:PlayVideo(true)
  end)
  self.pvpEffectTip = self:FindGO("EffectTip")
  local tipLabel = self.pvpEffectTip:GetComponent(UILabel)
  tipLabel.text = ZhString.RewardEffectView_PvpEffectTip
  self:UpdateTabList()
  self:ChooseTab(1)
end

function RewardEffectView:InitView()
  if nil == self.tableCtl then
    self.tableCtl = UIGridListCtrl.new(self.grid, RewardEffectCell, "RewardEffectCell")
    self.tableCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickEffectCell, self)
  end
end

function RewardEffectView:UpdateTabList()
  local tabDatas = ReusableTable.CreateArray()
  for i = 1, 2 do
    local data = {id = i}
    table.insert(tabDatas, data)
  end
  self.tabCtl:ResetDatas(tabDatas)
  ReusableTable.DestroyAndClearArray(tabDatas)
end

function RewardEffectView:ClickEffectTab(cell)
  local data = cell.data
  if not data then
    return
  end
  self.curTab = cell.tabType
  self.pvpEffectTip:SetActive(self.curTab == 2)
  self:ClickFirstCell()
end

function RewardEffectView:ChooseTab(tab)
  local cells = self.tabCtl:GetCells()
  local cell = cells[tab]
  if cell then
    self:ClickEffectTab(cell)
    cell:SetTog(true)
  end
end

function RewardEffectView:UpdateView()
  if not self.pageInited then
    return
  end
  local data = PvpProxy.Instance:GetEffectList(self.curTab)
  local notUsing = not PvpProxy.Instance:GetEffectInUse(self.curTab)
  if #data == 1 then
    self.noneTip.text = ZhString.RewardEffectView_NoneReward
  elseif not notUsing then
    self.noneTip.text = ZhString.RewardEffectView_NoneUse
  end
  self.noneTip.gameObject:SetActive(#data == 1 or notUsing)
  redlog("SetActive", data and #data)
  self.tableCtl:ResetDatas(data)
  self:UpdateTabList()
end

function RewardEffectView:Switch(show)
  if show then
    if not self.pageInited then
      self:FindObjs()
      self:InitView()
      self.pageInited = true
    end
    self.gameObject:SetActive(true)
    self:ClickFirstCell()
  elseif self.pageInited then
    self.gameObject:SetActive(false)
  end
end

function RewardEffectView:AddEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3EffectInfoUpdateUserCmd, self.UpdateView)
end

function RewardEffectView:OnClickEffectCell(cellctl, ignoreNotify)
  self:CloseVideo()
  self.videoGO:SetActive(false)
  local effectID = cellctl and cellctl.effectData.id
  local eType = cellctl and cellctl.effectData.tabType or 0
  self.curEffectID = effectID
  self.curChooseCtl = cellctl
  local data = Table_UserEffectInfo[effectID]
  if data then
    self.videoPath = data.VideoPath
    self:OpenVideo(true)
  else
    self.noneTip.gameObject:SetActive(true)
    local data = PvpProxy.Instance:GetEffectList(self.curTab)
    if #data == 1 then
      self.noneTip.text = ZhString.RewardEffectView_NoneReward
    elseif not PvpProxy.Instance:GetEffectInUse(self.curTab) then
      self.noneTip.text = ZhString.RewardEffectView_NoneUse
    end
  end
  if not ignoreNotify then
    ServiceSceneUser3Proxy.Instance:CallEffectInfoUseUserCmd(effectID, eType)
  end
end

function RewardEffectView:SetChoose(id)
  local cell = self.tableCtl:GetCells()
  if nil == cell then
    return
  end
  for _, cells in pairs(cell) do
    for k, cell in pairs(cells:GetCells()) do
      cell:SetChoose(id)
    end
  end
end

local F_SafePlayVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Play()
  videoPlayerNGUI.volume = FunctionPerformanceSetting.Me():GetBGMSetting()
end
local F_SafePauseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Pause()
end
local F_SafeOpenVideo = function(videoPlayerNGUI, videoPath, pathAbsolute)
  local video = videoPath
  local video_Branched = FunctionVideoStorage.GetBranchedVideoName(videoPath)
  if not FileHelper.ExistFile(videoPath) then
    local url_b = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(video_Branched)
    local url = XDCDNInfo.GetVideoServerURL() .. FunctionVideoStorage.GetVideoPath(video)
    HTTPRequest.Head(url_b, function(x)
      if not NetIngPersonalPhoto.Ins().netIngTerminated then
        local unityWebRequest = x
        local responseCode = unityWebRequest.responseCode
        if responseCode == 200 then
          videoPlayerNGUI:OpenVideo(url_b, pathAbsolute)
        else
          videoPlayerNGUI:OpenVideo(url, pathAbsolute)
        end
      end
    end)
    return
  end
  videoPlayerNGUI:OpenVideo(videoPath, pathAbsolute)
end
local F_SafeCloseVideo = function(videoPlayerNGUI)
  videoPlayerNGUI:Close()
end
local F_SafeVideo_loop = function(videoPlayerNGUI, b)
  videoPlayerNGUI.loop = b
end

function RewardEffectView:GetUrl(id)
  local url
  if not url and id then
    local data = Table_UserEffectInfo[id]
    if data then
      local datapath = data.VideoPath
      url = string.format("video/%s", datapath)
    end
  end
  if StringUtil.IsEmpty(url) then
    return
  elseif string.sub(url, 1, 4) ~= "http" then
    url = self:GetUrlPrefix() .. url
  end
  return url
end

function RewardEffectView:GetUrlPrefix()
  local prefix = BranchMgr.IsChina() and XDCDNInfo.GetFileServerURL() or RO.Config.BuildBundleEnvInfo.ResCDN
  if not StringUtil.IsEmpty(prefix) and string.sub(prefix, -1, -1) ~= "/" then
    return prefix .. "/"
  end
  return prefix or ""
end

function RewardEffectView:PlayVideo(b)
  if b then
    self.videoGO:SetActive(true)
  end
  if not self.nowVideoPath then
    return
  end
  if Slua.IsNull(self.videoGO) or not self.videoGO.activeSelf then
    return
  end
  local exeRet, errorMsg
  if b then
    exeRet, errorMsg = xpcall(F_SafePlayVideo, debug.traceback, self.videoPlayerNGUI)
    if exeRet then
      self.playVideoBtn:SetActive(false)
    end
  else
    exeRet, errorMsg = xpcall(F_SafePauseVideo, debug.traceback, self.videoPlayerNGUI)
    if exeRet then
      self.playVideoBtn:SetActive(true)
    end
  end
  if not exeRet then
    LogUtility.Error(tostring(errorMsg))
  end
end

function RewardEffectView:OpenVideo(autoStart)
  self.videoGO:SetActive(true)
  if self.videoPath ~= self.nowVideoPath then
    if self.nowVideoPath then
      self:CloseVideo()
    end
    self.videoGO:SetActive(true)
    self.nowVideoPath = self.videoPath
    local exeRet, errorMsg
    exeRet, errorMsg = xpcall(F_SafeOpenVideo, debug.traceback, self.videoPlayerNGUI, self.nowVideoPath, true)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
      self.playVideoBtn:SetActive(false)
    end
    exeRet, errorMsg = xpcall(F_SafeVideo_loop, debug.traceback, self.videoPlayerNGUI, true)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
    end
    self.videoPlayerNGUI.autoStart = autoStart or false
  end
end

function RewardEffectView:CloseVideo()
  if Slua.IsNull(self.videoGO) then
    return
  end
  if self.nowVideoPath then
    self.nowVideoPath = nil
  end
  if not Slua.IsNull(self.videoGO) and self.videoGO.activeSelf then
    local exeRet, errorMsg = xpcall(F_SafeCloseVideo, debug.traceback, self.videoPlayerNGUI)
    if not exeRet then
      LogUtility.Error(tostring(errorMsg))
    end
  end
end

function RewardEffectView:OnEnter()
  self:ClickFirstCell()
end

function RewardEffectView:ClickFirstCell()
  if not self.pageInited then
    return
  end
  local data = PvpProxy.Instance:GetEffectList(self.curTab)
  self.noneTip.gameObject:SetActive(#data == 1)
  redlog("self.noneTip.gameObject:", #data)
  self.tableCtl:ResetDatas(data)
  local cells = self.tableCtl:GetCells()
  local displayCell
  for i = 1, #cells do
    if cells[i].isused then
      displayCell = cells[i]
      break
    end
  end
  displayCell = displayCell or cells[1]
  self:OnClickEffectCell(displayCell, true)
end

function RewardEffectView:OnDestroy()
  RewardEffectView.super.OnDestroy(self)
  self:CloseVideo()
end
