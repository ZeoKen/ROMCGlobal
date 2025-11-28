local BaseCell = autoImport("BaseCell")
TransferFightMonsterCell = class("TransferFightMonsterCell", BaseCell)
TransferFightMonsterCell.MonsterType = {
  [1] = ZhString.TransferFight_MonsterTypePower,
  [2] = ZhString.TransferFight_MonsterTypeSpeed
}
local tempVector3 = LuaVector3.Zero()

function TransferFightMonsterCell:Init()
  self:FindObjs()
end

function TransferFightMonsterCell:FindObjs()
  self.name = self:FindComponent("Name", UILabel)
  self.monsterType = self:FindComponent("MonsterType", UILabel)
  self.chooseFrame = self:FindGO("ChooseFrame")
  self.chooseStatus = self:FindGO("ChooseStatus")
  self.chooseBtn = self:FindGO("RoleTexture")
  self.boxcollider = self.chooseBtn:GetComponent(BoxCollider)
  self.monsterTexture = self:FindComponent("RoleTexture", UITexture)
  self:AddClickEvent(self.chooseBtn, function()
    helplog("ClickCell")
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function TransferFightMonsterCell:setChoose(bool)
  self.chooseFrame.gameObject:SetActive(bool)
end

function TransferFightMonsterCell:confirmChooseStatus(bool)
  if bool then
    self.chooseStatus.gameObject:SetActive(true)
  else
    self.chooseStatus.gameObject:SetActive(false)
  end
  self.boxcollider.enabled = false
end

function TransferFightMonsterCell:SetData(data)
  self.data = data
  self.id = data.id
  if data.monster and Table_Monster[data.monster] then
    self.staticData = Table_Monster[data.monster]
    self.name.text = self.staticData.NameZh
  end
  if data.buff and Table_Buffer[data.buff] then
    local buffData = Table_Buffer[data.buff]
    local desc = buffData.BuffDesc
    self.monsterType.text = desc
  end
  self:ShowMonster3DModel()
end

function TransferFightMonsterCell:ShowMonster3DModel()
  local data = self.data
  local monsterid = data and data.monster
  local monsterData = Table_Monster[monsterid]
  if monsterData then
    UIModelUtil.Instance:ResetTexture(self.monsterTexture)
    UIModelUtil.Instance:SetMonsterModelTexture(self.monsterTexture, monsterData.id, nil, nil, function(obj)
      self.model = obj
      local showPos = monsterData.LoadShowPose
      if showPos and #showPos == 3 then
        LuaVector3.Better_Set(tempVector3, showPos[1], showPos[2], showPos[3])
        self.model:SetPosition(tempVector3)
      end
      self.model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
      local size = monsterData.LoadShowSize or 1
      self.model:SetScale(size)
    end)
  end
end
