autoImport("ColliderItemCell")
TutorRewardBoxPopUp = class("TutorRewardBoxPopUp", BaseView)
TutorRewardBoxPopUp.ViewType = UIViewType.PopUpLayer
local greyOutline = LuaColor(0.4235294117647059, 0.4235294117647059, 0.4235294117647059)
local orangeOutline = LuaColor(0.6196078431372549, 0.33725490196078434, 0 / 255)

function TutorRewardBoxPopUp:Init()
  self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UIButton)
  self.confirmLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.tip = self:FindGO("tip")
  local grid = self:FindGO("itemGrid"):GetComponent(UIGrid)
  self.itemCtl = UIGridListCtrl.new(grid, ColliderItemCell, "ColliderItemCell")
  self:AddClickEvent(self.confirmButton.gameObject, function(go)
    self:DoConfirm()
  end)
end

function TutorRewardBoxPopUp:DoConfirm()
  ServiceTutorProxy.Instance:CallTutorTaskTeacherRewardCmd(0)
  self:CloseSelf()
end

function TutorRewardBoxPopUp:UpdateInfo()
  local datas = TutorProxy.Instance:GetTutorBoxList()
  if not datas or datas[1].num <= 0 then
    self.confirmButton.isEnabled = false
    self.confirmLabel.effectColor = greyOutline
  else
    self.confirmButton.isEnabled = true
    self.confirmLabel.effectColor = orangeOutline
  end
  self.itemCtl:ResetDatas(datas)
end

function TutorRewardBoxPopUp:OnEnter()
  TutorRewardBoxPopUp.super.OnEnter(self)
  self:UpdateInfo()
end

function TutorRewardBoxPopUp:OnExit()
  TutorRewardBoxPopUp.super.OnExit(self)
end
