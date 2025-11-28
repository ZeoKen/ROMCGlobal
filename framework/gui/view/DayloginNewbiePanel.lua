autoImport("DayloginContainerView")
DayloginNewbiePanel = class("DayloginNewbiePanel", DayloginContainerView)
autoImport("DayloginCell")
autoImport("RewardGridCell")
local decorateTextureNameMap = {
  bottom_1 = "daylogin_bg_bottom_01",
  bottom_2 = "daylogin_bg_bottom_02",
  bottom_3 = "daylogin_bg_bottom_03",
  bottom_4 = "daylogin_bg_bottom_04",
  bottom_5 = "daylogin_bg_bottom_05",
  bottom_6 = "daylogin_bg_bottom_06",
  bottom_7 = "daylogin_bg_bottom_07",
  bottom_8 = "daylogin_bg_bottom_08"
}
local returnTextureNameMap = {
  return_bottom_1 = "returnactivity_bg_decorate_01",
  returnactivity_decorate_4 = "returnactivity_bg_decorate_04",
  returnactivity_decorate_5 = "returnactivity_bg_decorate_05",
  coin3_1 = "returnactivity_bg_coin_03",
  coin3_2 = "returnactivity_bg_coin_03"
}
local picIns = PictureManager.Instance

function DayloginNewbiePanel.CanShow()
  local hotPotIcon = DailyLoginProxy.Instance.hotPotIcon
  local validActivityIDs = {}
  if hotPotIcon then
    for k, v in pairs(hotPotIcon) do
      if v.redtip and GameConfig.FestivalSignin[k] and (not GameConfig.FestivalSignin[k].Newbie or GameConfig.FestivalSignin[k].Newbie ~= 1) then
        table.insert(validActivityIDs, k)
      end
    end
  end
  if 0 < #validActivityIDs then
    return validActivityIDs
  end
  redlog("没有可以签到的活动")
  return nil
end

function DayloginNewbiePanel:FindObjs()
  DayloginNewbiePanel.super.FindObjs(self)
  self.dailyLoginGridCtrl = UIGridListCtrl.new(self.grid, DayloginCell, "DayloginCellType2")
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.HandleClickDailyLogin, self)
  self.dailyLoginGridCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.HandleClickReward, self)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  for objName, _ in pairs(returnTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.calendarBG2 = self:FindGO("calendar_pic2"):GetComponent(UITexture)
end

function DayloginNewbiePanel:InitData()
  DayloginNewbiePanel.super.InitData(self)
  self:ShowRewardPreview()
end

function DayloginNewbiePanel:OnEnter()
  DayloginNewbiePanel.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetDayLoginTexture(texName, self[objName])
  end
  for objName, texName in pairs(returnTextureNameMap) do
    picIns:SetReturnActivityTexture(texName, self[objName])
  end
  picIns:SetUI("calendar_bg1_picture2", self.calendarBG2)
end

function DayloginNewbiePanel:OnExit()
  DayloginNewbiePanel.super.OnExit(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadDayLoginTexture(texName, self[objName])
  end
  for objName, texName in pairs(returnTextureNameMap) do
    picIns:UnloadReturnActivityTexture(texName, self[objName])
  end
  picIns:UnLoadUI("calendar_bg1_picture2", self.calendarBG2)
end

function DayloginNewbiePanel:ShowRewardPreview()
  local rewardPreview = self.config.RewardPreview
  if not rewardPreview then
    return
  end
  local targetNpcid = rewardPreview and rewardPreview.NpcID
  if targetNpcid then
    self:Show3DModel(targetNpcid)
    self.bottom_8.gameObject:SetActive(false)
  else
    self.bottom_8.gameObject:SetActive(true)
  end
end
