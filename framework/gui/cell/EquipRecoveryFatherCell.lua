local BaseCell = autoImport("BaseCell")
autoImport("EquipNewChooseCell")
EquipRecoveryFatherCell = class("EquipRecoveryFatherCell", BaseCell)
local equipSitePartsNameMap, blackSmith

function EquipRecoveryFatherCell:Init()
  if not blackSmith then
    blackSmith = BlackSmithProxy.Instance
  end
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.arrow = self:FindGO("Arrow")
  local fatherObj = self:FindGO("Father")
  self.fatherLabel = self:FindComponent("Label", UILabel, fatherObj)
  self:AddClickEvent(fatherObj, function()
    self:ReverseFold()
  end)
  self.childCtl = ListCtrl.new(self:FindComponent("Children", UIGrid), EquipNewChooseCell, "EquipNewChooseCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickChild, self)
  self.childCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickChildIcon, self)
  self:SetFold(false, false)
  self.timesLabel = self:FindComponent("TimesLabel", UILabel, fatherObj)
  self.tipData = {
    funcConfig = {},
    callback = function()
      self.clickId = 0
    end,
    ignoreBounds = {}
  }
end

function EquipRecoveryFatherCell:SetData(data)
  self.data = data
  local flag = data ~= nil and data.items ~= nil and #data.items > 0
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  if not equipSitePartsNameMap then
    equipSitePartsNameMap = {}
    for _, d in pairs(GameConfig.EquipParts) do
      for _, site in pairs(d.site) do
        equipSitePartsNameMap[site] = d.name
      end
    end
  end
  self.fatherLabel.text = equipSitePartsNameMap[data.site] or ""
  self:UpdateTimesLabel(data.site, data.plus)
  self.childCtl:ResetDatas(data.items)
  self:SetFold(true, false)
end

function EquipRecoveryFatherCell:OnClickChild(cellCtl)
  self:PassEvent(MouseEvent.MouseClick, cellCtl)
end

function EquipRecoveryFatherCell:OnClickChildIcon(cellCtl)
  self:PassEvent(EquipChooseCellEvent.ClickItemIcon, cellCtl)
end

function EquipRecoveryFatherCell:ReverseFold(withAnimation)
  self:SetFold(not self.isFold, withAnimation)
end

local tempRot = LuaQuaternion()

function EquipRecoveryFatherCell:SetFold(isOpen, withAnimation)
  if self.isFold == isOpen then
    return
  end
  if withAnimation == nil then
    withAnimation = true
  end
  self.isFold = isOpen
  if withAnimation then
    if isOpen then
      self.tweenScale:PlayForward()
    else
      self.tweenScale:PlayReverse()
    end
  else
    self.tweenScale:Sample(isOpen and 1 or 0, true)
  end
  LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, isOpen and 180 or 0))
  self.arrow.transform.rotation = tempRot
end

function EquipRecoveryFatherCell:SetChooseId(id)
  for _, cell in pairs(self.childCtl:GetCells()) do
    cell:SetChooseId(id)
  end
end

function EquipRecoveryFatherCell:SetItemIconChooseId(id)
  for _, cell in pairs(self.childCtl:GetCells()) do
    cell:SetItemIconChooseId(id)
  end
end

function EquipRecoveryFatherCell:UpdateTimesLabel(pos, isPlus)
  local times = blackSmith:GetEquipRecoveryTimes(pos, isPlus)
  if not GameConfig.EquipRecovery[pos] or times < 0 then
    LogUtility.WarningFormat("Cannot get equip recovery times while pos = {0} and isPlus = {1}", pos, isPlus)
    self.timesLabel.text = ""
  end
  local maxtimes = GameConfig.EquipRecovery[pos][isPlus and 1 or 2]
  self.timesLabel.text = string.format(ZhString.RollReward_CountLeftFormat, maxtimes - times, maxtimes)
end
