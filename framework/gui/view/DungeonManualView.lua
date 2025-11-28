using("UnityEngine")
DungeonManualView = class("DungeonManualView", SubView)
DungeonManualView.ViewType = UIViewType.NormalLayer
local Prefab_Path = ResourcePathHelper.UIView("DungeonManualView")
autoImport("BMLeftComineCell")
autoImport("BMRightToggleCell")
autoImport("DMCell")
DungeonManualView.RightToggleName = {
  [1] = {
    id = 1,
    NameZh = "剧情",
    iconName_yellow = "DungeonManual_icon_01",
    iconName_blue = "DungeonManual_icon_05"
  },
  [2] = {
    id = 2,
    NameZh = "技能",
    iconName_yellow = "DungeonManual_icon_02",
    iconName_blue = "DungeonManual_icon_06"
  },
  [3] = {
    id = 3,
    NameZh = "召唤",
    iconName_yellow = "DungeonManual_icon_09",
    iconName_blue = "DungeonManual_icon_08"
  },
  [4] = {
    id = 4,
    NameZh = "掉落",
    iconName_yellow = "DungeonManual_icon_04",
    iconName_blue = "DungeonManual_icon_07"
  }
}
DungeonManualView.XiaLaName = {
  [1] = {id = 1, NameZh = "MVP"},
  [2] = {id = 2, NameZh = "mini"},
  [3] = {id = 3, NameZh = "亡者MVP"}
}
local curShowCache, currentTopId

function DungeonManualView:Init()
  self:initData()
  self:initView()
end

function DungeonManualView:initData()
  self.QueueTable = {}
end

function DungeonManualView:NPCDance()
end

function DungeonManualView:ShowCustomPanel(PanelconifgPanel, PanelData, btnfunc)
end

function DungeonManualView:HideCustomPanel(PanelconifgPanel)
end

