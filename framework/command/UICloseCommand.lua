UICloseCommand = class("UICloseCommand", pm.SimpleCommand)

function UICloseCommand:execute(note)
  if note.body == nil then
    error("not send view Type!")
  end
  if type(note.body) == "string" then
    UIManagerProxy.Instance:CloseUIByClassName(note.body)
    return
  end
  if type(note.body) == "table" and note.body.className then
    UIManagerProxy.Instance:CloseUIByClassName(note.body.className, note.body.needRollBack)
    return
  end
  local closeWholeLayer = note.body.__cname == nil
  if closeWholeLayer then
    UIManagerProxy.Instance:CloseLayerAllChildren(note.body)
  else
    UIManagerProxy.Instance:CloseUI(note.body)
  end
end

function UICloseCommand:ExitView(viewCtl, callBack)
  local config = viewCtl.ViewType
  local exitAnim
  if config.exitAnim ~= nil then
    exitAnim = UIAnimMap[config.exitAnim]
  end
  if exitAnim ~= nil then
    exitAnim(viewCtl.gameObject, function()
      viewCtl:OnExit()
      if callBack ~= nil then
        callBack()
      end
    end)
  else
    viewCtl:OnExit()
    GameObject.Destroy(viewCtl.gameObject)
    if callBack ~= nil then
      callBack()
    end
  end
end
