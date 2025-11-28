TeamOption_SetRolePopup = class("TeamOption_SetRolePopup", ContainerView)
TeamOption_SetRolePopup.ViewType = UIViewType.Lv4PopUpLayer
autoImport("Team_RoleCell")
autoImport("SelectRoleCell")
local teamProxy
local IndexHeight = 95.3
local teampVector3 = LuaVector3.Zero()
local MaxMember = GameConfig.Team.maxmember

function TeamOption_SetRolePopup:Init()
  teamProxy = TeamProxy.Instance
  self:InitUI()
  self:AddViewInterests()
end

function TeamOption_SetRolePopup:InitUI()
  self.cursor = self:FindGO("cursor")
  local tip = self:FindGO("tip"):GetComponent(UILabel)
  tip.text = ZhString.TeamOptionPopUp_Tip
  self.preBtn = self:FindGO("preBtn")
  self.nextBtn = self:FindGO("nextBtn")
  self:AddClickEvent(self.preBtn, function()
    self:SetPre()
  end)
  self:AddClickEvent(self.nextBtn, function()
    self:SetNext()
  end)
  self:AddButtonEvent("ConfirmBtn", function(go)
    self:SendOption()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CancelBtn", function(go)
    self:CloseSelf()
  end)
  self.selects = {}
  for i = 1, 3 do
    local cellGO = self:FindGO("SelectRoleCell" .. i)
    local cell = SelectRoleCell.new(cellGO)
    cell:SetData(i)
    table.insert(self.selects, cell)
  end
  self.team1 = self:FindGO("Team1")
  self.roleGrid1 = self:FindGO("roleGrid", self.team1):GetComponent(UIGrid)
  self.roleCtrl1 = UIGridListCtrl.new(self.roleGrid1, Team_RoleCell, "Team_RoleCell")
  self.roleCtrl1:AddEventListener(MouseEvent.MouseClick, self.ClickRoleCell, self)
  self.team2 = self:FindGO("Team2")
  self.roleGrid2 = self:FindGO("roleGrid", self.team2):GetComponent(UIGrid)
  self.roleCtrl2 = UIGridListCtrl.new(self.roleGrid2, Team_RoleCell, "Team_RoleCell")
  self.roleCtrl2:AddEventListener(MouseEvent.MouseClick, self.ClickRoleCell, self)
  self.selectView = self:FindGO("selectView")
end

function TeamOption_SetRolePopup:OnEnter()
  local myTeam = teamProxy.myTeam
  local role1 = myTeam:GetRoles()
  if not teamProxy:IHaveGroup() then
    self.roleCtrl1:ResetDatas(role1)
    self.team1:SetActive(true)
    self.team2:SetActive(false)
    self.nextBtn:SetActive(false)
  else
    local uniteGroupTeam = teamProxy.uniteGroupTeam
    local role2 = uniteGroupTeam:GetRoles()
    self.roleCtrl1:ResetDatas(role1)
    self.roleCtrl2:ResetDatas(role2)
    self.team1:SetActive(true)
    self.team2:SetActive(false)
    self.nextBtn:SetActive(true)
  end
  local cells = self.roleCtrl1:GetCells()
  local flag = false
  if cells then
    for i = 1, #cells do
      if cells[i].data <= 0 then
        self:ClickRoleCell(cells[i])
        flag = true
        break
      end
    end
  end
  if not flag then
    cells = self.roleCtrl2:GetCells()
    if cells then
      for i = 1, #cells do
        if cells[i].data <= 0 then
          self:ClickRoleCell(cells[i])
          flag = true
          break
        end
      end
    end
  end
end

local tempMsg = {
  body = {}
}
local cellPos = LuaVector3.Zero()

function TeamOption_SetRolePopup:ClickRoleCell(cell)
  if cell and cell.data > 0 then
    return
  end
  if self.currentCell then
    self.currentCell:SetSelected(false)
  end
  self.currentCell = cell
  self.currentCell:SetSelected(true)
  local x, y, z = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
  LuaVector3.Better_Set(teampVector3, x, IndexHeight, 0)
  self.cursor.transform.localPosition = teampVector3
  self:ShowSelectView(true)
end

function TeamOption_SetRolePopup:ShowSelectView(v)
  self.selectView:SetActive(v == true)
  for i = 1, #self.selects do
    self.selects[i]:SetSelected(false)
  end
end

function TeamOption_SetRolePopup:AddViewInterests()
  self:AddListenEvt(TeamEvent.TeamOption_SelectRole, self.HandleSelect)
  self:AddListenEvt(TeamEvent.TeamOption_DeleteRole, self.HandleDelete)
end

function TeamOption_SetRolePopup:HandleSelect(note)
  local roleid = note.body.data
  if self.currentCell then
    self.currentCell:SetData(roleid * -1)
  end
end

function TeamOption_SetRolePopup:HandleDelete(note)
  local roleid = note.body.data
  if self.currentCell then
    self.currentCell:SetData(0)
  end
end

function TeamOption_SetRolePopup:SetPre()
  self.team1:SetActive(true)
  self.team2:SetActive(false)
  self.nextBtn:SetActive(true)
end

function TeamOption_SetRolePopup:SetNext()
  self.team1:SetActive(false)
  self.team2:SetActive(true)
  self.preBtn:SetActive(true)
end

function TeamOption_SetRolePopup:OnExit()
  TeamOption_SetRolePopup.super.OnExit(self)
end

function TeamOption_SetRolePopup:SendOption()
  local result = {}
  local cells = self.roleCtrl1:GetCells()
  local flag1, flag2 = false, false
  local id = 0
  if cells then
    for i = 1, #cells do
      id = cells[i].data
      if id < 0 then
        table.insert(result, id * -1)
        flag = true
      end
    end
  end
  if flag then
    local changeOption = {}
    local roleOption = {
      type = SessionTeam_pb.ETEAMDATA_NEED_FUNCTIONS,
      values = {}
    }
    TableUtility.ArrayShallowCopy(roleOption.values, result)
    table.insert(changeOption, roleOption)
    ServiceSessionTeamProxy.Instance:CallSetTeamOption(nil, changeOption)
  else
    redlog("flag false")
  end
  local myTeam = teamProxy.myTeam
  if myTeam and teamProxy:IHaveGroup() then
    local result2 = {}
    cells = self.roleCtrl2:GetCells()
    flag = false
    if cells then
      for i = 1, #cells do
        id = cells[i].data
        if id < 0 then
          table.insert(result2, id * -1)
          flag = true
        end
      end
    end
    if flag then
      local changeOption = {}
      local roleOption = {
        type = SessionTeam_pb.ETEAMDATA_NEED_FUNCTIONS,
        values = {}
      }
      TableUtility.ArrayShallowCopy(roleOption.values, result2)
      table.insert(changeOption, roleOption)
      ServiceSessionTeamProxy.Instance:CallSetTeamOption(nil, changeOption, myTeam.uniteteamid)
    end
  end
end
