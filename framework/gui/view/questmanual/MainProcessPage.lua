MainProcessPage = class("MainProcessPage", SubView)
autoImport("ManualQuestNodeCell")
autoImport("ProcessGiftCell")
autoImport("MainProcessTip")
autoImport("ItemNewCell")
autoImport("BagItemNewCell")
autoImport("RewardGridCell")
local tempRot = LuaQuaternion()

function MainProcessPage:Init()
end

function MainProcessPage:TryInit()
  if not self.loaded then
    self:ReLoadPerferb("view/MainProcessPage", false)
    self.loaded = true
    self:initView()
    self:addViewEventListener()
    self:initData()
    self:AddMapEvts()
  end
end

function MainProcessPage:initView()
  self.root = self:FindGO("Root")
  self.bgTexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  self.sliderPart = self:FindGO("ProcessSliderPart")
  self.sliderBg = self:FindGO("SliderBg"):GetComponent(UISprite)
  self.progressSlider = self:FindGO("Slider"):GetComponent(UISlider)
  self.sliderThumb = self:FindGO("Thumb")
  self.giftNode = self:FindGO("GiftNode")
  self.cellParent = self:FindGO("NodeParent")
  self.processTip = self:FindGO("MainProcessTip")
  self.processTipCtrl = MainProcessTip.new(self.processTip)
  self.processTip:SetActive(false)
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
  self.energy = self:FindGO("Energy")
  self.energyLabel = self:FindGO("EnergyLabel"):GetComponent(UILabel)
  self.rewardPanel = self:FindGO("RewardPanel")
  self.closeReward = self:FindGO("CloseReward")
  self.rewardGrid = self:FindGO("RewardGrid", self.rewardPanel):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.recvBtn = self:FindGO("RecvBtn")
  self.conditionLabel = self:FindGO("ConditionLabel"):GetComponent(UILabel)
  self.recvBtnCollider = self.recvBtn:GetComponent(BoxCollider)
  self.rewardPanel:SetActive(false)
  self.noInfoPanel = self:FindGO("NoInfo")
  self.noInfoLabel = self:FindGO("Label", self.noInfoPanel):GetComponent(UILabel)
  self.noInfoLabel.text = string.format(ZhString.QuestManual_NoneTip, ZhString.QuestManual_ProcessPage)
  self.rewardEffectHandler = self:FindGO("RewardEffectHandler")
  self.rewardEffectRq = self.rewardEffectHandler:GetComponent(ChangeRqByTex)
end

function MainProcessPage:initData()
  self.nodeCells = {}
  self.giftCells = {}
  self.curVersion = "8.0"
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.rewardEffect = {}
end

function MainProcessPage:addViewEventListener()
  self:AddClickEvent(self.closeReward, function()
    self.rewardPanel:SetActive(false)
  end)
  self:AddClickEvent(self.recvBtn, function()
    self.rewardPanel:SetActive(false)
    redlog("call================>申请进度条进度奖励", self.curVersion, self.curGiftProcess)
    ServiceGoalCmdProxy.Instance:CallGetScoreRewardGoalCmd(self.curVersion, self.curGiftProcess)
  end)
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function MainProcessPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.GoalCmdQueryGoalListGoalCmd, self.RefreshCurVersion)
  self:AddListenEvt(ServiceEvent.GoalCmdNewGoalItemUpdateGoalCmd, self.UpdateSingleCells)
  self:AddListenEvt(ServiceEvent.GoalCmdNewGoalScoreUpdateGoalCmd, self.UpdateScore)
  self:AddListenEvt(ServiceEvent.GoalCmdNewGroupUpdateGoalCmd, self.RefreshCurVersion)
  self:AddListenEvt(ServiceEvent.GoalCmdGetRewardGoalCmd, self.RefreshCurVersion)
  self:AddListenEvt(ServiceEvent.GoalCmdGetScoreRewardGoalCmd, self.RefreshCurVersion)
  self:AddListenEvt(QuestManualEvent.RemoveNodeChooseState, self.setDefaultChooseStatus)
end

function MainProcessPage:SetData(version)
  helplog("MainProcessPage:SetData", version)
  self.curVersion = version
  self:InitNodeCells()
  self:RefreshCurVersion()
end

