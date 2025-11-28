autoImport("SaveNewCell")
ProfessionSaveLoadNewPage = class("ProfessionSaveLoadNewPage", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ProfessionSaveLoadNewPage")

function ProfessionSaveLoadNewPage:Init()
  self:LoadPrefab()
  self:FindObjs()
  ServiceNUserProxy.Instance:CallQueryProfessionDataDetailUserCmd(SaveInfoEnum.Record)
end

function ProfessionSaveLoadNewPage:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ProfessionSaveLoadNewPage"
  self.gameObject = obj
end

function ProfessionSaveLoadNewPage:FindObjs()
  self.recordList = self:FindGO("RecordList")
  self.listScrollView = self:FindComponent("ListScrollView", UIScrollView, self.recordList)
  self.saveGrid = self:FindComponent("saveGrid", UIGrid)
  self.saveCtl = UIGridListCtrl.new(self.saveGrid, SaveNewCell, "SaveNewCell")
  self.saveCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.saveCtl:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickItem, self)
  self.loadBtn = self:FindGO("loadBtn")
  self:AddClickEvent(self.loadBtn, function()
    if not self:IsMyCurrentRole(self.curSaveId) and Game.MapManager:IsRaidMode() then
      MsgManager.ShowMsgByID(26300)
      return
    end
    if TriplePlayerPvpProxy.Instance:CheckNeedConfirmChangePro() then
      MsgManager.ConfirmMsgByID(26291, function()
        self:OnLoadBtnClick()
      end)
    else
      self:OnLoadBtnClick()
    end
  end)
  self.saveBtn = self:FindGO("saveBtn")
  self:AddClickEvent(self.saveBtn, function()
    self:OnSaveBtnClick()
  end)
  self.nilTip = self:FindGO("nilTip")
  local myselfData = Game.Myself.data
  if Game.Myself:IsDead() or Game.Myself:IsInBooth() then
    self:SetTextureGrey(self.loadBtn)
    self:SetTextureGrey(self.saveBtn)
  end
end

function ProfessionSaveLoadNewPage:OnEnter()
  self:Show()
end

function ProfessionSaveLoadNewPage:OnExit()
  self:Hide()
  MultiProfessionSaveProxy.Instance:SetSavedRecordId(self.curSaveId)
end

function ProfessionSaveLoadNewPage:Show()
  self.container:UpdateNodeSwitch(1)
  self.gameObject:SetActive(true)
  self:SetPreview()
  self.container:OnProfessionSaveLoadPageShow()
end

function ProfessionSaveLoadNewPage:Hide()
  self.gameObject:SetActive(false)
  self:ShowModel()
  self.container:OnProfessionSaveLoadPageHide()
end

function ProfessionSaveLoadNewPage:SetData()
  self:SetSaveList()
  self:SetEquip()
end

function ProfessionSaveLoadNewPage:SetSaveList()
  local datas = {}
  local _slotdatas = MultiProfessionSaveProxy.Instance.slotDatas
  for i = 1, #_slotdatas do
    table.insert(datas, _slotdatas[i])
    if _slotdatas[i].status == 0 and _slotdatas[i].type == SceneUser2_pb.ESLOT_BUY then
      break
    end
  end
  local _slotIndexDatas = MultiProfessionSaveProxy.Instance.saveLocalIndexes
  table.sort(datas, function(l, r)
    return (_slotIndexDatas[l.id] or 99999) < (_slotIndexDatas[r.id] or 99999)
  end)
  self.saveCtl:ResetDatas(datas)
  self.curSaveId = self.curSaveId or MultiProfessionSaveProxy.Instance:GetSavedRecordId()
  self:RefreshChoose()
  local cells = self.saveCtl:GetCells()
  local relative
  for i = 1, #cells do
    local cell = cells[i]
    if cell.id == self.curSaveId then
      local panel = self.listScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      relative = LuaVector3(0, offset.y, 0)
      break
    end
  end
  if relative then
    self.listScrollView:MoveRelative(relative)
  end
end

function ProfessionSaveLoadNewPage:RefreshChoose()
  local childCells = self.saveCtl:GetCells()
  for i = 1, #childCells do
    local childCell = childCells[i]
    childCell:ShowChoose(self.curSaveId)
  end
end

