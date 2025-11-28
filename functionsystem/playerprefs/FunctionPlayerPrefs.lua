FunctionPlayerPrefs = class("FunctionPlayerPrefs")

function FunctionPlayerPrefs.Me()
  if nil == FunctionPlayerPrefs.me then
    FunctionPlayerPrefs.me = FunctionPlayerPrefs.new()
  end
  return FunctionPlayerPrefs.me
end

function FunctionPlayerPrefs:ctor()
end

function FunctionPlayerPrefs:Reset()
end

function FunctionPlayerPrefs:IsInited()
  return self.user ~= nil
end

function FunctionPlayerPrefs:InitUser(user)
  self.user = user
end

function FunctionPlayerPrefs:DeleteKey(key, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  PlayerPrefs.DeleteKey(key)
end

function FunctionPlayerPrefs:SetBool(key, value, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  value = value and 1 or 0
  PlayerPrefs.SetInt(key, value)
end

function FunctionPlayerPrefs:GetBool(key, default, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  default = default and 1 or 0
  local res = PlayerPrefs.GetInt(key, default)
  return res == 1 and true or false
end

function FunctionPlayerPrefs:SetInt(key, value, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  PlayerPrefs.SetInt(key, value)
end

function FunctionPlayerPrefs:GetInt(key, default, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  local res = PlayerPrefs.GetInt(key, default)
  return res
end

function FunctionPlayerPrefs:SetFloat(key, value, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  PlayerPrefs.SetFloat(key, value)
end

function FunctionPlayerPrefs:GetFloat(key, default, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  local res = PlayerPrefs.GetFloat(key, default)
  return res
end

function FunctionPlayerPrefs:SetString(key, value, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  PlayerPrefs.SetString(key, value)
end

function FunctionPlayerPrefs:AppendString(key, value, split, userDepends)
  local res = self:GetString(key, "", userDepends)
  split = split or ""
  key = self:TryGetUserIndependentKey(key, userDepends)
  if res == nil or res == "" then
    PlayerPrefs.SetString(key, res .. value)
  else
    PlayerPrefs.SetString(key, res .. split .. value)
  end
end

function FunctionPlayerPrefs:GetString(key, default, userDepends)
  key = self:TryGetUserIndependentKey(key, userDepends)
  local res = PlayerPrefs.GetString(key, default)
  return res
end

function FunctionPlayerPrefs:Save()
  PlayerPrefs.Save()
end

function FunctionPlayerPrefs:TryGetUserIndependentKey(key, userDepends)
  if userDepends == nil then
    userDepends = true
  end
  if userDepends then
    key = self.user .. "_" .. key
  end
  return key
end
