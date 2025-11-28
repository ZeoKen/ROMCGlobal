local _SpriteIconMap = {
  [1] = {
    [2] = "{cardicon=mall_twistedegg_card_02}"
  }
}
local _GetName = function(config)
  local t = type(config)
  local name = ""
  if "string" == t then
    name = config
  elseif "table" == t then
    name = config.name or config.Name
  elseif "number" == t then
    name = tostring(config)
  end
  return name
end
local filter = {}
local _GetFilter = function(config, firstKey, spriteIcon_type)
  TableUtility.ArrayClear(filter)
  local single = {}
  single.id = firstKey
  single.Name = _GetName(config[firstKey])
  filter.fatherGoal = single
  filter.childGoals = {}
  for k, v in pairs(config) do
    local single = {}
    single.id = k
    if spriteIcon_type and _SpriteIconMap[spriteIcon_type] and _SpriteIconMap[spriteIcon_type][k] then
      single.Name = _GetName(v) .. _SpriteIconMap[spriteIcon_type][k]
    else
      single.Name = _GetName(v)
    end
    table.insert(filter.childGoals, single)
  end
  table.sort(filter.childGoals, function(l, r)
    return l.id < r.id
  end)
  return filter
end
local BaseCell = autoImport("BaseCell")
PopupCombineCell = class("PopupCombineCell", BaseCell)
autoImport("PopUpCell")
autoImport("PopUpChildCell")
PopupCombineCellType = {Lottery = 1, GVGLand = 2}
PopupCombineCellMaxBgHeight = {
  [PopupCombineCellType.GVGLand] = 530
}
PopupCombineCell.TypeColor = {
  [PopupCombineCellType.Lottery] = {
    ChooseColor = LuaColor.New(1, 0.9725490196078431, 0.8862745098039215),
    NormalColor = LuaColor.New(0.7019607843137254, 0.6235294117647059, 0.5215686274509804)
  },
  [PopupCombineCellType.GVGLand] = {
    ChooseColor = LuaColor.New(0.14901960784313725, 0.28627450980392155, 0.615686274509804),
    NormalColor = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
  }
}

function PopupCombineCell:SetTypeInfo()
  PopupCombineCell.ChooseColorConfig = PopupCombineCell.TypeColor[self.type]
end

function PopupCombineCell:ctor(obj, type)
  PopupCombineCell.super.ctor(self, obj)
  self.type = type or PopupCombineCellType.Lottery
  self:SetTypeInfo()
  self:Init()
end

function PopupCombineCell:SetFatherColliderState(var)
  if not self.fatherCell then
    return
  end
  self.fatherCell:SetBoxCllider(var)
  self.fatherSymbol.enabled = var
end

