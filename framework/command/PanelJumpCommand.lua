PanelJumpCommand = class("PanelJumpCommand", pm.SimpleCommand)
autoImport("OverseaFFKK")

function PanelJumpCommand:execute(note)
  local body = note.body
  if body and body.view then
    local panelData = body.view
    if type(panelData) == "number" then
      panelData = PanelProxy.Instance:GetData(panelData)
    end
    if panelData then
      self:TryShowPanel(panelData, body.viewdata, body.force)
    end
  end
end

function PanelJumpCommand:TryShowPanel(data, vdata, force)
  local isSuccess = false
  if force == nil then
    force = false
  end
  LogUtility.InfoFormat("尝试打开id:{0},{1}界面", data.id, data.name, data.prefab)
  OverseaFFKK:CatchHook(data.id .. data.name)
  if force or FunctionUnLockFunc.Me():CheckCanOpenByPanelId(data.id, false) then
    local uidata = {view = data, viewdata = vdata}
    UIManagerProxy.Instance:ShowUIByConfig(uidata)
    isSuccess = true
  else
    self:UnOpenJump(data, vdata)
  end
  GameFacade.Instance:sendNotification(UIEvent.FinishJump, isSuccess)
end

function PanelJumpCommand:UnOpenJump(config, vdata)
  if config.unOpenJump then
    config = PanelProxy.Instance:GetData(config.unOpenJump)
    if config then
      LogUtility.InfoFormat("界面{0},{1}未开启", config.id, config.name)
      self:TryShowPanel(config, vdata)
    end
  else
    FunctionUnLockFunc.Me():CheckCanOpenByPanelId(config.id, true)
  end
end
