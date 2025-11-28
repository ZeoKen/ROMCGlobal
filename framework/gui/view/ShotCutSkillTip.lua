autoImport("SkillTip")
ShotCutSkillTip = class("ShotCutSkillTip", SkillTip)
local MaxHeight = 330

function ShotCutSkillTip:Init()
  self.calPropAffect = true
  self.tweenTime = 0.2
  self.tweenDis = 30
  self:FindObjs()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function ShotCutSkillTip:FindObjs()
  self.topAnchor = self:FindGO("Top"):GetComponent(UIWidget)
  self.centerBg = self:FindGO("CenterBg"):GetComponent(UIWidget)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
  self.scroll = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self:AddToUpdateAnchors(self:FindGO("TopBound"):GetComponent(UIWidget))
  self:AddToUpdateAnchors(self:FindGO("BottomBound"):GetComponent(UIWidget))
  self:AddToUpdateAnchors(self.topAnchor)
  self:AddToUpdateAnchors(self.centerBg)
  self:AddToUpdateAnchors(self.scrollView)
  self:FindTitleUI()
  self:FindCurrentUI()
  self:FindFunc()
end

function ShotCutSkillTip:OnEnter()
  self.bg.alpha = 0
  LeanTween.cancel(self.gameObject)
  local startPos = self.gameObject.transform.localPosition
  startPos.y = startPos.y - self.tweenDis
  self.gameObject.transform.localPosition = startPos
  local lt = LeanTween.moveLocalY(self.gameObject, self.pos.y, self.tweenTime)
  lt:setEase(LeanTweenType.easeOutBack)
  LeanTween.alphaNGUI(self.bg, 0, 1, self.tweenTime)
end

function ShotCutSkillTip:OnExit()
  LeanTween.cancel(self.gameObject)
  local ldt = LeanTween.alphaNGUI(self.bg, 1, 0, self.tweenTime):setOnComplete(function()
    self:DestroySelf()
  end)
  ldt = LeanTween.moveLocalY(self.gameObject, self.pos.y - self.tweenDis, self.tweenTime)
  ldt:setEase(LeanTweenType.easeInBack)
  if self.ltLayout then
    self.ltLayout:Destroy()
    self.ltLayout = nil
  end
  self:CheckSpecialModified()
  local _EventManager = EventManager.Me()
  _EventManager:RemoveEventListener(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, self.HandleSkillOptionUpdate, self)
  _EventManager:RemoveEventListener(SkillEvent.SkillUpdate, self.HandleSkillUpdate, self)
end

function ShotCutSkillTip:SetData(data)
  self.data = data
  self:UpdateCurrentInfo(self.data:GetExtraStaticData())
  self:ShowHideFunc()
  self.ltLayout = TimeTickManager.Me():CreateOnceDelayTick(10, function(owner, deltaTime)
    self.ltLayout = nil
    local height = math.max(math.min(self:Layout() + 190, MaxHeight), SkillTip.MinHeight)
    self.bg.height = height
    self:UpdateAnchors()
    self.scroll:ResetPosition()
    self.skillInfo = nil
  end, self)
end

function ShotCutSkillTip:UpdateContainer(height)
  self.containerTrans.localPosition = LuaGeometry.GetTempVector3(0, height - 35, 0)
  self.isUpdateContainer = true
end

function ShotCutSkillTip:ClickMultiSelect(cell)
  if ShotCutSkillTip.super.ClickMultiSelect(self, cell) then
    self:CheckMultiSelectModified()
  end
end

function ShotCutSkillTip:ClickSpecialCheck()
  if ShotCutSkillTip.super.ClickSpecialCheck(self) then
    self:CheckRuneModified()
  end
end

function ShotCutSkillTip:ClickSpecialEffect(cell)
  if ShotCutSkillTip.super.ClickSpecialEffect(self, cell) then
    self:CheckRuneModified()
  end
end

function ShotCutSkillTip:ClickSelectOption(cell)
  if ShotCutSkillTip.super.ClickSelectOption(self, cell) then
    self:CheckSelectModified()
  end
end

function ShotCutSkillTip:ClickAddSubSkill(cell)
  self:TryInitSubSkill()
  self.closecomp.enabled = false
  self.closecomp.enabled = true
end
