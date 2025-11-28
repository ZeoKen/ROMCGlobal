local baseCell = autoImport("BaseCell")
PetHouseCell = class("PetHouseCell", baseCell)
autoImport("SceneEmojiCell")
local FIXED_BG_TEX = "Bg_beijing"
local FIXED_UNLOCK_TEX = "PetRoom_bg2"
local PET_ACTIONS = {
  [1] = {
    action = "wait",
    duringTime = {5, 15}
  },
  [2] = {
    action = "eat",
    emoji = "Emoji_happy",
    duringTime = {5, 15}
  }
}
local ActionState = {
  None = 0,
  Idle = 1,
  Eat = 2
}
local NextState = {}
NextState[ActionState.Idle] = ActionState.Eat
NextState[ActionState.Eat] = ActionState.Idle

function PetHouseCell:Init()
  self:FindObjs()
  self:AddEvts()
  PictureManager.Instance:SetPetRenderTexture(FIXED_BG_TEX, self.bgTexture)
  PictureManager.Instance:SetUI(FIXED_UNLOCK_TEX, self.unlockTexture)
  self.petActionCFG = GameConfig.Home.PetHouse_PetAction or PET_ACTIONS
  self:InitPetActionCalls()
end

function PetHouseCell:InitPetActionCalls()
  self.calls = {}
  self.calls[ActionState.Idle] = self._HandleIdle
  self.calls[ActionState.Eat] = self._HandleEat
end

function PetHouseCell:_HandleIdle(actionState)
  local config = self.petActionCFG[1]
  if config.action then
    self:_SetPetState(actionState, math.random(config.duringTime[1], config.duringTime[2]))
    self.modelAssetRole:PlayAction_Simple(config.action)
  end
end

function PetHouseCell:_HandleEat(actionState)
  local config = self.petActionCFG[2]
  if config.action then
    self:_SetPetState(actionState, math.random(config.duringTime[1], config.duringTime[2]))
    self.modelAssetRole:PlayAction_Simple(config.action)
    if not StringUtil.IsEmpty(config.emoji) then
      self:PlayEmoji(config.emoji)
    end
  end
end

function PetHouseCell:_SetPetState(state, duration)
  local data = {}
  data[1] = state
  data[2] = duration
  self.PetStates = data
end

function PetHouseCell:UpdateState(actionState)
  local call = self.calls[actionState]
  if call then
    call(self, actionState)
  end
end

function PetHouseCell:FindObjs()
  self.name = self:FindComponent("PetName", UILabel)
  self.desc = self:FindComponent("Des", UILabel)
  self.desc.text = ZhString.PetHouseView_Desc
  self.closebuttom = self:FindGO("Close")
  self.lvLab = self:FindComponent("LvValue", UILabel)
  self.friendlvLab = self:FindComponent("FriendlyLvValue", UILabel)
  self.costImg = self:FindComponent("Cost", UISprite)
  self.costNum = self:FindComponent("CostNum", UILabel)
  self.unlockBtn = self:FindGO("UnlockBtn")
  self.unlockLab = self:FindComponent("UnlockLab", UILabel)
  self.unlockLab.text = ZhString.PetHouseView_UnlockContent
  self.petInfo = self:FindGO("PetInfo")
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.unlockTexture = self:FindComponent("UnlockTexture", UITexture)
  self.modelTexture = self:FindComponent("ModelRoot", UITexture)
  self.follow = self:FindGO("Follow")
  self.lvSlider = self:FindComponent("LvSlider", UISlider)
  self.lvSliderLab = self:FindComponent("LvSliderLab", UILabel)
  self.friendlyLvSlider = self:FindComponent("FriendlyLvSlider", UISlider)
  self.friendlyLvSliderLab = self:FindComponent("FriendlyLvSliderLab", UILabel)
end

function PetHouseCell:AddEvts()
  self:AddClickEvent(self.closebuttom, function()
    if BagProxy.Instance:CheckPetBagIsFull() then
      MsgManager.ShowMsgByID(43465)
      return
    end
    local data = self.data
    if data and data:GetCurPetGuid() then
      ServiceHomeCmdProxy.Instance:CallPetFurnitureActionhomeCmd(HomeCmd_pb.EPETFURNITUREACTION_PETOFF, data.index, data:GetCurPetGuid())
    end
  end)
  self:AddClickEvent(self.unlockBtn, function()
    local data = self.data
    if not data then
      return
    end
    if data.cost == GameConfig.MoneyId.Zeny then
      if MyselfProxy.Instance:GetROB() < data.costNum then
        MsgManager.ShowMsgByID(1)
        return
      end
    elseif data.cost == GameConfig.MoneyId.Lottery and MyselfProxy.Instance:GetLottery() < data.costNum then
      MsgManager.ShowMsgByID(3634)
      return
    end
    if data then
      ServiceHomeCmdProxy.Instance:CallPetFurnitureActionhomeCmd(HomeCmd_pb.EPETFURNITUREACTION_UNLOCK, data.index)
    end
  end)
end