function ProfessionSaveLoadNewPage:SetPreview()
  local saveData = MultiProfessionSaveProxy.Instance.recordDatas[self.curSaveId]
  local curSlotStatus = MultiProfessionSaveProxy.Instance:GetCurrentSlotStatus(self.curSaveId)
  if saveData == nil then
    self:ClearPreview()
    if curSlotStatus == 1 then
      self.saveBtn:SetActive(true)
    end
  else
    self:SetInfo()
    self.nilTip:SetActive(false)
    self.saveBtn:SetActive(false)
    self.container:SetSwitchNodeActive(true)
  end
end

function ProfessionSaveLoadNewPage:ClearPreview()
  self.nilTip:SetActive(true)
  self.saveBtn:SetActive(false)
  self.loadBtn:SetActive(false)
  self:HideModel()
  self:HideInfo()
  self.container:SetSwitchNodeActive(false)
end

function ProfessionSaveLoadNewPage:SetInfo()
  local classID = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
  local profession = classID
  local isCurRole = self:IsMyCurrentRole(self.curSaveId)
  if isCurRole then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classID)
    local branchInfoProf = ProfessionProxy.Instance:GetHighestProfessionByTypeBranch(typeBranch)
    profession = branchInfoProf or profession
  end
  self:SetRoleInfo()
  self:SetAttribute()
  self:SetModel(profession, isCurRole)
  self:SetProcess()
  self:SetEquip()
  self:ShowInfo()
  self:ShowModel()
end

function ProfessionSaveLoadNewPage:SetEquip()
  local saveData = MultiProfessionSaveProxy.Instance:GetUsersaveData(self.curSaveId)
  if saveData then
    local data = {
      showType = MPShowType.FromSave,
      userSaveInfoData = saveData
    }
    self.container:SetEquip(data)
  end
end

local PartIndex = Asset_Role.PartIndex
local PartIndexEx = Asset_Role.PartIndexEx

function ProfessionSaveLoadNewPage:SetModel(classid, isCurRole)
  local parts = Asset_Role.CreatePartArray()
  local config = Table_Class[classid]
  local userData = MultiProfessionSaveProxy.Instance:GetUserDataByID(self.curSaveId)
  if userData and config then
    local savedClassID = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
    local savedConfig = Table_Class[savedClassID]
    local body = userData:Get(UDEnum.BODY) or 0
    local eye = userData:Get(UDEnum.EYE) or 0
    local gender = isCurRole and MyselfProxy.Instance:GetMySex() or userData:Get(UDEnum.SEX)
    local classBody = gender == ProtoCommon_pb.EGENDER_MALE and config.MaleBody or config.FemaleBody
    local classEye = gender == ProtoCommon_pb.EGENDER_MALE and config.MaleEye or config.FemaleEye
    local savedDefaultBody = gender == ProtoCommon_pb.EGENDER_MALE and savedConfig.MaleBody or savedConfig.FemaleBody
    local savedDefaultEye = gender == ProtoCommon_pb.EGENDER_MALE and savedConfig.MaleEye or savedConfig.FemaleEye
    if 0 < body and body ~= savedDefaultBody then
      parts[PartIndex.Body] = body
    else
      parts[PartIndex.Body] = classBody or 0
    end
    if 0 < eye and eye ~= savedDefaultEye then
      eye = ProfessionProxy.GetOriginalEye(eye, parts[PartIndex.Body])
      parts[PartIndex.Eye] = eye
    else
      parts[PartIndex.Eye] = classEye or 0
    end
    parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
    parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
    parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
  end
  FunctionMultiProfession.Me():UpdateRoleModel(parts)
  Asset_Role.DestroyPartArray(parts)
  self.container:ShowSwitchEffect()
  AudioUtility.PlayOneShot2D_Path(AudioMap.UI.ProfessionSwitch, AudioSourceType.UI)
end