function PopupCombineCell:Init()
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  local fahterObj = self:FindGO("FatherGoal")
  self.fatherSprite = self:FindComponent("FatherGoal", UISprite)
  self.fatherLabel = self:FindComponent("Label", UILabel, self.fatherSprite.gameObject)
  self.fatherSymbol = self:FindComponent("Symbol", UISprite, fahterObj)
  self.fatherCell = PopUpCell.new(fahterObj)
  self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)
  local grid = self:FindComponent("ChildGoals", UIGrid)
  self.childCtl = UIGridListCtrl.new(grid, PopUpChildCell, "PopUpChildCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childSpace = grid.cellHeight
  self.childBg = self:FindComponent("ChildBg", UISprite)
  self.closecomp = self.tweenScale.gameObject:GetComponent(CloseWhenClickOtherPlace)
  if not self.closecomp then
    self.closecomp = self.tweenScale.gameObject:AddComponent(CloseWhenClickOtherPlace)
  end
  self.closecomp:AddTarget(fahterObj.transform)
  
  function self.closecomp.callBack(go)
    if self.folderState then
      self:PlayReverseAnimation()
    end
  end
  
  self:SetFolderState(false)
end

function PopupCombineCell:ClearCallBack()
  if self.closecomp then
    self.closecomp.callBack = nil
  end
end

local _popupFlag = false

function PopupCombineCell:OnClickFilter(parama)
  if "Father" == parama.type then
    local combine = parama.father
    if _popupFlag then
      self:PlayReverseAnimation()
      self.fatherGoalId = combine.data.id
      self.goal = self.fatherGoalId
      _popupFlag = not _popupFlag
      return
    end
    self:PlayReverseAnimation()
    self.fatherGoalId = combine.data.id
    self.goal = self.fatherGoalId
    _popupFlag = not _popupFlag
  elseif parama.child and parama.child.data then
    self.goal = parama.child.data.id
    self:SetFatherData(parama.child.data)
    _popupFlag = not _popupFlag
  else
    self.goal = self.fatherGoalId
  end
  self:PassEvent(MouseEvent.MouseClick, self)
end

function PopupCombineCell:Reset()
  if not self.firstGoal then
    return
  end
  self.fatherGoalId = self.firstGoal
  self.goal = self.firstGoal
  self.fatherCell:SetData(self.data.fatherGoal)
end

function PopupCombineCell:SetInvalidMsgID(id)
  self.invalidMsg = id
end

function PopupCombineCell:ClickFather(cellCtl)
  if self.invalidMsg then
    MsgManager.ShowMsgByID(self.invalidMsg)
    return
  end
  cellCtl = cellCtl or self.fatherCell
  self:OnClickFilter({
    type = "Father",
    combine = self,
    father = cellCtl
  })
end

function PopupCombineCell:GetchildCtl()
  return self.childCtl
end

function PopupCombineCell:ClickChild(cellCtl)
  if cellCtl == self.nowChild then
    self:PlayReverseAnimation()
    return
  end
  if self.nowChild then
    self.nowChild:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.nowChild = cellCtl
  self:PlayReverseAnimation()
  self:OnClickFilter({
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end

function PopupCombineCell:GetCurConfigValue()
  if self.config then
    return self.config[self.goal]
  end
end

function PopupCombineCell:SetData(config, reset, spriteIcon_type)
  if not config or not next(config) then
    redlog("PopupCombineCell 检查配置")
    return
  end
  if self.config and not reset then
    return
  end
  self.config = config
  local keyList = {}
  for k, v in pairs(config) do
    keyList[#keyList + 1] = k
  end
  table.sort(keyList)
  self.firstGoal = keyList[1]
  self.goal = keyList[1]
  local data = _GetFilter(config, self.goal, spriteIcon_type)
  self.data = data
  if reset then
    self:ResetChoose()
  end
  if data.fatherGoal then
    self.fatherCell:SetData(data.fatherGoal)
    if data.childGoals then
      self.childCtl:ResetDatas(data.childGoals, nil, reset)
    end
    if data.childGoals and #data.childGoals > 0 then
      self:Show(self.childBg)
      self:Show(self.fatherSymbol)
      local height = 20 + self.childSpace * #data.childGoals
      local maxHeight = PopupCombineCellMaxBgHeight[self.type]
      if nil ~= maxHeight then
        self.childBg.height = math.min(height, maxHeight)
      else
        self.childBg.height = height
      end
    else
      self:Hide(self.childBg)
      self:Hide(self.fatherSymbol)
    end
  end
  if data.avaliable then
    self:SetAvailable(true)
  end
end

function PopupCombineCell:SetFatherData(childdata)
  if self.fatherCell and childdata then
    self.fatherCell:SetData(childdata)
  end
end

function PopupCombineCell:ResetChoose()
  if self.nowChild then
    self.nowChild:SetChoose(false)
    self.nowChild = nil
  end
end

function PopupCombineCell:GetFolderState()
  return self.folderState == true
end

function PopupCombineCell:PlayReverseAnimation()
  self:SetFolderState(not self.folderState)
end

local tempRot = LuaQuaternion()

function PopupCombineCell:SetFolderState(isOpen)
  if self.folderState ~= isOpen then
    self.folderState = isOpen
    self.tweenScale.gameObject:SetActive(true)
    self.tweenScale:ResetToBeginning()
    if isOpen then
      self.tweenScale:PlayForward()
      self.childCtl:Layout()
    else
      self.tweenScale:PlayReverse()
    end
  end
end