function DungeonManualView:initView()
  self.containergo = self:FindGO("DungeonManualView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.containergo, true)
  obj.name = "DungeonManualView"
  self.gameObject = obj.gameObject
  self.Left = self:FindGO("Left", self.gameObject)
  self.Center = self:FindGO("Center", self.gameObject)
  self.Right = self:FindGO("Right", self.gameObject)
  self.LeftScrollView = self:FindGO("LeftScrollView", self.Left)
  self.LeftScrollView_UIScrollView = self.LeftScrollView:GetComponent(UIScrollView)
  self.UITableP = self:FindGO("UITableP", self.LeftScrollView)
  self.UITableP_UITable = self.UITableP:GetComponent(UITable)
  self.LeftCtrl = UIGridListCtrl.new(self.UITableP_UITable, BMLeftComineCell, "BMLeftComineCell")
  self.LeftCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.LeftScrollViewForMVP = self:FindGO("LeftScrollViewForMVP", self.Left)
  self.LeftScrollViewForMVP_UIScrollView = self.LeftScrollViewForMVP:GetComponent(UIScrollView)
  self.LeftScrollViewForMVP_UITableP = self:FindGO("UITableP", self.LeftScrollViewForMVP)
  self.LeftScrollViewForMVP_UITableP_UITable = self.LeftScrollViewForMVP_UITableP:GetComponent(UITable)
  self.LeftCtrlForMVP = UIGridListCtrl.new(self.LeftScrollViewForMVP_UITableP_UITable, BMLeftComineCell, "BMLeftComineCell")
  self.LeftCtrlForMVP:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.XiaLa = self:FindGO("XiaLa", self.Left)
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  self.XiaLaNameTable = GameConfig.DungeonManualViewXiaLaName or DungeonManualView.XiaLaName
  self.itemTabs:Clear()
  for i = 1, #self.XiaLaNameTable do
    self.itemTabs:AddItem(self.XiaLaNameTable[i].NameZh)
  end
  EventDelegate.Add(self.itemTabs.onChange, function()
    for k, v in pairs(self.XiaLaNameTable) do
      if v.NameZh == self.itemTabs.value then
        local curTabCache
        if curShowCache and curShowCache[currentTopId] then
          curTabCache = curShowCache[currentTopId]
          if curTabCache.xiala ~= v.id then
            curTabCache.xiala = v.id
            curTabCache.father = 1
            curTabCache.child = 1
          end
        end
        local fatherTable = self:MakeLeftFatherTable(v.id)
        helplog("#fatherTable" .. #fatherTable)
        if self.currentLeftCtrl == nil then
          return
        end
        self.currentLeftCtrl:ResetDatas(fatherTable)
        local cells = self.currentLeftCtrl:GetCells()
        for k, v in pairs(cells) do
          v:SetChoose(false)
          v:SetFolderState(false)
        end
        if cells and 1 <= #cells then
          local fatherid = 1
          if curTabCache then
            if #cells < curTabCache.father then
              curTabCache.father = 1
            else
              fatherid = curTabCache.father
            end
          end
          cells[fatherid]:ClickFather()
          cells[fatherid]:SetChoose(true)
          cells[fatherid]:SetFolderState(true)
          local childCtl = cells[fatherid]:GetChildCtl()
          local childCtlcells = childCtl:GetCells()
          if childCtlcells and 1 <= #childCtlcells then
            local childid = 1
            if curTabCache then
              if #childCtlcells < curTabCache.child then
                curTabCache.child = 1
              else
                childid = curTabCache.child
              end
            end
            cells[fatherid]:ClickChild(childCtlcells[childid])
          end
        end
      end
    end
  end)
  self.Right = self:FindGO("Right", self.gameObject)
  self.Right_UIGridP = self:FindGO("UIGridP", self.Right)
  self.Right_UIGridP_UIGrid = self.Right_UIGridP:GetComponent(UIGrid)
  self.RightCtrl = UIGridListCtrl.new(self.Right_UIGridP_UIGrid, BMRightToggleCell, "BMRightToggleCell")
  if GameConfig.DungeonManualViewRightToggleName then
    self.RightCtrl:ResetDatas(GameConfig.DungeonManualViewRightToggleName)
  else
    self.RightCtrl:ResetDatas(DungeonManualView.RightToggleName)
  end
  self.RightCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickRightToggle, self)
  self.Center_ScrowView = self:FindGO("ScrowView", self.Center)
  self.Center_UITableP = self:FindGO("UITableP", self.Center_ScrowView)
  self.Center_ScrowView_UIScrollView = self.Center_ScrowView:GetComponent(UIScrollView)
  self.Center_UITableP_UITable = self.Center_UITableP:GetComponent(UITable)
  self.CenterCtrl = UIGridListCtrl.new(self.Center_UITableP_UITable, DMCell, "DMCell")
  self.Center_ScrowView_MyUICenterOnChild = self.Center_ScrowView:GetComponent(MyUICenterOnChild)
  if self.Center_ScrowView_MyUICenterOnChild == nil then
    self.Center_ScrowView_MyUICenterOnChild = self.Center_ScrowView:AddComponent(MyUICenterOnChild)
  end
  self.CenterCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
end

function DungeonManualView:tabClick(selectTabData)
  TableUtil.Print(selectTabData)
end

function DungeonManualView:ClickRightToggle(Cell)
  local curcellid = Cell.data.id or 1
  local cells = self.CenterCtrl:GetCells()
  for k, v in pairs(cells) do
    local cellData = v:GetData()
    if curcellid == 1 then
      if cellData.Location == 1 then
        self:CenterReposition()
        return
      end
    elseif curcellid == 2 then
      if cellData.Location == 2 then
        self.Center_ScrowView_MyUICenterOnChild:CenterOn(v.gameObject.transform)
        return
      end
    elseif curcellid == 3 then
      if cellData.Location == 3 then
        self.Center_ScrowView_MyUICenterOnChild:CenterOn(v.gameObject.transform)
        return
      end
    elseif curcellid == 4 and cellData.Location == 4 then
      self.Center_ScrowView_MyUICenterOnChild:CenterOn(v.gameObject.transform)
      return
    end
  end
end

function DungeonManualView:_resetCurCombine(id)
  if id == 4 then
    if self.combineGoal and next(self.combineGoal) ~= nil then
      self.combineGoal:SetChoose(false)
      self.combineGoal:SetFolderStateForTopId4(false)
      self.combineGoal = nil
    end
  elseif self.combineGoal and next(self.combineGoal) ~= nil then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end

function DungeonManualView:ClickGoal(parama)
  helplog("EquipRecommendMainNew:ClickGoal(parama)")
  if "Father" == parama.type then
    local combine = parama.combine
    if combine.data ~= nil then
      helplog("combine.data.MainpageID:" .. combine.data.fatherGoal.MainpageID)
      if combine.data.fatherGoal.MainpageID == 4 then
        if curShowCache then
          local curTabCache = curShowCache[currentTopId]
          curTabCache.father = parama.combine.indexInList
          curTabCache.child = 1
        end
        if combine == self.combineGoal then
          combine:PlayReverseAnimationForTopId4()
          return
        end
        self:_resetCurCombine(combine.data.fatherGoal.MainpageID)
        self.combineGoal = combine
        self.combineGoal:PlayReverseAnimationForTopId4()
        self.fatherGoalId = combine.data.fatherGoal.id
        self.goal = self.fatherGoalId
        self:UpdateCenterAccordingToId(combine.data.fatherGoal.id)
        return
      else
      end
    end
    if combine == self.combineGoal then
      combine:PlayReverseAnimation()
      return
    end
    self:_resetCurCombine()
    self.combineGoal = combine
    self.combineGoal:PlayReverseAnimation()
    self.fatherGoalId = combine.data.fatherGoal.id
    self.goal = self.fatherGoalId
  elseif parama.child and parama.child.data then
    if curShowCache then
      local curTabCache = curShowCache[currentTopId]
      curTabCache.father = parama.combine.indexInList
      curTabCache.child = parama.child.indexInList
    end
    self.goal = parama.child.data.id
    self:UpdateCenterAccordingToId(parama.child.data.id)
  else
    self.goal = self.fatherGoalId
  end
end

function DungeonManualView:IsThisNilOrEmptyString(obj)
  if obj == "" or obj == nil then
    return true
  else
    if type(obj) == "table" and #obj == 0 then
      return true
    end
    return false
  end
end

function DungeonManualView:InsertThisToTableToRight(data, insertString, Typesetting, Location, id, tableDesc)
  if self:IsThisNilOrEmptyString(data) then
  elseif insertString == "SkillID" then
    for k, v in pairs(data) do
      local tmp = {}
      tmp[insertString] = v
      tmp.Typesetting = Typesetting
      tmp.Location = Location
      tmp.id = id
      tmp.Desc = tableDesc
      table.insert(self.tableForRight, tmp)
    end
  else
    local tmp = {}
    tmp[insertString] = data
    tmp.Typesetting = Typesetting
    tmp.Location = Location
    tmp.id = id
    tmp.Desc = tableDesc
    table.insert(self.tableForRight, tmp)
  end
end

function DungeonManualView:UpdateCenterAccordingToIdForTopId4(id)
end

function DungeonManualView:CenterReposition()
  local c = coroutine.create(function()
    Yield(WaitForEndOfFrame())
    self.CenterCtrl:Layout()
    self.Center_ScrowView_UIScrollView:ResetPosition()
  end)
  coroutine.resume(c)
end

function DungeonManualView:UpdateCenterAccordingToId(id)
  self.CenterCtrl:ResetDatas()
  self.Right.gameObject:SetActive(true)
  local dataFromDMTable = Table_DungeonManual[id]
  if dataFromDMTable then
    self.tableForRight = {}
    for k, v in pairs(dataFromDMTable.TextID) do
      if dataFromDMTable.TextID then
        local dataFromStrateText = Table_StrateText[v]
        self:InsertThisToTableToRight(dataFromStrateText.Title, "Title", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.Image, "Image", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.SubTitle, "SubTitle", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.Text, "Text", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.MonsterID, "MonsterID", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.Stage, "Stage", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.StageIntroduce, "StageIntroduce", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.ServantID, "ServantID", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.SkillID, "SkillID", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.ServantSkillID, "ServantSkillID", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
        self:InsertThisToTableToRight(dataFromStrateText.ItemID, "ItemID", dataFromDMTable.Typesetting, dataFromStrateText.Location, v, dataFromStrateText.Desc)
      end
    end
    self.CenterCtrl:ResetDatas(self.tableForRight)
    if dataFromDMTable.Typesetting == 1 then
      self.Right.gameObject:SetActive(false)
    elseif dataFromDMTable.Typesetting == 2 then
      self.Right.gameObject:SetActive(true)
      local firstToggle = self.Right:GetComponentsInChildren(UIToggle)
      if firstToggle and 0 < #firstToggle then
        firstToggle[1].value = true
      end
    elseif dataFromDMTable.Typesetting == 3 then
      self.Right.gameObject:SetActive(false)
    end
  else
    helplog("id:" .. id .. "不存在！")
  end
  self:CenterReposition()
end

function DungeonManualView:MakeLeftFatherTable(mvpType)
  local fatherTable = {}
  for k, v in pairs(Table_DungeonManual) do
    if v.Type == 1 and v.MainpageID == currentTopId then
      table.insert(fatherTable, v)
    elseif v.Type == 3 and v.MainpageID == currentTopId then
      table.insert(fatherTable, v)
    end
  end
  local resultTable = {}
  for k, v in pairs(fatherTable) do
    local newGoal = {}
    newGoal.fatherGoal = v
    newGoal.childGoals = {}
    for m, n in pairs(Table_DungeonManual) do
      if v.SubpageID == n.SubpageID and n.Type == 2 then
        if mvpType then
          if n.MonsterType and mvpType == n.MonsterType then
            table.insert(newGoal.childGoals, n)
          end
        else
          table.insert(newGoal.childGoals, n)
        end
      end
    end
    if v.Type ~= 1 or #newGoal.childGoals > 0 then
      table.sort(newGoal.childGoals, function(a, b)
        return a.id < b.id
      end)
      table.insert(resultTable, newGoal)
    end
  end
  table.sort(resultTable, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  return resultTable
end

function DungeonManualView:SwitchToTopId(id)
  currentTopId = id
  local curTabCache
  if curShowCache and curShowCache[currentTopId] then
    curTabCache = curShowCache[currentTopId]
  else
    curTabCache = {
      xiala = 1,
      father = 1,
      child = 1
    }
    if not curShowCache then
      curShowCache = {}
    end
    curShowCache[currentTopId] = curTabCache
  end
  self.combineGoal = nil
  self.Left.gameObject:SetActive(true)
  self.Center.gameObject:SetActive(true)
  if id == 2 then
    self.XiaLa:SetActive(true)
    self.itemTabs.value = self.XiaLaNameTable[curTabCache.xiala].NameZh
    self.LeftScrollViewForMVP:SetActive(true)
    self.LeftScrollView:SetActive(false)
    self.LeftScrollViewForMVP_UIScrollView:ResetPosition()
  else
    self.XiaLa:SetActive(false)
    self.LeftScrollViewForMVP:SetActive(false)
    self.LeftScrollView:SetActive(true)
    self.LeftScrollView_UIScrollView:ResetPosition()
  end
  local fatherTable
  self.currentLeftCtrl = nil
  if id == 1 then
    self.currentLeftCtrl = self.LeftCtrl
    fatherTable = self:MakeLeftFatherTable()
  elseif id == 2 then
    self.currentLeftCtrl = self.LeftCtrlForMVP
    fatherTable = self:MakeLeftFatherTable(curTabCache.xiala)
  elseif id == 3 then
    self.currentLeftCtrl = self.LeftCtrl
    fatherTable = self:MakeLeftFatherTable()
  elseif id == 4 then
    self.currentLeftCtrl = self.LeftCtrl
    fatherTable = self:MakeLeftFatherTable()
  end
  self.currentLeftCtrl:ResetDatas(fatherTable)
  local cells = self.currentLeftCtrl:GetCells()
  if not cells or #cells < curTabCache.father then
    curTabCache.father = 1
  end
  local fatherid = curTabCache.father
  if currentTopId == 4 then
    for k, v in pairs(cells) do
      v:SetChoose(false)
      v:SetFolderState(false)
    end
    if cells and 1 <= #cells then
      cells[fatherid]:ClickFather()
      cells[fatherid]:SetChoose(true)
      cells[fatherid]:SetFolderStateForTopId4(true)
    end
  else
    for k, v in pairs(cells) do
      v:SetChoose(false)
      v:SetFolderState(false)
    end
    if cells and 1 <= #cells then
      cells[fatherid]:ClickFather()
      cells[fatherid]:SetChoose(true)
      cells[fatherid]:SetFolderState(true)
      local childCtl = cells[fatherid]:GetChildCtl()
      local childCtlcells = childCtl:GetCells()
      if childCtlcells and 1 <= #childCtlcells then
        if #childCtlcells < curTabCache.child then
          curTabCache.child = 1
        end
        cells[fatherid]:ClickChild(childCtlcells[curTabCache.child])
      end
    end
  end
end

function DungeonManualView:ClickDropItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponentInChildren(UISprite)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local locker = false
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        },
        needLocker = locker
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChoose()
  end
end

function DungeonManualView:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end

function DungeonManualView:InitShare()
end

function DungeonManualView:ShareAndReward(sharetype, content_title, content_body, platform_type, texture)
end

function DungeonManualView:RecvKFCEnrollCodeUserCmd(data)
end

function DungeonManualView:RecvKFCHasEnrolledUserCmd(data)
end

function DungeonManualView:RecvKFCEnrollUserCmd(data)
end

function DungeonManualView:RecvKFCEnrollReplyUserCmd(data)
end

function DungeonManualView:takePic()
end

function DungeonManualView:PreTakePic()
end

function DungeonManualView:StringIsNullOrEmpty(text)
end

function DungeonManualView:InitHead()
end

function DungeonManualView:OnEnter()
end

function DungeonManualView:OnExit()
end

function DungeonManualView:CheckGPS()
end

function DungeonManualView:RecvKFCShareUserCmd(data)
end

function DungeonManualView:SavePic(texture, name)
end

function DungeonManualView:ShowNPC()
end

function DungeonManualView:HideNPC()
end
