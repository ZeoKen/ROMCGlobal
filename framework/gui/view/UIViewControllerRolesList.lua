autoImport("UIModelRolesList")
autoImport("UIListItemViewControllerRoleSlot")
autoImport("UIBlackScreen")
autoImport("LoginRoleSelector")
autoImport("RoleReadyForLogin")
autoImport("WeGameHelper")
autoImport("WaitEnterBord")
autoImport("UIViewRolesListMsgCell")
autoImport("RewardGridCell")
autoImport("CreateRoleRewardCell")
UIViewControllerRolesList = class("UIViewControllerRolesList", BaseView)
UIViewControllerRolesList.ViewType = UIViewType.MainLayer
local tempTable = {}
local afkMsgTable = {}

function UIViewControllerRolesList:Init()
  Buglylog("UIViewControllerRolesList:Init")
  self.waitEnterBord = WaitEnterBord.new(self:FindGO("WaitEnterBord"))
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:RegisterAreaDragEvent()
  self:CloseDeleteConfirm()
  self:CloseCancelDeleteConfirm()
  self:GetModel()
  self:LoadView()
  self:Listen()
  self.leftOpt = 0
  self.rightOpt = 0
  self.leftMax = 3
  self.rightMax = 4
  self.rightUp = self:FindGO("rightUp", self.gameObject)
  self.leftDown = self:FindGO("leftDown", self.gameObject)
  if self.rightUp then
    self:AddClickEvent(self.rightUp, function()
      helplog("self:rightUp")
      self:checkShow(1)
    end)
  else
    redlog("Missing rightUp!!!")
  end
  if self.leftDown then
    self:AddClickEvent(self.leftDown, function()
      helplog("self:leftDown")
      self:checkShow(2)
    end)
  else
    redlog("Missing leftDown!!!")
  end
  self:InitAfk()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function UIViewControllerRolesList:InitAfk()
  self.msgNode = self:FindGO("MsgNode")
  self.afkScrollView = self:FindGO("MsgScrollView", self.msgNode):GetComponent(UIScrollView)
  local afkTable = self:FindGO("Table", self.afkScrollGO):GetComponent(UITable)
  self.afkListCtrl = UIGridListCtrl.new(afkTable, UIViewRolesListMsgCell, "UIViewRolesListMsgCell")
  local afkProxy = AfkProxy.Instance
  self.msgNode:SetActive(afkProxy.isAfk)
  if afkProxy.isAfk and afkProxy.lastAfkRewardData then
    self:OnRecvAfkStatData(afkProxy.lastAfkRewardData)
  end
  if afkProxy:IsAfkEnabled() then
    self:AddListenEvt(AfkEvent.SyncAfkStatus, self.OnRecvAfkStatData)
    AfkProxy.Instance:StartQueryAfkStatus()
  end
end

function UIViewControllerRolesList:QueryAfkData()
  AfkProxy.Instance:CallQueryAfkStatUserCmd()
end

function UIViewControllerRolesList:OnRecvAfkStatData(data)
  local afkProxy = AfkProxy.Instance
  if not afkProxy.isAfk then
    self.msgNode:SetActive(false)
  else
    if not afkMsgTable then
      afkMsgTable = {}
    else
      TableUtility.ArrayClear(afkMsgTable)
    end
    local result = afkProxy:GetAfkMsgArray(afkMsgTable, data)
    if result == true then
      self.msgNode:SetActive(true)
      self.afkListCtrl:ResetDatas(afkMsgTable)
      self.afkScrollView:ResetPosition()
    end
  end
  self:GetModel()
  self:LoadView()
end

function UIViewControllerRolesList:checkShow(option)
  if BranchMgr.IsChina() or BranchMgr.IsTW() then
    return
  end
  if option == 1 then
    self.rightOpt = self.rightOpt + 1
  elseif option == 2 then
    self.leftOpt = self.leftOpt + 1
  end
  if self.rightOpt == self.rightMax and self.leftOpt == self.leftMax then
    if PlayerPrefs.GetString("TestForce") ~= "1" then
      UIUtil.PopUpConfirmYesNoView("提示", "是否强制设为中文", function()
        PlayerPrefs.SetString("TestForce", "1")
        Game.Me():BackToLogo()
      end, function()
      end, nil, "是的", "不要")
    else
      UIUtil.PopUpConfirmYesNoView("提示", "已经强制中文，是否解锁", function()
        PlayerPrefs.DeleteKey("TestForce")
        Game.Me():BackToLogo()
      end, function()
      end, nil, "是的", "不要")
    end
  end
end

