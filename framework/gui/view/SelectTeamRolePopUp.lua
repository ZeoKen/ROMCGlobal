SelectTeamRolePopUp = class("SelectTeamRolePopUp", ContainerView)
SelectTeamRolePopUp.ViewType = UIViewType.NormalLayer
autoImport("SelectRoleCell")

function SelectTeamRolePopUp:Init()
  local title = self:FindGO("title"):GetComponent(UILabel)
  self.cancelBtn = self:FindGO("CancelBtn")
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.selectsGrid = self:FindGO("selects"):GetComponent(UIGrid)
  self.roleCtrl = UIGridListCtrl.new(self.selectsGrid, SelectRoleCell, "SelectRoleCell")
  self.roleCtrl:AddEventListener(MouseEvent.MouseClick, self.OnSelect, self)
  self:AddEvts()
end

function SelectTeamRolePopUp:AddEvts()
  self:AddClickEvent(self.cancelBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    if self.teamData and self.currentSelect then
      self:DoApply(self.teamData, self.currentSelect)
    else
      redlog("self.teamData and self.currentSelect nil", self.teamData, self.currentSelect)
    end
    self:CloseSelf()
  end)
end

function SelectTeamRolePopUp:DoApply(teamData, role)
  local _TeamProxy = TeamProxy.Instance
  local _haveTeam = _TeamProxy:IHaveTeam()
  local teamCheck, groupCheck = teamData:CheckValidRole(true, role)
  if TeamProxy.IsGroupTeamGoal(teamData.type) then
    if _haveTeam and teamData:IsGroupTeam() then
      redlog("return")
      return
    end
    if not _haveTeam then
      if teamData:IsGroupTeam() then
        if teamCheck then
          ServiceSessionTeamProxy.Instance:CallTeamMemberApply(teamData.id, self.currentSelect)
          return
        elseif groupCheck then
          ServiceSessionTeamProxy.Instance:CallTeamMemberApply(teamData.uniteteamid, self.currentSelect)
          return
        end
      elseif teamCheck then
        ServiceSessionTeamProxy.Instance:CallTeamMemberApply(teamData.id, self.currentSelect)
        return
      end
    else
      ServiceSessionTeamProxy.Instance:CallTeamGroupApplyTeamCmd(teamData.id, nil, false)
      return
    end
  elseif teamCheck then
    ServiceSessionTeamProxy.Instance:CallTeamMemberApply(teamData.id, self.currentSelect)
    return
  end
  MsgManager.ShowMsgByID(28102)
end

function SelectTeamRolePopUp:OnEnter()
  local myroles = MyselfProxy.Instance:GetMyTeamRoles()
  if not next(myroles) then
    return
  end
  self.roleCtrl:ResetDatas(myroles)
  local param = self.viewdata.viewdata
  self.teamguid = param and param[1]
  self.teamData = param and param[2]
  redlog("self.self.viewdata.", self.teamguid, self.teamData)
  local cells = self.roleCtrl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetSelected(false)
    end
  end
end

function SelectTeamRolePopUp:OnSelect(cell)
  if cell and cell.toggle then
    cell.toggle.value = true
    self.currentSelect = cell.data
    self.currentSelect = cell.data
  end
end

function SelectTeamRolePopUp:SelectRole()
  if self.currentSelect then
  end
end
