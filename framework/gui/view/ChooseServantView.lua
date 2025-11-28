ChooseServantView = class("ChooseServantView", ContainerView)
ChooseServantView.ViewType = UIViewType.PopUpLayer
local _ServantConfig, _PicMgr
local _DecorationTexArray = {
  [1] = "deacon_shafa",
  [2] = "deacon_boli",
  [3] = "deacon_zhuozi",
  [4] = "deacon_bg"
}

function ChooseServantView:FindObj()
  self.confirmRoot = self:FindGO("ConfirmRoot")
  self:RegisterGuideTarget(ClientGuide.TargetType.chooseservantview_confirmbord, self.confirmRoot)
  self.confirmBtn = self:FindGO("ConfirmBtn", self.confirmRoot)
  self:RegisterGuideTarget(ClientGuide.TargetType.chooseservantview_confirmbutton, self.confirmBtn)
  self:AddOrRemoveGuideId(self.confirmBtn, 519)
  local confirmLab = self:FindComponent("Label", UILabel, self.confirmBtn)
  confirmLab.text = ZhString.Push_otherButtonTitles
  self.cancelBtn = self:FindGO("CancelBtn", self.confirmRoot)
  local cancelLab = self:FindComponent("Label", UILabel, self.cancelBtn)
  cancelLab.text = ZhString.Push_cancelButtonTitle
  self.contentLab = self:FindComponent("ContentLab", UILabel, self.confirmRoot)
  self.servantNameLab = self:FindComponent("ServantNameLab", UILabel, self.confirmRoot)
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  local servantRoot = self:FindGO("ServantRoot")
  self.servantTexMap = {}
  local texGo, tex, colider
  for i = 1, #_ServantConfig do
    texGo = self:FindGO("Servant_" .. i, servantRoot)
    tex = texGo:GetComponent(UITexture)
    if tex then
      if self:CanHireServant(i) then
        ColorUtil.WhiteUIWidget(tex)
      else
        ColorUtil.DeepGrayUIWidget(tex)
      end
      _PicMgr:SetUI(_ServantConfig[i].texture, tex)
      self.servantTexMap[i] = tex
      if i == 5 then
        self:RegisterGuideTarget(ClientGuide.TargetType.chooseservantview_servant5, texGo)
      elseif i == 6 then
        self:RegisterGuideTarget(ClientGuide.TargetType.chooseservantview_servant6, texGo)
      end
    end
  end
  local decorationRoot = self:FindGO("DecorationRoot")
  self.decorationTexs = {}
  self.decorationTexs[1] = self:FindComponent("Sofa", UITexture, decorationRoot)
  self.decorationTexs[2] = self:FindComponent("Boli", UITexture, decorationRoot)
  self.decorationTexs[3] = self:FindComponent("Table", UITexture, decorationRoot)
  self.decorationTexs[4] = self:FindComponent("BG", UITexture, decorationRoot)
  for i = 1, #self.decorationTexs do
    _PicMgr:SetUI(_DecorationTexArray[i], self.decorationTexs[i])
  end
  self.initRoot = self:FindComponent("InitRootBg", Transform)
  local readyChooseLab = self:FindComponent("ReadyChooseLab", UILabel, self.initRoot.gameObject)
  readyChooseLab.text = ZhString.ChooseServant_ReadyChoose
end

function ChooseServantView:CanHireServant(index)
  local config = _ServantConfig[index]
  if config.first then
    return true
  end
  return FunctionUnLockFunc.Me():CheckCanOpen(config.menuid)
end

function ChooseServantView:OnExit()
  ChooseServantView.super.OnExit(self)
  self:UnloadTex()
end

function ChooseServantView:UnloadTex()
  for index, v in pairs(self.servantTexMap) do
    _PicMgr:UnLoadUI(_ServantConfig[index].texture, v)
  end
  for i = 1, #self.decorationTexs do
    _PicMgr:UnLoadUI(_DecorationTexArray[i], self.decorationTexs[i])
  end
end

