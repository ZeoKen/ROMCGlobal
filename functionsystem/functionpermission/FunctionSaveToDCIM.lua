FunctionSaveToDCIM = class("FunctionSaveToDCIM")

function FunctionSaveToDCIM.Me()
  if FunctionSaveToDCIM.me == nil then
    FunctionSaveToDCIM.me = FunctionSaveToDCIM.new()
  end
  return FunctionSaveToDCIM.me
end

function FunctionSaveToDCIM:ctor()
  self.requestList = {}
  EventManager.Me():AddEventListener(PermissionEvent.RequestSuccess, self.OnPermissionRequestSuccess, self)
  EventManager.Me():AddEventListener(PermissionEvent.RequestFail, self.OnPermissionRequestFail, self)
end

function FunctionSaveToDCIM:OnPermissionRequestSuccess(code)
  if self.requestList then
    local path = self.requestList[code]
    if path then
      helplog("FunctionSaveToDCIM OnPermissionRequestSuccess. Code:", code, "Path:", path)
      local ret = ExternalInterfaces.SavePicToDCIM(path)
      helplog("SavePicToDCIM", path, ret)
      if ret then
        MsgManager.ShowMsgByID(907)
      end
      self.requestList[code] = nil
    end
  end
end

function FunctionSaveToDCIM:OnPermissionRequestFail(code)
  if self.requestList and self.requestList[code] then
    helplog("FunctionSaveToDCIM OnPermissionRequestFail. Code:", code)
    self.requestList[code] = nil
  end
end

function FunctionSaveToDCIM:TrySavePicToDCIM(path)
  local code = FunctionPermission.Me():RequestRWPermissionForA13()
  helplog("FunctionSaveToDCIM RequestReadWriteExternalStoragePermission. Code:", code, "Path:", path)
  if code == 0 then
    local ret = ExternalInterfaces.SavePicToDCIM(path)
    helplog("SavePicToDCIM", path, ret)
    if ret then
      MsgManager.ShowMsgByID(907)
    end
  else
    self.requestList[code] = path
  end
end
