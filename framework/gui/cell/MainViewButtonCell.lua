local BaseCell = autoImport("BaseCell")
MainViewButtonCell = class("MainViewButtonCell", BaseCell)
MainViewButtonType = {
  Menu = 1,
  Activity = 2,
  Auction = 3,
  MVP = 4,
  PVE = 5,
  PROFESSION = 6
}
local GuideTargetMap = {
  [1] = ClientGuide.TargetType.mainview_morebord_skillbutton,
  [3] = ClientGuide.TargetType.mainview_morebord_adventurebutton,
  [6] = ClientGuide.TargetType.mainview_morebord_guildbutton,
  [11] = ClientGuide.TargetType.mainview_morebord_setbutton,
  [17] = ClientGuide.TargetType.mainview_morebord_novicetarget2023button
}

function MainViewButtonCell:Init()
  self:InitUI()
end

function MainViewButtonCell:InitUI()
  self.sprite = self:FindComponent("Sprite", GradientUISprite)
  self.label = self:FindComponent("Label", UILabel)
end

function MainViewButtonCell:SetData(data)
  self.data = data
  local sData = self.data.staticData
  self:SetEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end, {
    hideClickSound = sData and sData.Sound ~= ""
  })
  if data.type == MainViewButtonType.Menu then
    if sData.name == "GM" then
      self.gameObject:SetActive(false)
      return
    end
    self.label.text = sData.name
    if sData.icon == "item_5549" then
      IconManager:SetItemIcon(sData.icon or "", self.sprite)
    elseif sData.icon == "123" or sData.icon == "124" then
      self.sprite.width = 66
      self.sprite.height = 66
      IconManager:SetUIIcon(sData.icon or "", self.sprite)
    elseif sData.icon == "calender_icon_zhishi" then
      self.sprite.width = 53
      self.sprite.height = 53
      IconManager:SetUIIcon(sData.icon or "", self.sprite)
    else
      IconManager:SetUIIcon(sData.icon or "", self.sprite)
      self.sprite:MakePixelPerfect()
    end
    local platHide = self:UpdatePlatformHide()
    if platHide then
      return
    end
    self.gameObject:SetActive(not self:CheckIosBranchHide())
  elseif data.type == MainViewButtonType.PVE then
    self.label.text = sData.name
    IconManager:SetUIIcon(sData.icon or "", self.sprite)
    self.sprite:MakePixelPerfect()
    FunctionUnLockFunc.Me():RegisteEnterBtn(8104, self.gameObject)
  elseif data.type == MainViewButtonType.Activity then
    self.label.text = sData.Name
    IconManager:SetUIIcon(sData.Icon or "", self.sprite)
    self.sprite:MakePixelPerfect()
    self:UpdateActivityState()
  elseif data.type == MainViewButtonType.MVP then
    IconManager:SetUIIcon(sData.icon or "", self.sprite)
    if GameConfig.CommuteBoss and GameConfig.CommuteBoss.isopen and GameConfig.CommuteBoss.isopen > 0 and not BranchMgr.IsJapan() then
      self.label.text = string.format([=[
%s
[c][6dccff]%s[-][/c]]=], sData.name, ServiceBossCmdProxy.GetBossCommuteTimeStr())
    else
      self.label.text = sData.name
    end
    self:UpdatePlatformHide()
  elseif data.type == MainViewButtonType.PROFESSION then
    self.label.text = sData.name
    local curJob = MyselfProxy.Instance:GetMyProfession()
    local classConfig = Table_Class[curJob]
    if classConfig then
      IconManager:SetNewProfessionIcon(classConfig.icon, self.sprite)
      self.sprite:MakePixelPerfect()
      self.sprite.width = self.sprite.width * 0.6
      self.sprite.height = self.sprite.height * 0.6
    end
  end
  if sData.id and GuideTargetMap[sData.id] then
    self:RegisterGuideTarget(GuideTargetMap[sData.id], self.gameObject)
  end
end

local EnvChannelIndex = {
  [EnvChannel.ChannelConfig.Develop.Name] = 1,
  [EnvChannel.ChannelConfig.Alpha.Name] = 2,
  [EnvChannel.ChannelConfig.Studio.Name] = 4,
  [EnvChannel.ChannelConfig.Gravity.Name] = 8,
  [EnvChannel.ChannelConfig.UWA.Name] = 16,
  [EnvChannel.ChannelConfig.Release.Name] = 32,
  [EnvChannel.ChannelConfig.Oversea.Name] = 32
}

function MainViewButtonCell:CheckIosBranchHide()
  local nowPlatform = ApplicationInfo.GetRunPlatform()
  if nowPlatform ~= RuntimePlatform.IPhonePlayer then
    return false
  end
  local channelName = EnvChannel.Channel.Name
  local branchHide = self.data.staticData.BranchHide
  if branchHide == nil then
    return false
  end
  local index = EnvChannelIndex[channelName]
  return 0 < branchHide & index
end

local PlatformHideMap = {
  [1] = RuntimePlatform.IPhonePlayer,
  [2] = RuntimePlatform.Android
}

function MainViewButtonCell:UpdatePlatformHide()
  local sData, platHide = self.data.staticData, false
  local nowPlatform = ApplicationInfo.GetRunPlatform()
  if type(sData.Enterhide) == "table" then
    for i = 1, #sData.Enterhide do
      local platformType = sData.Enterhide[i]
      if platformType == 0 or nowPlatform == PlatformHideMap[platformType] then
        platHide = true
        break
      end
    end
  end
  self.platHide = platHide or false
  return self.platHide
end

function MainViewButtonCell:UpdateActivityState()
  local aType = self.data and self.data.staticData.id
  if aType then
    local running = FunctionActivity.Me():IsActivityRunning(aType)
    self.gameObject:SetActive(running)
  else
    self.gameObject:SetActive(false)
  end
end

function MainViewButtonCell:UpdateAuction(totalSec, hour, min, sec)
  if self.data and totalSec ~= nil and hour ~= nil then
    if 24 <= hour then
      self.label.text = string.format(ZhString.Auction_CountdownDayName, hour / 24)
    else
      self.label.text = string.format(ZhString.Auction_CountdownName, hour, min, sec)
    end
  end
end

function MainViewButtonCell:UpdateLabel(str)
  if str ~= nil then
    self.label.text = str
  end
end
