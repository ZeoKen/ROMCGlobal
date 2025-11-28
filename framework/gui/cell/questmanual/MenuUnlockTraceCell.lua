MenuUnlockTraceCell = class("MenuUnlockTraceCell", BaseCell)
autoImport("MenuUnlockItemCell")
local color_origin = LuaColor.New(1.0, 1.0, 1.0)
local color_gray = LuaColor.New(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local color_red = LuaColor.New(0.8117647058823529, 0.10980392156862745, 0.058823529411764705, 1)
local color_blue = LuaColor.New(0.29411764705882354, 0.48627450980392156, 1)
local extandHeight = 280
local lineHeight = 24
local funcDescOriginalY = -21
local funcItemOriginalY = -84
local tempPos = LuaVector3(-163, 0, 0)

function MenuUnlockTraceCell:Init()
  self.menuName = self:FindGO("menuName"):GetComponent(UILabel)
  self.toggle = self:FindGO("toggle"):GetComponent(UIButton)
  self.tgSprite = self:FindGO("tgSprite"):GetComponent(UISprite)
  self.questname = self:FindGO("questname"):GetComponent(UILabel)
  self.questMap = self:FindGO("questMap"):GetComponent(UILabel)
  self.lockicon = self:FindGO("lockicon")
  self.menuIcon = self:FindGO("menuIcon"):GetComponent(UISprite)
  self.goBtn = self:FindGO("GoBtn"):GetComponent(UIButton)
  self.profile = self:FindGO("Profile")
  self.specialDesc = self:FindGO("specialDesc"):GetComponent(UILabel)
  self.detail = self:FindGO("Detail")
  self.funcState = self:FindGO("funcState"):GetComponent(UILabel)
  self.state = self:FindGO("State"):GetComponent(UILabel)
  self.description = self:FindGO("description"):GetComponent(UILabel)
  self.funcDesc = self:FindGO("funcDesc")
  self.funcItem = self:FindGO("funcItem")
  self.itemGrid = self:FindGO("itemGrid"):GetComponent(UIGrid)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
  self.itemCtr = UIGridListCtrl.new(self.itemGrid, MenuUnlockItemCell, "MenuUnlockItemCell")
  self.itemCtr:AddEventListener(MouseEvent.MouseClick, self.ShowItemTip, self)
  for i = 1, 5 do
    self.itemCtr:AddCell(nil, i)
  end
  self.complete = self:FindGO("Complete")
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.tweenPlay = self.bg:GetComponent(TweenHeight)
  self.detailToggle = false
  self.tgSprite.flip = self.detailToggle and 0 or 2
  self.detail:SetActive(self.detailToggle)
  self:AddButtonEvent("toggle", function()
    self:ToggleDetail()
    if self.tweenPlay.from ~= self.toPos then
      self.tweenPlay.from = self.toPos
    end
    self.tweenPlay:Play(not self.detailToggle)
  end)
  self:AddButtonEvent("GoBtn", function()
    if self.data then
      local qdata = self.data:GetCurrentTraceQuest()
      if qdata then
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_FUNCTION_OPENING, self.data.type)
        if not self.isMainViewTrace then
          local data = {}
          local ddata = {}
          ddata.questData = qdata
          ddata.type = qdata.questListType
          data.data = ddata
          EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, data)
        end
        FunctionQuest.Me():executeManualQuest(qdata)
      end
    end
  end)
end

local tempVector3 = LuaVector3(0.9, 0.9, 0.9)