function UIViewControllerRolesList:OnEnter()
  UIViewControllerRolesList.super.OnEnter(self)
  local rolesInfo = MyselfProxy.Instance:GetUserRolesInfo()
  if rolesInfo == nil then
    return
  end
  if rolesInfo.deletechar then
    MsgManager.ShowMsgByID(1066)
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    if self.goDeleteConfirm.gameObject.activeInHierarchy then
      self.goDeleteConfirm:SetActive(false)
    elseif self.goCancelDeleteConfirm.gameObject.activeInHierarchy then
      self.goCancelDeleteConfirm:SetActive(false)
    else
      local callback = UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback()
      callback()
    end
  end)
  PictureManager.Instance:SetUI("login_bg_title", self.txMerchantTitle2)
end

function UIViewControllerRolesList:OnDestroy()
  RoleReadyForLogin.Ins():Reset()
  UIViewControllerRolesList.super.OnDestroy(self)
  TimeTickManager.Me():ClearTick(self)
end

function UIViewControllerRolesList:OnExit()
  Buglylog("UIViewControllerRolesList:OnExit")
  UIViewControllerRolesList.super.OnExit(self)
  self.isDestroyed = true
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  self.waitEnterBord:OnDestroy()
  self.waitEnterBord = nil
  AfkProxy.Instance:StopQueryAfkStatus()
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadUI("login_bg_title", self.txMerchantTitle2)
end

function UIViewControllerRolesList:GetGameObjects()
  self.goButtonStartGame = self:FindGO("ButtonStartGame", self.gameObject)
  self.bcButtonStartGame = self.goButtonStartGame:GetComponent(BoxCollider)
  self.goTitleOfButtonStartGame = self:FindGO("Title", self.goButtonStartGame)
  self.labTitleOfButtoNStartGame = self.goTitleOfButtonStartGame:GetComponent(UILabel)
  self.goNormalOfButtonStartGame = self:FindGO("Normal", self.goButtonStartGame)
  self.spNormalOfButtonStartGame = self.goNormalOfButtonStartGame:GetComponent(UISprite)
  self.goButtonCancelDelete = self:FindGO("ButtonCancelDelete", self.gameObject)
  self.goButtonBack = self:FindGO("ButtonBack", self.gameObject)
  self.goRolesList = self:FindGO("RolesList", self.gameObject)
  self.goMask = self:FindGO("Mask", self.gameObject)
  self.spMask = self.goMask:GetComponent(UISprite)
  self.goRoleDetail = self:FindGO("RoleDetail", self.gameObject)
  self.goIcon = self:FindGO("Icon", self.goRoleDetail)
  self.goProfessionIcon = self:FindGO("ProfessionIcon", self.goIcon)
  self.spProfessionIcon = self.goProfessionIcon:GetComponent(UISprite)
  self.goName = self:FindGO("Name", self.goRoleDetail)
  self.labName = self.goName:GetComponent(UILabel)
  self.goButtonDelete = self:FindGO("ButtonDelete", self.gameObject)
  self.goBCForDrag = self:FindGO("BCForDrag", self.gameObject)
  self.goDeleteConfirm = self:FindGO("DeleteConfirm", self.gameObject)
  self.goInputField = self:FindGO("InputField", self.goDeleteConfirm)
  self.inputField = self.goInputField:GetComponent(UIInput)
  self.goCancelDeleteConfirm = self:FindGO("CancelDeleteConfirm", self.gameObject)
  self.goRoleDetailOfDeleteConfirm = self:FindGO("RoleDetail", self.goDeleteConfirm)
  self.labRoleDetailOfDeleteConfirm = self.goRoleDetailOfDeleteConfirm:GetComponent(UILabel)
  self.goRoleDetailOfCancelDeleteConfirm = self:FindGO("RoleDetail", self.goCancelDeleteConfirm)
  self.labRoleDetailOfCancelDeleteConfirm = self.goRoleDetailOfCancelDeleteConfirm:GetComponent(UILabel)
  self.goButtonYesOfDeleteConfirm = self:FindGO("ButtonYes", self.goDeleteConfirm)
  self.goButtonNoOfDeleteConfirm = self:FindGO("ButtonNo", self.goDeleteConfirm)
  self.goButtonYesOfCancelDeleteConfirm = self:FindGO("ButtonYes", self.goCancelDeleteConfirm)
  self.goButtonNoOfCancelDeleteConfirm = self:FindGO("ButtonNo", self.goCancelDeleteConfirm)
  self.preCreatePart = self:FindGO("PreCreate")
  self.labServerName = self:FindGO("ServerName"):GetComponent(UILabel)
  self.labOpenTime = self:FindGO("OpenTimeLabel"):GetComponent(UILabel)
  self.svReward = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.gridReward = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(self.gridReward, CreateRoleRewardCell, "RewardGridCell")
  self.itemGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.labTip1 = self:FindGO("Tip1"):GetComponent(UILabel)
  self.labTimeLeft = self:FindGO("TimeLeftLabel"):GetComponent(UILabel)
  self.txMerchantTitle2 = self:FindGO("Merchant_bg_title2"):GetComponent(UITexture)
  self:RegisterChildPopObj(self.goDeleteConfirm)