function ProfessionSaveLoadNewPage:SetProcess()
  local result = ReusableTable.CreateArray()
  local saveData = MultiProfessionSaveProxy.Instance:GetUsersaveData(self.curSaveId)
  local usedAstro = saveData and AstrolabeProxy.Instance:GetPoints_CostGoldMedalCount(saveData) or 0
  local totalAstro = GameConfig.Profession.maxAstro or 0
  local data = {
    order = 6,
    curValue = usedAstro,
    maxValue = totalAstro
  }
  data.clickFunc = self.OnAstroBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[6] = data
  local classid = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
  local unusedSkill
  if self:IsMyCurrentRole(self.curSaveId) then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classid)
    local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf()
    unusedSkill = typeBranch == myTypeBranch and Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) or BranchInfoSaveProxy.Instance:GetUnusedSkillPoint(typeBranch)
  else
    unusedSkill = MultiProfessionSaveProxy.Instance:GetUnusedSkillPoint(self.curSaveId)
  end
  unusedSkill = unusedSkill or 0
  local usedSkill = MultiProfessionSaveProxy.Instance:GetUsedPoints(self.curSaveId) or 0
  local totalSkill = unusedSkill + usedSkill
  data = {
    order = 1,
    curValue = usedSkill,
    maxValue = totalSkill
  }
  data.clickFunc = self.OnSkillBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[1] = data
  local skillGem = 0
  local attrGem = 0
  local secretLandGem = 0
  local maxSkillGem = GameConfig.Profession.maxSkillGem or 0
  local maxAttrGem = GameConfig.Profession.maxAttrGem or 0
  local maxSecretLandGem = GameConfig.Profession.maxSecretLandGem or 3
  local gemData = MultiProfessionSaveProxy.Instance:GetGemData(self.curSaveId)
  if gemData and 0 < #gemData then
    for i = 1, #gemData do
      local single = gemData[i]
      if single.gemSkillData and single.gemSkillData.available then
        skillGem = skillGem + 1
      elseif single.gemAttrData then
        attrGem = attrGem + 1
      elseif single.secretLandDatas then
        secretLandGem = secretLandGem + 1
      end
    end
  end
  if not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SKILL) then
    if ProfessionProxy.IsHero(classid) then
      data = {
        order = 2,
        curValue = MultiProfessionSaveProxy.Instance:GetHeroFeatureLv(self.curSaveId) or 1,
        maxValue = maxSkillGem + 1
      }
      data.clickFunc = self.OnGemBtnClick
      data.owner = self
      data.funcParams = self.curSaveId
      result[data.order] = data
    else
      data = {
        order = 3,
        curValue = skillGem,
        maxValue = maxSkillGem
      }
      data.clickFunc = self.OnGemBtnClick
      data.owner = self
      data.funcParams = self.curSaveId
      result[data.order] = data
    end
  end
  if not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_ATTR) then
    data = {
      order = 4,
      curValue = attrGem,
      maxValue = maxAttrGem
    }
    data.clickFunc = self.OnGemBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[data.order] = data
  end
  if FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.Gem.SecretlandGemMenuID) or not GemProxy.CheckGemForbidden(SceneItem_pb.EPACKTYPE_GEM_SECRETLAND) then
    data = {
      order = 5,
      curValue = secretLandGem,
      maxValue = maxSecretLandGem
    }
    data.clickFunc = self.OnGemBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[data.order] = data
  end
  if not FunctionUnLockFunc.CheckForbiddenByFuncState("personal_artifact_forbidden") then
    local progress = PersonalArtifactProxy.Instance:GetPreviewProgress(SaveInfoEnum.Record, self.curSaveId)
    data = {
      order = 7,
      curValue = math.floor(progress * 100)
    }
    data.clickFunc = self.OnArtifactBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[data.order] = data
  end
  if not FunctionUnLockFunc.CheckForbiddenByFuncState("extraction_forbidden") then
    local extractData = MultiProfessionSaveProxy.Instance:GetExtract(self.curSaveId)
    local activeCount = extractData and extractData:GetActiveCount() or 0
    local extractLimit = GameConfig.Profession.maxExtract or 2
    data = {
      order = 8,
      curValue = activeCount,
      maxValue = extractLimit
    }
    data.clickFunc = self.OnExtractBtnClick
    data.owner = self
    data.funcParams = self.curSaveId
    result[data.order] = data
  end
  local initPoint = GameConfig.SkillInherit and GameConfig.SkillInherit.InitPointMax or 0
  local extendPointCost = GameConfig.SkillInherit and GameConfig.SkillInherit.PointExtendCost
  local max = initPoint
  if extendPointCost then
    max = max + #extendPointCost
  end
  local loadSkills = MultiProfessionSaveProxy.Instance:GetInheritSkillLoadSkills(self.curSaveId)
  local costPoints = 0
  for i = 1, #loadSkills do
    local skill = loadSkills[i]
    costPoints = costPoints + skill:GetCostPoint()
  end
  data = {
    order = 9,
    curValue = costPoints,
    maxValue = max
  }
  data.clickFunc = self.OnInheritSkillBtnClick
  data.owner = self
  data.funcParams = self.curSaveId
  result[data.order] = data
  self.container:UpdateClassProcess(result, 2)
  ReusableTable.DestroyAndClearArray(result)
