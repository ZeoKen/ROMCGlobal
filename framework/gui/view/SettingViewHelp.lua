autoImport("MultiGeneralHelp")
SettingViewHelp = class("SettingViewHelp", MultiGeneralHelp)
autoImport("SettingViewTitleCell")
local _ArrayClear = TableUtility.ArrayClear
local getTitleData = function(sLabel, sSpriteName, bline)
  return {
    label = sLabel,
    spriteName = sSpriteName,
    line = bline
  }
end

function SettingViewHelp:GetTitleDatas(index)
  if not self.titleDatas then
    self.titleDatas = {}
  else
    _ArrayClear(self.titleDatas)
  end
  local battleTimeMgr = BattleTimeDataProxy.Instance
  local helpData = self.datas[index]
  if helpData.id == GameConfig.Setting.GametimeHelpId then
    local musicTime = battleTimeMgr:MusicTime()
    local tutorTime = battleTimeMgr:TutorTime()
    local powerTime = battleTimeMgr:PowerTime()
    local len = 0
    if 0 < musicTime then
      table.insert(self.titleDatas, getTitleData("+" .. musicTime .. "min", "item_5827", true))
      len = len + 1
    end
    if 0 < tutorTime then
      table.insert(self.titleDatas, getTitleData("+" .. tutorTime .. "min", "item_12390", true))
      len = len + 1
    end
    if 0 < powerTime then
      table.insert(self.titleDatas, getTitleData("+" .. powerTime .. "min", "item_6959", true))
      len = len + 1
    end
    if 0 < len then
      self.titleDatas[len].line = false
    end
  elseif helpData.id == GameConfig.Setting.PlaytimeHelpId then
    local servant_time = battleTimeMgr:TotalPlaytime_extra_daily(true)
    local item_time = battleTimeMgr:TotalPlaytime_extra(true)
    local playtime = battleTimeMgr:TotalPlayTime(true)
    playtime = playtime - item_time - servant_time
    if 0 < playtime then
      table.insert(self.titleDatas, getTitleData("+" .. playtime // 60 .. "min", "item_3005420", true))
    end
    if 0 < servant_time then
      table.insert(self.titleDatas, getTitleData("+" .. servant_time // 60 .. "min", "item_5827", true))
    end
    if 0 < item_time then
      table.insert(self.titleDatas, getTitleData("+" .. item_time // 60 .. "min", "item_6959", false))
    end
  end
  return self.titleDatas
end

function SettingViewHelp:InitTip()
  SettingViewHelp.super.InitTip(self)
  local titleGrid = self:FindComponent("TitleGrid", UIGrid)
  self.titleCtrl = UIGridListCtrl.new(titleGrid, SettingViewTitleCell, "SettingViewTitleCell")
  self.emptyTipGO = self:FindGO("EmptyTip")
  self.emptyTipLab = self:FindComponent("Label", UILabel, self.emptyTipGO)
  self:FindComponent("Label", UILabel, self.emptyTipGO).text = ZhString.SettingViewHelp_EmptyTip
end

function SettingViewHelp:SetToggle(index)
  SettingViewHelp.super.SetToggle(self, index)
  self:UpdateEmptyLab()
  local titleDatas = self:GetTitleDatas(index)
  self.titleCtrl:ResetDatas(titleDatas)
  self.emptyTipGO:SetActive(#titleDatas == 0)
end

function SettingViewHelp:UpdateEmptyLab()
  if not self.emptyTipLab then
    return
  end
  if ISNoviceServerType then
    self.emptyTipLab.text = self.toggleIndex == 1 and ZhString.SettingViewHelp_EmptyTip_Novice or ZhString.SettingViewHelp_EmptyTip
  else
    self.emptyTipLab.text = ZhString.SettingViewHelp_EmptyTip
  end
end