end

function UIViewControllerRolesList:GetModel()
  if self.roles ~= nil then
    TableUtility.ArrayClear(self.roles)
  end
  if self.roles == nil then
    self.roles = {}
  end
  local afkProxy = AfkProxy.Instance
  local rolesInfo = ServiceUserProxy.Instance:GetAllRoleInfos()
  for _, v in pairs(rolesInfo) do
    local roleInfo = v
    local copyRoleInfo = {}
    copyRoleInfo.id = roleInfo.id
    copyRoleInfo.baselv = roleInfo.baselv
    copyRoleInfo.hair = roleInfo.hair
    copyRoleInfo.haircolor = roleInfo.haircolor
    copyRoleInfo.lefthand = roleInfo.lefthand
    copyRoleInfo.righthand = roleInfo.righthand
    copyRoleInfo.body = roleInfo.body
    copyRoleInfo.clothcolor = roleInfo.clothcolor
    copyRoleInfo.head = roleInfo.head
    copyRoleInfo.back = roleInfo.back
    copyRoleInfo.face = roleInfo.face
    copyRoleInfo.tail = roleInfo.tail
    copyRoleInfo.mount = roleInfo.mount
    copyRoleInfo.eye = roleInfo.eye
    copyRoleInfo.partnerid = roleInfo.partnerid
    copyRoleInfo.gender = roleInfo.gender
    copyRoleInfo.profession = roleInfo.profession
    copyRoleInfo.name = roleInfo.name
    copyRoleInfo.sequence = roleInfo.sequence
    copyRoleInfo.isopen = roleInfo.isopen
    copyRoleInfo.deletetime = roleInfo.deletetime
    copyRoleInfo.delete_marks = roleInfo.delete_marks
    table.insert(self.roles, copyRoleInfo)
    if BranchMgr.IsJapan() then
      break
    end
  end
end

function UIViewControllerRolesList:GetRoleInfoFromID(roleID)
  local roleInfo
  for _, v in pairs(self.roles) do
    roleInfo = v
    if roleInfo.id == roleID then
      break
    end
  end
  roleInfo.name = AppendSpace2Str(roleInfo.name)
  return roleInfo
end

function UIViewControllerRolesList:LoadView()
  if self.uiGridListCtrl == nil then
    local uiGrid = self.goRolesList:GetComponent(UIGrid)
    self.uiGridListCtrl = UIGridListCtrl.new(uiGrid, UIListItemViewControllerRoleSlot, "UIListItemViewRoleSlot")
  end
  for k, v in pairs(self.roles) do
    if v then
      local roleInfo = v
      local index = roleInfo.sequence
      local isLock = false
      if roleInfo.id > 0 then
        isLock = false
      else
        isLock = roleInfo.isopen == 0
      end
      tempTable[index] = {
        roleID = roleInfo.id,
        lock = isLock,
        index = index,
        deletetime = roleInfo.deletetime
      }
    end
  end
  self.uiGridListCtrl:ResetDatas(tempTable)
  TableUtility.TableClear(tempTable)
  if self.listItemsViewController == nil then
    self.listItemsViewController = self.uiGridListCtrl:GetCells()
  end
  self:CancelAllSelectedIcon()
  if self:IsHaveAnyRole() then
    local isSelectHistory = false
    local selectedRole = UIModelRolesList.Ins():GetSelectedRole()
    if 0 < selectedRole and self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
      for _, v in pairs(self.listItemsViewController) do
        local itemViewController = v
        if itemViewController.roleID == selectedRole then
          if itemViewController:IsNormal() then
            self:SelectNormal(selectedRole)
            isSelectHistory = true
          end
          break
        end
      end
    end
    if not isSelectHistory then
      self:SelectDefaultNormal()
    end
  else
    self:SelectFirst()
  end
  if self.goDeleteConfirm.activeSelf == true and self.selectedRoleID ~= nil and 0 < self.selectedRoleID then
    self:OpenDeleteConfirm(self.selectedRoleID)
  end
  if self.goCancelDeleteConfirm.activeSelf == true and self.willCancelDeleteRoleID ~= nil and 0 < self.willCancelDeleteRoleID then
    self:OpenCancelDeleteConfirm(self.willCancelDeleteRoleID)
  end
  self:RefreshPreCreatePart()
  ServiceLoginUserCmdProxy.Instance:OfflineDetect_SendLoginEvents()