end

function ProfessionSaveLoadNewPage:ShowModel()
  FunctionMultiProfession.Me():SetRoleModelActive(true)
end

function ProfessionSaveLoadNewPage:HideModel()
  FunctionMultiProfession.Me():SetRoleModelActive(false)
end

function ProfessionSaveLoadNewPage:SetRoleInfo()
  local classID = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
  local lv
  if self:IsMyCurrentRole(self.curSaveId) then
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classID)
    local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf()
    lv = typeBranch == myTypeBranch and MyselfProxy.Instance:JobLevel() or BranchInfoSaveProxy.Instance:GetJobLevel(typeBranch)
  else
    lv = MultiProfessionSaveProxy.Instance:GetJobLevel(self.curSaveId)
  end
  lv = ProfessionProxy.Instance:GetThisJobLevelForClient(classID, lv)
  self.container:UpdateCurClassBranch(classID, false, lv and true or false, lv or 0)
  local props = MultiProfessionSaveProxy.Instance:GetProps(self.curSaveId)
  if props then
    for i = 1, #GameConfig.SavePreviewAttrMain do
      local single = GameConfig.SavePreviewAttrMain[i]
      local prop = props.mProps[single]
      if prop then
        local value = prop.value
        self.container:SetPolygonValue(i, value, false)
      end
    end
  end
  self.container:SetMaxJobTipActive(false)
end

function ProfessionSaveLoadNewPage:SetAttribute()
  local props = MultiProfessionSaveProxy.Instance:GetProps(self.curSaveId)
  self.container:SetProps(props)
end

function ProfessionSaveLoadNewPage:ShowInfo()
  local curNodeIndex = self.container.basePart.curSwitchNode
  if curNodeIndex == 1 then
    self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.Ymir)
    self.loadBtn:SetActive(true)
  elseif curNodeIndex == 2 then
    self.container:ShowEquip(true)
    self.loadBtn:SetActive(false)
  end
end

function ProfessionSaveLoadNewPage:HideInfo()
  local curNodeIndex = self.container.basePart.curSwitchNode
  if curNodeIndex == 1 then
    self.container:SwitchPageStatus(ProfessionPageBasePart.TweenGroup.YmirNoRecord)
  elseif curNodeIndex == 2 then
    self.container:ShowEquip(false)
  end
end

function ProfessionSaveLoadNewPage:ClickItem(cell)
  if cell and cell.id ~= self.curSaveId then
    if cell.data.status == 0 then
      if cell.data.type == SceneUser2_pb.ESLOT_MONTH_CARD then
        return
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PurchaseSaveSlotPopUp,
          viewdata = cell.data
        })
        return
      end
    end
    self.curSaveId = cell.id
    self:SetPreview()
    self:RefreshChoose()
  end
end

function ProfessionSaveLoadNewPage:DoubleClickItem(cell)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if cell ~= nil and cell.data.status == 1 and cell.data.recordTime ~= 0 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeSaveNamePopUp,
      viewdata = cell
    })
  else
    return
  end
end

function ProfessionSaveLoadNewPage:OnNodeSwitch(index)
  local saveData = MultiProfessionSaveProxy.Instance.recordDatas[self.curSaveId]
  self.loadBtn:SetActive(saveData and index == 1 or false)
end

function ProfessionSaveLoadNewPage:OnLoadBtnClick()
  if self.call_lock then
    return
  end
  local myselfData = Game.Myself.data
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25708)
    return
  end
  self:LockCall()
  local callRecord = function()
    MultiProfessionSaveProxy.Instance:LoadRecordByMapRule(self.curSaveId, true)
  end
  local totalContri, totalGold = MultiProfessionSaveProxy.Instance:GetContribute(self.curSaveId), MultiProfessionSaveProxy.Instance:GetGoldMedal(self.curSaveId)
  AstrolabeProxy.ConfirmAstrolMaterialOnChange(totalContri, totalGold, function()
    if GemProxy.CheckIsGemDataDifferentFrom(MultiProfessionSaveProxy.Instance:GetGemData(self.curSaveId)) then
      MsgManager.ConfirmMsgByID(36011, callRecord)
    else
      callRecord()
    end
  end)
