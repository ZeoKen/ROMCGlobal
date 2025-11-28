local baseCell = autoImport("BaseCell")
AnnounceQuestPanelCellNew = class("AnnounceQuestPanelCellNew", baseCell)
autoImport("Table_NewWanted")
autoImport("AnnounceQuestVersionTaskCell")
AnnounceQuestPanelCellNewCellLabelColor = {
  [1] = LuaColor.New(0.7215686274509804, 0.3568627450980392, 0.10196078431372549, 1),
  [2] = LuaColor.New(0.14901960784313725, 0.4196078431372549, 0, 1),
  [3] = LuaColor.New(0.5137254901960784, 0.027450980392156862, 0.047058823529411764, 1)
}
AnnounceQuestPanelCellNewTitleLabelColor = {
  [1] = LuaColor.New(0.2, 0.5058823529411764, 0.7294117647058823, 1),
  [2] = LuaColor.New(0.5803921568627451, 0.4196078431372549, 0.6352941176470588, 1)
}

function AnnounceQuestPanelCellNew:Init()
  self:initView()
  self:addViewEventListener()
end

function AnnounceQuestPanelCellNew:initView()
  self.LeftNode = self:FindGO("LeftNode")
  self.LeftNodeStatic = self:FindGO("Static", self.LeftNode)
  self.LeftNodeDynamic = self:FindGO("Dynamic", self.LeftNode)
  self.completeHolder = self:FindGO("completeHolder", self.LeftNode)
  self.LeftNodeLinkName_UILabel = self:FindGO("LinkName", self.LeftNodeDynamic):GetComponent(UILabel)
  self.LeftNodeCurStep_UILabel = self:FindGO("CurStep", self.LeftNodeDynamic):GetComponent(UILabel)
  self.LeftNodeAllStep_UILabel = self:FindGO("AllStep", self.LeftNodeDynamic):GetComponent(UILabel)
  self.LeftNodeName_UILabel = self:FindGO("Name", self.LeftNodeDynamic):GetComponent(UILabel)
  self.LeftNodeDescScrollView = self:FindGO("DescScrollView", self.LeftNodeDynamic):GetComponent(UIScrollView)
  self.LeftNodeDesc_UILabel = self:FindGO("Desc", self.LeftNodeDescScrollView.gameObject):GetComponent(UILabel)
  self.LeftNodeHeadNode = self:FindGO("HeadNode", self.LeftNodeDynamic)
  self.LeftNodeHeadNodename_UILabel = self:FindGO("name", self.LeftNodeHeadNode):GetComponent(UILabel)
  self.LeftNodeRewardGrid_UIGrid = self:FindGO("RewardGrid", self.LeftNodeDynamic):GetComponent(UIGrid)
  self.LeftNodeBaseCell = self:FindGO("BaseCell", self.LeftNodeDynamic)
  self.LeftNodeJobCell = self:FindGO("JobCell", self.LeftNodeDynamic)
  self.LeftNodeBaseValue_UILabel = self:FindGO("value", self.LeftNodeBaseCell):GetComponent(UILabel)
  self.LeftNodeJobValue_UILabel = self:FindGO("value", self.LeftNodeJobCell):GetComponent(UILabel)
  self.LeftNodeRewardCell1 = self:FindGO("cell1", self.LeftNodeRewardGrid_UIGrid.gameObject)
  self.LeftNodeRewardCell2 = self:FindGO("cell2", self.LeftNodeRewardGrid_UIGrid.gameObject)
  self.LeftNodeRewardCell3 = self:FindGO("cell3", self.LeftNodeRewardGrid_UIGrid.gameObject)
  self.LeftNodeRewardCell4 = self:FindGO("cell4", self.LeftNodeRewardGrid_UIGrid.gameObject)
  self.LeftNodeRewardCell1_UILabel = self:FindGO("numberTitle", self.LeftNodeRewardCell1):GetComponent(UILabel)
  self.LeftNodeRewardCell2_UISprite = self:FindGO("icon", self.LeftNodeRewardCell2):GetComponent(UISprite)
  self.LeftNodeRewardCell2_UILabel = self:FindGO("numberTitle", self.LeftNodeRewardCell2):GetComponent(UILabel)
  self.LeftNodeRewardCell3_UISprite = self:FindGO("icon", self.LeftNodeRewardCell3):GetComponent(UISprite)
  self.LeftNodeRewardCell3_UILabel = self:FindGO("numberTitle", self.LeftNodeRewardCell3):GetComponent(UILabel)
  self.LeftNodeRewardCell4_UISprite = self:FindGO("icon", self.LeftNodeRewardCell4):GetComponent(UISprite)
  self.LeftNodeRewardCell4_UILabel = self:FindGO("numberTitle", self.LeftNodeRewardCell4):GetComponent(UILabel)
  self.LeftNodeFinishedMark = self:FindGO("yiwancheng", self.LeftNodeDynamic)
  IconManager:SetArtFontIcon("Rewardtask_txt_1", self.LeftNodeFinishedMark:GetComponent(UISprite))
  self.actionBtn = self:FindGO("actionBtn", self.LeftNodeDynamic)
  self.actionBtn_UISprite = self.actionBtn:GetComponent(UISprite)
  self.actionBtn_UILabel = self:FindGO("actionBtnLabel1", self.actionBtn):GetComponent(UILabel)
  self.expandBtn = self:FindGO("expandBtn", self.LeftNodeDynamic)
  self.RightNode = self:FindGO("RightNode")
  self.RightNodeDynamic = self:FindGO("Dynamic", self.RightNode)
  self.RightNodeStick_UIWidget = self:FindGO("stick", self.RightNodeDynamic):GetComponent(UIWidget)
  self.RightNodeBG_UITex = self:FindGO("BG", self.RightNodeDynamic):GetComponent(UITexture)
  self.RightNodeTopTitle_UILabel = self:FindGO("TopTitle", self.RightNodeDynamic):GetComponent(UILabel)
  self.RightNodeTable_UITable = self:FindGO("UITable", self.RightNodeDynamic):GetComponent(UITable)
  self.RightNodeStepGrid_UIGrid = self:FindGO("StepGrid", self.RightNodeTable_UITable.gameObject):GetComponent(UIGrid)
  self.RightNodeStepCtl = UIGridListCtrl.new(self.RightNodeStepGrid_UIGrid, AnnounceQuestVersionTaskCell, "AnnounceQuestVersionTaskCell")
  self.RightNodeStepCtl:AddEventListener(MouseEvent.MouseClick, self.ClickFinishedTask, self)
  self.RightNodeFinalRewardNode = self:FindGO("FinalRewardNode", self.RightNodeTable_UITable.gameObject)
  self.RightNodeFinalRewardTitle_UILabel = self:FindGO("finalrewardTitle", self.RightNodeFinalRewardNode):GetComponent(UILabel)
  self.RightNodeFinalRewardGrid_UIGrid = self:FindGO("Grid", self.RightNodeFinalRewardNode):GetComponent(UIGrid)
  self.RightNodeFinalRewardItem1 = self:FindGO("finalrewardItem1", self.RightNodeFinalRewardGrid_UIGrid.gameObject)
  self.RightNodeFinalRewardItem2 = self:FindGO("finalrewardItem2", self.RightNodeFinalRewardGrid_UIGrid.gameObject)
  self.RightNodeFinalRewardItem1_UISprite = self:FindComponent("finalrewardItem1_Icon", UISprite)
  self.RightNodeFinalRewardItem1_UILabel = self:FindComponent("finalrewardItem1_Num", UILabel)
  self.RightNodeFinalRewardItem2_UISprite = self:FindComponent("finalrewardItem2_Icon", UISprite)
  self.RightNodeFinalRewardItem2_UILabel = self:FindComponent("finalrewardItem2_Num", UILabel)
  self:AddClickEvent(self.RightNodeFinalRewardItem1, function()
    self:OnClickForIconView(self.rewardItem1, self.RightNodeStick_UIWidget)
  end)
  self:AddClickEvent(self.RightNodeFinalRewardItem2, function()
    self:OnClickForIconView(self.rewardItem2, self.RightNodeStick_UIWidget)
  end)
  self:Hide(self.RightNode)
  self.selectFrameObj = self:FindGO("selectFrameObj")
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function AnnounceQuestPanelCellNew:addViewEventListener()
  self:AddButtonEvent("actionBtn", function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddButtonEvent("expandBtn", function(go)
    self.RightNode:SetActive(not self.RightNode.activeSelf)
    if self.RightNode.activeSelf then
      self.RightNodeTable_UITable:Reposition()
    else
    end
  end)
end

function AnnounceQuestPanelCellNew:checkLevelCross(qMinLv, qMaxLv, rMinLv, rMaxLv)
  if rMinLv <= qMaxLv and qMinLv <= rMaxLv then
    return true
  end
end

function AnnounceQuestPanelCellNew:OnRemove()
  if self.DisenableAnnounceQuestTwId then
    LeanTween.cancel(self.gameObject, self.DisenableAnnounceQuestTwId)
    self.DisenableAnnounceQuestTwId = nil
  end
end

function AnnounceQuestPanelCellNew:adjustButton(data)
  if data:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT then
    if data.staticData and data.staticData.Params and data.staticData.Params.ifAccessFc then
      self:Hide(self.LeftNodeFinishedMark)
      self:Show(self.actionBtn.gameObject)
      self.actionBtn_UISprite.spriteName = "com_btn_3"
      self.actionBtn_UILabel.text = ZhString.AnnounceQuestPanel_CommitQuest
      self.actionBtn_UILabel.effectColor = AnnounceQuestPanelCellNewCellLabelColor[2]
      self.actionBtn_UILabel.effectStyle = UILabel.Effect.Outline
      helplog("adjustButtonSt3")
    else
      self:Hide(self.LeftNodeFinishedMark)
      self:Show(self.actionBtn.gameObject)
      self.actionBtn_UISprite.spriteName = "com_btn_0"
      self.actionBtn_UILabel.text = ZhString.AnnounceQuestPanel_AbadonQuest
      self.actionBtn_UILabel.effectColor = AnnounceQuestPanelCellNewCellLabelColor[3]
      self.actionBtn_UILabel.effectStyle = UILabel.Effect.Outline
      helplog("adjustButtonSt2")
    end
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    self:Hide(self.LeftNodeFinishedMark)
    self:Show(self.actionBtn.gameObject)
    self.actionBtn_UISprite.spriteName = "com_btn_3"
    self.actionBtn_UILabel.text = ZhString.AnnounceQuestPanel_CommitQuest
    self.actionBtn_UILabel.effectColor = AnnounceQuestPanelCellNewCellLabelColor[2]
    self.actionBtn_UILabel.effectStyle = UILabel.Effect.Outline
    helplog("adjustButtonSt3")
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
    self:Show(self.LeftNodeFinishedMark)
    self:Hide(self.actionBtn.gameObject)
    helplog("adjustButtonSt4")
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    helplog("adjustButtonSt6")
    self:Hide(self.LeftNodeFinishedMark)
    self:Show(self.actionBtn.gameObject)
    self.actionBtn_UISprite.spriteName = "com_btn_2"
    self.actionBtn_UILabel.text = ZhString.AnnounceQuestPanel_AcceptQuest
    self.actionBtn_UILabel.effectColor = AnnounceQuestPanelCellNewCellLabelColor[1]
    self.actionBtn_UILabel.effectStyle = UILabel.Effect.Outline
  else
    helplog("未知的任务状态 data:getQuestListType()" .. data:getQuestListType())
    self:Hide(self.LeftNodeFinishedMark)
    self:Hide(self.actionBtn.gameObject)
  end
end

function AnnounceQuestPanelCellNew:SetData(data)
  self.data = data.quest
  self.versionTaskData = Table_NewWanted[data.nwid]
  if not self.versionTaskData then
    if not self:ObjIsNil(self.gameObject) then
      self:Hide()
    end
    return
  end
  self:Show()
  self.renwuzongshu = 0
  for k, v in pairs(Table_NewWanted) do
    if v.QuestLink == self.versionTaskData.QuestLink then
      self.renwuzongshu = self.renwuzongshu + 1
    end
  end
  if self.versionTaskData.Rare then
    self.LeftNodeLinkName_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[2]
    self.LeftNodeCurStep_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[2]
    self.LeftNodeAllStep_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[2]
  else
    self.LeftNodeLinkName_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[1]
    self.LeftNodeCurStep_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[1]
    self.LeftNodeAllStep_UILabel.effectColor = AnnounceQuestPanelCellNewTitleLabelColor[1]
  end
  self:ShowCurrentTask()
  self.RightNodeTopTitle_UILabel.text = self.versionTaskData.LinkName
  self:updateVersionQuestLinkList()
  if self.selectFrameObj then
    self.selectFrameObj:SetActive(false)
  end
  local cells = self.RightNodeStepCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data[3] == self.versionTaskData.id then
      cells[i]:ShowSelectHere(self.selectFrameObj)
    end
  end
end

function AnnounceQuestPanelCellNew:updateVersionQuestLinkList()
  local datas = {}
  for k, v in pairs(Table_NewWanted) do
    if v.QuestLink == self.versionTaskData.QuestLink then
      local questTitle = v.Name
      local status = 0
      if v.id < self.versionTaskData.id then
        status = 1
      elseif v.id > self.versionTaskData.id then
        status = -1
      elseif self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
        status = 1
      end
      local data = {
        questTitle,
        status,
        v.id
      }
      table.insert(datas, data)
    end
  end
  table.sort(datas, function(l, r)
    return l[3] < r[3]
  end)
  self.RightNodeStepCtl:ResetDatas(datas)
  self.RightNodeBG_UITex.height = self.RightNodeStepGrid_UIGrid.cellHeight * #datas + 88
  self.RightNodeFinalRewardNode:SetActive(false)
  self.RightNodeFinalRewardItem1:SetActive(false)
  self.RightNodeFinalRewardItem2:SetActive(false)
  self.rewardItem1, self.rewardItem2 = nil, nil
  if self.versionTaskData.FinalReward then
    local rewardItem = ItemUtil.GetRewardItemIdsByTeamId(self.versionTaskData.FinalReward)
    if rewardItem then
      if rewardItem[1] then
        self.RightNodeFinalRewardNode:SetActive(true)
        self.RightNodeBG_UITex.height = self.RightNodeStepGrid_UIGrid.cellHeight * #datas + 205
        local itemData = Table_Item[rewardItem[1].id]
        if itemData then
          self.RightNodeFinalRewardItem1:SetActive(true)
          self.RightNodeFinalRewardItem1_UILabel.text = rewardItem[1].num
          IconManager:SetItemIcon(itemData.Icon, self.RightNodeFinalRewardItem1_UISprite)
          self.rewardItem1 = rewardItem[1].id
        end
      end
      if rewardItem[2] then
        local itemData = Table_Item[rewardItem[2].id]
        if itemData then
          self.RightNodeFinalRewardItem2:SetActive(true)
          self.RightNodeFinalRewardItem2_UILabel.text = rewardItem[2].num
          IconManager:SetItemIcon(itemData.Icon, self.RightNodeFinalRewardItem2_UISprite)
          self.rewardItem2 = rewardItem[2].id
        end
      end
    end
  end
  self.RightNodeTable_UITable:Reposition()
end

function AnnounceQuestPanelCellNew:setQuestRewardData(versionTaskData)
  self.LeftNodeBaseValue_UILabel.text = versionTaskData.BaseExp
  self.LeftNodeJobValue_UILabel.text = versionTaskData.JobExp
  self.LeftNodeRewardCell1:SetActive(false)
  self.LeftNodeRewardCell2:SetActive(false)
  self.LeftNodeRewardCell3:SetActive(false)
  self.LeftNodeRewardCell4:SetActive(false)
  if versionTaskData.Reward then
    local rewardItem = ItemUtil.GetRewardItemIdsByTeamId(versionTaskData.Reward)
    if rewardItem then
      if rewardItem[1] then
        local itemData = Table_Item[rewardItem[1].id]
        if itemData then
          self.LeftNodeRewardCell1:SetActive(true)
          self.LeftNodeRewardCell1_UILabel.text = rewardItem[1].num
          IconManager:SetItemIcon(itemData.Icon, self.LeftNodeRewardCell1_UISprite)
        end
      end
      if rewardItem[2] then
        local itemData = Table_Item[rewardItem[2].id]
        if itemData then
          self.LeftNodeRewardCell2:SetActive(true)
          self.LeftNodeRewardCell2_UILabel.text = rewardItem[2].num
          IconManager:SetItemIcon(itemData.Icon, self.LeftNodeRewardCell2_UISprite)
        end
      end
      if rewardItem[3] then
        local itemData = Table_Item[rewardItem[3].id]
        if itemData then
          self.LeftNodeRewardCell3:SetActive(true)
          self.LeftNodeRewardCell3_UILabel.text = rewardItem[3].num
          IconManager:SetItemIcon(itemData.Icon, self.LeftNodeRewardCell3_UISprite)
        end
      end
      if rewardItem[4] then
        local itemData = Table_Item[rewardItem[4].id]
        if itemData then
          self.LeftNodeRewardCell4:SetActive(true)
          self.LeftNodeRewardCell4_UILabel.text = rewardItem[4].num
          IconManager:SetItemIcon(itemData.Icon, self.LeftNodeRewardCell4_UISprite)
        end
      end
    end
  end
  self.LeftNodeRewardGrid_UIGrid:Reposition()
end

function AnnounceQuestPanelCellNew:SetNpcData(npcId)
  if npcId then
    local npcdata = Table_Npc[npcId]
    self:Show(self.LeftNodeHeadNode)
    if npcdata then
      if not self.targetCell then
        self.targetCell = HeadIconCell.new()
        self.targetCell:CreateSelf(self.LeftNodeHeadNode)
        self.targetCell:SetScale(0.67)
        self.targetCell:SetMinDepth(3)
      end
      self.LeftNodeHeadNodename_UILabel.text = npcdata.NameZh
      local data = ReusableTable.CreateTable()
      local hasSimpleIcon = npcdata.Icon and npcdata.Icon ~= ""
      local showDetailedIcon = npcdata.Body and npcdata.Hair and npcdata.HeadDefaultColor and npcdata.Gender and npcdata.Eye and npcdata.Head
      if showDetailedIcon or not hasSimpleIcon then
        data.bodyID = npcdata.Body or 0
        data.hairID = npcdata.Hair or 0
        data.haircolor = npcdata.HeadDefaultColor or 0
        data.gender = npcdata.Gender or -1
        data.eyeID = npcdata.Eye or 0
        data.headID = npcdata.Head or 0
        self.targetCell:SetData(data)
      else
        self.targetCell:SetSimpleIcon(npcdata.Icon)
      end
      ReusableTable.DestroyTable(data)
    else
      printRed("can't find npcData at id:" .. npcId)
    end
  else
    self:Hide(self.LeftNodeHeadNode)
  end
end

function AnnounceQuestPanelCellNew:OnClickForIconView(itemId, stick)
  if not itemId then
    return
  end
  local itemData = ItemData.new(nil, itemId)
  local tab = ReusableTable.CreateTable()
  tab.itemdata = itemData
  self:ShowItemTip(tab, stick, NGUIUtil.AnchorSide.Center, {-300, -37})
  ReusableTable.DestroyAndClearTable(tab)
end

function AnnounceQuestPanelCellNew:OnExit()
  self.super.OnExit(self)
end

function AnnounceQuestPanelCellNew:playAnim()
end

function AnnounceQuestPanelCellNew.AnimEffectHandle(effectHandle, owner)
end

function AnnounceQuestPanelCellNew:ClickFinishedTask(cell)
  if cell.data and cell.data[2] and cell.data[2] >= 0 then
    cell:ShowSelectHere(self.selectFrameObj)
    self:ShowSelectedTask(cell)
  end
end

function AnnounceQuestPanelCellNew:ShowSelectedTask(cell)
  local taskData = cell and cell.data and cell.data[3] and Table_NewWanted[cell.data[3]]
  if taskData then
    if taskData.id == self.versionTaskData.id then
      self:ShowCurrentTask()
    else
      self.LeftNodeLinkName_UILabel.text = taskData.LinkName
      self.LeftNodeName_UILabel.text = taskData.Name
      self.LeftNodeCurStep_UILabel.text = taskData.id % 100
      self.LeftNodeAllStep_UILabel.text = "/" .. self.renwuzongshu
      self.LeftNodeDescScrollView:ResetPosition()
      self.LeftNodeDesc_UILabel.text = taskData.PlotReview or ""
      self:SetNpcData(taskData.NpcID)
      self:setQuestRewardData(taskData)
      self:Show(self.LeftNodeFinishedMark)
      self:Hide(self.actionBtn.gameObject)
    end
  end
end

function AnnounceQuestPanelCellNew:ShowCurrentTask()
  self.LeftNodeLinkName_UILabel.text = self.versionTaskData.LinkName
  self.LeftNodeName_UILabel.text = self.versionTaskData.Name
  self.LeftNodeCurStep_UILabel.text = self.versionTaskData.id % 100
  self.LeftNodeAllStep_UILabel.text = "/" .. self.renwuzongshu
  self.LeftNodeDescScrollView:ResetPosition()
  self.LeftNodeDesc_UILabel.text = self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT and self.versionTaskData.PlotReview or self.versionTaskData.Describe
  self:SetNpcData(self.versionTaskData.NpcID)
  self:setQuestRewardData(self.versionTaskData)
  self:adjustButton(self.data)
end
