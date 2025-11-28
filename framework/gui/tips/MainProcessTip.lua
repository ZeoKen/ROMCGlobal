autoImport("QuestTraceCell")
MainProcessTip = class("MainProcessTip", BaseTip)
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local tempVector3 = LuaVector3.Zero()

function MainProcessTip:Init()
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.bgTweenScale = self.bg:GetComponent(TweenScale)
  self.table = self:FindGO("ContentTable"):GetComponent(UITable)
  self.contentTweenAlpha = self:FindGO("ContentTable"):GetComponent(TweenAlpha)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.content = self:FindGO("InfoContent")
  self.questTraceCell = QuestTraceCell.new(self.content)
  self.questTraceCell.RefreshMark = MainProcessTip.RefreshTraceMark
  self.rewardPart = self:FindGO("RewardPart")
  self.rewardTweenAlpha = self.rewardPart:GetComponent(TweenAlpha)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.goBtn = self:FindGO("TraceMark")
  self.goBtn:SetActive(false)
  self.traceGrid = self:FindGO("traceGrid")
  
  function self.closecomp.callBack(go)
    self:sendNotification(QuestManualEvent.RemoveNodeChooseState)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.rewardTweenAlpha:SetOnFinished(function()
    self.rewardGrid.gameObject:SetActive(true)
  end)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function MainProcessTip:SetData(configid, firstAcceptQuest, recvedRewards)
  local config = Table_VersionGoal[configid]
  if not config then
    return
  end
  local pos = config.Pos
  if pos[1] < -50 then
    LuaVector3.Better_Set(tempVector3, pos[1] + 45, pos[2] + 30, 0)
    self.gameObject.transform.localPosition = tempVector3
    self.bg.pivot = UIWidget.Pivot.TopLeft
    self.bg.transform.localPosition = LuaGeometry.Const_V3_zero
    self.goBtn.transform.localPosition = LuaGeometry.GetTempVector3(-40, -3.5, 0)
  else
    LuaVector3.Better_Set(tempVector3, pos[1] - 370, pos[2] + 30, 0)
    self.gameObject.transform.localPosition = tempVector3
    self.bg.pivot = UIWidget.Pivot.TopRight
    self.bg.transform.localPosition = LuaGeometry.GetTempVector3(339, 0, 0)
    self.goBtn.transform.localPosition = LuaGeometry.GetTempVector3(375, -3.5, 0)
  end
  local rewardConfig = GameConfig.VersionGoal.group_reward
  if rewardConfig and rewardConfig[config.group] then
    local maxRewardCount = #rewardConfig[config.group].rewardStep or 0
    local versionReward = QuestManualProxy.Instance.versionGoalReward
    local curRewardCount = 0
    if versionReward and versionReward[config.group] then
      curRewardCount = versionReward[config.group] or 0
    end
    if maxRewardCount <= curRewardCount then
      self.rewardPart:SetActive(false)
    else
      local itemList = {}
      local rewardStep = rewardConfig[config.group].rewardStep
      local rewardList = {}
      for i = curRewardCount, #rewardStep do
        table.insert(rewardList, rewardStep[i])
      end
      self.rewardPart:SetActive(true)
      self:UpdateRewards(rewardList, itemList)
      self.rewardCtrl:ResetDatas(itemList)
      self.rewardTweenAlpha:ResetToBeginning()
      self.rewardTweenAlpha:PlayForward()
      self.rewardGrid.gameObject:SetActive(false)
    end
  else
    self.rewardPart:SetActive(false)
  end
  if firstAcceptQuest then
    self.questTraceCell:SetData(firstAcceptQuest)
    self.curTraceQuest = firstAcceptQuest
    self.traceGrid:SetActive(true)
  else
    self.questTraceCell:SetData()
    self.traceGrid:SetActive(false)
    redlog("没有firstacceptquest")
  end
  self.table:Reposition()
  local size = calSize(self.table.transform)
  local height = size.size.y
  local offset = firstAcceptQuest ~= nil and 10 or 0
  self.bg.height = height + offset
  self.bgTweenScale:ResetToBeginning()
  self.bgTweenScale:PlayForward()
  self.contentTweenAlpha:ResetToBeginning()
  self.contentTweenAlpha:PlayForward()
end

function MainProcessTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  self.gameObject:SetActive(false)
  self.closecomp = nil
end

function MainProcessTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function MainProcessTip:RefreshTraceMark()
  self.traceMark:SetActive(false)
end

function MainProcessTip:ClickGO()
  helplog("ClickGO")
  if self.curTraceQuest.questData then
    if not self.questTraceCell.isMainViewTrace then
      local data = {}
      data.data = self.curTraceQuest
      EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, data)
    end
    FunctionQuest.Me():executeManualQuest(self.curTraceQuest.questData)
    return
  end
  if self.curTraceQuest.gotomode and self.curTraceQuest.gotomode ~= 0 then
    FuncShortCutFunc.Me():CallByID(self.curTraceQuest.gotomode)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  else
    MsgManager.ShowMsgByID(26009)
    return
  end
  self:sendNotification()
end

function MainProcessTip:UpdateRewards(rewardids, array)
  if rewardids and 0 < #rewardids then
    for i = 1, #rewardids do
      local singleRewardID = rewardids[i]
      local list = ItemUtil.GetRewardItemIdsByTeamId(singleRewardID)
      if list then
        for j = 1, #list do
          local single = list[j]
          local hasAdd = false
          for j = 1, #array do
            local temp = array[j]
            if temp.itemData.id == single.id then
              temp.num = temp.num + single.num
              hasAdd = true
              break
            end
          end
          if not hasAdd then
            local data = {}
            data.itemData = ItemData.new("Reward", single.id)
            if data.itemData then
              data.num = single.num
              table.insert(array, data)
            end
          end
        end
      end
    end
  end
end

function MainProcessTip:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-450, 0})
  end
end
