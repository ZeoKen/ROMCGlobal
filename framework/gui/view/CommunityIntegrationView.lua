CommunityIntegrationView = class("CommunityIntegrationView", ContainerView)
autoImport("ActivityIntegrationTabCell")
autoImport("CommunityIntegrationFollowSubView")
autoImport("CommunityIntegrationActivitySubView")
CommunityIntegrationView.ViewType = UIViewType.NormalLayer
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  bottom_01 = "activityintegration_bg_bottom_01"
}

function CommunityIntegrationView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function CommunityIntegrationView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.u_bgTex = self:FindComponent("MainBG", UITexture, self.gameObject)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.tabLine = self:FindGO("TabLine", self.gameObject):GetComponent(UISprite)
  self.tagScrollView = self:FindGO("TagScrollView"):GetComponent(UIScrollView)
  self.tabGrid = self:FindGO("TabGrid"):GetComponent(UIGrid)
  self.tabSelectListCtrl = UIGridListCtrl.new(self.tabGrid, ActivityIntegrationTabCell, "ActivityIntegrationTabCell")
  self.tabSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTabCell, self)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
end

function CommunityIntegrationView:AddMapEvts()
end

function CommunityIntegrationView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function CommunityIntegrationView:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.currentTab = viewdata and viewdata.tab
  self.groupID = viewdata and viewdata.group or 1
  local groupInfo = ActivityIntegrationProxy.Instance:GetGroupInfo(self.groupID)
  self.activityIDs = groupInfo and groupInfo.activityIDs
end

function CommunityIntegrationView:InitShow()
  local config = GameConfig.CommunityIntegration
  if not config then
    return
  end
  local tabList = {}
  local acts = CommunityIntegrationProxy.Instance:GetActs() or {}
  local langInt = ApplicationInfo.GetSystemLanguage()
  xdlog("当前语言", langInt)
  for i = 1, #acts do
    local actInfo = acts[i]
    if actInfo.type == 2 then
      local staticData = config[actInfo.id]
      local data = {
        id = actInfo.id,
        staticData = staticData,
        type = actInfo.type
      }
      table.insert(tabList, data)
    elseif actInfo.type == 1 then
      local event = actInfo.event
      local langInfo = event and event.langInfo or {}
      local curLangConfig
      if langInfo and langInfo[langInt] then
        curLangConfig = langInfo[langInt]
      elseif langInfo and langInfo[10] then
        curLangConfig = langInfo[10]
      else
        for k, v in pairs(langInfo) do
          curLangConfig = v
          break
        end
      end
      if curLangConfig then
        local data = {
          id = actInfo.id,
          type = actInfo.type,
          TitleName = curLangConfig.name,
          config = curLangConfig,
          reward = event.rewards,
          startTime = os.date("%Y-%m-%d %H:%M:%S", actInfo.startTime),
          endTime = os.date("%Y-%m-%d %H:%M:%S", actInfo.endTime)
        }
        table.insert(tabList, data)
      end
    elseif actInfo.type == 3 then
      local staticData = config and config.NoRewardAct and config.NoRewardAct[actInfo.id]
      local data = {
        id = actInfo.id,
        staticData = staticData,
        type = 2
      }
      table.insert(tabList, data)
    end
  end
  self.tabSelectListCtrl:ResetDatas(tabList)
  self.tabLine.width = 42 + (#tabList - 1) * 148.2
  self:LoadSubView(tabList)
  local cells = self.tabSelectListCtrl:GetCells()
  for i = 1, #cells do
    local type = cells[i].data.type
    local redtipid
    if type == 2 then
      redtipid = SceneTip_pb.EREDSYS_GLOBAL_ACT_REWARD
    elseif type == 1 then
      redtipid = SceneTip_pb.EREDSYS_EVENT_ACT_REWARD
    end
    self:RegisterRedTipCheck(redtipid, cells[i].gameObject, 42, {-30, -30}, nil, cells[i].data.id)
  end
  if cells and 0 < #cells then
    if self.currentTab then
      for i = 1, #cells do
        if cells[i].id == self.currentTab then
          self:handleClickTabCell(cells[i])
        end
      end
    else
      self:handleClickTabCell(cells[1])
    end
  end
end

function CommunityIntegrationView:LoadSubView(tabList)
  local loadCommunityPage = function()
    if not self.communityView then
      self.communityView = self:AddSubView("CommunityIntegrationFollowSubView", CommunityIntegrationFollowSubView)
      self.communityView.parentView = self
    end
    return self.communityView
  end
  local loadActivityPage = function()
    if not self.activityView then
      self.activityView = self:AddSubView("CommunityIntegrationActivitySubView", CommunityIntegrationActivitySubView)
      self.activityView.parentView = self
    end
    return self.activityView
  end
  self.subViews = {}
  self.subViews[1] = loadActivityPage
  self.subViews[2] = loadCommunityPage
  for i = 1, #tabList do
    local type = tabList[i].type
    if type then
      local subView = self.subViews[type]()
      subView.gameObject:SetActive(false)
    end
  end
end

function CommunityIntegrationView:handleClickTabCell(cellCtrl)
  local data = cellCtrl.data
  local id = data.id
  local type = data.type
  local subView = self.subViews[type]()
  if self.currentType then
    local curSubView = self.subViews[self.currentType]()
    curSubView.gameObject:SetActive(false)
    curSubView:OnHide()
  end
  self.currentType = type
  subView.gameObject:SetActive(true)
  subView:OnShow()
  subView:OnEnter(data)
  self:ChangeSubSelectorOnSelect(data.id)
  self:HandleSwitchBG(id)
end

function CommunityIntegrationView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.tabSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local sstab = ssCells[i].data.id
    ssCells[i]:SetSelect(sstab == id)
  end
end

function CommunityIntegrationView:HandleClickHelpBtn(helpid)
  local helpConfig = Table_Help[helpid]
  if helpConfig then
    self:OpenHelpView(helpConfig)
  end
end

function CommunityIntegrationView:HandleSwitchBG(id)
  local config = GameConfig.CommunityIntegration
  local params = config and config[id]
  local textureName = params and params.BgTexture or "mall_twistedegg_bg_bottom"
  if self.textureName and textureName == self.textureName then
    return
  end
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.u_bgTex)
  end
  self.textureName = textureName
  PictureManager.Instance:SetUI(self.textureName, self.u_bgTex)
end

function CommunityIntegrationView:OnEnter(id)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function CommunityIntegrationView:OnExit()
  CommunityIntegrationView.super.OnExit(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
end
