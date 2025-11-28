ChooseProfessionBranchPopup = class("ChooseProfessionBranchPopup", BaseView)
ChooseProfessionBranchPopup.ViewType = UIViewType.PopUpLayer

function ChooseProfessionBranchPopup:Init()
  self:InitUI()
  self:AddListenEvt()
end

function ChooseProfessionBranchPopup:InitUI()
  self.panel = self:FindGO("Panel")
  self.collider = self:FindGO("collider")
  self.left = self:FindGO("left")
  self.right = self:FindGO("right")
  self.leftSelect = self:FindGO("select", self.left)
  self.rightSelect = self:FindGO("select", self.right)
  self.leftTex = self:FindComponent("pic", UITexture, self.left)
  self.rightTex = self:FindComponent("pic", UITexture, self.right)
  self.confirmBtn = self:FindGO("ConfirmButton")
  self.cancelBtn = self:FindGO("CancelButton")
  self:FindComponent("Label", UILabel, self.confirmBtn).text = ZhString.UniqueConfirmView_Confirm
  self:FindComponent("Label", UILabel, self.cancelBtn).text = ZhString.UniqueConfirmView_CanCel
  self:AddClickEvent(self.confirmBtn, function()
    self:TryDoChooseBranch()
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self.selectBranchProf = nil
    self:TryDoChooseBranch()
  end)
  self:AddClickEvent(self.left, function()
    self.leftSelect:SetActive(true)
    self.rightSelect:SetActive(false)
    self:SelectBranch(1)
  end)
  self:AddClickEvent(self.right, function()
    self.leftSelect:SetActive(false)
    self.rightSelect:SetActive(true)
    self:SelectBranch(2)
  end)
end

function ChooseProfessionBranchPopup:AddListenEvt()
end

function ChooseProfessionBranchPopup:OnEnter()
  ChooseProfessionBranchPopup.super.OnEnter(self)
  self.panel:SetActive(false)
  self.questData = self.viewdata.viewdata
  self.leftSelect:SetActive(false)
  self.rightSelect:SetActive(false)
  self:LoadProfessionFrame()
end

function ChooseProfessionBranchPopup:OnExit()
  self.leftTex = nil
  self.rightTex = nil
  ChooseProfessionBranchPopup.super.OnExit(self)
end

function ChooseProfessionBranchPopup:LoadProfessionFrame()
  local prof = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local sex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  if ProfessionProxy.IsNovice(prof) then
    local advProf = Table_Class and Table_Class[prof] and Table_Class[prof].AdvanceClass
    if advProf and 0 < #advProf then
      prof = advProf[1]
    end
  end
  self.advProf = {}
  self.selectBranchProf = 0
  local advProf = Table_Class and Table_Class[prof] and Table_Class[prof].AdvanceClass
  if ProfessionProxy.GetJobDepth(prof) == 1 and advProf then
    for i = 1, #advProf do
      local p = Table_Class[advProf[i]]
      if p and p.gender == nil or p.gender == sex then
        table.insert(self.advProf, p)
      end
    end
    if #self.advProf == 0 then
    elseif #self.advProf == 1 then
      self.selectBranchProf = self.advProf[1].id
    else
      self.selectBranchProf = nil
      self.panel:SetActive(true)
      self.right:SetActive(true)
      self.left:SetActive(true)
      self:ShowRoleModel(self.advProf[2].id, self.rightTex)
      self:ShowRoleModel(self.advProf[1].id, self.leftTex)
    end
  end
  if self.selectBranchProf then
    local c = coroutine.create(function()
      Yield(WaitForEndOfFrame())
      self:TryDoChooseBranch()
    end)
    coroutine.resume(c)
  end
end

function ChooseProfessionBranchPopup:SelectBranch(idx)
  self.selectBranchProf = self.advProf[idx].id
end

function ChooseProfessionBranchPopup:TryDoChooseBranch()
  self.selectBranchProf = self.selectBranchProf and Table_Class[self.selectBranchProf] and Table_Class[self.selectBranchProf].TypeBranch
  if self.questData and self.questData.scope and self.questData.id then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.selectBranchProf or 0)
  else
    redlog("选择职业分支：任务数据有误")
  end
  self:CloseSelf()
end

function ChooseProfessionBranchPopup:ShowRoleModel(profession, tex)
  if not tex then
    return
  end
  local profCfg = Table_Class and Table_Class[profession]
  local sex = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = profCfg and (sex == 1 and profCfg.MaleBody or profCfg.FemaleBody) or Game.Myself.data.userdata:Get(UDEnum.BODY)
  parts[Asset_Role.PartIndex.Hair] = Game.Myself.data.userdata:Get(UDEnum.HAIR)
  parts[Asset_Role.PartIndex.Eye] = Game.Myself.data.userdata:Get(UDEnum.EYE)
  parts[Asset_Role.PartIndexEx.HairColorIndex] = Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
  parts[Asset_Role.PartIndexEx.EyeColorIndex] = Game.Myself.data.userdata:Get(UDEnum.EYECOLOR)
  UIModelUtil.Instance:SetRoleModelTexture(tex, parts, UIModelCameraTrans.ChooseBranch)
  Asset_Role.DestroyPartArray(parts)
end
