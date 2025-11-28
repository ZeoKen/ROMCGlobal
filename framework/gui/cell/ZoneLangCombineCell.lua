local BaseCell = autoImport("BaseCell")
ZoneLangCombineCell = class("ZoneLangCombineCell", BaseCell)
autoImport("ZoneLanguageCell")

function ZoneLangCombineCell:Init()
  helplog("ZobeLabfConBineCell Init")
  self.folderState = false
  self.fatherResult = self:FindGO("FatherResult")
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.arrow = self:FindGO("Arrow")
  self.ENLabel = self:FindComponent("EN_ZoneName", UILabel)
  self.LocalLabel = self:FindComponent("Local_ZoneName", UILabel)
  self.ChildContainer = self:FindGO("ChildContainer")
  self.ChildGoals = self:FindGO("ChildGrid", self.ChildContainer)
  self.ChildGoals_UIGrid = self.ChildGoals:GetComponent(UIGrid)
  self.childBg = self:FindComponent("ChildBg", UISprite)
  self.childSpace = self.ChildGoals_UIGrid.cellHeight
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, ZoneLanguageCell, "ZoneLanguageCell")
  if self.childCtl == nil then
    helplog("if self.childCtl == nil then")
  end
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  local serverNameList = ChangeZoneProxy.Instance.serverNames
  if serverNameList then
    self.childCtl:ResetDatas(serverNameList)
    local cells = self.childCtl:GetCells()
    for i = 1, #cells do
      cells[i]:SetID(i)
    end
  end
  local listNum = #serverNameList or 5
  self.childBg.height = 20 + self.childSpace * listNum
  self:SetFolderState(self.folderState)
  self:AddClickEvent(self.fatherResult, function()
    self:SetFolderState(not self.folderState)
  end)
  self.id = 1
end

local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()

function ZoneLangCombineCell:SetFolderState(isOpen)
  helplog("SetFolderState:", isOpen)
  self.folderState = isOpen
  if isOpen then
    tempV3[1] = 0
    self.tweenScale:PlayForward()
  else
    tempV3[1] = 180
    self.tweenScale:PlayReverse()
  end
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.arrow.transform.rotation = tempRot
end

function ZoneLangCombineCell:OnTweenScaleOnFinished()
end

function ZoneLangCombineCell:ChangeFatherLabelText(str)
end

function ZoneLangCombineCell:ClickFather(cellCtl)
  cellCtl = cellCtl or self.fatherCell
end

function ZoneLangCombineCell:ClickChild(cellCtl)
  helplog("ClickChild", cellCtl.id)
  self:PlayReverseAnimation()
  self:SetData(cellCtl.id)
  GameFacade.Instance:sendNotification(ChangeZoneEvent.ZoneLanguageSetData)
end

function ZoneLangCombineCell:ChildrenLayout()
  self.childCtl:Layout()
end

function ZoneLangCombineCell:SetData(data)
  self.data = data
  helplog("SetData ID : ", data)
  local serverNameList = ChangeZoneProxy.Instance.serverNames
  if serverNameList and 0 < #serverNameList and serverNameList[data] then
    self.ENLabel.text = serverNameList[data].name_prefix
    self.LocalLabel.text = serverNameList[data].fullname
    self.id = data
    self.value = serverNameList[data].name_prefix
  end
end

function ZoneLangCombineCell:PlayReverseAnimation()
  self:SetFolderState(not self.folderState)
end