function MainProcessPage:RefreshCurVersion()
  redlog("刷新界面")
  self.versionDatas = QuestManualProxy.Instance:GetVersionGoalList(self.curVersion)
  if not self.versionDatas then
    redlog("无数据，申请", self.curVersion)
    ServiceGoalCmdProxy.Instance:CallQueryGoalListGoalCmd(self.curVersion)
    return
  end
  local items = self.versionDatas.items
  for k, v in pairs(items) do
    for m, n in pairs(self.nodeCells) do
      if n.stepid == k then
        self.nodeCells[m]:SetData(v)
      end
    end
  end
  local goalScore = self.versionDatas.score
  self.progressSlider.value = goalScore.score / 100
  self.processLabel.text = goalScore.score .. "/100"
  if goalScore.score < 20 then
    self.sliderThumb:SetActive(false)
  else
    self.sliderThumb:SetActive(true)
  end
  local rewards = goalScore.rewards
  for k, v in pairs(self.giftCells) do
    local finish = false
    if rewards and 0 < #rewards then
      for i = 1, #rewards do
        if rewards[i] == k then
          finish = true
        end
      end
    end
    if finish then
      v:InitStatus(2)
    else
      v:InitStatus(1, goalScore.score)
    end
  end
  local config = Game.Config_VersionGoal
  if not config then
    redlog("VersionGoal表不存在")
    return
  end
  local ids = config[self.curVersion]
  if not ids then
    self.noInfoPanel:SetActive(true)
    self.root:SetActive(false)
    return
  end
  local rewardConfig = GameConfig.VersionGoal.group_reward
  local versionReward = QuestManualProxy.Instance.versionGoalReward
  self.rewardEffectHandler:SetActive(true)
  if rewardConfig then
    for i = 1, #ids do
      local groupid = Table_VersionGoal[ids[i]].group
      if Table_VersionGoal[ids[i]].step ~= 1 then
        groupid = 0
      end
      local hasReward = rewardConfig[groupid]
      if hasReward then
        local maxRewardCount = hasReward.rewardStep and #hasReward.rewardStep or 0
        local curRewardCount = versionReward and versionReward[groupid] or 0
        if maxRewardCount > curRewardCount then
          if not self.rewardEffect[groupid] then
            xdlog("播特效")
            local path = ResourcePathHelper.EffectUI(hasReward.effect)
            local effect = self:LoadPreferb_ByFullPath(path, self.rewardEffectHandler)
            self.rewardEffect[groupid] = effect
            self.rewardEffectRq:AddChild(effect)
            local pos = hasReward.pos
            effect.transform.localPosition = LuaGeometry.GetTempVector3(pos[1], pos[2], 0)
            local randomScale = math.random(15, 20) / 10
            effect.transform.localScale = LuaGeometry.GetTempVector3(randomScale, randomScale, randomScale)
            LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, hasReward.dir))
            effect.transform.rotation = tempRot
          end
        elseif self.rewardEffect[groupid] then
          redlog("删除奖励特效")
          GameObject.DestroyImmediate(self.rewardEffect[groupid])
          self.rewardEffect[groupid] = nil
        end
      end
    end
  end
  self.rewardEffectRq.excute = true
end

function MainProcessPage:UpdateSingleCells(note)
  local data = note.body
  local item = data.item
  local id = item.id
  self.versionDatas = QuestManualProxy.Instance:GetVersionGoalList(self.curVersion)
  local items = self.versionDatas.items
  for k, v in pairs(self.nodeCells) do
    if v.stepid == id then
      xdlog("更新子内容", v.index)
      v:SetData(items[id])
    end
  end
end

function MainProcessPage:UpdateScore()
  xdlog("刷新分数进度条")
  self.versionDatas = QuestManualProxy.Instance:GetVersionGoalList(self.curVersion)
  local items = self.versionDatas.items
  local goalScore = self.versionDatas.score
  self.progressSlider.value = goalScore.score / 100
  self.processLabel.text = goalScore.score .. "/100"
  if goalScore.score < 20 then
    self.sliderThumb:SetActive(false)
  else
    self.sliderThumb:SetActive(true)
  end
  local rewards = goalScore.rewards
  if rewards then
    for k, v in pairs(self.giftCells) do
      local finish = false
      for i = 1, #rewards do
        if rewards[i] == k then
          finish = true
        end
      end
      if finish then
        v:InitStatus(2)
      else
        v:InitStatus(1, goalScore.score)
      end
    end
  end