end

function UIViewControllerRolesList:RefreshPreCreatePart()
  local serverData = FunctionLogin.Me():getCurServerData()
  local openTime = serverData.opentime or 0
  local loginData = FunctionLogin.Me():getLoginData()
  local flag = loginData ~= nil and loginData.flag or 0
  local curTime = ServerTime and ServerTime.CurServerTime() or 0
  if openTime == 0 or openTime < curTime / 1000 then
    self.preCreatePart:SetActive(false)
    self.labTimeLeft.gameObject:SetActive(false)
    self.bcButtonStartGame.enabled = true
    self:SetTextureWhite(self.goButtonStartGame, LuaColor(0.10196078431372549, 0.3333333333333333, 0.7450980392156863))
  else
    self.preCreatePart:SetActive(true)
    self.labTimeLeft.gameObject:SetActive(true)
    self.labServerName.text = serverData.name
    local openStr = GameConfig.System and GameConfig.System.preregistration_opentime
    local serverID = serverData ~= nil and serverData.linegroup or 1
    openStr = openStr and openStr[serverID]
    if openStr and openStr ~= "" then
      self.labOpenTime.text = openStr
    else
      local startTime = os.date(ZhString.StartGamePanel_OpenTime, openTime)
      self.labOpenTime.text = startTime
    end
    local preRegisterTipStr = GameConfig.System and GameConfig.System.preregistration_tip
    if preRegisterTipStr and preRegisterTipStr ~= "" then
      self.labTip1.text = preRegisterTipStr
    else
      self.labTip1.text = ZhString.LoginRole_PreRegisterRewardTip
    end
    local rewardConfig = GameConfig.System.preregistration_reward
    if rewardConfig and 0 < #rewardConfig then
      local rewardList = {}
      for i = 1, #rewardConfig do
        local reward = rewardConfig[i]
        table.insert(rewardList, {
          id = reward[1],
          num = reward[2]
        })
      end
      self.itemGridCtrl:ResetDatas(rewardList)
    end
    self.endTimeStamp = openTime
    TimeTickManager.Me():ClearTick(self)
    TimeTickManager.Me():CreateTick(0, 1000, self.CoundDownServerOpen, self, 1)
    if flag == 1 then
      self.bcButtonStartGame.enabled = true
      self:SetTextureWhite(self.goButtonStartGame, LuaColor(0.10196078431372549, 0.3333333333333333, 0.7450980392156863))
    end
  end
end

function UIViewControllerRolesList:CoundDownServerOpen()
  if not self.endTimeStamp then
    return
  end
  local curTime = ServerTime.CurServerTime()
  if not curTime or curTime == 0 then
    return
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if leftDay <= 0 and leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    self.labTimeLeft.gameObject:SetActive(false)
    self.bcButtonStartGame.enabled = true
    self:SetTextureWhite(self.goButtonStartGame, LuaColor(0.10196078431372549, 0.3333333333333333, 0.7450980392156863))
  else
    self.labTimeLeft.text = string.format(ZhString.StartGamePanel_TimeLeft, leftDay, leftHour, leftMin, leftSec)
  end
end

function UIViewControllerRolesList:OpenDeleteConfirm(roleID)
  local roleInfo = self:GetRoleInfoFromID(roleID)
  if roleInfo then
    self.goDeleteConfirm:SetActive(true)
    local professionName = ProfessionProxy.GetProfessionNameFromSocialData(roleInfo)
    self.labRoleDetailOfDeleteConfirm.text = roleInfo.name .. "  " .. ZhString.MonsterTip_Characteristic_Level .. roleInfo.baselv .. "   " .. professionName
  end
end

function UIViewControllerRolesList:CloseDeleteConfirm()
  self.inputField.value = ""
  self.goDeleteConfirm:SetActive(false)
end

function UIViewControllerRolesList:OpenCancelDeleteConfirm(roleID)
  local roleInfo = self:GetRoleInfoFromID(roleID)
  if roleInfo then
    self.goCancelDeleteConfirm:SetActive(true)
    local professionName = ProfessionProxy.GetProfessionNameFromSocialData(roleInfo)
    self.labRoleDetailOfCancelDeleteConfirm.text = roleInfo.name .. "  " .. ZhString.MonsterTip_Characteristic_Level .. roleInfo.baselv .. "   " .. professionName
  end
end

function UIViewControllerRolesList:CloseCancelDeleteConfirm()
  self.goCancelDeleteConfirm:SetActive(false)
end

function UIViewControllerRolesList:Close()
  self:CancelListen()
  if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      itemViewController:CloseMyTick()
    end
  end
  UIViewControllerRolesList.super.CloseSelf(self)
end

