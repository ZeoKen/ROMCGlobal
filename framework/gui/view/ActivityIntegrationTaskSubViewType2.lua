autoImport("ActivityIntegrationTaskSubView")
autoImport("ActivityIntegrationTaskCellType2")
ActivityIntegrationTaskSubViewType2 = class("ActivityIntegrationTaskSubViewType2", ActivityIntegrationTaskSubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationTaskSubViewType2")
local Shop_Bg_Texture = "petchallenge_list_bg02"
local Condition_Bg_Texture = "petchallenge_base_bg"

function ActivityIntegrationTaskSubViewType2:Init()
  self.prefabPath = Prefab_Path
  self.prefabName = "ActivityIntegrationTaskSubViewType2"
  self.cellClass = ActivityIntegrationTaskCellType2
  self.cellPfbName = "ActivityIntegrationTaskCellType2"
  ActivityIntegrationTaskSubViewType2.super.Init(self)
end

function ActivityIntegrationTaskSubViewType2:GetShopBgTextureName()
  return Shop_Bg_Texture
end

function ActivityIntegrationTaskSubViewType2:GetConditionBgTextureName()
  return Condition_Bg_Texture
end

function ActivityIntegrationTaskSubViewType2:ResetColorTheme(index)
end

function ActivityIntegrationTaskSubViewType2:UpdateTaskScrollViewLayout(showCondition)
  local panel = self.taskScrollView and self.taskScrollView.panel
  if not panel then
    return
  end
  local clip = panel.baseClipRegion
  local centerY = showCondition and -51 or -68
  local sizeY = showCondition and 406 or 440
  panel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, centerY, clip.z, sizeY)
end