end

function MainProcessPage:InitNodeCells()
  for k, v in pairs(self.nodeCells) do
    GameObject.DestroyImmediate(v.gameObject)
    self.nodeCells[k] = nil
  end
  for k, v in pairs(self.giftCells) do
    GameObject.DestroyImmediate(v.gameObject)
    self.giftCells[k] = nil
  end
  for k, v in pairs(self.rewardEffect) do
    GameObject.DestroyImmediate(v.gameObject)
    self.rewardEffect[k] = nil
  end
  local config = Game.Config_VersionGoal
  if not config then
    redlog("VersionGoal表不存在")
    return
  end
  local ids = config[self.curVersion]
  if not ids then
    self.noInfoPanel:SetActive(true)
    self.root:SetActive(false)
    return
  end
  self.noInfoPanel:SetActive(false)
  self.root:SetActive(true)
  self.rewardEffectHandler:SetActive(false)
  local picConfig = GameConfig.VersionGoal.version_pic[self.curVersion]
  if not picConfig then
    redlog("当前版本" .. self.curVersion .. "未配置version_pic参数,请检查")
    return
  end
  self.bgTextureName = "new_taskmanual_bg_pic"
  PictureManager.Instance:SetUI(self.bgTextureName, self.bgTexture)
  for i = 1, #ids do
    local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ManualQuestNodeCell"), self.cellParent)
    cellpfb.name = "ManualQuestNodeCell" .. i
    local singleCtrl = ManualQuestNodeCell.new(cellpfb)
    singleCtrl:SetIndex(ids[i])
    singleCtrl:InitShow(picConfig.nodeResources)
    singleCtrl:AddEventListener(MouseEvent.MouseClick, self.clickCell, self)
    self.nodeCells[ids[i]] = singleCtrl
  end
  local rewardConfig = GameConfig.VersionGoal.version_reward[self.curVersion]
  if not rewardConfig then
    redlog("当前version未配置奖励列表，请检查GameConfig.VersionGoal.version_reward" .. self.curVersion)
    return
  end
  local sliderBgWidth = self.sliderBg.width
  helplog("进度条宽度", sliderBgWidth)
  for k, v in pairs(rewardConfig) do
    local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ProcessGiftCell"), self.giftNode)
    cellpfb.name = "ProcessGiftCell" .. k
    local singleCtrl = ProcessGiftCell.new(cellpfb)
    singleCtrl:InitShow(k, sliderBgWidth)
    singleCtrl:AddEventListener(MouseEvent.MouseClick, self.clickGiftCell, self)
    self.giftCells[k] = singleCtrl
  end
end

function MainProcessPage:Show(target)
  self:TryInit()
  MainProcessPage.super.Show(self, target)
  redlog("MainProcessPage:Show")
end

function MainProcessPage:Hide(target)
  self:TryInit()
  helplog("====MainProcessPage:Hide==>>>")
  MainProcessPage.super.Hide(self, target)
end