function UIViewControllerRolesList:SelectDefaultNormal()
  if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      if itemViewController:IsNormal() then
        itemViewController:SetSelected()
        self:DoSelectNormal(itemViewController.roleID)
        break
      end
    end
  end
end

function UIViewControllerRolesList:SelectNormal(roleID)
  if 0 < roleID and self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      if itemViewController.roleID == roleID then
        itemViewController:SetSelected()
        self:DoSelectNormal(roleID)
        break
      end
    end
  end
end

function UIViewControllerRolesList:DoSelectNormal(roleID)
  self.goButtonStartGame:SetActive(true)
  self.goButtonCancelDelete:SetActive(false)
  self.labTitleOfButtoNStartGame.text = ZhString.LoginRole_LoginRole
  local roleInfo = self:GetRoleInfoFromID(roleID)
  if roleInfo ~= nil then
    self.labName.text = roleInfo.name
    local professionConf = Table_Class[tonumber(roleInfo.profession)]
    if professionConf ~= nil then
      IconManager:SetNewProfessionIcon(professionConf.icon, self.spProfessionIcon)
    end
  end
  self.goRoleDetail:SetActive(true)
  self.goButtonDelete:SetActive(not BranchMgr.IsJapan())
  self.selectedRoleID = roleID
  self.willCreateRoleSlotIndex = nil
  self.willCancelDeleteRoleID = nil
  RoleReadyForLogin.Ins():Iam(roleID)
  local serverData = FunctionLogin.Me():getCurServerData()
  local openTime = serverData.opentime or 0
  local loginData = FunctionLogin.Me():getLoginData()
  local flag = loginData ~= nil and loginData.flag or 0
  local curTime = ServerTime and ServerTime.CurServerTime() or 0
  if openTime == 0 or openTime < curTime / 1000 then
    self.bcButtonStartGame.enabled = true
    self.labTimeLeft.gameObject:SetActive(false)
    self:SetTextureWhite(self.goButtonStartGame, LuaColor(0.10196078431372549, 0.3333333333333333, 0.7450980392156863))
  elseif flag ~= 1 then
    self.bcButtonStartGame.enabled = false
    self:SetTextureGrey(self.goButtonStartGame, LuaColor.grey)
  end
end

function UIViewControllerRolesList:SelectEmpty(index)
  if 0 < index then
    if self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
      for _, v in pairs(self.listItemsViewController) do
        local itemViewController = v
        if itemViewController.index == index then
          itemViewController:SetSelected()
          break
        end
      end
    end
    self.willCreateRoleSlotIndex = index
    self.selectedRoleID = nil
    self.willCancelDeleteRoleID = nil
    self.goRoleDetail:SetActive(false)
    self.goButtonStartGame:SetActive(true)
    self.goButtonCancelDelete:SetActive(false)
    self.labTitleOfButtoNStartGame.text = ZhString.LoginRole_CreateRole
    RoleReadyForLogin.Ins():Hide()
    UIModelRolesList.Ins():SetEmptyIndex(index)
    self.bcButtonStartGame.enabled = true
    self:SetTextureWhite(self.goButtonStartGame, LuaColor(0.10196078431372549, 0.3333333333333333, 0.7450980392156863))
  end
end

function UIViewControllerRolesList:SelectDelete(roleID)
  if 0 < roleID and self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      if itemViewController.roleID == roleID then
        itemViewController:SetSelected()
        self:DoSetDelete(roleID)
        break
      end
    end
  end
end

function UIViewControllerRolesList:DoSetDelete(roleID)
  self.goButtonStartGame:SetActive(false)
  self.goButtonCancelDelete:SetActive(true)
  local roleInfo = self:GetRoleInfoFromID(roleID)
  if roleInfo ~= nil then
    self.labName.text = roleInfo.name
    local professionConf = Table_Class[tonumber(roleInfo.profession)]
    if professionConf ~= nil then
      self.spProfessionIcon.spriteName = professionConf.icon
    end
  end
  self.goRoleDetail:SetActive(true)
  self.goButtonDelete:SetActive(false)
  self.willCancelDeleteRoleID = roleID
  self.willCreateRoleSlotIndex = nil
  self.selectedRoleID = nil
  RoleReadyForLogin.Ins():Iam(roleID)
end

function UIViewControllerRolesList:SelectFirst()
  if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
    local firstItemViewController = self.listItemsViewController[1]
    if firstItemViewController:IsNormal() then
      self:SelectNormal(firstItemViewController.roleID)
    elseif firstItemViewController:IsEmpty() then
      self:SelectEmpty(1)
    elseif firstItemViewController:IsDelete() then
      self:SelectDelete(firstItemViewController.roleID)
    end
  end
end

