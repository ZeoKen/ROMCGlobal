local BaseCell = autoImport("BaseCell")
ProfessionTypeIconCell = class("ProfessionTypeIconCell", BaseCell)

function ProfessionTypeIconCell:Init()
  self:initView()
  self:initData()
end

function ProfessionTypeIconCell:initData()
  self.isSelected = true
  self:setIsSelected(false)
end

function ProfessionTypeIconCell:initView()
  self.name = self:FindGO("Label", self:FindGO("name")):GetComponent(UILabel)
  self.selected = self:FindGO("selected")
  self.lockedIcon = self:FindGO("noneProfession")
  self.headCellObj = self:FindGO("PortraitCell")
  self.State1 = self:FindGO("State1")
  self.State3 = self:FindGO("State3")
  self.State6 = self:FindGO("State6")
  self.State7 = self:FindGO("State7")
  self.jinjie = self:FindGO("jinjie")
  self.jinjie.gameObject:SetActive(false)
  self.selectedMP = self:FindGO("selectedMP")
  self.State7.gameObject:SetActive(false)
end

function ProfessionTypeIconCell:SetSelectedMPActive(b)
  self.selectedMP.gameObject:SetActive(b)
end

function ProfessionTypeIconCell:addViewEventListener()
  self:AddClickEvent(self.gameObject, function()
    if self.data then
      self:setIsSelected(not self.isSelected)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ProfessionTypeIconCell:setIsSelected(isSelected)
  if isSelected ~= self.isSelected then
    self.selected:SetActive(false)
    self.isSelected = isSelected
  end
end

local tempColor = LuaColor.White()

function ProfessionTypeIconCell:SetData(data)
  self.data = data
  if data == nil then
    self:Show(self.lockedIcon)
    self.name.color = tempColor
    self.name.text = ZhString.Charactor_ProfessionPage_NotOpen
    self.previousId = nil
    self.state = nil
  else
    self:initHead()
    self.state = self.state or "XXX"
    self.name.text = self:GetNameZh()
    local id = self:GetId()
    if id then
      self.headData:TransByMyselfWithCustomJob(id)
    end
    self.headData.frame = nil
    self.headData.job = nil
    if self.headData == nil then
      helplog("if self.headData == nil then")
    end
    if self.targetCell == nil then
      helplog("if self.targetCell == nil then")
    end
    self.targetCell:SetData(self.headData)
  end
end

function ProfessionTypeIconCell:SetMyselfData()
  local nowOcc = Game.Myself.data:GetCurOcc()
  self.data = Table_Class[nowOcc.profession]
  self:initHead()
  self.headData:TransByMyself()
  self.headData.frame = nil
  self.headData.job = nil
  self.targetCell:SetData(self.headData)
end

local tempVector3 = LuaVector3.Zero()

function ProfessionTypeIconCell:initHead()
  self:Hide(self.lockedIcon)
  self.cellObj = self.cellObj or Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), self.headCellObj)
  self.cellObj.transform.localPosition = tempVector3
  self.targetCell = self.targetCell or PlayerFaceCell.new(self.cellObj)
  self.targetCell:HideHpMp()
  self.targetCell:HideLevel()
  self.headData = self.headData or HeadImageData.new()
  self:AddClickEvent(self.cellObj, function()
    if self.data then
      self:setIsSelected(not self.isSelected)
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ProfessionTypeIconCell:isShowName(isShow)
  self:SetActive(self.name.transform.parent.gameObject, isShow)
end

function ProfessionTypeIconCell:SetPreviousId(previousId)
  self.previousId = previousId
end

function ProfessionTypeIconCell:SetPreviousCell(cell)
  self.previousCell = cell
end

function ProfessionTypeIconCell:GetPreviousId()
  return self.previousId
end

function ProfessionTypeIconCell:GetPreviousCell()
  return self.previousCell
end

function ProfessionTypeIconCell:SetHeadIconState(state)
  self.state = state
end

function ProfessionTypeIconCell:GetHeadIconState()
  return self.state
end

function ProfessionTypeIconCell:GetId()
  return self.data and self.data.id or nil
end

function ProfessionTypeIconCell:SetPreviousJob(previousId, previousJoblv)
  self.previousId = previousId
  self.previousJoblv = previousJoblv
end

function ProfessionTypeIconCell:GetPrevious()
  return self.previousId or 0, self.previousJoblv or 0
end

function ProfessionTypeIconCell:UpdateState()
  if self.data ~= nil then
    self.name.text = self:GetNameZh()
    self:ChangeUIState(self.state)
  end
end

function ProfessionTypeIconCell:ChangeUIState(state)
  self.State1.gameObject:SetActive(state == 1)
  self.State3.gameObject:SetActive(state == 3)
  self.State6.gameObject:SetActive(state == 6)
  if state == 4 or state == 5 or state == 6 or state == 7 then
    self.targetCell:SetGoGreyMP()
  else
    self.targetCell:SetGoNormalMP()
  end
  local id = self:GetId()
  local previousId = ProfessionProxy.Instance:GetThisIdPreviousId(id)
  if previousId == MyselfProxy.Instance:GetMyProfession() and self:NeedShowJinJie() then
    self:ShowJinJie()
  else
    self.jinjie.gameObject:SetActive(false)
  end
  if ProfessionProxy.Instance:ShouldThisIdVisible(id) then
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function ProfessionTypeIconCell:NeedShowJinJie()
  local thisId = self:GetId()
  local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local previousId = ProfessionProxy.Instance:GetThisIdPreviousId(thisId)
  local userData = Game.Myself.data.userdata
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  local thisRaceMPOpen = ProfessionProxy.Instance:IsMPOpen()
  if thisRaceMPOpen and thisId % 10 == 2 then
    local previousBranch = Table_Class[previousId].TypeBranch
    local previousSaveData = S_ProfessionDatas[previousBranch]
    if previousSaveData and previousSaveData.Isjust1stJob then
      thisRaceMPOpen = false
    end
  end
  if not thisRaceMPOpen then
    if previousId == MyselfProxy.Instance:GetMyProfession() then
      local tiaojianlevel = ProfessionProxy.Instance:GetThisIdJiuZhiTiaoJianLevel(thisId)
      local previouslevel = ProfessionProxy.Instance:GetThisJobLevelForClient(previousId, MyselfProxy.Instance:JobLevel())
      if tiaojianlevel == nil then
        helplog("if tiaojianlevel == nil then 请策划检查配置表")
        return false
      end
      if previouslevel == nil then
        helplog("if previouslevel == nil then")
        return false
      end
      if tiaojianlevel <= previouslevel then
        if thisId % 10 == 1 and nowRoleLevel < 40 then
          return false
        end
        return true
      end
    end
    return false
  end
  local thisBranch = Table_Class[thisId].TypeBranch
  local saveData = S_ProfessionDatas[thisBranch]
  if saveData == nil then
    return false
  end
  if saveData and previousId and saveData.profession == previousId and thisBranch == saveData.branch and ProfessionProxy.Instance:GetCurTypeBranch() == thisBranch then
    local tiaojianlevel = ProfessionProxy.Instance:GetThisIdJiuZhiTiaoJianLevel(thisId)
    local previouslevel = saveData.joblv
    if previousId == Game.Myself.data:GetCurOcc().profession then
      previouslevel = MyselfProxy.Instance:JobLevel()
    end
    previouslevel = ProfessionProxy.Instance:GetThisJobLevelForClient(saveData.profession, previouslevel)
    if tiaojianlevel == nil then
      helplog("tiaojianlevel == nil 就职条件根据配置表 推测不出 请检查配置表")
      return false
    end
    if previouslevel == nil then
      helplog("if previouslevel == nil then")
      return false
    end
    if saveData.profession == ProfessionProxy.Instance:GetThisIdPreviousId(thisId) and tiaojianlevel <= previouslevel then
      if thisId % 10 == 1 and nowRoleLevel < 40 then
        helplog("NeedShowJinJie5")
        return false
      end
      return true
    end
  end
  return false
end

function ProfessionTypeIconCell:ShowJinJie()
  self:SetHeadIconState(HeadIconState.State4)
  self.jinjie.gameObject:SetActive(true)
  self.name.text = "进阶"
end

function ProfessionTypeIconCell:GetNameZh()
  if self.data.isFake then
    return self.data.NameZh
  else
    return ProfessionProxy.GetProfessionName(self.data.id, MyselfProxy.Instance:GetMySex())
  end
end
