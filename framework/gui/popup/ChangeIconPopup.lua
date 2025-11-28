autoImport("AppIconCell")
ChangeIconPopup = class("ChangeIconPopup", ContainerView)
ChangeIconPopup.ViewType = UIViewType.PopUpLayer
local IconConfig = GameConfig.System.IconChange
local configString = ""

function ChangeIconPopup:Init()
  self:FindObj()
  self:AddViewEvts()
  self:InitView()
  for i = 1, #IconConfig do
    configString = configString .. IconConfig[i]
    if i ~= #IconConfig then
      configString = configString .. ","
    end
  end
end

function ChangeIconPopup:FindObj()
  self.iconGrid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.iconCtrl = UIGridListCtrl.new(self.iconGrid, AppIconCell, "AppIconCell")
end

function ChangeIconPopup:AddViewEvts()
  self.iconCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickIcon, self)
  local confirmbtn = self:FindGO("confirmbtn")
  self:AddClickEvent(confirmbtn, function()
    if IconConfig and self.chooseid and IconConfig[self.chooseid] then
      redlog("ChangeAPPIcon", self.chooseid)
      FunctionPlayerPrefs.Me():SetString(LocalSaveProxy.SAVE_KEY.ChangedAppIcon, IconConfig[self.chooseid])
      EventManager.Me():PassEvent(SetViewEvent.ChangeAppIcon, IconConfig[self.chooseid])
      local runtimePlatform = ApplicationInfo.GetRunPlatform()
      if runtimePlatform == RuntimePlatform.Android then
        ExternalInterfaces.ChangeAPPIcon(IconConfig[self.chooseid], configString)
        redlog("ChangeAPPIcon", temps)
      else
        ExternalInterfaces.ChangeAPPIcon(IconConfig[self.chooseid])
        redlog("ChangeAPPIcon", IconConfig[self.chooseid])
      end
    end
    self:CloseSelf()
  end)
end

function ChangeIconPopup:InitView()
  if IconConfig then
    self.iconConfigList = {}
    for i = 1, #IconConfig do
      local entry = {}
      entry.id = i
      entry.iconStr = IconConfig[i]
      table.insert(self.iconConfigList, entry)
    end
    self.iconCtrl:ResetDatas(self.iconConfigList)
    self:SetChooseCell()
  end
  self.chooseid = 0
end

function ChangeIconPopup:ClickIcon(cellctl)
  redlog("ClickIcon")
  if cellctl and cellctl.data then
    self.chooseid = cellctl.data.id
    redlog("self.chooseid", self.chooseid)
    self:SetChooseCell()
  end
end

function ChangeIconPopup:SetChooseCell()
  local cells = self.iconCtrl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    if cells[i].data.id == self.chooseid then
      cells[i]:SetChoose(true)
    else
      cells[i]:SetChoose(false)
    end
  end
end

function ChangeIconPopup:OnExit()
end
