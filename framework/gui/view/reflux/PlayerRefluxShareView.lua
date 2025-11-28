PlayerRefluxShareView = class("PlayerRefluxShareView", BaseView)
PlayerRefluxShareView.ViewType = UIViewType.PopUpLayer
local bgName = "reflux_bg"
local roleBgName = "reflux_bg_03"
local recordBgName = "reflux_bg_bottem_04"
local sharePicName = "/Player_Reflux"
local picExt = ".jpg"

function PlayerRefluxShareView:Init()
  self:FindOBJ()
  self:AddEvents()
  self:InitData()
  if not BranchMgr.IsChina() then
    self:OverseaShare()
  end
end

function PlayerRefluxShareView:FindOBJ()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  if self.screenShotHelper == nil then
    self.screenShotHelper = self.gameObject:AddComponent(ScreenShotHelper)
  end
  local bgRoot = self:FindGO("Bg")
  self.rootBg = bgRoot:GetComponent("UITexture")
  self.rolePic = self:FindComponent("rolePic", UITexture, bgRoot)
  self.titleLable = self:FindComponent("titleLable", UILabel, bgRoot)
  self.disTitle = self:FindComponent("disTitle", UILabel, bgRoot)
  local recordBgRoot = self:FindGO("recordBg", bgRoot)
  self.recordBg = recordBgRoot:GetComponent("UITexture")
  self.itemLable = self:FindComponent("itemName", UILabel, recordBgRoot)
  self.infoLable = self:FindComponent("infoLable", UILabel, recordBgRoot)
  self.sprite = self:FindComponent("Icon_sprite", UISprite, recordBgRoot)
  self.inputLable = self:FindComponent("inputLable", UILabel, recordBgRoot)
  self.shareInfoLable = self:FindComponent("shareinfoLable", UILabel, bgRoot)
  self.closeButton = self:FindGO("ColseButton")
  self.shareRoot = self:FindGO("shareGridRoot")
  self.shareQQbtn = self:FindGO("shareQQBtn", self.shareRoot)
  self.shareWeiBoBtn = self:FindGO("shareWeiBoBtn", self.shareRoot)
  self.shareWeiChat = self:FindGO("shareWeChatBtn", self.shareRoot)
end

function PlayerRefluxShareView:AddEvents()
  self:AddClickEvent(self.closeButton, function()
    self:CloseSelf()
  end)
  if not BranchMgr.IsChina() then
    return
  end
  local sdkEnable = FunctionLogin.Me():getSdkEnable()
  self:AddClickEvent(self.shareQQbtn, function()
    if not sdkEnable then
      self:SharePlatform()
      return
    end
    if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
      self:SharePlatform(E_PlatformType.QQ)
    else
      MsgManager.ShowMsgByIDTable(562)
    end
  end)
  self:AddClickEvent(self.shareWeiBoBtn, function()
    if not sdkEnable then
      self:SharePlatform()
      return
    end
    if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
      self:SharePlatform(E_PlatformType.Sina)
    else
      MsgManager.ShowMsgByIDTable(563)
    end
  end)
  self:AddClickEvent(self.shareWeiChat, function()
    if not sdkEnable then
      self:SharePlatform()
      return
    end
    if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
      self:SharePlatform(E_PlatformType.Wechat)
    else
      MsgManager.ShowMsgByIDTable(561)
    end
  end)
end

function PlayerRefluxShareView:OverseaShare()
  local sp = self:FindComponent("Sprite", UISprite, self.shareQQbtn)
  IconManager:SetUIIcon("Facebook", sp)
  if BranchMgr.IsJapan() then
    sp = self:FindComponent("Sprite", UISprite, self.shareWeiBoBtn)
    IconManager:SetUIIcon("Twitter", sp)
    sp = self:FindComponent("Sprite", UISprite, self.shareWeiChat)
    IconManager:SetUIIcon("line", sp)
  else
    self.shareWeiBoBtn:SetActive(false)
    self.shareWeiChat:SetActive(false)
  end
  self:AddClickEvent(self.shareQQbtn, function()
    self:SharePlatform("fb")
  end)
  self:AddClickEvent(self.shareWeiBoBtn, function()
    self:SharePlatform("twitter")
  end)
  self:AddClickEvent(self.shareWeiChat, function()
    self:SharePlatform("line")
  end)
end

function PlayerRefluxShareView:OnExit()
  PictureManager.Instance:UnloadPlayerRefluxTexture(bgName, self.rootBg)
  PictureManager.Instance:UnloadPlayerRefluxTexture(roleBgName, self.rolePic)
  PictureManager.Instance:UnloadPlayerRefluxTexture(recordBgName, self.recordBg)
end

function PlayerRefluxShareView:OnEnter()
  PictureManager.Instance:SetPlayerRefluxTexture(bgName, self.rootBg)
  PictureManager.Instance:SetPlayerRefluxTexture(roleBgName, self.rolePic)
  PictureManager.Instance:SetPlayerRefluxTexture(recordBgName, self.recordBg)
end

function PlayerRefluxShareView:InitData()
  local invalidCode = self.viewdata.inviteCode
  self.inputLable.text = string.format(ZhString.PlayerRefluxView_Yao, invalidCode)
  local configIndex = 104201
  if GameConfig and GameConfig.ReturnInvitation then
    self.configData = GameConfig.ReturnInvitation[configIndex]
  end
  if self.configData and self.configData.ShareReward then
    local itemId = self.configData.ShareReward[1][1]
    local itemData = Table_Item[itemId]
    if itemData then
      if itemData.Icon then
        IconManager:SetItemIcon(itemData.Icon, self.sprite)
      end
      if itemData.NameZh then
        self.itemLable.text = itemData.NameZh
      end
    end
  end
  self.disTitle.text = self.configData.ShareActivityName or ""
  self.shareInfoLable.text = self.configData.ShareActivityInfo or ""
end

function PlayerRefluxShareView:SharePlatform(platform)
  if not FunctionLogin.Me():getSdkEnable() then
    self:ShareSucessCallBack()
    return
  end
  local camera = NGUIUtil:GetCameraByLayername("UI")
  self:SetUIVisible(false)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:SetUIVisible(true)
    self:OnGetScreenShotFinish(texture, "", "", platform)
  end, camera)
end

function PlayerRefluxShareView:SetUIVisible(isVisible)
  self.closeButton:SetActive(false)
  self.shareRoot:SetActive(false)
end

function PlayerRefluxShareView:OnGetScreenShotFinish(texture, title, content, platform)
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. sharePicName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. picExt
  helplog("path ====== ", path)
  local successFunc = function(msg)
    ROFileUtils.FileDelete(path)
  end
  local failFunc = function(errorCode, msg)
    ROFileUtils.FileDelete(path)
    redlog("share failed, errorCode = ", errorCode)
  end
  local cancelFunc = function()
    ROFileUtils.FileDelete(path)
  end
  if BranchMgr.IsChina() then
    SocialShare.Instance:ShareImage(path, title, content, platform, successFunc, failFunc, cancelFunc)
  else
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    if platform ~= "fb" then
      overseasManager:ShareImgWithChannel(path, title, OverseaHostHelper.Share_URL, content, platform, function(msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          Debug.Log("success")
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
        end
      end)
    else
      overseasManager:ShareImg(path, title, OverseaHostHelper.Share_URL, content, function(msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
        end
      end)
    end
  end
  self:ShareSucessCallBack()
end

function PlayerRefluxShareView:ShareSucessCallBack()
  self:sendNotification(PlayerRefluxEvent.ShareRelfuxPic)
  self:CloseSelf()
end