function UIViewControllerRolesList:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonStartGame, function()
    self:OnClickForButtonLogin()
  end, {hideClickSound = true})
  self:AddClickEvent(self.goButtonCancelDelete, function()
    self:OnClickForButtonLogin()
  end, {hideClickSound = true})
  self:AddClickEvent(self.goButtonBack, function()
    self:OnClickForButtonBack()
  end)
  self:AddClickEvent(self.goButtonDelete, function()
    self:OnClickForButtonDelete()
  end)
  self:AddClickEvent(self.goButtonYesOfDeleteConfirm, function()
    self:OnClickForButtonYesOfDeleteConfirm()
  end)
  self:AddClickEvent(self.goButtonNoOfDeleteConfirm, function()
    self:OnClickForButtonNoOfDeleteConfirm()
  end)
  self:AddClickEvent(self.goButtonYesOfCancelDeleteConfirm, function()
    self:OnClickForButtonYesOfCancelDeleteConfirm()
  end)
  self:AddClickEvent(self.goButtonNoOfCancelDeleteConfirm, function()
    self:OnClickForButtonNoOfCancelDeleteConfirm()
  end)
end

local chooseMainRole_ConfirmMsgids = GameConfig.System.chooseMainRole_ConfirmMsgids

function UIViewControllerRolesList:ChooseMainRoleConfirm(checkPoint, callBack, callBackParam)
  local roleInfo = self:GetRoleInfoFromID(self.selectedRoleID)
  if self.selectedRoleID == nil or roleInfo == nil then
    callBack(callBackParam)
    return
  end
  if chooseMainRole_ConfirmMsgids == nil then
    callBack(callBackParam)
    return
  end
  if checkPoint > #chooseMainRole_ConfirmMsgids then
    callBack(callBackParam)
    return
  end
  local msgId = chooseMainRole_ConfirmMsgids[checkPoint]
  MsgManager.ConfirmMsgByID(msgId, function()
    self:ChooseMainRoleConfirm(checkPoint + 1, callBack, callBackParam)
  end, nil, nil, self:GetMsgParam(msgId))
end

function UIViewControllerRolesList:GetMsgParam(msgid)
  if msgid == 25415 then
    local roleInfo = self:GetRoleInfoFromID(self.selectedRoleID)
    if roleInfo == nil then
      return
    end
    local baselv = roleInfo.baselv
    local professionName = ProfessionProxy.GetProfessionNameFromSocialData(roleInfo)
    return baselv, professionName
  end
end

function UIViewControllerRolesList:addLoadingAnim()
  local loadingAni = self:FindGO("UILoadingAni", self.gameObject)
  if loadingAni then
    loadingAni:SetActive(true)
  end
end

function UIViewControllerRolesList:DoLoginSelectedRole()
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    local selectRoleinfo = self:GetRoleInfoFromID(self.selectedRoleID)
    if selectRoleinfo ~= nil and selectRoleinfo.isban == true then
      MsgManager.ConfirmMsgByID(1038)
      return
    end
  end
  UIBlackScreen.DoFadeIn(self.spMask, 1, function()
    ResourceManager.Instance.IsAsyncLoadOn = true
    redlog("ResourceManager.Instance.IsAsyncLoadOn =======3======= " .. tostring(ResourceManager.Instance.IsAsyncLoadOn))
    self:addLoadingAnim()
    LoginRoleSelector.Ins():HideSceneAndRoles()
    LoginRoleSelector:Ins():Reset()
    ServiceUserProxy.Instance:CallSelect(self.selectedRoleID)
    self.waitEnterBord:Active(true)
    if BranchMgr.IsTW() then
      local server = FunctionLogin.Me():getCurServerData()
      local serverID = server ~= nil and server.serverid or 1
      WeGameHelper:trackCreatRole(serverID, ServiceUserProxy.Instance:GetRoleInfo().baselv)
    end
  end)
end

