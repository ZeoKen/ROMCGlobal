local baseCell = autoImport("BaseCell")
ManualQuestNodeCell = class("ManualQuestNodeCell", BaseCell)
local tempVector3 = LuaVector3.Zero()
local tempRot = LuaQuaternion()
ManualQuestNodeCell.NodeStatus = {
  NotActive = 1,
  Active = 2,
  RewardReady = 3,
  ScoreReady = 4,
  Finish = 5,
  Hide = 6
}
ManualQuestNodeCell.FinishType = {
  [1] = "finish_quest",
  [2] = "kill_monster",
  [3] = "level",
  [4] = "menu",
  [5] = "raid",
  [6] = "map"
}

function ManualQuestNodeCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function ManualQuestNodeCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.choose = self:FindGO("Choose")
  self.chooseIcon = self.choose:GetComponent(UISprite)
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.content = self:FindGO("Content")
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectContainer:SetActive(false)
  self.containerRq = self.effectContainer:GetComponent(ChangeRqByTex)
  self.rewardEffectContainer = self:FindGO("RewardEffectContainer")
end

function ManualQuestNodeCell:AddEvts()
  self:SetEvent(self.gameObject, function()
    redlog("点击")
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddCellClickEvent()
end

function ManualQuestNodeCell:SetData(data)
  if self.gameObject.activeSelf then
    self.gameObject:SetActive(true)
  end
  self.data = data
  if not self.config then
    return
  end
  local finishType = self.config.Finish
  local maxProcess
  if finishType == ManualQuestNodeCell.FinishType[1] then
    maxProcess = self.config.Finish_Params.count
  elseif finishType == ManualQuestNodeCell.FinishType[2] then
    local monsterNum = self.config.Finish_Params.count
    if not monsterNum then
      redlog("当前节点kill_monster未配置number限制")
      return
    end
    maxProcess = monsterNum
  elseif finishType == ManualQuestNodeCell.FinishType[3] then
    maxProcess = self.config.Finish_Params.level
  elseif finishType == ManualQuestNodeCell.FinishType[4] then
    maxProcess = 1
  elseif finishType == ManualQuestNodeCell.FinishType[5] then
    maxProcess = #self.config.Finish_Params or 1
  elseif finishType == ManualQuestNodeCell.FinishType[6] then
    maxProcess = #self.config.Finish_Params or 1
  else
    maxProcess = self.config.Finish_Params.count or 0
  end
  self.curProcess = data.process or 0
  if maxProcess <= self.curProcess then
    if 0 < self.maxRewardCount then
      local versionReward = QuestManualProxy.Instance.versionGoalReward
      local curRewardCount = 0
      if versionReward and versionReward[self.groupid] then
        curRewardCount = versionReward[self.groupid]
      end
      redlog("当前groupid 领奖数量", curRewardCount)
      if curRewardCount < self.maxRewardCount then
        self.status = ManualQuestNodeCell.NodeStatus.RewardReady
        if not self.processingEffect then
          self:CreateEffect()
          self.effectAnimator:Play("glow_2")
        end
        return
      end
    end
    if data.point then
      self.icon.spriteName = self.nodeResources[self.config.type][2]
      self.icon:MakePixelPerfect()
      self.boxCollider.enabled = false
      self.status = ManualQuestNodeCell.NodeStatus.Finish
      if self.processingEffect then
        self.effectAnimator:Play("state2001")
      end
      if self.rewardEffect then
        GameObject.DestroyImmediate(self.rewardEffect)
      end
    else
      self.icon.gameObject:SetActive(false)
      self.status = ManualQuestNodeCell.NodeStatus.ScoreReady
      if not self.processingEffect then
        self:CreateEffect()
        self.effectAnimator:Play("glow_2")
      end
    end
  else
    self.status = ManualQuestNodeCell.NodeStatus.Active
    self.icon.gameObject:SetActive(false)
    local speed = math.random(5, 10)
    if not self.processingEffect then
      self:CreateEffect()
      self.effectAnimator:Play("Shaking")
    end
  end
end

function ManualQuestNodeCell:SetIndex(index)
  self.index = index
end

function ManualQuestNodeCell:InitShow(nodeResources)
  self.config = Table_VersionGoal[self.index]
  if not self.config then
    return
  end
  if not self.config.group or not self.config.step then
    redlog("Versiongoal", self.index, "缺少group或step参数")
    return
  end
  self.groupid = self.config.group
  self.stepid = self.config.group * 10000 + self.config.step
  local nodeType = self.config.type
  self.nodeResources = nodeResources
  if nodeType and nodeResources[nodeType] then
    self.icon.spriteName = nodeResources[nodeType][1]
    self.icon:MakePixelPerfect()
  end
  local pos = self.config.Pos
  LuaVector3.Better_Set(tempVector3, pos[1], pos[2], 0)
  self.gameObject.transform.localPosition = tempVector3
  local dir = self.config.icon_dir
  LuaVector3.Better_Set(tempVector3, 0, 0, dir)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
  self.content.transform.localRotation = tempRot
  local scale = self.config.scale or 1
  LuaVector3.Better_Set(tempVector3, scale, scale, scale)
  self.content.transform.localScale = tempVector3
  local hide = self.config.Hide
  if hide then
    redlog("hide 隐藏")
    self.gameObject:SetActive(false)
  end
  self.status = 1
  self.maxRewardCount = 0
  local rewardConfig = GameConfig.VersionGoal.group_reward
  if rewardConfig then
    local hasReward = rewardConfig[self.groupid]
    if hasReward then
      self.maxRewardCount = hasReward.rewardStep and #hasReward.rewardStep or 0
    end
  end
end

function ManualQuestNodeCell:CreateEffect()
  self.effectContainer:SetActive(true)
  local path = ResourcePathHelper.EffectUI(self.nodeResources[self.config.type][3])
  self.processingEffect = self:LoadPreferb_ByFullPath(path, self.effectContainer)
  self.effectAnimator = self.processingEffect:GetComponent(Animator)
  self.containerRq:AddChild(self.processingEffect)
  self.containerRq.excute = true
end

function ManualQuestNodeCell:SetChoose(bool)
  self.choose:SetActive(bool)
  if bool then
    if self.data then
      self.label.text = "GO"
      if self.effectAnimator then
        self.effectAnimator:Play("glow_1")
      end
    else
      self.label.text = ""
      return
    end
    if self.config.type == 1 then
      self.label.color = LuaGeometry.GetTempVector4(0.22745098039215686, 0.4117647058823529, 0.6196078431372549, 1)
    elseif self.config.type == 2 then
      self.label.color = LuaGeometry.GetTempVector4(0.5490196078431373, 0.3568627450980392, 0.20392156862745098, 1)
    end
  elseif self.status == 3 then
    if self.effectAnimator then
      self.effectAnimator:Play("glow_2")
    end
  elseif self.status == 4 then
    if self.effectAnimator then
      self.effectAnimator:Play("glow_2")
    end
  elseif self.status == 5 then
    if self.effectAnimator then
      self.effectContainer:SetActive(false)
      self.icon.gameObject:SetActive(true)
    end
  else
    self.label.text = ""
    if self.effectAnimator then
      self.effectAnimator:Play("Shaking")
    end
  end
end

function ManualQuestNodeCell:ShowEffect(bool)
  self.effectContainer:SetActive(bool)
  self.icon.gameObject:SetActive(not bool)
end

function ManualQuestNodeCell:CallRewardGoalCmd()
  ServiceGoalCmdProxy.Instance:CallGetGroupRewardGoalCmd(self.groupid)
end
