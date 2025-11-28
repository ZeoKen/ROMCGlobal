autoImport("LotteryResultCell")
LotteryResultView = class("LotteryResultView", ContainerView)
LotteryResultView.ViewType = UIViewType.PopUpLayer
local GetLocalPosition = LuaGameObject.GetLocalPosition

function LotteryResultView:Init()
  self:FindObjs()
  self:InitShow()
  local close = self:FindGO("CloseButton", pfb)
  self:AddClickEvent(close, function()
    GameFacade.Instance:sendNotification(XDEUIEvent.LotteryAnimationEnd)
    self:CloseSelf()
  end)
  local share = self:FindGO("ShareButton")
  self:AddClickEvent(share, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    local itemList = {}
    for i = 1, #self.list do
      itemList[#itemList + 1] = self.list[i]
    end
    for i = 1, #self.extraList do
      itemList[#itemList + 1] = self.extraList[i]
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryResultShareView,
      viewdata = itemList
    })
  end)
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
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function LotteryResultView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function LotteryResultView:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
  self.extraEffectContainer = self:FindGO("ExtraEffectContainer")
  self.specialBg = self:FindGO("SpecialBg")
end

function LotteryResultView:InitShow()
  local data = self.viewdata.viewdata.list
  if data then
    self.list = {}
    self.extraList = {}
    local mid = math.floor(#data / 2)
    for i = 1, mid do
      self.list[#self.list + 1] = data[i]:Clone()
    end
    for i = mid + 1, #data do
      self.extraList[#self.extraList + 1] = data[i]:Clone()
    end
    local grid = self:FindGO("Grid"):GetComponent(UIGrid)
    self.itemCtl = UIGridListCtrl.new(grid, LotteryResultCell, "LotteryResultCell")
    self.itemCtl:ResetDatas(self.list)
    local extraGrid = self:FindGO("ExtraGrid"):GetComponent(UIGrid)
    self.extraItemCtl = UIGridListCtrl.new(extraGrid, LotteryResultCell, "LotteryResultCell")
    self.extraItemCtl:ResetDatas(self.extraList)
    local itemCells = self.itemCtl:GetCells()
    for i = 1, #itemCells do
      self:SetNormal(self.effectContainer, LotteryProxy.IsSSR(itemCells[i].data), GetLocalPosition(itemCells[i].trans))
    end
    itemCells = self.extraItemCtl:GetCells()
    for i = 1, #itemCells do
      if i == #itemCells and self.viewdata.viewdata.count < #data then
        self:SetSpecial(self.extraEffectContainer, LotteryProxy.IsSSR(itemCells[i].data), GetLocalPosition(itemCells[i].trans))
      else
        self:SetNormal(self.extraEffectContainer, LotteryProxy.IsSSR(itemCells[i].data), GetLocalPosition(itemCells[i].trans))
      end
    end
  end
  local button = self:FindGO("Button")
  local btnText = self.viewdata.viewdata.btnText
  if btnText ~= nil then
    local label = self:FindGO("Label", button)
    local sl = SpriteLabel.new(label, nil, 36, 36, true)
    sl:SetText(btnText, true)
  end
  local btnCallback = self.viewdata.viewdata.btnCallback
  if btnCallback ~= nil then
    self:AddClickEvent(button, btnCallback)
  else
    self:AddClickEvent(button, function()
      self:CloseSelf()
    end)
  end
end

local effectName

function LotteryResultView:SetNormal(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.Egg10DritO or EffectMap.UI.Egg10DritB
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
end

function LotteryResultView:SetSpecial(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.Egg10DritO or EffectMap.UI.Egg10DritB
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
  self.specialBg:SetActive(true)
  self.specialBg.transform.localPosition = LuaGeometry.GetTempVector3(x + 40, y + 40, z)
end