function PetHouseCell:SetPetModel(eggData)
  local monsterParts = PetEggInfo.GetPetDessParts(eggData.petid, eggData.equips)
  if self.modelAssetRole then
    self.modelAssetRole:Redress(monsterParts)
    self:SetPetModelCallBack(eggData, monsterParts)
  else
    UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, monsterParts, UIModelCameraTrans.Role, nil, nil, nil, nil, function(obj)
      self.modelAssetRole = obj
      self:SetPetModelCallBack(eggData, monsterParts)
    end)
  end
  Asset_Role.DestroyPartArray(monsterParts)
end

function PetHouseCell:SetPetModelCallBack(eggData, monsterParts)
  self.modelAssetRole:PlayAction_Idle()
  local configSize = Table_Monster[eggData.petid] and Table_Monster[eggData.petid].LoadShowSize or 1
  self.modelAssetRole:SetScale(configSize)
  self:UpdateState(ActionState.Idle)
  self:_StartTimeTick()
end

function PetHouseCell:UnLoadPet()
  self:ClearTick()
  if self.modelAssetRole then
    self.modelAssetRole = nil
    UIModelUtil.Instance:ResetTexture(self.modelTexture)
  end
end

local strFormat = "%s/%s"

function PetHouseCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(nil ~= data)
  if data then
    local myPet = data.petEgg
    self.bgTexture.gameObject:SetActive(true)
    if data.unlock == false then
      self:Show(self.unlockBtn)
      self:Hide(self.petInfo)
      self:Hide(self.desc)
      self:Hide(self.closebuttom)
      if data.cost and data.costNum then
        IconManager:SetItemIcon(Table_Item[data.cost].Icon, self.costImg)
        self.costNum.text = data.costNum
      end
      self:UnLoadPet()
    elseif nil ~= myPet then
      self:Show(self.petInfo)
      self:Show(self.closebuttom)
      self:Hide(self.unlockBtn)
      self:Hide(self.desc)
      self:SetPetModel(myPet)
      self.bgTexture.gameObject:SetActive(false)
      local exp, uplvExp
      self.friendlyLvSlider.value, exp, uplvExp = myPet:GetPetFriendPercent()
      self.friendlyLvSliderLab.text = exp >= uplvExp and string.format(uplvExp, uplvExp) or string.format(strFormat, exp, uplvExp)
      local nowlvConfig = Table_PetBaseLevel[myPet.lv + 1]
      local curlvConfig = Table_PetBaseLevel[myPet.lv]
      if nowlvConfig then
        self.lvSlider.value = myPet.exp / nowlvConfig.NeedExp_2
        self.lvSliderLab.text = string.format(strFormat, myPet.exp, nowlvConfig.NeedExp_2)
      else
        self.lvSlider.value = 1
        self.lvSliderLab.text = string.format(strFormat, curlvConfig.NeedExp, curlvConfig.NeedExp)
      end
      self.name.text = data:GetPetName()
      self.lvLab.text = data:GetPetLv()
      self.friendlvLab.text = data:GetPetFriendlyLv()
    else
      self:UnLoadPet()
      self:Hide(self.unlockBtn)
      self:Hide(self.closebuttom)
      self:Hide(self.petInfo)
      self:Show(self.desc)
    end
  end
end

local tempVector3 = LuaVector3.Zero()
local tempOffset = LuaGeometry.Const_V3_zero
local cellData = {}

function PetHouseCell:PlayEmoji(emoji)
  self:_DestroyEmoji()
  if self.follow then
    Game.RoleFollowManager:RegisterFollow(self.follow.transform, self.modelAssetRole.complete, tempVector3, tempOffset, RoleDefines_EP.Top, nil, nil, false)
    local path = ResourcePathHelper.Emoji(emoji)
    TableUtility.ArrayClear(cellData)
    cellData[1] = self.follow
    cellData[2] = path
    cellData[3] = 2
    cellData[4] = "animation"
    cellData[5] = 1
    cellData[6] = PetHouseCell._DestroyEmoji
    cellData[7] = self
    self.emoji = SceneEmojiCell.CreateAsArray(cellData)
    self.emoji.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
    self.emoji.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.emoji.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  end
end

local RANDOM = math.random

function PetHouseCell:_Tick(deltaTime)
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local state = self.PetStates
  if state then
    state[2] = state[2] - deltaTime
    if state[2] <= 0 then
      state[2] = 0
      local nextState = NextState[state[1]]
      if nextState then
        self:UpdateState(nextState)
      end
    end
  end
end

function PetHouseCell:_StartTimeTick()
  self:ClearTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 50, self._Tick, self, self.data.index, true)
end

function PetHouseCell:_DestroyEmoji()
  if self.emoji then
    self.emoji:Destroy()
    self.emoji = nil
    if self.follow then
      Game.RoleFollowManager:UnregisterFollow(self.follow.transform)
    end
  end
end

function PetHouseCell:OnCellDestroy()
  self:UnLoadPet()
  self.modelTexture = nil
  PictureManager.Instance:UnloadPetTexture(FIXED_BG_TEX, self.bgTexture)
  PictureManager.Instance:UnLoadUI(FIXED_UNLOCK_TEX, self.unlockTexture)
end

function PetHouseCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