function ChooseServantView:AddEvt()
  self:AddClickEvent(self.confirmBtn, function()
    self:DoChoosed()
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self:OffChoose()
  end)
  self:AddClickEvent(self.decorationTexs[4].gameObject, function()
    self:OffChoose()
  end)
  for i, configMap in pairs(_ServantConfig) do
    self:AddClickEvent(self.servantTexMap[i].gameObject, function()
      self:OnChoose(i)
    end)
  end
  self:AddListenEvt(MyselfEvent.ServantID, self.UpdateServant)
end

function ChooseServantView:OnChoose(index)
  if self.curIndex == index then
    return
  end
  if not self.isChange and not self:CanHireServant(index) then
    return
  end
  if self.curIndex then
    self:_DestroyEffect()
  end
  self.curIndex = index
  self:GrayWidget(true)
  self:_PlayEffect()
  self:Show(self.confirmRoot)
  self:Hide(self.initRoot)
  self:SetServantInfo()
end

function ChooseServantView:GrayWidget(var)
  for k, tex in pairs(self.servantTexMap) do
    if not self:CanHireServant(k) then
      ColorUtil.DeepGrayUIWidget(tex)
    elseif self.curIndex then
      if k ~= self.curIndex then
        ColorUtil.GrayUIWidget(tex)
      else
        ColorUtil.WhiteUIWidget(tex)
      end
    else
      ColorUtil.WhiteUIWidget(tex)
    end
  end
  for i = 1, #self.decorationTexs do
    if var then
      ColorUtil.GrayUIWidget(self.decorationTexs[i])
    else
      ColorUtil.WhiteUIWidget(self.decorationTexs[i])
    end
  end
end

function ChooseServantView:SetServantInfo()
  local servantid = _ServantConfig[self.curIndex].servantid
  local name = Table_Npc[servantid] and Table_Npc[servantid].NameZh
  self.servantNameLab.text = string.format(ZhString.ChooseServant_Name, name)
  if FunctionUnLockFunc.Me():CheckCanOpen(_ServantConfig[self.curIndex].menuid) then
    self.contentLab.text = string.format(ZhString.ChooseServant_Content, name)
    self.contentLab.width = 594
    self.cancelBtn:SetActive(true)
  else
    self.contentLab.text = _ServantConfig[self.curIndex].tip
    self.contentLab.width = 880
    self.cancelBtn:SetActive(false)
  end
end

function ChooseServantView:_PlayEffect()
  if self.effect then
    self:_DestroyEffect()
  end
  if FunctionUnLockFunc.Me():CheckCanOpen(_ServantConfig[self.curIndex].menuid) then
    local container = self:FindGO("EffectContainer", self.servantTexMap[self.curIndex].gameObject)
    self.effect = self:PlayUIEffect(_ServantConfig[self.curIndex].effect, container, false)
  end
end

function ChooseServantView:_DestroyEffect()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
end

function ChooseServantView:OffChoose()
  self:Hide(self.confirmRoot)
  self:_DestroyEffect()
  self:Show(self.initRoot)
  if nil == self.curIndex then
    return
  end
  self.curIndex = nil
  self:GrayWidget(false)
end

function ChooseServantView:Init()
  self.isChange = self.viewdata.viewdata and self.viewdata.viewdata.isChange == true or false
  _PicMgr = PictureManager.Instance
  _ServantConfig = GameConfig.Servant and GameConfig.Servant.firstHire
  if not _ServantConfig then
    redlog("未找到配置 ： GameConfig.Servant.firstHire")
    self:CloseSelf()
    return
  end
  self:FindObj()
  self:AddEvt()
  self:OffChoose()
end

function ChooseServantView:DoChoosed()
  if not FunctionUnLockFunc.Me():CheckCanOpen(_ServantConfig[self.curIndex].menuid) then
    self:OffChoose()
  else
    local servantid = _ServantConfig[self.curIndex].servantid
    helplog("CallHireServantUserCmd servantid: ", servantid)
    ServiceNUserProxy.Instance:CallHireServantUserCmd(servantid, self.isChange)
    if self.isChange then
      self:CloseSelf()
    end
  end
end

function ChooseServantView:UpdateServant()
  if not self.isChange then
    if MyselfProxy.Instance:GetMyServantID() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ServantNewMainView
      })
    end
    self:CloseSelf()
  end
end
