VideoPreview = class("VideoPreview", BaseView)
VideoPreview.ViewType = UIViewType.Lv4PopUpLayer
local texObjStaticNameMap = {
  Bg = "College-transfer_bg_bottom",
  Line1 = "College-transfer_bg_line",
  Line2 = "College-transfer_bg_line",
  PlayBtn = "College-transfer_btn_play"
}

function VideoPreview:Init()
  self:InitData()
  self:FindObjs()
  self:InitVideoComp()
  self:AddEvents()
end

function VideoPreview:InitData()
  self.data = self.viewdata.viewdata
  if not self.data then
    LogUtility.Warning("Cannot play video when viewData is nil!")
  end
end

function VideoPreview:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.videoPlayer = self:FindComponent("VideoPlayer", VideoPlayerNGUI)
  self.addon = self:FindGO("Addon")
  self.descCtl = self:FindGO("DescCtl")
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.btn = self:FindGO("Btn")
  self.btnLabel = self:FindComponent("BtnLabel", UILabel)
  self.playCtl = self:FindGO("PlayCtl")
  self.tipLabel = self:FindComponent("TipLabel", UILabel)
end

function VideoPreview:InitVideoComp()
  function self.videoPlayer.onReadyToPlay()
    self.playCtl:SetActive(false)
  end
  
  function self.videoPlayer.onError()
    self.playCtl:SetActive(true)
    self.tipLabel.text = ZhString.VideoPreview_PlayFailed
  end
end

function VideoPreview:AddEvents()
  self:AddClickEvent(self.btn, function()
    self:OnClickBtn()
  end)
  self:AddButtonEvent("PlayBtn", function()
    self:TryPlayVideo()
  end)
  self:AddButtonEvent("Bg", function()
    self:CloseSelf()
  end)
end

function VideoPreview:OnEnter()
  VideoPreview.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    PictureManager.Instance:SetUI(texName, self[objName])
  end
  if not self.data then
    return
  end
  self:UpdatePreview()
  self:TryCheckWifi(self.TryPlayVideo)
end

function VideoPreview:OnExit()
  if self.videoPlayer.isPlaying then
    self.videoPlayer:Close()
  end
  for objName, texName in pairs(texObjStaticNameMap) do
    PictureManager.Instance:UnLoadUI(texName, self[objName])
  end
  VideoPreview.super.OnExit(self)
end

function VideoPreview:OnClickBtn()
  if type(self.btnFunc) ~= "function" then
    return
  end
  self.btnFunc(self.btnLabel)
end

function VideoPreview:UpdatePreview()
  redlog("videoplayer", self.videoPlayer)
  if self.data.loop == nil then
    self.videoPlayer.loop = true
  else
    self.videoPlayer.loop = self.data.loop and true or false
  end
  if self.data.skillId then
    local skillSData = Table_ClassShowSkill[self.data.skillId]
    if not skillSData then
      LogUtility.ErrorFormat("Cannot find static data of skill {0}", self.data.skillId)
      self:CloseSelf()
      return
    end
    self:SetTitleAndDesc(skillSData.name, skillSData.des)
  elseif self.data.btnText and self.data.btnFunc then
    self:SetBtn(self.data.btnText, self.data.btnFunc)
  elseif self.data.title then
    self:SetTitleAndDesc(self.data.title, self.data.desc)
  end
end

function VideoPreview:SetAddon(isActive)
  self.addon:SetActive(isActive and true or false)
  self.Bg.height = isActive and 564 or 467
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
end

function VideoPreview:SetTitleAndDesc(title, desc)
  self:SetAddon(true)
  self.descCtl:SetActive(true)
  self.btn:SetActive(false)
  self.titleLabel.text = title
  self.descLabel.text = desc
end

function VideoPreview:SetBtn(text, func)
  self:SetAddon(true)
  self.descCtl:SetActive(false)
  self.btn:SetActive(true)
  self.btnLabel.text = text
  self.btnFunc = func
end

function VideoPreview:TryCheckWifi(successFunc)
  if not successFunc then
    return
  end
  if ApplicationInfo.IsEmulator() then
    successFunc(self)
    return
  end
  InternetUtil.Ins:WIFIIsValid(function(success)
    if not self.playCtl then
      return
    end
    self.playCtl:SetActive(not success)
    self.tipLabel.text = ZhString.VideoPreview_WifiUnavailable
    if success then
      successFunc(self)
    end
  end)
end

function VideoPreview:GetUrl()
  local url = self.data.url
  if not url and self.data.skillId then
    url = Table_ClassShowSkill[self.data.skillId] and string.format("video/%s", self:_GetClassShowResource())
  end
  if StringUtil.IsEmpty(url) then
    return
  elseif string.sub(url, 1, 4) ~= "http" then
    url = self:GetUrlPrefix() .. url
  end
  return url
end

function VideoPreview:TryPlayVideo()
  local url = self:GetUrl()
  if not url then
    LogUtility.Warning("There's no video url to play")
    self.playCtl:SetActive(true)
    self.tipLabel.text = ZhString.VideoPreview_PlayFailed
    return
  end
  self.videoPlayer:OpenVideo(url, true)
end

local sexFieldMap = {"resource", "resource_F"}

function VideoPreview:_GetClassShowResource()
  if self.data.skillId and Table_ClassShowSkill[self.data.skillId] then
    local sexField = sexFieldMap[MyselfProxy.Instance:GetMySex()]
    return Table_ClassShowSkill[self.data.skillId][sexField]
  end
  return ""
end

function VideoPreview:GetUrlPrefix()
  local prefix = BranchMgr.IsChina() and XDCDNInfo.GetFileServerURL() or RO.Config.BuildBundleEnvInfo.ResCDN
  if not StringUtil.IsEmpty(prefix) and string.sub(prefix, -1, -1) ~= "/" then
    return prefix .. "/"
  end
  return prefix or ""
end
