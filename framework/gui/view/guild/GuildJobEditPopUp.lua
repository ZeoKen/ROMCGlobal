GuildJobEditPopUp = class("GuildJobEditPopUp", ContainerView)
GuildJobEditPopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildJobEditCell")

function GuildJobEditPopUp:Init()
  self.filterType = GameConfig.MaskWord.GuildProfession
  self:InitUI()
end

function GuildJobEditPopUp:InitUI()
  local grid = self:FindComponent("JobGrid", UIGrid)
  self.jobCtl = UIGridListCtrl.new(grid, GuildJobEditCell, "GuildJobEditCell")
  self:RegistShowGeneralHelpByHelpID(531, self:FindGO("HelpBtn"))
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GuildJobAuth_Title
  self.jobAuthLab = self:FindComponent("Label", UILabel, self.titleLab.gameObject)
  self.jobAuthLab.text = ZhString.GuildJobAuth_JobAuth
  local fixedLabGrid = self:FindGO("TitleGrid", self.titleLab.gameObject)
  if not self.fixedZhStr then
    self.fixedZhStr = {
      ZhString.GuildJobAuth_Invite,
      ZhString.GuildJobAuth_Expel,
      ZhString.GuildJobAuth_Picture,
      ZhString.GuildJobAuth_Mercenary,
      ZhString.GuildJobAuth_GVG_City,
      ZhString.GuildJobAuth_Edit
    }
  end
  self.fixedLab = {}
  for i = 1, 6 do
    self.fixedLab[i] = self:FindComponent("Label" .. tostring(i), UILabel, fixedLabGrid)
    if self.fixedLab[i] then
      self.fixedLab[i].text = self.fixedZhStr[i] or "undefinition"
    end
  end
end

function GuildJobEditPopUp:UpdateJobInfo()
  if self.datas == nil then
    self.datas = {}
  else
    TableUtility.ArrayClear(self.datas)
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  local myJobInfo = myGuildData:GetJobMap()
  for _, jobdata in pairs(myJobInfo) do
    if myGuildData.level >= jobdata.limitlv then
      table.insert(self.datas, jobdata)
    end
  end
  table.sort(self.datas, GuildJobEditPopUp.SortJobInfo)
  self.jobCtl:ResetDatas(self.datas)
end

function GuildJobEditPopUp.SortJobInfo(a, b)
  return a.id < b.id
end

function GuildJobEditPopUp:OnEnter()
  GuildJobEditPopUp.super.OnEnter(self)
  self:UpdateJobInfo()
end

function GuildJobEditPopUp:OnExit()
  GuildJobEditPopUp.super.OnExit(self)
end
