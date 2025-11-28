autoImport("CharacterEncounterDialogCell")
autoImport("Dialog_MenuData")
autoImport("NpcMenuBtnCell")
CharacterEncounterView = class("CharacterEncounterView", BaseView)
CharacterEncounterView.ViewType = UIViewType.Show3D2DLayer

function CharacterEncounterView.CanShow()
  return LinkCharacterProxy.Instance:GetCurrentCharacterConfig() ~= nil
end

function CharacterEncounterView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function CharacterEncounterView:Init()
  self:FindObjs()
  self:InitData()
  self:InitView()
  self:AddListenEvts()
end

function CharacterEncounterView:FindObjs()
  self.menu = self:FindGO("Menu")
  self.menuSprite = self.menu:GetComponent(UISprite)
  self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView)
  self.grid = self:FindComponent("MenuGrid", UIGrid, self.menu)
  self.modelTex = self:FindComponent("ModelTex", UITexture)
  self.effectContainer = self:FindGO("EffectContainer")
end

function CharacterEncounterView:InitData()
  self.dialogInfo = {}
  self.dialogIndex = 1
  self.menuData = {}
  self.charCfg = LinkCharacterProxy.Instance:GetCurrentCharacterConfig()
end

function CharacterEncounterView:InitView()
  local obj = self:LoadPreferb("cell/CharacterEncounterDialogCell", self:FindGO("Bottom"))
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.dialogCtl = CharacterEncounterDialogCell.new(obj)
  self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDialog, self)
  self.dialogCtl.gameObject:SetActive(false)
  self.menuCtl = UIGridListCtrl.new(self.grid, NpcMenuBtnCell, "NpcMenuBtnCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMenu, self)
end

function CharacterEncounterView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.OnQuestDataUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.OnQuestStepUpdate)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.OnServerReceiveLoaded)
end

function CharacterEncounterView:OnEnter()
  if not self:CheckCharCfg() then
    return
  end
  TimeTickManager.Me():CreateOnceDelayTick(200, function()
    Game.PerformanceManager:SkinWeightHigh(true)
  end, self, 9999)
  self:OnQuestDataUpdate()
end

function CharacterEncounterView:OnExit()
  self.dialogCtl:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.model then
    UIModelUtil.Instance:ResetTexture(self.modelTex)
    self.modelTex = nil
    self.model = nil
  end
  Game.PerformanceManager:SkinWeightHigh(false)
  CharacterEncounterView.super.OnExit(self)
end

function CharacterEncounterView:OnClickDialog()
  if self.clickDisabled then
    return
  end
  local preDialog = self.dialogInfo[self.dialogIndex]
  if preDialog and StringUtil.IsEmpty(preDialog.Option) then
    if self.dialogIndex == #self.dialogInfo then
      self.clickDisabled = true
      self:CloseSelf(true)
    else
      self.clickDisabled = nil
      self:StepDialog()
    end
  end
end

function CharacterEncounterView:OnClickMenu(cellCtl)
  local data = cellCtl.data
  if not data then
    return
  end
  if data.optionid == 0 then
    self:StepDialog()
  else
    FunctionVisitNpc._DialogEndCall(self.questData.id, data.optionid, true, self.questData.scope)
    if data.name == ZhString.ActivityData_GoLabelText then
      self:sendNotification(MainViewEvent.ClearViewSequence)
    end
  end
end

function CharacterEncounterView:OnQuestDataUpdate()
  if not self:CheckCharCfg() then
    return
  end
  self:RefreshQuestData(self.charCfg.QuestID)
end

function CharacterEncounterView:OnQuestStepUpdate(note)
  if not self.questData then
    LogUtility.Warning("Cannot find questData of LinkCharacter! QuestStepUpdate will be ignored.")
    return
  end
  local data = note.body
  if not data or data.id ~= self.questData.id then
    LogUtility.WarningFormat("Invalid id:{0} of QuestStepUpdate!", data and data.id)
    return
  end
  self:RefreshQuestData(data.id)
end

local encounterAnimCallback = function(id, self)
  self:PlayCharacterAction(self.charCfg.WaitAnimation)
  self:PlayUIEffect(self.charCfg.WaitFX, self.effectContainer)
  self.characterEncounterAnimCompleted = true
  self.dialogCtl.gameObject:SetActive(true)
end
local onModelCreated = function(model, self)
  self.model = model
  self:PlayCharacterAction(self.charCfg.OpeningAnimation, encounterAnimCallback)
  self:PlayUIEffect(self.charCfg.OpeningFX, self.effectContainer)
end

function CharacterEncounterView:OnServerReceiveLoaded()
  if not self:CheckCharCfg() then
    return
  end
  local parts = Asset_RoleUtility.CreateNpcRoleParts(self.charCfg.NpcID)
  parts[Asset_Role.PartIndexEx.LoadFirst] = true
  UIModelUtil.Instance:SetRoleModelTexture(self.modelTex, parts, UIModelCameraTrans.LinkCharacter, nil, nil, nil, nil, onModelCreated, self)
  UIModelUtil.Instance:SetCellTransparent(self.modelTex)
  Asset_Role.DestroyPartArray(parts)
  self.forceShowTick = TimeTickManager.Me():CreateOnceDelayTick(18000, self.OnForceShow, self)
