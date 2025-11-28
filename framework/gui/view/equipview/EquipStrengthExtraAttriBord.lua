autoImport("EquipStrengthExtraAttriCell")
EquipStrengthExtraAttriBord = class("EquipStrengthExtraAttriBord", CoreView)
EquipStrengthExtraAttriBord.ShowEvent = "EquipStrengthExtraAttriBord_ShowEvent"
EquipStrengthExtraAttriBord.HideEvent = "EquipStrengthExtraAttriBord_HideEvent"
local prefabPath = ResourcePathHelper.UIV1("part/EquipStrengthExtraAttriBord")

function EquipStrengthExtraAttriBord.CreateInstance(parent)
  local obj = Game.AssetManager_UI:CreateAsset(prefabPath, parent)
  local upPanel = UIUtil.GetComponentInParents(obj, UIPanel)
  local panels = UIUtil.GetAllComponentsInChildren(obj, UIPanel, true)
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + upPanel.depth
  end
  return EquipStrengthExtraAttriBord.new(obj)
end

function EquipStrengthExtraAttriBord:ctor(go)
  EquipStrengthExtraAttriBord.super.ctor(self, go)
  self:Init()
end

function EquipStrengthExtraAttriBord:Init()
  self.returnBtn = self:FindGO("ReturnButton")
  self:AddClickEvent(self.returnBtn, function()
    self:HideBord()
  end)
  local grid = self:FindComponent("SGrid", UIGrid)
  self.ctrl = UIGridListCtrl.new(grid, EquipStrengthExtraAttriCell, "EquipStrengthExtraAttriCell")
end

function EquipStrengthExtraAttriBord:RefreshInfo()
  self.ctrl:ResetDatas(StrengthProxy.Instance:GetExtraAttriList())
end

function EquipStrengthExtraAttriBord:OnEnter()
  EventManager.Me():AddEventListener(StrengthProxy.Event_RefreshStrengthLv, self.RefreshInfo, self)
end

function EquipStrengthExtraAttriBord:OnExit()
  EventManager.Me():RemoveEventListener(StrengthProxy.Event_RefreshStrengthLv, self.RefreshInfo, self)
end

function EquipStrengthExtraAttriBord:ShowBord()
  self.gameObject:SetActive(true)
  self:RefreshInfo()
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_STRENGTH_ACCUMULATE_REWARD)
  self:PassEvent(EquipStrengthExtraAttriBord.ShowEvent, self)
end

function EquipStrengthExtraAttriBord:HideBord()
  self.gameObject:SetActive(false)
  self:PassEvent(EquipStrengthExtraAttriBord.HideEvent, self)
end
