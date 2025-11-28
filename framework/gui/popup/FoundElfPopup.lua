FoundElfPopup = class("FoundElfPopup", ContainerView)
FoundElfPopup.ViewType = UIViewType.PopUpLayer

function FoundElfPopup:Init()
  self:FindObj()
  self:AddViewEvts()
  self:InitView()
end

local field_name = {
  "found_abyss_lake_elf_num",
  "found_elf_num"
}

function FoundElfPopup.GetConfigs()
  if Game.MapManager:IsInAbyssLake() then
    return Game.abyssLakeFoundElfConfigs, field_name[1]
  end
  return Game.FoundElfConfigs, field_name[2]
end

function FoundElfPopup.GetVarType()
  return Game.MapManager:IsInAbyssLake() and Var_pb.EVARTYPE_FOUND_ABYSS_LAKE_ELF_NUM or Var_pb.EVARTYPE_FOUND_ELF_NUM
end

function FoundElfPopup:FindObj()
  self.progress_bg = self:FindGO("progress_bg"):GetComponent(UITexture)
  self.progress_fg = self:FindGO("progress_fg"):GetComponent(UITexture)
  self.progress_fg2 = self:FindGO("progress_fg2"):GetComponent(UITexture)
  self.progress_lb = self:FindGO("progress_desc"):GetComponent(UILabel)
  self.progress_animHelper = self.gameObject:GetComponent(SimpleAnimatorPlayer)
  self.progress_animHelper = self.progress_animHelper.animatorHelper
  self:AddAnimatorEvent()
end

function FoundElfPopup:AddAnimatorEvent()
  function self.progress_animHelper.actionEventListener(state, _, eventName)
    if eventName == "progress_start" then
      if self.old_p ~= self.new_p then
        self:AddMonoUpdateFunction(self.ProgressUpdateFunc)
      end
    elseif eventName == "progress_end" then
      self:RemoveMonoUpdateFunction()
    elseif eventName == "anim_end" then
      TimeTickManager.Me():CreateOnceDelayTick(300, self.CloseSelf, self)
    elseif eventName == "effect_spark" then
      self:PlayEffectSpark()
    elseif eventName == "effect_shake" then
      self:PlayEffectShake()
    end
  end
end

local lerp = NumberUtility.LerpUnclamped

function FoundElfPopup:ProgressUpdateFunc()
  local fa = lerp(self.old_p, self.new_p, self.progress_fg2.alpha)
  self.progress_fg.fillAmount = fa
  self.progress_fg2.fillAmount = fa
end

function FoundElfPopup:AddViewEvts()
  local BtnClose = self:FindGO("BtnClose")
  if BtnClose then
    self:AddClickEvent(BtnClose, function()
      self:CloseSelf()
    end)
  end
end

function FoundElfPopup:InitView()
  local var_type = FoundElfPopup.GetVarType()
  local configs, field_name = FoundElfPopup.GetConfigs()
  local found_elf_num = self.viewdata.new_var or MyselfProxy.Instance:getVarByType(var_type) and MyselfProxy.Instance:getVarByType(var_type).value or 0
  local old_var = self.viewdata.old_var or found_elf_num - 1
  local config, last_config
  for i = 1, #configs do
    if found_elf_num <= configs[i].Condition[field_name] then
      config = configs[i]
      last_config = configs[i - 1]
      break
    end
  end
  local base, length, old_p, new_p = 0
  if config then
    base = last_config and last_config.Condition[field_name] or 0
    length = config.Condition[field_name] - base
    old_p = old_var - base
    new_p = found_elf_num - base
    local next = length - new_p
    if next == 0 then
      self.progress_lb.text = string.format(ZhString.FoundElfPopup_DescGet, config.Tip)
    else
      self.progress_lb.text = string.format(ZhString.FoundElfPopup_Desc, next, config.Tip)
    end
  else
    length = 1
    old_p = 1
    new_p = 1
    self.progress_lb.text = ZhString.FoundElfPopup_Max
  end
  if old_p < 0 or new_p < 0 or old_p > new_p then
    redlog("FoundElfPopup:InitView error", old_p, new_p, length)
    old_p = 0
    new_p = 0
  end
  self:SetProgress(old_p, new_p, length)
