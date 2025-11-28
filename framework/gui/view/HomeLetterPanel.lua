autoImport("LetterContainerView")
HomeLetterPanel = class("HomeLetterPanel", LetterContainerView)
HomeLetterPanel.ViewType = UIViewType.PopUpLayer
HomeLetterPanel.PartName = "HomeLetter"
local isNil = LuaGameObject.ObjectIsNull

function HomeLetterPanel:InitLetterPart()
  HomeLetterPanel.super.InitLetterPart(self)
  self.letterStamp = self:FindGO("Stamp", self.letter)
  self.letterLabel = self:FindGO("Label", self.letter)
  self.TopTitle_UILabel = self:FindComponent("TopTitle", UILabel, self.letterLabel)
  self.HomeTypeLeft_UILabel = self:FindComponent("HomeType", UILabel, self.letterLabel)
  self.HomeTypeRight_UILabel = self:FindComponent("HomeTypeRight", UILabel, self.letterLabel)
  self.Desc_UILabel = self:FindComponent("Desc", UILabel, self.letterLabel)
  self.Name_UIInput = self:FindComponent("Input1", UIInput, self.letterLabel)
  self.Sign_UIInput = self:FindComponent("Input2", UIInput, self.letterLabel)
  self.Name_UIInput.characterLimit = GameConfig.System.homename_max
  self.Sign_UIInput.characterLimit = GameConfig.System.homesign_max
  self.Name_Collider = self:FindComponent("Input1", BoxCollider, self.letterLabel)
  self.Sign_Collider = self:FindComponent("Input2", BoxCollider, self.letterLabel)
  local housebelongLeft_UILabel = self:FindComponent("housebelong", UILabel, self.letterLabel)
  local housebelongRight_UILabel = self:FindComponent("housebelongRight", UILabel, self.letterLabel)
  housebelongRight_UILabel.text = Game.Myself.data:GetName()
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if myHouseData then
    self.Name_UIInput.value = myHouseData.name
    self.Sign_UIInput.value = myHouseData.sign
  end
  self.stepid = 1
end

function HomeLetterPanel:OnClickConfirmBtn()
  if self:TrySetHomeName() and self:TrySetHomeSign() then
    self:ShowShare()
  end
end

function HomeLetterPanel:OnClickBlackBg()
  if self.stepid > 2 then
    self:CloseSelf()
  end
end

function HomeLetterPanel:OnClickLetterBg()
  if self.stepid == 1 then
    if self.letterEffect then
      self.letterEffect:SetPlaybackSpeed(1)
    end
    self.stepid = 2
    TimeTickManager.Me():CreateOnceDelayTick(self.DrawOutDuration, function(self)
      if not isNil(self.Name_Collider) then
        self.Name_Collider.enabled = true
      end
      if not isNil(self.Sign_Collider) then
        self.Sign_Collider.enabled = true
      end
    end, self)
  end
end

function HomeLetterPanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  HomeLetterPanel.super.OnExit(self)
end

function HomeLetterPanel:TrySetHomeName()
  local name = self.Name_UIInput.value
  if StringUtil.IsEmpty(name) then
    MsgManager.ShowMsgByIDTable(1006)
    self.Name_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.homename_min or length > GameConfig.System.homename_max then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homename_max
    })
    self.Name_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(2604)
    self.Name_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.Name, nil, nil, name)
  return true
end

function HomeLetterPanel:TrySetHomeSign()
  local name = self.Sign_UIInput.value
  if StringUtil.IsEmpty(name) then
    MsgManager.ShowMsgByIDTable(38021)
    self.Sign_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.homesign_min or length > GameConfig.System.homesign_max then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homesign_max
    })
    self.Sign_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(38022)
    self.Sign_UIInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.Sign, nil, nil, name)
  return true
end

function HomeLetterPanel:ShowShare()
  self.confirmbtn:SetActive(false)
  self.share.gameObject:SetActive(BranchMgr.IsChina() == true)
  self.letterStamp:SetActive(true)
  self.letterBgCollider.enabled = false
  self.Name_Collider.enabled = false
  self.Sign_Collider.enabled = false
  self.stepid = 3
end
