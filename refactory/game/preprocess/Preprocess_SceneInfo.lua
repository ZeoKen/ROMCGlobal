function Game.DoPreprocess_ScenePartInfo(info, sceneInfoName)
  if nil == info then
    return
  end
  local map = Game.PreprocessHelper_BuildMap(info.bps, "ID")
  if nil ~= map then
    info.bpMap = map
  end
  if info.eps then
    local myBranchValue = EnvChannel.BranchBitValue[EnvChannel.Channel.Name]
    local ep, forbidBranch, fit
    local _checkFuncStateValid = FunctionUnLockFunc.checkFuncStateValid
    local _arrayFindIndex = TableUtility.ArrayFindIndex
    local _forbidden_Eps = GameConfig.FuncState_eps_func and GameConfig.FuncState_eps_func.eps
    for i = #info.eps, 1, -1 do
      ep = info.eps[i]
      if ep.nextSceneID and GameConfig.Map_BranchForbid then
        fit = false
        for k, v in pairs(GameConfig.Map_BranchForbid) do
          forbidBranch = v[ep.nextSceneID]
          if forbidBranch and 0 < forbidBranch & myBranchValue then
            fit = true
          end
        end
        if fit == false and nil ~= sceneInfoName and _forbidden_Eps then
          local funcStateID = _forbidden_Eps[sceneInfoName]
          if nil ~= funcStateID and not _checkFuncStateValid(funcStateID) then
            local forbiddenEps = Table_FuncState[funcStateID] and Table_FuncState[funcStateID].Param
            if forbiddenEps and 0 ~= _arrayFindIndex(forbiddenEps, ep.ID) then
              fit = true
            end
          end
        end
        if fit == false and ep.nextSceneID and ep.nextSceneID > 0 and not Table_Map[ep.nextSceneID] then
          fit = true
        end
      end
      if fit then
        table.remove(info.eps, i)
      end
    end
  end
  map = Game.PreprocessHelper_BuildMap(info.eps, "ID")
  if nil ~= map then
    info.epMap = map
  end
  map = Game.PreprocessHelper_BuildMap(info.nps, "uniqueID")
  if nil ~= map then
    info.npMap = map
  end
  if info.onps ~= nil then
    map = Game.PreprocessHelper_BuildMap(info.onps, "uniqueID")
    if nil ~= map then
      info.onpMap = map
    end
  end
end

function Game.DoPreprocess_SceneInfo(info)
  if nil == info then
    return
  end
  Game.DoPreprocess_ScenePartInfo(info.PVE)
  Game.DoPreprocess_ScenePartInfo(info.PVP)
  if nil ~= info.Raids then
    for k, v in pairs(info.Raids) do
      Game.DoPreprocess_ScenePartInfo(v)
    end
  end
end

function Game.Preprocess_SceneInfo()
  if nil ~= Table_Map then
    for k, v in pairs(Table_Map) do
      if nil ~= v.Type or v.Type > 0 then
        local sceneName = v.NameEn
        if nil ~= sceneName and nil == SceneInfo[sceneName] then
          SceneInfo[sceneName] = autoImport("Scene_" .. sceneName)
        end
      end
    end
  end
  for k, v in pairs(SceneInfo) do
    Game.DoPreprocess_SceneInfo(v)
  end
end
