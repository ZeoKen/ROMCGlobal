AllProfessionShareView = class("AllProfessionShareView", BaseView)
autoImport("PhotographResultPanel")
autoImport("AdventureCollectionAchShowCell")
autoImport("ProfessionSimpleIconCell")
AllProfessionShareView.ViewType = UIViewType.ShareLayer
AllProfessionShareView.ShareType = {
  NormalShare = 1,
  SkadaShare = 2,
  RaidResultShare = 3
}

function AllProfessionShareView:Init()
  self:initView()
  self:initData()
end

function AllProfessionShareView:initView()
  self.secondContent = self:FindGO("secondContent")
  local collectionShowGrid = self:FindComponent("adventureProgressGrid", UIGrid)
  self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid, AdventureCollectionAchShowCell, "AdventureCollectionAchShowShareCell")
  self.adventurePropCt = self:FindGO("AdventurePropCt")
  grid = self:FindComponent("Grid", UIGrid, self.adventurePropCt)
  self.adventurePropGrid = UIGridListCtrl.new(grid, ProfessionSimpleIconCell, "ProfessionSimpleIconCell")
  self.adventurePropCtLeft = self:FindGO("AdventurePropCt_Left")
  gridLeft = self:FindComponent("Grid_Left", UIGrid, self.adventurePropCtLeft)
  self.adventurePropGridLeft = UIGridListCtrl.new(gridLeft, ProfessionSimpleIconCell, "ProfessionSimpleIconCell")
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  local myName = self:FindGO("myName"):GetComponent(UILabel)
  myName.text = Game.Myself.data.name
  local serverName = self:FindGO("ServerName"):GetComponent(UILabel)
  local curServer = FunctionLogin.Me():getCurServerData()
  local serverID = curServer and curServer.name or 1
  serverName.text = serverID
  if BranchMgr.IsJapan() then
    myName.gameObject:SetActive(false)
    serverName.gameObject:SetActive(false)
    local bg_name = self:FindGO("bg_name")
    if bg_name then
      bg_name:SetActive(false)
    end
  end
  local _myName = self:FindGO("_myName"):GetComponent(UILabel)
  _myName.text = Game.Myself.data.name
  local _serverName = self:FindGO("_ServerName"):GetComponent(UILabel)
  _serverName.text = serverID
  if BranchMgr.IsJapan() then
    _myName.gameObject:SetActive(false)
    _serverName.gameObject:SetActive(false)
  end
  local rewardTips = self:FindGO("WeekRewardTips")
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", rewardTips):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", GameConfig.Share.ShareReward[1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", rewardTips):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. GameConfig.Share.ShareReward[2]
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 1 then
    rewardTips:SetActive(false)
  else
    rewardTips:SetActive(true)
  end
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self.snsPlatform = {}
  local qq = self:FindGO("share_qq")
  self:AddClickEvent(qq, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
      self:SharePicture(E_PlatformType.QQ, "", "")
    else
      MsgManager.ShowMsgByIDTable(562)
    end
  end)
  qq:SetActive(false)
  self.snsPlatform.QQ = qq
  local wechat = self:FindGO("share_wechat")
  self:AddClickEvent(wechat, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
      self:SharePicture(E_PlatformType.Wechat, "", "")
    else
      MsgManager.ShowMsgByIDTable(561)
    end
  end)
  wechat:SetActive(false)
  self.snsPlatform.Wechat = wechat
  local sina = self:FindGO("share_weibo")
  self:AddClickEvent(sina, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
      self:SharePicture(E_PlatformType.Sina, "RO", "RO")
    else
      MsgManager.ShowMsgByIDTable(563)
    end
  end)
  sina:SetActive(false)
  self.snsPlatform.Sina = sina
  local fb = self:FindGO("share_fb")
  self:AddClickEvent(fb, function()
    self:SharePicture("fb", "RO", "RO")
  end)
  fb:SetActive(false)
  self.snsPlatform.Facebook = fb
  local twitter = self:FindGO("share_twitter")
  self:AddClickEvent(twitter, function()
    self:SharePicture("twitter", "RO", "RO")
  end)
  twitter:SetActive(false)
  self.snsPlatform.Twitter = twitter
  local line = self:FindGO("share_line")
  self:AddClickEvent(line, function()
    self:SharePicture("line", "RO", "RO")
  end)
  line:SetActive(false)
  self.snsPlatform.line = line
  local off = 0
  for i = 1, #GameConfig.Share.Sns_platform do
    if self.snsPlatform[GameConfig.Share.Sns_platform[i]] then
      self.snsPlatform[GameConfig.Share.Sns_platform[i]]:SetActive(true)
      self.snsPlatform[GameConfig.Share.Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-390 + off * 75, 0, 0)
      off = off + 1
    end
  end
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:UpdateHead()
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function AllProfessionShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function AllProfessionShareView:ShareToGlobalChannel()
end

function AllProfessionShareView:setCollectionAchievement()
end

function AllProfessionShareView:showPropView()
  local tempArray = CheckAllProfessionProxy.Instance:GetCellFirstRowTable(true)
  local jobDepth = ProfessionProxy.GetJobDepth()
  local jobArray = {}
  for k, v in pairs(tempArray) do
    if v and v.AdvanceClass then
      if #v.AdvanceClass >= 3 then
        local rightTable = {}
        for k, v in pairs(v.AdvanceClass) do
          if Table_Class[v] and Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
          else
            table.insert(rightTable, v)
          end
        end
        if #rightTable == 2 then
          for r = 1, #rightTable do
            if Table_Class[rightTable[r]] and Table_Class[rightTable[r]].IsOpen ~= 0 then
              if ProfessionProxy.Instance:IsThisIdYiGouMai(rightTable[r]) then
                local added = false
                for i = jobDepth, 0, -1 do
                  local thisidClass = Table_Class[rightTable[r] + i]
                  if thisidClass and ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightTable[r] + i) then
                    jobArray[#jobArray + 1] = rightTable[r] + i
                    added = true
                    break
                  end
                end
                if not added then
                  local typeBranch = Table_Class[rightTable[r]].TypeBranch
                  local branchInfo = Table_Branch[typeBranch]
                  if branchInfo then
                    local baseId = branchInfo.base_id
                    if ProfessionProxy.Instance:IsThisIdYiJiuZhi(baseId) then
                      jobArray[#jobArray + 1] = rightTable[r]
                    end
                  end
                end
              else
                jobArray[#jobArray + 1] = rightTable[r]
              end
            end
          end
        end
      elseif #v.AdvanceClass == 1 then
        if not ProfessionProxy.Instance:IsThisIdYiGouMai(v.id) then
          jobArray[#jobArray + 1] = v.id
        else
          for k1, v1 in pairs(v.AdvanceClass) do
            if v1 and Table_Class[v1] and Table_Class[v1].IsOpen ~= 0 then
              if ProfessionProxy.Instance:IsThisIdYiGouMai(v1) then
                for i = jobDepth, -1, -1 do
                  local thisidClass = Table_Class[v1 + i]
                  if thisidClass and ProfessionProxy.Instance:IsThisIdYiJiuZhi(v1 + i) then
                    jobArray[#jobArray + 1] = v1 + i
                    break
                  end
                end
              else
                jobArray[#jobArray + 1] = v.id
              end
            end
          end
        end
      elseif ProfessionProxy.IsHero(v.id) then
        if ProfessionProxy.Instance:IsThisIdYiGouMai(v.id) then
          jobArray[#jobArray + 1] = v.id
        end
      else
        for k1, v1 in pairs(v.AdvanceClass) do
          if v1 and Table_Class[v1] and Table_Class[v1].IsOpen ~= 0 then
            if ProfessionProxy.Instance:IsThisIdYiGouMai(v1) then
              local added = false
              for i = jobDepth, 0, -1 do
                local thisidClass = Table_Class[v1 + i]
                if thisidClass and ProfessionProxy.Instance:IsThisIdYiJiuZhi(v1 + i) then
                  jobArray[#jobArray + 1] = v1 + i
                  added = true
                  break
                end
              end
              if not added then
                local typeBranch = Table_Class[v1].TypeBranch
                local branchInfo = Table_Branch[typeBranch]
                if branchInfo then
                  local baseId = branchInfo.base_id
                  if ProfessionProxy.Instance:IsThisIdYiJiuZhi(baseId) then
                    jobArray[#jobArray + 1] = v1
                  end
                end
              end
            else
              jobArray[#jobArray + 1] = v1
            end
          end
        end
      end
    end
  end
  local locked = 0
  for k, v in pairs(jobArray) do
    if ProfessionProxy.Instance:IsThisIdYiGouMai(v) then
      locked = locked + 1
    end
  end
  if 12 < #jobArray then
    local jobArrayLeft = {}
    local jobArrayRight = {}
    for i = 1, #jobArray do
      if #jobArrayLeft < 12 then
        jobArrayLeft[#jobArrayLeft + 1] = jobArray[i]
      else
        jobArrayRight[#jobArrayRight + 1] = jobArray[i]
      end
    end
    self.adventurePropGridLeft:ResetDatas(jobArrayLeft)
    self.adventurePropGrid:ResetDatas(jobArrayRight)
  else
    self.adventurePropGridLeft:ResetDatas(jobArray)
  end
  self.title.text = string.format(ZhString.PrefessionShare_Title, locked, #jobArray)
end

function AllProfessionShareView:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

function AllProfessionShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
end

function AllProfessionShareView:SetData(data)
  self.data = data
  self:showPropView()
  self:setCollectionAchievement()
end

function AllProfessionShareView:GetGameObjects()
end

function AllProfessionShareView:RegisterButtonClickEvent()
end

function AllProfessionShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function AllProfessionShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function AllProfessionShareView:OnExit()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function AllProfessionShareView:SharePicture(platform_type, content_title, content_body)
  helplog("AllProfessionShareView SharePicture", platform_type)
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 0 then
    ServiceChatCmdProxy.Instance:CallShareSuccessNofityCmd()
    self:sendNotification(ShareNewEvent.HideWeekShraeTip, self)
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.CloseButton = self:FindGO("CloseButton")
  self.CloseButton:SetActive(false)
  self.SharePanel = self:FindGO("SharePanel")
  if self.SharePanel then
    self.SharePanel:SetActive(false)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.CloseButton:SetActive(true)
    if self.SharePanel then
      self.SharePanel:SetActive(true)
    end
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    if self.texture ~= nil then
      texture = self.texture
    else
      xdlog("没有获得 texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("StarView Share path", path)
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
