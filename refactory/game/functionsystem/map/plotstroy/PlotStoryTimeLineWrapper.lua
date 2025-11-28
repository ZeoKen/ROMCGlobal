PlotStoryTimeLineWrapper = class("PlotStoryTimeLineWrapper")
local getmetatable = getmetatable

function PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  local param = {}
  if param_keys.Count == param_values.Count then
    local maxCnt = param_keys.Count - 1
    local k, v
    for m = 0, maxCnt do
      k = param_keys:getItem(m)
      v = param_values[m]
      if type(v) == "userdata" and getmetatable(v).__typename == "List`1" then
        local list2table = {}
        for i = 1, v.Count do
          local item = v:getItem(i - 1)
          if type(item) == "userdata" then
            local data = {}
            data.key = item.key
            data.value = tonumber(item.value) or item.value
            list2table[i] = data
          else
            list2table[i] = item
          end
        end
        param[k] = list2table
      else
        param[k] = v
      end
    end
  end
  local refParam = {}
  if reference_param then
    local refCnt = reference_param.Count - 1
    for m = 0, refCnt do
      TableUtility.ArrayPushBack(refParam, reference_param:getItem(m))
    end
  end
  param._refParam = refParam
  return param
end

function PlotStoryTimeLineWrapper.ProcessStartCMD(pqtl_id, timeline_param_keys, timeline_param_values)
  local param = PlotStoryTimeLineWrapper.parse(timeline_param_keys, timeline_param_values)
  if param then
    Game.PlotStoryManager:CSNotify_PQTLP_Start(pqtl_id, param)
  end
end

function PlotStoryTimeLineWrapper.ProcessCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, need_result, reference_param, simple_blend_info, ff_pct, ff_time)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  local param = PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  if param then
    pstls:AddStep(caster, trigger_type, action_type, param, need_result, simple_blend_info, ff_pct, ff_time)
  end
end

function PlotStoryTimeLineWrapper.ProcessPreloadCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, reference_param)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  local param = PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  if param then
    pstls:ProcessPreload(caster, trigger_type, action_type, param)
  end
end

function PlotStoryTimeLineWrapper.ProcessCurveCMD(pqtl_id, caster, curvePos, targetType)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  pstls:UpdateCurvePos(caster, curvePos, targetType)
end

function PlotStoryTimeLineWrapper.ProcessGetExtraParamCMD(pqtl_id, caster, key)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  return pstls:GetExtraParam(key)
end

function PlotStoryTimeLineWrapper.QuickFinishCMD(pqtl_id, cmds)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
end

function PlotStoryTimeLineWrapper.ResetLocalEditorGame()
end

return PlotStoryTimeLineWrapper
