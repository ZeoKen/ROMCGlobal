autoImport("MobaPvpCompetiveView")
MobaPVPView = class("MobaPVPView", SubView)

function MobaPVPView:Init()
  self.coreTabMap = ReusableTable.CreateTable()
  self:FindObjs()
  self:InitShow()
  self:AddEvts()
end

function MobaPVPView:AddEvts()
end

local ShowHelpDesc = function(id)
  local desc = Table_Help[id] and Table_Help[id].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end

function MobaPVPView:FindObjs()
  self.gameObject = self:FindGO("MobaPVPView")
  self.competiveModeBtn = self:FindGO("CompetiveModeBtn", self.gameObject)
  self.competiveModeObj = self:FindGO("MobaPvpCompetiveView", self.gameObject)
  self.cupModeBtn = self:FindGO("CupModeBtn", self.gameObject)
  self.cupModeObj = self:FindGO("MobaPvpCupModeView", self.gameObject)
  self.pvpTypeGrid = self:FindComponent("TypeGrid", UIGrid, self.gameObject)
  self.warbandModelObj = self:FindGO("WarbandModelView")
  self.freeModeBtn = self:FindGO("FreeModeBtn", self.gameObject)
  self.freeModeObj = self:FindGO("MobaPvpFreeModeView", self.gameObject)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:AddClickEvent(self.helpBtn, function()
    if self.competiveModeObj.activeSelf then
      ShowHelpDesc(32618)
    elseif self.cupModeObj.activeSelf then
      ShowHelpDesc(PanelConfig.WarbandModelView.id)
    elseif self.freeModeObj.activeSelf then
      ShowHelpDesc(32603)
    end
  end)
  self.openLabel = self:FindGO("OpenLabel", self.gameObject):GetComponent(UILabel)
  self.openLabel_Bg = self:FindGO("OpenBg", self.openLabel.gameObject):GetComponent(UISprite)
  self.txt_season = self:FindGO("txt_season", self.openLabel.gameObject):GetComponent(UITexture)
  self.openLabel.gameObject:SetActive(false)
end

function MobaPVPView:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.warbandModelBtn.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function MobaPVPView:InitShow()
  self.cupModeBtn:SetActive(false)
  self.competiveModeBtn:SetActive(true)
  self.pvpTypeGrid:Reposition()
  self.competiveModeView = self:AddSubView("MobaPvpCompetiveView", MobaPvpCompetiveView)
  self.freeModeView = self:AddSubView("MobaPvpFreeModeView", MobaPvpFreeModeView)
  self:AddTabChangeEvent(self.competiveModeBtn, self.competiveModeObj, self.competiveModeView)
  self:AddTabChangeEvent(self.freeModeBtn, self.freeModeObj, self.freeModeView)
  if self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandlerWithPanelID(self.viewdata.viewdata.tab)
  else
    self:TabChangeHandler(self.competiveModeBtn.name)
  end
end

function MobaPVPView:AddTabChangeEvent(toggleObj, targetObj, script)
  local key = toggleObj.name
  if not self.coreTabMap[key] then
    local table = ReusableTable.CreateTable()
    table.obj = targetObj
    table.script = script
    table.tabGO = toggleObj
    self.coreTabMap[key] = table
    self:AddClickEvent(toggleObj, function(go)
      self:TabChangeHandler(go.name)
    end)
  end
end

function MobaPVPView:TabChangeHandlerWithPanelID(tabID)
  if tabID == PanelConfig.MobaPvpCompetiveView.tab then
    self:TabChangeHandler(self.competiveModeBtn.name)
  end
end

function MobaPVPView:TabChangeHandler(key)
  if self.currentKey ~= key then
    if self.currentKey then
      self.coreTabMap[self.currentKey].obj:SetActive(false)
    end
    self.coreTabMap[key].obj:SetActive(true)
    self.coreTabMap[key].script:UpdateView()
    self.currentKey = key
  end
  for k, v in pairs(self.coreTabMap) do
    if v.tabGO then
      local bg = self:FindComponent("Bg", UISprite, v.tabGO)
      local name = self:FindComponent("Name", UILabel, v.tabGO)
      if k == key then
        bg.spriteName = "sports_btn_liang"
        name.color = LuaGeometry.GetTempVector4(0.34901960784313724, 0.21176470588235294, 0.07450980392156863, 1)
      else
        bg.spriteName = "sports_btn_an"
        name.color = LuaColor.White()
      end
    end
  end
end

function MobaPVPView:UpdateView()
  self.coreTabMap[self.currentKey].script:UpdateView()
end

function MobaPVPView:OnExit()
  MobaPVPView.super.OnExit(self)
end

function MobaPVPView:OnDestroy()
  for k, v in pairs(self.coreTabMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.coreTabMap)
  MobaPVPView.super.OnDestroy(self)
end

function MobaPVPView:UpdateOpenLabel()
end