end

function CharacterEncounterView:OnForceShow()
  if self.characterEncounterAnimCompleted then
    return
  end
  redlog("CharacterEncounterView", "OnForceShow")
  encounterAnimCallback(nil, self)
end

function CharacterEncounterView:RefreshQuestData(questId)
  if not self:CheckCharCfg() then
    return
  end
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    self.questData = questData
    self:UpdateDialogList()
  end
end

function CharacterEncounterView:StepDialog()
  self.dialogIndex = self.dialogIndex + 1
  if self.dialogIndex <= #self.dialogInfo then
    self:UpdateDialog()
  end
end

function CharacterEncounterView:UpdateDialog()
  if #self.dialogInfo > 0 then
    self.nowDialogData = self.dialogInfo[self.dialogIndex]
    if self.nowDialogData then
      self.dialogCtl:SetData(self.nowDialogData, self.questParams)
      if StringUtil.IsEmpty(self.nowDialogData.Option) then
        self:UpdateMenu()
      else
        local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(self.nowDialogData.Option))
        if optionConfig and 0 < #optionConfig then
          self:UpdateMenu(optionConfig)
        end
      end
      self.menuSprite.enabled = not StringUtil.IsEmpty(self.nowDialogData.Text)
      local actionName = Table_ActionAnime[self.nowDialogData.ModelAct] and Table_ActionAnime[self.nowDialogData.ModelAct].Name
      if actionName then
        self:PlayCharacterAction(actionName)
      end
    else
      LogUtility.WarningFormat("Cannot find dialog of index {0}", self.dialogIndex)
    end
  else
    self.nowDialogData = nil
  end
end

function CharacterEncounterView:UpdateDialogList(list)
  list = list or self.questData.params.dialog
  if not list or #list == 0 then
    LogUtility.Warning("Cannot find quest dialog of CharacterEncounterView!")
    self:CloseSelf()
    return
  end
  TableUtility.TableClear(self.dialogInfo)
  local element, data
  for i = 1, #list do
    element = list[i]
    data = DialogUtil.GetDialogData(element)
    if data then
      table.insert(self.dialogInfo, data)
    end
  end
  self.dialogIndex = 1
  self:UpdateDialog()
  if not self.characterEncounterAnimCompleted then
    self.dialogCtl.gameObject:SetActive(false)
  end
end

function CharacterEncounterView:UpdateMenu(option)
  TableUtility.ArrayClear(self.menuData)
  if option then
    for i = 1, #option do
      local option_menuData = Dialog_MenuData.new()
      option_menuData:Set_ByOption(option[i])
      table.insert(self.menuData, option_menuData)
    end
  end
  DialogUtil.SetViewMenuCtlByMenuData(self.menu, self.menuCtl, self.menuData)
  local cells = self.menuCtl:GetCells()
  for _, cell in pairs(cells) do
    if cell.content == ZhString.ActivityData_GoLabelText then
      cell:SetStyle(NpcMenuBtnCell.Style.Primary)
    end
  end
end

local restoreAnimCallback = function(id, self)
  self:_PlayCharacterAction(self.charCfg and self.charCfg.WaitAnimation or Asset_Role.ActionName.Idle)
end

function CharacterEncounterView:PlayCharacterAction(actionName, callback, callbackArg)
  self:_PlayCharacterAction(actionName, callback or restoreAnimCallback, callbackArg or self)
end

function CharacterEncounterView:_PlayCharacterAction(actionName, callback, callbackArg)
  if not self.model then
    return
  end
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  params[7] = callback
  params[8] = callbackArg
  self.model:PlayActionRaw(params)
end

function CharacterEncounterView:PlayUIEffect(id, container, once, callback, callArgs)
  if self.effect then
    self.effect:Destroy()
  end
  if id == nil then
    return
  end
  CharacterEncounterView.super.PlayUIEffect(self, id, container, once, function(obj, args, assetEffect)
    self.effect = assetEffect
    if callback then
      callback(assetEffect, callArgs)
    end
  end, callArgs)
end

local farewellAnimCallback = function(id, self)
  CharacterEncounterView.super.CloseSelf(self)
end

function CharacterEncounterView:CloseSelf(playFarewellAnim)
  if playFarewellAnim and self.charCfg then
    self:PlayCharacterAction(self.charCfg.EndingAnimation, farewellAnimCallback)
    self:PlayUIEffect(self.charCfg.EndingFX, self.effectContainer)
  else
    farewellAnimCallback(nil, self)
  end
end

function CharacterEncounterView:CheckCharCfg()
  local b = self.charCfg ~= nil
  if not b then
    LogUtility.Error("Cannot find link character config!!")
    self:CloseSelf()
  end
  return b
end
