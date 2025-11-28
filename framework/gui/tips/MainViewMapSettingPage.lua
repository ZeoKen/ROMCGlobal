MainViewMapSettingPage = class("MainViewMapSettingPage", CoreView)
PlayerPrefsShowAreaTips = "PlayerPrefsShowAreaTips"

function MainViewMapSettingPage:ctor(go)
  MainViewMapSettingPage.super.ctor(self, go)
  self:Init()
end

function MainViewMapSettingPage:Init()
  self:FindObjs()
  self:InitShow()
  self:AddEvts()
end

function MainViewMapSettingPage:FindObjs()
  self.showAreaTipsTog = self:FindGO("ShowAreaTipsToggle"):GetComponent("UIToggle")
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self:FindComponent("Setting_areatips", UILabel).text = ZhString.MapTransmitter_AreaTips
  self.settingScrollViewGO = self:FindGO("SettingScrollView")
  self.settingPanel = self.settingScrollViewGO:GetComponent(UIPanel)
end

function MainViewMapSettingPage:InitShow()
  self.showAreaTipsTog.value = self.showAreaTips == 1
end

function MainViewMapSettingPage:AddEvts()
  EventDelegate.Set(self.showAreaTipsTog.onChange, function()
    self:SaveSetting()
    GameFacade.Instance:sendNotification(MainViewEvent.MiniMapSettingChange, {
      showAreaTips = self.showAreaTips == 1
    })
  end)
end

function MainViewMapSettingPage:SaveSetting()
  self.showAreaTips = self.showAreaTipsTog.value and 1 or 0
  PlayerPrefs.SetInt(PlayerPrefsShowAreaTips, self.showAreaTips)
  return nil, self.showAreaTips
end

function MainViewMapSettingPage:GetBitByInt(num, index)
  return num >> index & 1 == 0
end

function MainViewMapSettingPage:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end

function MainViewMapSettingPage:ShowAreaTipsToggle(isShow)
  isShow = isShow and true or false
  if self.showAreaTipsTog then
    self.showAreaTipsTog.gameObject.transform.parent.gameObject:SetActive(isShow)
  end
  self:RefreshGrid()
end

function MainViewMapSettingPage:RefreshGrid()
  self.grid:Reposition()
end

function MainViewMapSettingPage:SetPanelDepth(depth)
  self.settingPanel.depth = depth
end
