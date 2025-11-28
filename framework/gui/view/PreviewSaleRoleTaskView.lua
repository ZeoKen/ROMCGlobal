PreviewSaleRoleTaskView = class("PreviewSaleRoleTaskView", ContainerView)
autoImport("PreviewSaleRoleTaskCell")
PreviewSaleRoleTaskView.ViewType = UIViewType.NormalLayer
local tipData = {}

function PreviewSaleRoleTaskView:Init()
  self:initView()
  self:addViewEventListener()
  self:addListEventListener()
  self:AddEvts()
end

function PreviewSaleRoleTaskView:initView()
  self.scrollView = self:FindComponent("TaskScrollView", UIScrollView)
  self.taskTable = self:FindGO("TaskTable"):GetComponent(UITable)
  self.taskGridCtrl = UIGridListCtrl.new(self.taskTable, PreviewSaleRoleTaskCell, "PreviewSaleRoleTaskCell")
  self.panel = self.scrollView.panel
  self.TitleRoot = self:FindGO("TitleRoot")
  self.TitleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.DescRoot = self:FindGO("DescRoot")
  self.DescLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.bgTex = self:FindGO("role_bg"):GetComponent(UITexture)
  self.RoleBG = "malibefore_bg_03"
  self.roleName = {}
  self.roleNameLabel = {}
  self.roleNameBG = {}
  for i = 1, 4 do
    self.roleName[i] = self:FindGO("roleName" .. i)
    self.roleNameLabel[i] = self:FindGO("name", self.roleName[i]):GetComponent(UILabel)
    self.roleNameBG[i] = self:FindGO("bg", self.roleName[i]):GetComponent(UISprite)
    self.roleName[i]:SetActive(false)
  end
  local taskData = QuestProxy.Instance:PreviewSaleRoleTask()
  if taskData then
    self.taskGridCtrl:ResetDatas(taskData)
    local tableData = Table_QuestHero[taskData[1].id]
    if tableData then
      local cfg = GameConfig.PreviewSaleRole[tableData.GroupID]
      if cfg then
        self.RoleBG = cfg.RoleBg
        PictureManager.Instance:SetPreviewSaleRoleTexture(self.RoleBG, self.bgTex)
        self.bgTex:MakePixelPerfect()
        self.TitleLabel.text = cfg.Title
        self.TitleRoot.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(cfg.TitlePos[1], cfg.TitlePos[2], 0)
        self.DescLabel.text = cfg.Desc
        self.DescRoot.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(cfg.DescPos[1], cfg.DescPos[2], 0)
        for i = 1, #cfg.HeroName do
          if self.roleName[i] then
            self.roleName[i]:SetActive(true)
            self.roleNameLabel[i].text = cfg.HeroName[i]
            local chlen = StringUtil.getTextLen(cfg.HeroName[i])
            self.roleNameBG[i].width = chlen * 24 + 40
            self.roleName[i].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(cfg.NamePos[i][1], cfg.NamePos[i][2], 0)
          end
        end
      end
    end
  end
end

function PreviewSaleRoleTaskView:addViewEventListener()
end

function PreviewSaleRoleTaskView:addListEventListener()
end

function PreviewSaleRoleTaskView:AddEvts()
  self:AddListenEvt(ServiceEvent.QuestUpdateQuestHeroQuestCmd, self.OnUpdateQuestHeroQuest)
end

function PreviewSaleRoleTaskView:OnUpdateQuestHeroQuest()
  local taskData = QuestProxy.Instance:PreviewSaleRoleTask()
  if taskData then
    self.taskGridCtrl:ResetDatas(taskData)
  end
end

function PreviewSaleRoleTaskView:OnExit()
  PictureManager.Instance:UnloadPreviewSaleRoleTexture(self.RoleBG, self.bgTex)
end
