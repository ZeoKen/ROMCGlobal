autoImport("DayloginContainerView")
DayloginAnniversaryPanel = class("DayloginAnniversaryPanel", DayloginContainerView)
autoImport("DayloginCell")
autoImport("RewardGridCell")
local decorateTextureNameMap = {
  bottom_17 = "daylogin_bg_bottom_17",
  bottom_15 = "daylogin_bg_bottom_15",
  decorate_1 = "daylogin_bg_decorate_01",
  decorate_2 = "daylogin_bg_decorate_02"
}
local picIns = PictureManager.Instance

function DayloginAnniversaryPanel.CanShow()
  local canShow = DailyLoginProxy.Instance.inited
  if canShow then
    local activeSignIn = DailyLoginProxy.Instance.activeSignIn
    for k, v in pairs(activeSignIn) do
      if v.novicetype then
        xdlog("新人推送")
        return k
      end
    end
  end
  return false
end

function DayloginAnniversaryPanel:FindObjs()
  DayloginAnniversaryPanel.super.FindObjs(self)
  self.dailyLoginGridCtrl = UIGridListCtrl.new(self.grid, DayloginCell, "DayloginCell")
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickDailyLogin, self)
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleClickReward, self)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.lucky_line = self:FindGO("lucky_line"):GetComponent(UITexture)
end

function DayloginAnniversaryPanel:InitData()
  DayloginAnniversaryPanel.super.InitData(self)
  self:ShowRewardPreview()
end

function DayloginAnniversaryPanel:InitShow()
  DayloginAnniversaryPanel.super.InitShow(self)
end

function DayloginAnniversaryPanel:OnEnter()
  DayloginAnniversaryPanel.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetDayLoginTexture(texName, self[objName])
  end
  picIns:SetUI("lucky_bg_decorate_line", self.lucky_line)
end

function DayloginAnniversaryPanel:OnExit()
  DayloginAnniversaryPanel.super.OnExit(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadDayLoginTexture(texName, self[objName])
  end
  picIns:UnLoadUI("lucky_bg_decorate_line", self.lucky_line)
end

function DayloginAnniversaryPanel:ShowRewardPreview()
  local rewardPreview = self.config.RewardPreview
  if not rewardPreview then
    redlog("新手签到未配置展示NPC")
    self:Show3DModel(1050)
    return
  end
  local targetNpcid = rewardPreview and rewardPreview.NpcID
  if targetNpcid then
    self:Show3DModel(targetNpcid)
  end
end