function UIViewControllerRolesList:OnClickForButtonLogin()
  if self.selectedRoleID ~= nil and self.selectedRoleID > 0 then
    local afkProxy = AfkProxy.Instance
    if afkProxy.isAfk and not afkProxy.hasQuitAfk then
      MsgManager.ConfirmMsgByID(41149, function()
        afkProxy:SetAfk(false)
        self:DoLoginSelectedRole()
        ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(214)
      end)
    else
      self:DoLoginSelectedRole()
    end
    ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(211)
  elseif self.willCreateRoleSlotIndex ~= nil and 0 < self.willCreateRoleSlotIndex then
    local cache_willCreateRoleSlotIndex = self.willCreateRoleSlotIndex
    if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion == true then
      GameConfig.CreateRole.UseNewVersion = 1
    end
    if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion and 0 < GameConfig.CreateRole.UseNewVersion then
      UIBlackScreen.DoFadeIn(self.spMask, 1, function()
        self:Close()
        LoginRoleSelector.Ins():GoToNewCreateRole(cache_willCreateRoleSlotIndex)
        LoginRoleSelector.Ins():HideSceneAndRoles()
        LoginRoleSelector.Ins():Reset()
        if Game.PerformanceManager then
          Game.PerformanceManager:SkinWeightHigh(true)
        end
      end)
    else
      UIBlackScreen.DoFadeIn(self.spMask, 1, function()
        self:Close()
        LoginRoleSelector.Ins():GoToCreateRole(cache_willCreateRoleSlotIndex)
        LoginRoleSelector.Ins():HideSceneAndRoles()
        LoginRoleSelector.Ins():Reset()
      end)
    end
    ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(212)
  elseif self.willCancelDeleteRoleID ~= nil and 0 < self.willCancelDeleteRoleID then
    self:OpenCancelDeleteConfirm(self.willCancelDeleteRoleID)
  end
end

function UIViewControllerRolesList:GoToNewCreateRole()
  UIBlackScreen.DoFadeIn(self.spMask, 1, function()
    self:Close()
    LoginRoleSelector.Ins():GoToNewCreateRole(self.willCreateRoleSlotIndex)
    LoginRoleSelector.Ins():HideSceneAndRoles()
    LoginRoleSelector.Ins():Reset()
  end)
end

function UIViewControllerRolesList:OnClickForButtonBack()
  AfkProxy.Instance:SetAfk(false)
  self:Close()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "StartGamePanel"
  })
  LoginRoleSelector.Ins():HideSceneAndRoles()
end

function UIViewControllerRolesList:OnClickForButtonDelete()
  local roleID = self:AnyRoleBeingDelete()
  if 0 < roleID then
    local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
    local nameOfRoleBeingDelete = roleDetail.name
    local deleteLeftHour, deleteLeftMinute, deleteLeftSecond
    if self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
      for _, v in pairs(self.listItemsViewController) do
        local itemViewController = v
        if itemViewController.roleID == roleID then
          deleteLeftHour = itemViewController.leftHour
          deleteLeftMinute = itemViewController.leftMinutes
          deleteLeftSecond = itemViewController.leftSeconds
          break
        end
      end
    end
    local strDeleteLeftTime = ""
    if 1 <= deleteLeftHour then
      strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.HoursFormat, deleteLeftHour)
      strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.MinutesFormat, deleteLeftMinute)
    else
      strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.MinutesFormat, deleteLeftMinute)
      strDeleteLeftTime = strDeleteLeftTime .. string.format(ZhString.SecondsFormat, deleteLeftSecond)
    end
    MsgManager.ShowMsgByIDTable(1068, {nameOfRoleBeingDelete, strDeleteLeftTime})
  elseif not UIModelRolesList.Ins():IsRoleDeleteCDComplete() then
    local hours, minutes, seconds = UIModelRolesList.Ins():GetRoleDeleteCDTime()
    if hours ~= nil then
      local strCDTime = ""
      if 1 <= hours then
        strCDTime = strCDTime .. string.format(ZhString.HoursFormat, hours)
        strCDTime = strCDTime .. string.format(ZhString.MinutesFormat, minutes)
      else
        strCDTime = strCDTime .. string.format(ZhString.MinutesFormat, minutes)
        strCDTime = strCDTime .. string.format(ZhString.SecondsFormat, seconds)
      end
      MsgManager.ShowMsgByIDTable(1073, {strCDTime})
    end
  else
    FunctionSecurity.Me():DeleteFriend(function()
      if self.selectedRoleID ~= nil and self.selectedRoleID > 0 then
        local roleInfo = self:GetRoleInfoFromID(self.selectedRoleID)
        local deleteMarks = roleInfo.delete_marks
        if bit.band(deleteMarks, EDELETECHARMARK.EDELETECHARMARK_PACKAGE) ~= 0 then
          MsgManager.ConfirmMsgByID(41140, function()
            self:OpenDeleteConfirm(self.selectedRoleID)
          end)
        else
          self:OpenDeleteConfirm(self.selectedRoleID)
        end
      end
    end)
  end
end

function UIViewControllerRolesList:OnClickForButtonYesOfDeleteConfirm()
  if self.inputField.value == "" then
    MsgManager.ShowMsgByID(1070)
  elseif self.inputField.value == "DELETE" then
    self:RequestDeleteRole(self.selectedRoleID)
    self.flagRequestDeleteRole = true
    self:CloseDeleteConfirm()
  else
    self.inputField.label.color = ColorUtil.Red
  end
end

