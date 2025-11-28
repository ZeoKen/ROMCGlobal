AchieveRewardView = class("AchieveRewardView", ContainerView)
AchieveRewardView.ViewType = UIViewType.NormalLayer
autoImport("AchieveRewardCell")

function AchieveRewardView:OnEnter()
  xdlog("请求数据", self.groupid)
  AchieveRewardProxy.Instance:SetSendGroupID(self.groupid)
  ServiceAchieveCmdProxy.Instance:CallQueryNpcAchieveAchCmd(self.groupid)
  local npc = self.viewdata.viewdata and self.viewdata.viewdata.npc
  if npc then
    local viewPort = CameraConfig.HappyShop_ViewPort
    local rotation = CameraConfig.HappyShop_Rotation
    self:CameraFaceTo(npc.assetRole.completeTransform, viewPort, rotation)
  else
    self:CameraRotateToMe()
  end
end

function AchieveRewardView:OnExit()
  self:CameraReset()
  AchieveRewardView.super.OnExit(self)
end

function AchieveRewardView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitData()
end

function AchieveRewardView:FindObjs()
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = self.itemContainer,
    pfbNum = 6,
    cellName = "AchieveRewardCell",
    control = AchieveRewardCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
  local titleBg = self:FindGO("titleBg")
  self.titleLab = self:FindComponent("Label", UILabel, titleBg)
end

function AchieveRewardView:AddEvts()
  self:AddListenEvt(ServiceEvent.AchieveCmdUpdateNpcAchieveAchCmd, self.InitShow)
end

function AchieveRewardView:AddViewEvts()
end

function AchieveRewardView:InitData()
  self.groupid = self.viewdata.viewdata.groupid or 2
  xdlog("AchieveRewardView:InitData", self.groupid)
end

function AchieveRewardView:InitShow()
  local achieves = AchieveRewardProxy.Instance:GetAchieveRewardByGroup(self.groupid) or {}
  table.sort(achieves, function(a, b)
    local a_canGet = a.finish_time > 0 and a.reward_get == false
    local b_canGet = b.finish_time > 0 and b.reward_get == false
    if a_canGet ~= b_canGet then
      return a_canGet == true
    end
    local a_canGetReward = a.can_get_reward and 1 or 0
    local b_canGetReward = b.can_get_reward and 1 or 0
    if a_canGetReward ~= b_canGetReward then
      return a_canGetReward == 1
    end
    local a_isFinish = a.finish_time and a.finish_time > 0
    local b_isFinish = b.finish_time and b.finish_time > 0
    if a_isFinish ~= b_isFinish then
      return a_isFinish == false
    end
    local a_isRewardGet = a.reward_get or false
    local b_isRewardGet = b.reward_get or false
    if a_isRewardGet ~= b_isRewardGet then
      return a_isRewardGet == false
    end
    return a.id < b.id
  end)
  self.itemWrapHelper:UpdateInfo(achieves)
end

function AchieveRewardView:HandleClickItem(cell)
end

function AchieveRewardView:HandleClickIconSprite(cell)
end
