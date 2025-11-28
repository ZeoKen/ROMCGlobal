ExchangeTypesData = class("ExchangeTypesData")

function ExchangeTypesData:ctor(data)
  self:SetData(data)
end

function ExchangeTypesData:SetData(data)
  self.id = data.id
  self.name = data.Name
  if data.JobOption then
    self.jobOption = data.JobOption
  end
  if data.LevelOption then
    self.levelOption = data.LevelOption
  end
  if data.RefineOption then
    self.refineOption = data.RefineOption
  end
  if data.LockOption then
    self.LockOption = data.LockOption
  end
  self.FuncStateID = data.FuncStateID
end

function ExchangeTypesData:IsFuncstateValid()
  if not self.FuncStateID or self.FuncStateID == 0 then
    return true
  end
  return FunctionUnLockFunc.checkFuncStateValid(self.FuncStateID)
end