end

function ProfessionSaveLoadNewPage:OnSaveBtnClick()
  if self.call_lock then
    return
  end
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByID(2500)
    return
  end
  if not ProfessionProxy.CanChangeProfession4NewPVPRule(25389) then
    return
  end
  self:LockCall()
  local str = string.format(ZhString.MultiProfession_SaveName, self.curSaveId)
  ServiceNUserProxy:CallSaveRecordUserCmd(self.curSaveId, str)
end

function ProfessionSaveLoadNewPage:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if not self.lock_lt then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function ProfessionSaveLoadNewPage:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function ProfessionSaveLoadNewPage:HandleRecvUpdateRecordInfoUserCmd(note)
  self.curSaveId = self.curSaveId or MultiProfessionSaveProxy.Instance:GetSavedRecordId()
  if self:IsMyCurrentRole(self.curSaveId) then
    local classID = MultiProfessionSaveProxy.Instance:GetProfession(self.curSaveId)
    local typeBranch = ProfessionProxy.GetTypeBranchFromProf(classID)
    if not BranchInfoSaveProxy.Instance:HasRecordData(typeBranch) then
      local curTypeBranch = ProfessionProxy.GetTypeBranchFromProf()
      if curTypeBranch ~= typeBranch then
        return false, typeBranch
      end
    end
  end
  self:CancelLockCall()
  self:SetData()
  self:SetPreview()
  return true
end

function ProfessionSaveLoadNewPage:OnStatusChange()
  self:SetData()
end

function ProfessionSaveLoadNewPage:OnAstroBtnClick(param)
  if not MyselfProxy.Instance:IsUnlockAstrolabe() then
    MsgManager.ShowMsgByID(25432)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25395)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AstrolabeView,
    viewdata = {storageId = param}
  })
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25395, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.AstrolabeView,
        viewdata = {storageId = param}
      })
    end)
  end
end

function ProfessionSaveLoadNewPage:OnSkillBtnClick(param)
  if GameConfig.SystemForbid.MultiProfession then
    MsgManager.ShowMsgByID(25413)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25395)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CharactorProfessSkill,
    viewdata = {
      saveId = param,
      saveType = SaveInfoEnum.Record,
      allowedSkillTip = {
        SkillTip.FuncTipType.SubSkillsReadOnly,
        SkillTip.FuncTipType.ItemCost
      }
    }
  })
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25395, function()
    end)
  end
end

function ProfessionSaveLoadNewPage:OnGemBtnClick(param)
  if not FunctionUnLockFunc.Me():CheckCanOpen(6200) then
    MsgManager.ShowMsgByID(36008)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25395)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemEmbedPreview,
    viewdata = {
      saveId = param,
      saveType = SaveInfoEnum.Record
    }
  })
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25395, function()
    end)
  end
end

function ProfessionSaveLoadNewPage:OnArtifactBtnClick(param)
  if not FunctionUnLockFunc.Me():CheckCanOpen(10014) then
    MsgManager.ShowMsgByID(41404)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25395)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PersonalArtifactFunctionView,
    viewdata = {
      save_type = SaveInfoEnum.Record,
      save_id = param
    }
  })
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25395, function()
    end)
  end
end

function ProfessionSaveLoadNewPage:OnExtractBtnClick(param)
  if not FunctionUnLockFunc.Me():CheckCanOpen(10004) then
    MsgManager.ShowMsgByID(40800)
    return
  end
  local savedata = MultiProfessionSaveProxy.Instance.recordDatas[param]
  if savedata == nil then
    return
  end
  local extractData = MultiProfessionSaveProxy.Instance:GetExtract(param)
  local extractList = extractData and extractData:GetExtractData()
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(25395)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MagicBoxPanel,
    viewdata = {preview = true, slotdatas = extractList}
  })
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(25395, function()
    end)
  end
end

function ProfessionSaveLoadNewPage:OnInheritSkillBtnClick(param)
  if not FunctionUnLockFunc.Me():CheckCanOpen(19390) then
    MsgManager.ShowMsgByID(43661)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.InheritSkillView,
    viewdata = {
      saveId = param,
      saveType = SaveInfoEnum.Record
    }
  })
end

function ProfessionSaveLoadNewPage:IsMyCurrentRole(saveId)
  local roleId = MultiProfessionSaveProxy.Instance:GetRoleID(saveId)
  return roleId == Game.Myself.data.id
end
