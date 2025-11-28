local baseCell = autoImport("BaseCell")
ClassPreviewCell = class("ClassPreviewCell", baseCell)
local effectSpecialStep = {
  [1] = {
    [1] = {
      from = {
        124,
        180,
        0
      },
      to = {
        124,
        111,
        0
      },
      duration = 0.15
    },
    [2] = {
      from = {
        124,
        111,
        0
      },
      to = {
        0,
        111,
        0
      },
      duration = 0.25
    },
    [3] = {
      from = {
        0,
        111,
        0
      },
      to = {
        0,
        80,
        0
      },
      duration = 0.2
    }
  },
  [2] = {
    [1] = {
      from = {
        -124,
        180,
        0
      },
      to = {
        -124,
        111,
        0
      },
      duration = 0.15
    },
    [2] = {
      from = {
        -124,
        111,
        0
      },
      to = {
        0,
        111,
        0
      },
      duration = 0.25
    },
    [3] = {
      from = {
        0,
        111,
        0
      },
      to = {
        0,
        80,
        0
      },
      duration = 0.2
    }
  }
}
local effectCommonStep = {
  [1] = {
    from = {
      0,
      144,
      0
    },
    to = {
      0,
      91,
      0
    },
    duration = 0.5
  }
}
local tempVector3 = LuaVector3.Zero()

function ClassPreviewCell.CreateNew(jobid, gameobj)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ClassPreviewCell"), gameobj)
  obj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  local pCell = ClassPreviewCell.new(obj)
  pCell:SetData(jobid)
  return pCell
end

function ClassPreviewCell:Init()
  self:initView()
  self:AddCellClickEvent()
end

function ClassPreviewCell:initView()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.jobNameLabel = self:FindGO("JobNameLabel"):GetComponent(UILabel)
  self.line = self:FindGO("Line")
  self.professionIcon = self:FindGO("ProfessionIcon"):GetComponent(UISprite)
  self.professionBg = self:FindGO("ProfessionBg"):GetComponent(UISprite)
  self.classTexture = self:FindGO("ClassTexture"):GetComponent(UITexture)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectTweenPos = self.effectContainer:GetComponent(TweenPosition)
  self.tweenLine = self:FindGO("TweenLine"):GetComponent(TweenHeight)
  self.tweenLine.gameObject:SetActive(false)
  self.curSymbol = self:FindGO("CurSymbol")
  self.curSymbol:SetActive(false)
  self.effectTweenPos:SetOnFinished(function()
    self:HandleEffectFinish()
  end)
end

function ClassPreviewCell:SetData(data)
  self.data = data
  local classData = Table_Class[data]
  if classData then
    self.jobNameLabel.text = ProfessionProxy.GetProfessionName(data, MyselfProxy.Instance:GetMySex())
    IconManager:SetNewProfessionIcon(classData.icon, self.professionIcon)
    local classType = classData.Type
    if classType then
      local iconColor = ColorUtil["CareerIconPreviewBg" .. classType]
      if iconColor == nil then
        iconColor = ColorUtil.CareerIconBg0
      end
      self.professionBg.color = iconColor
    end
    local iconName = classData.icon
    local classPicPath = string.gsub(iconName, "icon_", "class_")
    self.classPicPath = classPicPath .. "_" .. MyselfProxy.Instance:GetMySex()
    PictureManager.Instance:SetClassPicTexture(self.classPicPath, self.classTexture)
  end
  local status = ProfessionProxy.Instance:GetClassState(data)
  if status == 1 or status == 2 or status == 3 then
    self:SetUnlockStatus(true)
  else
    self:SetUnlockStatus(false)
  end
  self:SetChoose(false)
  self:SetCurSymbol(false)
  self.tweenLine:ResetToBeginning()
end

function ClassPreviewCell:ActiveLine(bool)
  self.line:SetActive(bool)
end

function ClassPreviewCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end