end

local tex_path = "GUI/pic/UI/"

function FoundElfPopup:SetProgress(old_p, new_p, length)
  self.old_p = old_p / length
  self.new_p = new_p / length
  if length ~= 1 and length ~= 3 and length ~= 5 and length ~= 6 then
    length = 1
  end
  self.tex_bg = tex_path .. "tansuo_line" .. length
  self.tex_fg = tex_path .. "tansuo_line" .. length .. "_1"
  self.tex_fg2 = tex_path .. "tansuo_line" .. length .. "_2"
  Game.AssetManager_UI:LoadAsset(self.tex_bg, Texture, function(_, asset)
    if asset then
      self.progress_bg.mainTexture = asset
    end
  end)
  Game.AssetManager_UI:LoadAsset(self.tex_fg, Texture, function(_, asset)
    if asset then
      self.progress_fg.mainTexture = asset
    end
  end)
  Game.AssetManager_UI:LoadAsset(self.tex_fg2, Texture, function(_, asset)
    if asset then
      self.progress_fg2.mainTexture = asset
    end
  end)
  self.progress_fg.fillAmount = self.old_p
  self.progress_fg2.fillAmount = self.old_p
  self:PlayProgress(self.new_p == 1)
end

function FoundElfPopup:PlayProgress(is_fin)
  self.progress_animHelper:Play(is_fin and "Progress" or "Progress_2", 0.4, true)
  self:PlayUIEffect(EffectMap.UI.FoundElfPopup, self.gameObject, true)
  TimeTickManager.Me():CreateOnceDelayTick(250, function()
    if self.progressAudio == nil then
      self.progressAudio = AudioUtility.PlayLoop_At(AudioMap.UI.FoundElfPopup, 0, 0, 0, AudioSourceType.UI)
    end
  end, self)
end

function FoundElfPopup:PlayEffectSpark()
  self:PlayUIEffect(EffectMap.UI.FoundElfPopup_Spark, self.gameObject, true)
  TimeTickManager.Me():CreateOnceDelayTick(600, function()
    self:ClearAudio()
    self:PlayUISound(AudioMap.UI.FoundElfPopup_Spark)
  end, self)
end

function FoundElfPopup:PlayEffectShake()
  self:PlayUIEffect(EffectMap.UI.FoundElfPopup_Shake, self.gameObject, true)
  self:ClearAudio()
  self:PlayUISound(AudioMap.UI.FoundElfPopup_Shake)
end

function FoundElfPopup:ClearAudio()
  if self.progressAudio ~= nil then
    self.progressAudio:Stop()
    self.progressAudio = nil
  end
end

function FoundElfPopup:OnExit()
  FoundElfPopup.super.OnExit(self)
  Game.AssetManager_UI:UnLoadAsset(self.tex_fg2)
  Game.AssetManager_UI:UnLoadAsset(self.tex_fg)
  Game.AssetManager_UI:UnLoadAsset(self.tex_bg)
  TimeTickManager.Me():ClearTick(self)
  self:ClearAudio()
end

function FoundElfPopup.TryGetFoundElfNumChange(data)
  local var_type = FoundElfPopup.GetVarType()
  if data ~= nil and data.vars ~= nil then
    local vars = data.vars
    local varslen = #vars
    local treat_as_login = false
    local old_var, new_var
    for i = 1, varslen do
      local single = vars[i]
      if single and single.type == var_type then
        new_var = single.value
        old_var = MyselfProxy.Instance:getVarByType(var_type)
        old_var = old_var and old_var.value
        helplog("FoundElfPopup server new_var", new_var)
        helplog("FoundElfPopup client old_var", old_var)
        if not old_var and new_var == 1 then
          old_var = 0
        end
      elseif single and single.value and single.value ~= 0 then
        treat_as_login = true
        return
      end
    end
    if old_var ~= nil and new_var ~= nil and new_var > old_var then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "FoundElfPopup",
        view = PanelConfig.FoundElfPopup,
        new_var = new_var,
        old_var = old_var
      })
    end
  end
end
