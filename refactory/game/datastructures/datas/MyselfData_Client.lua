MyselfData.ClientProps = {
  DisableSkill = "DisableSkill",
  SelfEnsemble = "SelfEnsemble",
  DisableRotateInPhotographMode = "DisableRotateInPhotographMode"
}

function MyselfData:Reset()
  MyselfData.super.Reset(self)
  for k, v in pairs(MyselfData.ClientProps) do
    self[v] = nil
  end
end

function MyselfData:Client_SetProps(propsName, value)
  local props = self[propsName] or 0
  props = props + (value and 1 or -1)
  self[propsName] = props
end

function MyselfData:Client_GetProps(propsName)
  local props = self[propsName] or 0
  return 0 < props
end

function MyselfData:Client_ResetProps(propsName)
  self[propsName] = nil
end
