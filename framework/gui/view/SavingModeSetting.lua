SavingModeSetting = class("SavingModeSetting")

function SavingModeSetting.EnterSavingMode()
  local changedSetting = {}
  local tab = Game.GetResolutionNames()
  changedSetting.outLine = false
  changedSetting.toonLight = false
  changedSetting.effectLv = LogicManager_MapCell.LODLevel.Low
  changedSetting.screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
  changedSetting.isShowOtherName = false
  changedSetting.showOtherChar = false
  changedSetting.resolution = #tab
  local me = FunctionPerformanceSetting.Me()
  me:Apply(changedSetting)
end

function SavingModeSetting.ExitSavingMode()
  local changedSetting = {}
  local me = FunctionPerformanceSetting.Me()
  changedSetting.outLine = me:GetSetting().outLine
  changedSetting.toonLight = me:GetSetting().toonLight
  changedSetting.effectLv = me:GetSetting().effectLv
  changedSetting.screenCount = me:GetSetting().screenCount
  changedSetting.isShowOtherName = me:GetSetting().isShowOtherName
  changedSetting.showOtherChar = me:GetSetting().showOtherChar
  changedSetting.resolution = me:GetSetting().resolution
  me:Apply(changedSetting)
end