function UIViewControllerRolesList:OnClickForButtonNoOfDeleteConfirm()
  self:CloseDeleteConfirm()
end

function UIViewControllerRolesList:OnClickForButtonYesOfCancelDeleteConfirm()
  self:RequestCancelDeleteRole(self.willCancelDeleteRoleID)
  self:CloseCancelDeleteConfirm()
  if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      if itemViewController.roleID == self.willCancelDeleteRoleID then
        itemViewController:CloseMyTick()
        break
      end
    end
  end
end

function UIViewControllerRolesList:OnClickForButtonNoOfCancelDeleteConfirm()
  self:CloseCancelDeleteConfirm()
end

function UIViewControllerRolesList:RegisterAreaDragEvent()
  self:AddDragEvent(self.goBCForDrag, function(go, delta)
    self:OnDrag(go, delta)
  end)
end

function UIViewControllerRolesList:OnDrag(go, delta)
  local deltaAngle = -delta.x * 360 / 400
  RoleReadyForLogin.Ins():RotateDelta(deltaAngle)
end

function UIViewControllerRolesList:Listen()
  EventManager.Me():AddEventListener(LoginRoleEvent.UIRoleBeSelected, self.OnRolesListItemBeSelected, self)
  self:ListenServerResponse()
end

function UIViewControllerRolesList:RequestDeleteRole(roleID)
  ServiceLoginUserCmdProxy.Instance:CallDeleteCharUserCmd(roleID)
end

function UIViewControllerRolesList:RequestCancelDeleteRole(roleID)
  ServiceLoginUserCmdProxy.Instance:CallCancelDeleteCharUserCmd(roleID)
end

function UIViewControllerRolesList:ListenServerResponse()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.OnMapChange)
  self:AddListenEvt(ServiceEvent.LoginUserCmdSnapShotUserCmd, self.OnReceiveRolesInfoUpdate)
  self:AddListenEvt(XDEUIEvent.RoleBack, self.OnClickForButtonBack)
end

function UIViewControllerRolesList:CancelListen()
  EventManager.Me():RemoveEventListener(LoginRoleEvent.UIRoleBeSelected, self.OnRolesListItemBeSelected, self)
end

function UIViewControllerRolesList:OnMapChange()
  UIModelRolesList.Ins():SetSelectedRole(self.selectedRoleID)
  self:Close()
  FrameRateSpeedUpChecker.Instance():Open()
end

function UIViewControllerRolesList:OnRolesListItemBeSelected(content)
  if self.isDestroyed then
    return
  end
  local itemViewController = content
  if itemViewController:IsNormal() then
    if not itemViewController.isSelected then
      self:CancelAllSelectedIcon()
    end
    self:SelectNormal(itemViewController.roleID)
  elseif itemViewController:IsEmpty() then
    if not itemViewController.isSelected then
      self:CancelAllSelectedIcon()
    end
    self:SelectEmpty(itemViewController.index)
  elseif itemViewController:IsLock() then
    MsgManager.ShowMsgByID(1065)
  elseif itemViewController:IsDelete() then
    if not itemViewController.isSelected then
      self:CancelAllSelectedIcon()
    end
    self:SelectDelete(itemViewController.roleID)
  end
end

function UIViewControllerRolesList:OnReceiveRolesInfoUpdate(content)
  if self.flagRequestDeleteRole == true and self:AnyRoleBeingDelete() then
    local deleteNeedTime = UIModelRolesList.Ins():GetRoleDeleteNeedTime(self.selectedRoleID)
    if 0 < deleteNeedTime then
      MsgManager.ShowMsgByID(1071)
    end
    self.flagRequestDeleteRole = false
  end
  if content.body.deletechar then
    MsgManager.ShowMsgByID(1066)
  end
  self:GetModel()
  self:LoadView()
end

function UIViewControllerRolesList:IsHaveAnyRole()
  if self.roles ~= nil then
    for _, v in pairs(self.roles) do
      local roleInfo = v
      if roleInfo.id > 0 and roleInfo.deletetime == 0 then
        return true
      end
    end
  end
  return false
end

function UIViewControllerRolesList:CancelAllSelectedIcon()
  if self.listItemsViewController ~= nil then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController1 = v
      if itemViewController1.isSelected then
        itemViewController1:CancelSelected()
      end
    end
  end
end

function UIViewControllerRolesList:AnyRoleBeingDelete()
  local roleID = 0
  if self.listItemsViewController ~= nil and 0 < #self.listItemsViewController then
    for _, v in pairs(self.listItemsViewController) do
      local itemViewController = v
      if itemViewController:IsDelete() then
        roleID = itemViewController.roleID
        break
      end
    end
  end
  return roleID
end

function UIViewControllerRolesList:HandleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0}, false)
  end
end