function MenuUnlockTraceCell:SetData(data)
  self.data = data
  if self.data then
    self.detailToggle = false
    self.tgSprite.flip = self.detailToggle and 0 or 2
    self.tweenPlay:Play(not self.detailToggle)
    self.gameObject:SetActive(true)
    self.menuName.text = data.name
    local isOpen = FunctionUnLockFunc.Me():CheckCanOpen(self.data.menuid)
    self.lockicon:SetActive(not isOpen)
    local isComplete = data:CheckComplete() or false
    self.complete:SetActive(isComplete)
    local iconStr = self.data.icon
    if iconStr.uiicon then
      IconManager:SetUIIcon(iconStr.uiicon, self.menuIcon)
    elseif iconStr.itemicon then
      IconManager:SetItemIcon(iconStr.itemicon, self.menuIcon)
    end
    self.menuIcon:MakePixelPerfect()
    self.menuIcon.gameObject.transform.localScale = tempVector3
    local qdata = self.data:GetCurrentTraceQuest()
    if isOpen then
      self.menuIcon.color = color_origin
    else
      self.menuIcon.color = color_gray
    end
    self.profile:SetActive(true)
    if not qdata and not isOpen then
      self.goBtn.gameObject:SetActive(false)
      if self.data.replaceName and self.data.replaceName ~= "" then
        self.questname.text = self.data.replaceName
        self.questMap.text = Table_Map[self.data.replaceMapid] and Table_Map[self.data.replaceMapid].NameZh or ""
        self.questname.gameObject:SetActive(true)
        self.questMap.gameObject:SetActive(true)
        self.specialDesc.gameObject:SetActive(false)
      elseif not data.questlist or #data.questlist == 0 then
        self.questname.gameObject:SetActive(false)
        self.questMap.gameObject:SetActive(false)
        self.specialDesc.gameObject:SetActive(true)
        self.specialDesc.text = self.data.spDescribe
      else
        self.questname.gameObject:SetActive(false)
        self.questMap.gameObject:SetActive(false)
        self.specialDesc.gameObject:SetActive(false)
      end
    elseif not isOpen then
      self.goBtn.gameObject:SetActive(true)
      self.questname.text = qdata.staticData.Name
      self.questname.gameObject:SetActive(true)
      if qdata.map then
        self.questMap.text = Table_Map[qdata.map] and Table_Map[qdata.map].NameZh or ""
        self.questMap.gameObject:SetActive(true)
      else
        self.questMap.text = ""
      end
      self.specialDesc.text = ""
    elseif isOpen then
      if self.data.replaceName and self.data.replaceName ~= "" then
        self.questname.text = self.data.replaceName
        self.questMap.text = Table_Map[self.data.replaceMapid] and Table_Map[self.data.replaceMapid].NameZh or ""
        self.questname.gameObject:SetActive(true)
        self.questMap.gameObject:SetActive(true)
        self.specialDesc.gameObject:SetActive(false)
        self.goBtn.gameObject:SetActive(false)
      elseif qdata then
        self.goBtn.gameObject:SetActive(true)
        self.questname.text = qdata.staticData.Name
        self.questname.gameObject:SetActive(true)
        if qdata.map then
          self.questMap.text = Table_Map[qdata.map] and Table_Map[qdata.map].NameZh or ""
          self.questMap.gameObject:SetActive(true)
        else
          self.questMap.text = ""
        end
        self.specialDesc.text = ""
      else
        self.complete:SetActive(true)
        self.goBtn.gameObject:SetActive(false)
        self.profile:SetActive(false)
        self.specialDesc.text = ""
      end
    end
    if isOpen then
      self.funcState.text = ZhString.QuestManual_FunctionState
      self.state.text = ZhString.QuestManual_FunctionUnlock
      self.state.color = color_blue
    else
      if not qdata then
        self.funcState.text = ZhString.QuestManual_FunctionStateGet
        self.state.text = self.data.conditiontip
      else
        self.funcState.text = ZhString.QuestManual_FunctionStateUnlock
        self.state.text = self.data.unlockCondition
      end
      self.state.color = color_red
    end
    local lines = self.state.height / lineHeight
    self:Reposition(lines, false)
    self.detail:SetActive(false)
    self:SetItem()
  else
    self.gameObject:SetActive(false)
  end
end

function MenuUnlockTraceCell:ToggleDetail()
  if not self.data then
    return
  end
  self.detailToggle = not self.detailToggle
  self.detail:SetActive(self.detailToggle)
  self.tgSprite.flip = self.detailToggle and 0 or 2
end

function MenuUnlockTraceCell:SetItem()
  local itemDataList = {}
  if self.data.items and #self.data.items > 0 then
    for i = 1, #self.data.items do
      local id = self.data.items[i]
      local tempItem = ItemData.new("", id)
      itemDataList[#itemDataList + 1] = tempItem
    end
  end
  local cells = self.itemCtr:GetCells()
  for i = 1, 5 do
    self.itemCtr:UpdateCell(i, itemDataList[i], true)
  end
  self.itemCtr:Layout()
end

function MenuUnlockTraceCell:ShowItemTip(cell)
  if not cell.data then
    return
  end
  local data = {
    itemdata = cell.data,
    funcConfig = {},
    noSelfClose = false,
    hideGetPath = true
  }
  TipManager.Instance:ShowItemFloatTip(data, self.bg, NGUIUtil.AnchorSide.Right, {200, -250})
end

function MenuUnlockTraceCell:Reposition(lines)
  local delta = (lines - 1) * lineHeight
  tempPos[2] = funcDescOriginalY - delta
  self.funcDesc.transform.localPosition = tempPos
  self.description.text = self.data.desc
  local deltaD = (self.description.height / lineHeight - 1) * lineHeight
  local totalDelta = delta + deltaD
  tempPos[2] = funcItemOriginalY - totalDelta
  self.funcItem.transform.localPosition = tempPos
  self.toPos = extandHeight + totalDelta
end

function MenuUnlockTraceCell:UpdateDepth(parentDepth)
  self.scrollView.depth = parentDepth + 1
end
