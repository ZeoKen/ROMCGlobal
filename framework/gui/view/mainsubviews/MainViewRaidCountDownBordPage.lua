MainViewRaidCountDownBordPage = class("MainViewRaidCountDownBordPage", SubMediatorView)

function MainViewRaidCountDownBordPage:Init()
  self:ReLoadPerferb("view/MainViewRaidCountDownBordPage")
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:InitShow()
  self:Show()
end

function MainViewRaidCountDownBordPage:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewRaidCountDownBordPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewRaidCountDownBordPage:initData()
  self.tickMg = TimeTickManager.Me()
  self.isFirstTimeRefresh = true
end

function MainViewRaidCountDownBordPage:initView()
  self.countDownBord = self:FindGO("CountDownBord")
  self.countDownRoot = self:FindGO("CountDownRoot")
  self.uiTable = self.countDownRoot:GetComponent(UITable)
  self.countDownPart = self:FindGO("CountDown")
  self.raidInfo = self:FindGO("CurRaidInfo")
  self.raidInfo.gameObject:SetActive(false)
  self.raidInfoLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.raidInfoLabelTweenScale = self:FindGO("Label"):GetComponent(TweenScale)
  self.progressLabel = self:FindComponent("progressLabel", UILabel)
  self.raidInfoLabelTweenScale:SetOnFinished(function()
    self.uiTable:Reposition()
  end)
end

function MainViewRaidCountDownBordPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdTowerPrivateLayerCountdownNtf, self.UpdateTotalTime)
end

function MainViewRaidCountDownBordPage:Show(tarObj)
  MainViewRaidCountDownBordPage.super.Show(self, tarObj)
  if not tarObj then
    self.isInit = true
    self:SetData()
  end
end

function MainViewRaidCountDownBordPage:Hide(tarObj)
  MainViewRaidCountDownBordPage.super.Hide(self, tarObj)
  if not tarObj then
    self.isInit = false
    self:ClearTimer()
  end
  self.isFirstTimeRefresh = true
end

function MainViewRaidCountDownBordPage:SetData()
  self.starttime = ServerTime.CurServerTime() / 1000
  self.endTimeStamp = ServerTime.CurServerTime() / 1000 + 600
  self:ResetTimer(true)
  if Game.MapManager:IsPVeMode_EndlessTowerPrivate() then
    self.raidInfo:SetActive(true)
    local curMapID = Game.MapManager:GetMapID()
    if curMapID == 115 then
      local curLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
      self.raidInfoLabel.text = string.format(ZhString.PracticeField_Layer, curLayer + 1)
    elseif curMapID == 139 then
      local curLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_CHALLENGE_ENDLESS) or 0
      self.raidInfoLabel.text = string.format(ZhString.PracticeField_PoliChallenge, curLayer + 1)
    end
  else
    self.raidInfo:SetActive(false)
  end
  self.uiTable:Reposition()
end

function MainViewRaidCountDownBordPage:updateLeftTime()
  local leftTime = self.endTimeStamp - ServerTime.CurServerTime() / 1000
  if leftTime < 0 then
    leftTime = 0
    self:ClearTimer()
  end
  leftTime = math.floor(leftTime + 0.5)
  local m = math.floor(leftTime / 60)
  local sd = leftTime - m * 60
  local leftTimeStr = string.format("%02d:%02d", m, sd)
  self.progressLabel.text = leftTimeStr
end

function MainViewRaidCountDownBordPage:UpdateTotalTime(note)
  local data = note.body
  local endTimeStamp = data.overat
  xdlog("结束时间戳", endTimeStamp, "当前时间", ServerTime.CurServerTime() / 1000)
  self.endTimeStamp = endTimeStamp
  if self.endTimeStamp and self.endTimeStamp ~= 0 then
    self.countDownPart.gameObject:SetActive(true)
    self:ResetTimer(true)
  else
    self.countDownPart.gameObject:SetActive(false)
    self:ResetTimer(false)
  end
  if Game.MapManager:IsPVeMode_EndlessTowerPrivate() then
    self.raidInfo:SetActive(true)
    local curMapID = Game.MapManager:GetMapID()
    if curMapID == 115 then
      local curLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
      self.raidInfoLabel.text = string.format(ZhString.PracticeField_Layer, curLayer + 1)
    elseif curMapID == 139 then
      local curLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_CHALLENGE_ENDLESS) or 0
      self.raidInfoLabel.text = string.format(ZhString.PracticeField_PoliChallenge, curLayer + 1)
    end
  else
    self.raidInfo:SetActive(false)
  end
  self.uiTable:Reposition()
  if self.isFirstTimeRefresh then
    self.isFirstTimeRefresh = false
  else
    self.raidInfoLabelTweenScale:ResetToBeginning()
    self.raidInfoLabelTweenScale:PlayForward()
  end
end

function MainViewRaidCountDownBordPage:ResetTimer(restart)
  self:ClearTimer()
  if restart then
    self.timer = self.tickMg:CreateTick(0, 500, self.updateLeftTime, self)
  end
end

function MainViewRaidCountDownBordPage:ClearTimer()
  if self.timer then
    self.tickMg:ClearTick(self)
    self.timer = nil
  end
end