function MainProcessPage:clickCell(cell)
  helplog("clickCell", cell.index, cell.stepid)
  if cell.status == 1 then
    cell:ShowEffect(false)
  elseif cell.status == 3 then
    redlog("call=============>申请领取奖励", cell.stepid)
    cell:CallRewardGoalCmd()
    return
  elseif cell.status == 4 then
    redlog("call=============>申请领取分数", cell.stepid)
    ServiceGoalCmdProxy.Instance:CallGetScoreGoalCmd(cell.stepid)
    return
  end
  if cell.label.text == "GO" then
    redlog("点击选中的内容")
    self.processTipCtrl:ClickGO()
    return
  end
  self.processTip:SetActive(true)
  local staticData = Table_VersionGoal[cell.index]
  if staticData then
    self.energyLabel.text = staticData.Point or 0
    local nodeType = staticData.type
    if nodeType == 1 then
      helplog("任务型", self.curVersion)
      local versionData = QuestManualProxy.Instance:GetManualQuestDatas(self.curVersion)
      if versionData then
        if not cell.data then
          helplog("当前节点未解锁")
          local tempInfo = {}
          tempInfo.stepName = ZhString.QuestManual_LockTitle
          tempInfo.stepTarget = staticData.unlock_desc
          self.processTipCtrl:SetData(cell.index, tempInfo)
          self:SetNodeChoose(cell.index)
          return
        end
        local data = versionData.main
        local findFirst = false
        if 0 < #data.questList and not findFirst then
          local firstAcceptQuest
          local acceptQuestList = {}
          for i = 1, #data.questList do
            local quest = data.questList[i]
            if (quest.type == SceneQuest_pb.EQUESTLIST_ACCEPT or quest.type == SceneQuest_pb.EQUESTLIST_CANACCEPT) and not findFirst then
              helplog("设置firstacceptQuest")
              firstAcceptQuest = quest
              findFirst = true
            end
          end
          if not firstAcceptQuest then
            helplog("找不到数据只能找假的了", version)
            local list = QuestProxy.Instance:GetCanAcceptMainQuestListByVersion(version)
            if list[1] then
              helplog("随意取第一个")
              local data = {}
              data.questData = list[1]
              firstAcceptQuest = data
            end
          end
          if firstAcceptQuest then
            helplog("找到了当前version唯一追踪任务")
            self.processTipCtrl:SetData(cell.index, firstAcceptQuest, cell.data.rewards)
            self:SetNodeChoose(cell.index)
          else
            redlog("假数据的也没找到")
          end
        end
      else
        redlog("无versionData")
      end
    elseif nodeType == 2 then
      helplog("条件型")
      if not cell.data then
        helplog("当前节点未解锁")
        local tempInfo = {}
        tempInfo.stepName = staticData.maintitle
        tempInfo.stepTarget = staticData.unlock_desc
        self.processTipCtrl:SetData(cell.index, tempInfo)
        self:SetNodeChoose(cell.index)
        return
      end
      local data = {}
      data.gotomode = staticData.GoToMode or 0
      data.versionGoalID = staticData.id
      data.process = cell.curProcess
      self.processTipCtrl:SetData(cell.index, data)
      self:SetNodeChoose(cell.index)
    end
  end
end

function MainProcessPage:SetNodeChoose(index)
  for k, v in pairs(self.nodeCells) do
    if k == index then
      redlog("SetChooseNode", index)
      v:SetChoose(true)
    else
      v:SetChoose(false)
    end
  end
end

function MainProcessPage:setDefaultChooseStatus()
  redlog("重置选择状态")
  for k, v in pairs(self.nodeCells) do
    v:SetChoose(false)
  end
end

function MainProcessPage:clickGiftCell(cell)
  helplog("ClickGiftCell", cell.giftProcess)
  if not self.versionDatas then
    return
  end
  self.curGiftProcess = cell.giftProcess
  self.rewardPanel:SetActive(true)
  self.curRewardList = {}
  local config = GameConfig.VersionGoal.version_reward[self.curVersion]
  if not config then
    redlog("当前version未配置奖励列表，请检查GameConfig.VersionGoal.version_reward" .. self.curVersion)
    return
  end
  self:UpdateItemsListByRewardGroup(config[cell.giftProcess], self.curRewardList)
  self.rewardCtrl:ResetDatas(self.curRewardList)
  local score = self.versionDatas.score
  if not score then
    return
  end
  if score.score >= cell.giftProcess then
    self.recvBtn:SetActive(true)
    self.conditionLabel.text = ""
  else
    self.recvBtn:SetActive(false)
    self.conditionLabel.text = string.format(ZhString.QuestManual_ProcessExpNeed, cell.giftProcess)
    return
  end
  if score and score.rewards then
    for i = 1, #score.rewards do
      if score.rewards[i] == cell.giftProcess then
        helplog("已领过奖")
        self:SetTextureGrey(self.recvBtn)
        self.recvBtnCollider.enabled = false
        return
      end
    end
    self:SetTextureColor(self.recvBtn, Color(57, 105, 245), true)
    self.recvBtnCollider.enabled = true
  end
end

function MainProcessPage:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0})
  end
end

function MainProcessPage:UpdateItemsListByRewardGroup(rewardids, array)
  local singleRewardID = rewardids
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
