using("UnityEngine")
LetterContainerView = class("LetterContainerView", BaseView)
LetterContainerView.DrawOutDuration = 3500
local letterContainerEffName = "Eff_ownership_open"

function LetterContainerView:Init()
  self:InitData()
  self:InitView()
  if self.PartName then
    self.letter = self:LoadPreferb("part/" .. self.PartName)
    self.letter:SetActive(false)
    self:InitLetterPart()
  else
    LogUtility.ErrorFormat("Please provide letter part name")
  end
end

function LetterContainerView:InitData()
  if self.LetterConfigIndex and GameConfig.Letter[self.LetterConfigIndex] then
    self.cfg = GameConfig.Letter[self.LetterConfigIndex]
  end
end

function LetterContainerView:InitView()
  self.effectanchor = self:FindGO("effectanchor")
  self.confirmbtn = self:FindGO("confirmbtn")
  self.share = self:FindGO("share")
  self:AddClickEvent(self.confirmbtn, function()
    self:OnClickConfirmBtn()
  end)
  self:AddButtonEvent("blackbg", function()
    self:OnClickBlackBg()
  end)
  self:AddButtonEvent("NodeForShareSina", function()
    self:ShareAndReward(E_PlatformType.Sina)
  end)
  self:AddButtonEvent("NodeForShareQQ", function()
    self:ShareAndReward(E_PlatformType.QQ)
  end)
  self:AddButtonEvent("NodeForShareWeiXin", function()
    self:ShareAndReward(E_PlatformType.WechatMoments)
  end)
end

function LetterContainerView:InitLetterPart()
  local bg = self:FindGO("BG", self.letter)
  self.letterBgCollider = bg:GetComponent(BoxCollider)
  self:AddClickEvent(bg, function()
    self:OnClickLetterBg()
  end)
end

function LetterContainerView:OnEnter()
  LetterContainerView.super.OnEnter(self)
  self:PlayUIEffect(letterContainerEffName, self.effectanchor, false, function(go, args, assetEffect)
    self.letterEffect = assetEffect
    local effectObjectAnchor = self:FindGO("anchor", self:FindGO("home_letter2", assetEffect.effectObj))
    local trans = self.letter.transform
    trans:SetParent(effectObjectAnchor.transform, false)
    trans.localScale = LuaGeometry.Const_V3_one
    trans.localPosition = LuaGeometry.Const_V3_zero
    trans.localRotation = LuaGeometry.Const_Qua_identity
    if not self.HideConfirmBtn then
      trans = self.confirmbtn.transform
      trans:SetParent(self:FindGO("btn", assetEffect.effectObj).transform, true)
      self.confirmbtn:SetActive(true)
    end
    if self.cfg then
      local tips = self:FindComponent("Label", UILabel, assetEffect.effectObj)
      tips.text = self.cfg.Tips
    end
    self.letterEffect:SetPlaybackSpeed(0)
    self.letter:SetActive(true)
  end)
end

function LetterContainerView:OnClickConfirmBtn()
end

function LetterContainerView:OnClickBlackBg()
end

function LetterContainerView:OnClickLetterBg()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function LetterContainerView:ShareAndReward(platform_type)
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  if not self.screenShotHelper then
    self.gameObject:AddComponent(ScreenShotHelper)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    SocialShare.Instance:ShareImage(path, "", "", platform_type, function(succMsg)
      ROFileUtils.FileDelete(path)
      if platform_type == E_PlatformType.Sina then
        MsgManager.ShowMsgByIDTable(566)
      end
    end, function(failCode, failMsg)
      ROFileUtils.FileDelete(path)
      local errorMessage = failMsg or "error"
      if failCode ~= nil then
        errorMessage = failCode .. ", " .. errorMessage
      end
      MsgManager.ShowMsg("", errorMessage, 0)
    end, function()
      ROFileUtils.FileDelete(path)
    end)
  end, gmCm, ui)
end