function ClassPreviewCell:SetUnlockStatus(bool)
  if bool then
    self.bg.spriteName = "newcareer_hero_bg03"
  else
    self.bg.spriteName = "newcareer_hero_bg01"
  end
end

function ClassPreviewCell:SetLine(line)
  self.line = line
end

function ClassPreviewCell:SetCurSymbol(bool)
  self.curSymbol:SetActive(bool)
end

function ClassPreviewCell:PlayTransferEffect()
  local classid = self.data
  local depth = ProfessionProxy.GetJobDepth(classid)
  if depth == 2 then
    if not self.effectConfig then
      self.effectConfig = effectSpecialStep[self.line]
      self.curStep = 1
    end
    if not self.pointEff then
      self.pointEff = self:PlayUIEffect(EffectMap.UI.TransferPreview_TransferLine, self.effectContainer)
    end
    self:PlayStepEffect()
    self.tweenLine.gameObject:SetActive(true)
    self.tweenLine:ResetToBeginning()
    self.tweenLine.delay = 1.2
    self.tweenLine:PlayForward()
  else
    if not self.effectConfig then
      self.effectConfig = effectCommonStep
    end
    if not self.pointEff then
      self.pointEff = self:PlayUIEffect(EffectMap.UI.TransferPreview_TransferLine, self.effectContainer)
    end
    self:PlayCommonEffect()
    self.tweenLine.gameObject:SetActive(true)
    self.tweenLine:ResetToBeginning()
    self.tweenLine.delay = 1.2
    self.tweenLine:PlayForward()
  end
end

function ClassPreviewCell:HandleEffectFinish()
  if self.curStep then
    self.curStep = self.curStep + 1
    if self.effectConfig[self.curStep] then
      self:PlayStepEffect()
    else
      self:PlayFinishEffect()
    end
  else
    self:PlayFinishEffect()
  end
end

function ClassPreviewCell:PlayStepEffect()
  if not self.effectConfig then
    return
  end
  local curStepConfig = self.effectConfig[self.curStep]
  if not curStepConfig then
    redlog("return", self.curStep)
    return
  end
  LuaVector3.Better_Set(tempVector3, curStepConfig.from[1], curStepConfig.from[2], curStepConfig.from[3])
  self.effectTweenPos.from = tempVector3
  LuaVector3.Better_Set(tempVector3, curStepConfig.to[1], curStepConfig.to[2], curStepConfig.to[3])
  self.effectTweenPos.to = tempVector3
  self.effectTweenPos.duration = curStepConfig.duration
  self.effectTweenPos:ResetToBeginning()
  self.effectTweenPos:PlayForward()
end

function ClassPreviewCell:PlayCommonEffect()
  if not self.effectConfig then
    return
  end
  local curStepConfig = self.effectConfig[1]
  if not curStepConfig then
    return
  end
  LuaVector3.Better_Set(tempVector3, curStepConfig.from[1], curStepConfig.from[2], curStepConfig.from[3])
  self.effectTweenPos.from = tempVector3
  LuaVector3.Better_Set(tempVector3, curStepConfig.to[1], curStepConfig.to[2], curStepConfig.to[3])
  self.effectTweenPos.to = tempVector3
  self.effectTweenPos.duration = curStepConfig.duration
  self.effectTweenPos:ResetToBeginning()
  self.effectTweenPos:PlayForward()
end

function ClassPreviewCell:PlayFinishEffect()
  if self.pointEff then
    self.pointEff:Destroy()
    self.pointEff = nil
  end
  self.effectTweenPos.enabled = false
  self.effectContainer.transform.localPosition = LuaVector3.Zero()
  self:PlayUIEffect(EffectMap.UI.TransferPreview_TransferFrame, self.effectContainer)
end

function ClassPreviewCell:OnCellDestroy()
  if self.classPicPath then
    PictureManager.Instance:UnloadClassPicTexture(self.classPicPath, self.classTexture)
    self.classPicPath = nil
  end
  if self.pointEff then
    self.pointEff:Destroy()
    self.pointEff = nil
  end
end
