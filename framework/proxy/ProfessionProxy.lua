local _TableClear = TableUtility.TableClear
local _TableShallowCopy = TableUtility.TableShallowCopy
local _ArrayFindIndex = TableUtility.ArrayFindIndex
ProfessionProxy = class("ProfessionProxy", pm.Proxy)
ProfessionProxy.Instance = nil
ProfessionProxy.NAME = "ProfessionProxy"
ProfessionProxy.RootClass = {
  [1] = 1,
  [150] = 150
}
ProfessionProxy.NoviceC2S = {
  [1] = 1000,
  [150] = 2000
}
ProfessionProxy.NoviceBranches = {
  [1000] = 1,
  [2000] = 1
}
ProfessionProxy.CommonClass = 500
ProfessionProxy.ClassState = {
  State1 = 1,
  State2 = 2,
  State3 = 3,
  State4 = 4,
  State5 = 5,
  State6 = 6,
  State7 = 7,
  State8 = 8
}
local TICKETPACKAGECHECK, _GameConfigHeroShop

function ProfessionProxy:ctor(proxyName, data)
  TICKETPACKAGECHECK = GameConfig.PackageMaterialCheck.buy_profession
  _GameConfigHeroShop = GameConfig.HeroShop and GameConfig.HeroShop.Items
  self.proxyName = proxyName or ProfessionProxy.NAME
  if ProfessionProxy.Instance == nil then
    ProfessionProxy.Instance = self
  end
  self.professionMap = {}
  self.raceFaceInfo = {}
  self:ParseStaticInfo()
  self:ParseProfession()
  self.fashionSetIndex = 1
end

function ProfessionProxy:ReInit()
  TICKETPACKAGECHECK = GameConfig.PackageMaterialCheck.buy_profession
  _GameConfigHeroShop = GameConfig.HeroShop and GameConfig.HeroShop.Items
  self.professionMap = {}
  self.raceFaceInfo = {}
  self:ParseStaticInfo()
  self:ParseProfession()
  self.fashionSetIndex = 1
end

function ProfessionProxy:ParseStaticInfo()
  ProfessionProxy.humanNovice = 1
  ProfessionProxy.doramNovice = 150
  ProfessionProxy.humanTypical1st = 11
  ProfessionProxy.doramTypical1st = 151
  ProfessionProxy.MultiSexJob1st = {41}
  ProfessionProxy.superNovice = GameConfig.SuperNovice.ClassId
  ProfessionProxy.moshentandoushiJob = 203
  ProfessionProxy.shenlongdoushiJob = 213
  ProfessionProxy.ninjaJob = 163
  ProfessionProxy.xiudoumodaoshiJob = 223
  ProfessionProxy.marksman = 173
  ProfessionProxy.SoulLinker = 183
  ProfessionProxy.Tawkwon = 193
  ProfessionProxy.Thanatos = 605
  ProfessionProxy.NedHoge = 615
  ProfessionProxy.Saitama = 625
  ProfessionProxy.Genos = 635
  ProfessionProxy.Hela = 645
  ProfessionProxy.RichMan = 655
  ProfessionProxy.Rathgricy = 665
  ProfessionProxy.Jormungandr = 675
  ProfessionProxy.Heinrich = 685
  ProfessionProxy.Elf = 695
  ProfessionProxy.Thor = 705
  ProfessionProxy.Fenrir = 715
  ProfessionProxy.Khalitzburg = 725
  ProfessionProxy.SaraIrena = 735
  ProfessionProxy.Elynia = 745
  ProfessionProxy.Cook = 755
  ProfessionProxy.Morocc = 765
  ProfessionProxy.Sunshine = 775
  ProfessionProxy.Nameless = 785
  ProfessionProxy.Kafra = 795
  ProfessionProxy.specialDepthJobs = {
    ProfessionProxy.moshentandoushiJob,
    ProfessionProxy.shenlongdoushiJob,
    ProfessionProxy.ninjaJob,
    ProfessionProxy.xiudoumodaoshiJob,
    ProfessionProxy.marksman,
    ProfessionProxy.SoulLinker,
    ProfessionProxy.Tawkwon,
    ProfessionProxy.Thanatos,
    ProfessionProxy.NedHoge,
    ProfessionProxy.Saitama,
    ProfessionProxy.Genos,
    ProfessionProxy.Hela,
    ProfessionProxy.RichMan,
    ProfessionProxy.Rathgricy,
    ProfessionProxy.Jormungandr,
    ProfessionProxy.Heinrich,
    ProfessionProxy.Elf,
    ProfessionProxy.Thor,
    ProfessionProxy.Fenrir,
    ProfessionProxy.Khalitzburg,
    ProfessionProxy.SaraIrena,
    ProfessionProxy.Elynia,
    ProfessionProxy.Cook,
    ProfessionProxy.Morocc,
    ProfessionProxy.Sunshine,
    ProfessionProxy.Nameless,
    ProfessionProxy.Kafra
  }
  ProfessionProxy.specialJobs = {
    ProfessionProxy.superNovice,
    ProfessionProxy.moshentandoushiJob,
    ProfessionProxy.shenlongdoushiJob,
    ProfessionProxy.xiudoumodaoshiJob,
    ProfessionProxy.ninjaJob,
    ProfessionProxy.marksman,
    ProfessionProxy.SoulLinker,
    ProfessionProxy.Tawkwon,
    ProfessionProxy.Thanatos,
    ProfessionProxy.NedHoge,
    ProfessionProxy.Saitama,
    ProfessionProxy.Genos,
    ProfessionProxy.Hela,
    ProfessionProxy.RichMan,
    ProfessionProxy.Rathgricy,
    ProfessionProxy.Jormungandr,
    ProfessionProxy.Heinrich,
    ProfessionProxy.Elf,
    ProfessionProxy.Thor,
    ProfessionProxy.Fenrir,
    ProfessionProxy.Khalitzburg,
    ProfessionProxy.SaraIrena,
    ProfessionProxy.Elynia,
    ProfessionProxy.Cook,
    ProfessionProxy.Morocc,
    ProfessionProxy.Sunshine,
    ProfessionProxy.Nameless,
    ProfessionProxy.Kafra
  }
  for i = #ProfessionProxy.specialJobs, 1, -1 do
    if not Table_Class[ProfessionProxy.specialJobs[i]] then
      table.remove(ProfessionProxy.specialJobs, i)
    end
  end
  if not ProfessionProxy.specialJobsRawType then
    ProfessionProxy.specialJobsRawType = {}
    for i = 1, #ProfessionProxy.specialJobs do
      local sp = ProfessionProxy.specialJobs[i]
      ProfessionProxy.specialJobsRawType[math.floor(sp / 10)] = 1
    end
  end
  if not ProfessionProxy.specialJobBranches then
    ProfessionProxy.specialJobBranches = {}
    for i = 1, #ProfessionProxy.specialJobs do
      local sp = ProfessionProxy.specialJobs[i]
      local typeBranch = Table_Class[sp] and Table_Class[sp].TypeBranch or nil
      if typeBranch then
        ProfessionProxy.specialJobBranches[typeBranch] = 1
      end
    end
  end
  ProfessionProxy.typical4th = 15
  if Table_Class[ProfessionProxy.typical4th] and Table_Class[ProfessionProxy.typical4th].IsOpen ~= 0 then
    ProfessionProxy.Forbid4th = false
  else
    ProfessionProxy.Forbid4th = true
  end
end

function ProfessionProxy:ParseProfession()
  self.professTreeByTypes = {}
  local rootClass, rootProfession
  for k, v in pairs(ProfessionProxy.RootClass) do
    rootClass = Table_Class[k]
    rootProfession = ProfessionData.new(rootClass)
    if rootClass then
      self.professionMap[k] = rootProfession
      for i = 1, #rootClass.AdvanceClass do
        self:_ParseProfession(rootClass.AdvanceClass[i], 1, rootProfession)
      end
    end
  end
  local specialJobId
  for i = 1, #ProfessionProxy.specialJobs do
    specialJobId = ProfessionProxy.specialJobs[i]
    if ProfessionProxy.IsHumanRace(specialJobId) then
      rootProfession = self.professionMap[ProfessionProxy.humanNovice]
    elseif ProfessionProxy.IsDoramRace(specialJobId) then
      rootProfession = self.professionMap[ProfessionProxy.doramNovice]
    end
    self:_ParseProfession(specialJobId, 3, rootProfession)
  end
end

function ProfessionProxy:_ParseProfession(classid, depth, rootProfession)
  local class = Table_Class[classid]
  if class then
    local profession = ProfessionData.new(class, depth or 1)
    self.professionMap[class.id] = profession
    local tree = ProfessionTree.new(rootProfession, profession)
    self:ParseNextProfession(tree, profession)
    self.professTreeByTypes[class.Type] = tree
  end
end

function ProfessionProxy:ParseNextProfession(tree, profession)
  local parentClass, class, p = profession.data
  if parentClass.AdvanceClass then
    for i = 1, #parentClass.AdvanceClass do
      class = Table_Class[parentClass.AdvanceClass[i]]
      if class ~= nil then
        p = ProfessionData.new(class)
        self.professionMap[class.id] = p
        profession:AddNext(p)
        self:ParseNextProfession(tree, p)
      end
    end
  end
end

function ProfessionProxy:GetProfessionTreeByType(t)
  if t == 0 then
    return nil
  else
    return self.professTreeByTypes[t]
  end
end

function ProfessionProxy:GetProfessionTreeByClassId(classID)
  local class = Table_Class[classID]
  return class and self:GetProfessionTreeByType(class.Type) or nil
end

function ProfessionProxy:GetDepthByClassId(classID)
  local tree = self:GetProfessionTreeByClassId(classID)
  if not tree then
    return 0
  else
    local p = tree:GetProfessDataByClassID(classID)
    if p then
      return p.depth
    end
  end
end

function ProfessionProxy:GetThisIdPreviousId(id)
  for k, v in pairs(Table_Class) do
    local advanceTable = v.AdvanceClass
    if advanceTable then
      for k1, v1 in pairs(advanceTable) do
        if id == v1 then
          return v.id
        end
      end
    end
  end
  return nil
end

function ProfessionProxy:GetThisIdJiuZhiTiaoJianLevel(id)
  local conf = Table_Class[id]
  if conf and conf.AdvancedJobOccupation then
    return conf.AdvancedJobOccupation
  end
  redlog("ProfessionProxy:GetThisIdJiuZhiTiaoJianLevel", id, "找不到AdvancedJobOccupation字段")
  if ProfessionProxy.GetSpecialJobDepth(id) == 4 then
    return 70
  end
  local previousId = self:GetThisIdPreviousId(id)
  if previousId then
    local previousData = Table_Class[previousId]
    if previousData.MaxPeak then
      local doublePreId = self:GetThisIdPreviousId(previousId)
      if doublePreId then
        local minus = Table_Class[doublePreId].MaxPeak or Table_Class[doublePreId].MaxJobLevel
        return previousData.MaxPeak - minus
      else
        helplog("GetThisIdJiuZhiTiaoJianLevel(id) 检查配置表 id:" .. id .. "\t和这个id相关联的地方配置有误！！！")
      end
    else
      return Table_Class[id].MaxJobLevel - previousData.MaxJobLevel
    end
  else
    helplog("GetThisIdJiuZhiTiaoJianLevel(id) 检查配置表")
  end
end

function ProfessionProxy:GetThisIdJiuZhiBaseLevel(id)
  local classConfig = Table_Class[id]
  if not classConfig then
    return
  end
  if classConfig.AdvancedOccupation and classConfig.AdvancedOccupation.BaseLv then
    return classConfig.AdvancedOccupation.BaseLv
  end
end

function ProfessionProxy:GetThisJobLevelForClient(id, level)
  if ProfessionProxy.IsHero(id) then
    return level
  end
  if id == 1 then
  elseif id ~= 1 then
    if id % 10 == 1 then
      return level - 10
    elseif id % 10 == 2 then
      return level - 50
    elseif id % 10 == 3 then
      return level - 90
    elseif id % 10 == 4 then
      return level - 160
    elseif id % 10 == 5 then
      return level - 220
    else
      helplog("服务器发了错误的东西！！")
    end
  end
  if level < 0 then
    helplog("服务器发了错误的东西！！ 请后端大佬检查代码！！ ")
  end
  return level
end

function ProfessionProxy:GetPreviousProfess(pro)
  local p = self.professionMap[pro]
  if p then
    return p.parentProfession
  end
  return nil
end

function ProfessionProxy:GetAllDepth2PlusJobs()
  self.depth2PlusJobs = self.depth2PlusJobs or {}
  if not next(self.depth2PlusJobs) then
    for id, _ in pairs(Table_Class) do
      if self.GetJobDepth(id) >= 2 then
        table.insert(self.depth2PlusJobs, id)
      end
    end
  end
  return self.depth2PlusJobs
end

function ProfessionProxy:RecvUpdateBranchInfoUserCmd(data)
  BranchInfoSaveProxy.Instance:RecvUpdateBranchInfoUserCmd(data)
end

function ProfessionProxy:RecvProfessionChangeUserCmd(data)
  self.topScrollViewIconTable = nil
  self.multiProfessionList = nil
end

function ProfessionProxy:RecvProfessionBuyUserCmd(data)
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd(nil)
end

function ProfessionProxy:SetCurProfessionUserInfo(data)
  self.CurProfessionUserInfo = data
end

function ProfessionProxy:GetCurProfessionUserInfo()
  return self.CurProfessionUserInfo or nil
end

function ProfessionProxy.GetProfessionName(prof, sex)
  local sData, rslt = Table_Class[prof], ""
  if sData then
    sex = sex or 1
    if sex == 2 then
      rslt = sData.NameZhFemale
    end
    if StringUtil.IsEmpty(rslt) then
      rslt = sData.NameZh
    end
  end
  return rslt
end

function ProfessionProxy.GetProfessionNameFromSocialData(socialData)
  if type(socialData) ~= "table" then
    return ""
  end
  return ProfessionProxy.GetProfessionName(socialData.profession, socialData.gender)
end

function ProfessionProxy.GetProfessionNameEn(prof, sex)
  local sData, rslt = Table_Class[prof], ""
  if sData then
    sex = sex or 1
    if sex == 2 then
      rslt = sData.NameEnFemale
    end
    if StringUtil.IsEmpty(rslt) then
      rslt = sData.NameEn
    end
  end
  return rslt
end

function ProfessionProxy:RecvProfessionQueryUserCmd(data)
  xdlog("RecvProfessionQueryUserCmd")
  self.topScrollViewIconTable = nil
  self.multiProfessionList = nil
  self.ProfessionQueryUserTable = {}
  ProfessionProxy.Instance:SetCurTypeBranch(data ~= nil and data.body ~= nil and data.body.curbranch)
  if not self.server_novice_branch_convert_patch then
    self.server_novice_branch_convert_patch = {}
  else
    TableUtility.TableClear(self.server_novice_branch_convert_patch)
  end
  if data ~= nil and data.body ~= nil and data.body.items ~= nil then
    local items = data.body.items
    local str = "ProfessionQueryUserCmd: \n"
    local formatStr = "Branch:%s, Prof:%s"
    for i = 1, #items do
      local data = items[i]
      str = str .. string.format(formatStr, data.branch, data.profession) .. "\n"
      local client_use_novice_branch = self.NoviceC2S[data.profession]
      if client_use_novice_branch and data.branch ~= client_use_novice_branch then
        self.server_novice_branch_convert_patch[client_use_novice_branch] = data.branch
        data.branch = client_use_novice_branch
      end
    end
    xdlog(str)
  end
  if data ~= nil and data.body ~= nil and data.body.items ~= nil then
    local items = data.body.items
    local haveFoundOriginBranch = false
    for i = 1, #items do
      local data = items[i]
      if data.isbuy == nil then
        helplog("isbuy 服务器没发！！！！")
      end
      local Isjust1stJob
      data.branch, Isjust1stJob = self.ProcessNoviceBranchValueS2C(data.branch, data.profession)
      self.ProfessionQueryUserTable[data.branch] = {}
      self.ProfessionQueryUserTable[data.branch].branch = data.branch
      self.ProfessionQueryUserTable[data.branch].profession = data.profession
      self.ProfessionQueryUserTable[data.branch].joblv = data.joblv
      self.ProfessionQueryUserTable[data.branch].isbuy = data.isbuy
      if data.branch == self.curTypeBranch then
        self.ProfessionQueryUserTable[data.branch].iscurrent = true
      end
      if Isjust1stJob == true then
        self.ProfessionQueryUserTable[data.branch].Isjust1stJob = true
      end
      if data.isbuy == false then
        haveFoundOriginBranch = true
      end
    end
    local haveFoundCurrentProf = false
    local curId = MyselfProxy:GetMyProfession()
    for _, v in pairs(self.ProfessionQueryUserTable) do
      if v.profession == curId then
        haveFoundCurrentProf = true
        break
      end
    end
    if not haveFoundCurrentProf then
      local curClassData = Table_Class[curId]
      if haveFoundOriginBranch == false or not self.ProfessionQueryUserTable[curClassData.TypeBranch] then
        self.ProfessionQueryUserTable[curClassData.TypeBranch] = {}
        self.ProfessionQueryUserTable[curClassData.TypeBranch].branch = curClassData.TypeBranch
        self.ProfessionQueryUserTable[curClassData.TypeBranch].profession = curId
        self.ProfessionQueryUserTable[curClassData.TypeBranch].joblv = MyselfProxy.Instance:JobLevel()
        self.ProfessionQueryUserTable[curClassData.TypeBranch].isbuy = false
        self.ProfessionQueryUserTable[curClassData.TypeBranch].iscurrent = true
        ProfessionProxy.Instance:SetCurTypeBranch(curClassData.TypeBranch)
      elseif curId > self.ProfessionQueryUserTable[curClassData.TypeBranch].profession then
        self.ProfessionQueryUserTable[curClassData.TypeBranch].profession = curId
        self.ProfessionQueryUserTable[curClassData.TypeBranch].joblv = MyselfProxy.Instance:JobLevel()
        self.ProfessionQueryUserTable[curClassData.TypeBranch].iscurrent = true
        ProfessionProxy.Instance:SetCurTypeBranch(curClassData.TypeBranch)
      end
    end
    if not self.curTypeBranch and self.GetJobDepth() == 1 then
      local curClassData = Table_Class[curId]
      local tempBranchData = Table_Branch[curClassData.TypeBranch]
      local raw_brotherList = string.split(tempBranchData.brother_list, ",")
      local brotherBranch, brotherBranchData
      for i = 1, #raw_brotherList do
        brotherBranch = tonumber(raw_brotherList[i])
        brotherBranchData = Table_Branch[brotherBranch]
        if (not brotherBranchData.gender or brotherBranchData.gender == self:GetCurSex()) and self.ProfessionQueryUserTable[brotherBranch] then
          self.ProfessionQueryUserTable[brotherBranch].iscurrent = true
          ProfessionProxy.Instance:SetCurTypeBranch(brotherBranch)
          break
        end
      end
    end
    self.hasdora = false
    self.hashuman = false
    self.hasdora2nd = false
    self.hashuman2nd = false
    for _, v in pairs(self.ProfessionQueryUserTable) do
      local prof = v.profession
      if ProfessionProxy.IsDoramRace(prof) and not ProfessionProxy.IsNovice(prof) then
        self.hasdora = true
        if self.GetJobDepth(prof) >= 2 then
          self.hasdora2nd = true
        end
      elseif ProfessionProxy.IsHumanRace(prof) and not ProfessionProxy.IsNovice(prof) then
        self.hashuman = true
        if self.GetJobDepth(prof) >= 2 then
          self.hashuman2nd = true
        end
      end
    end
  end
  if data ~= nil and data.body ~= nil and data.body.datas ~= nil then
    local raceInfo = data.body.datas
    for i = 1, #raceInfo do
      local data = raceInfo[i]
      if not self.raceFaceInfo[data.race] then
        self.raceFaceInfo[data.race] = {}
      end
      self.raceFaceInfo[data.race].hair = data.hair
      self.raceFaceInfo[data.race].eye = data.eye
    end
  end
  local str = ""
  local format = "JobID：%s, BranchID:%s, isBuy:%s, isCurrent:%s, Isjust1stJob:%s"
  for k, v in pairs(self.ProfessionQueryUserTable) do
    str = str .. string.format(format, v.profession, v.branch, v.isbuy, v.iscurrent, v.Isjust1stJob) .. "\n"
  end
  helplog(str)
end

function ProfessionProxy:HasMPInfo()
  if self.ProfessionQueryUserTable then
    local c = 0
    for k, v in pairs(self.ProfessionQueryUserTable) do
      c = c + 1
    end
    return 1 < c
  end
end

function ProfessionProxy:GetProfessionRaceFaceInfo(race)
  if self.raceFaceInfo[race] then
    return self.raceFaceInfo[race].hair, self.raceFaceInfo[race].eye
  elseif GameConfig.Profession.race_info and GameConfig.Profession.race_info[race] then
    local defaultRaceInfo = GameConfig.Profession.race_info[race]
    if self:GetCurSex() == 1 then
      return defaultRaceInfo.male_hair, defaultRaceInfo.male_eye
    else
      return defaultRaceInfo.female_hair, defaultRaceInfo.female_eye
    end
  end
end

function ProfessionProxy:ReplaceUserDataByProfession(userdata, profession)
  local ori_profession = userdata:Get(UDEnum.PROFESSION)
  local sex = userdata:Get(UDEnum.SEX)
  local ori_race = self.GetRaceByProfession(ori_profession)
  local race = self.GetRaceByProfession(profession)
  if race ~= ori_race then
    local classpfn = Table_Class[profession]
    local body = sex == 1 and classpfn.MaleBody or classpfn.FemaleBody
    local hair, eye = self:GetProfessionRaceFaceInfo(race)
    return body, hair, eye
  end
end

function ProfessionProxy.GetOriginalEye(eyeid, bodyid)
  local eyeSex
  local bodyData = Table_Body[bodyid]
  local bodyFeature = bodyData and bodyData.Feature
  if bodyFeature and bodyFeature & FeatureDefines_Body.Fashion > 0 then
    eyeSex = 0 < bodyFeature & FeatureDefines_Body.Female and Asset_Role.Gender.Female or Asset_Role.Gender.Male
  end
  local eyeConfig = Table_Eye[eyeid]
  if eyeSex and eyeConfig and eyeConfig.Sex ~= eyeSex then
    local pairItem = eyeConfig.PairItemID
    return pairItem
  else
    return eyeid
  end
end

function ProfessionProxy:GetProfessionQueryUserTable()
  return self.ProfessionQueryUserTable or {}
end

function ProfessionProxy:GetHighestProfessionByTypeBranch(typeBranch)
  if not self.ProfessionQueryUserTable then
    return
  end
  return self.ProfessionQueryUserTable[typeBranch] and self.ProfessionQueryUserTable[typeBranch].profession
end

function ProfessionProxy:HasHumanNoviceInfo()
  if not self.ProfessionQueryUserTable then
    return
  end
  if self.ProfessionQueryUserTable[0] and self.ProfessionQueryUserTable[0].profession == self.humanNovice then
    return true
  end
end

function ProfessionProxy:HasDoramNoviceInfo()
  if not self.ProfessionQueryUserTable then
    return
  end
  if self.ProfessionQueryUserTable[0] and self.ProfessionQueryUserTable[0].profession == self.doramNovice then
    return true
  end
end

function ProfessionProxy:GetGeneraData()
  local datas = {}
  for i = 1, #GameConfig.BaseAttrConfig do
    local data = {}
    local single = GameConfig.BaseAttrConfig[i]
    local prop = Game.Myself.data.props:GetPropByName(single)
    local extraP = MyselfProxy.Instance.extraProps:GetPropByName(single)
    local data = {}
    data.prop = prop
    data.extraP = extraP
    if self.attr then
      data.addData = self.attr[prop.propVO.id] or 0
      local maxProp = Game.Myself.data.props:GetPropByName("Max" .. data.prop.propVO.name)
      maxProp = maxProp and maxProp.propVO or nil
      maxProp = maxProp and maxProp.id or -999
      data.maxAddData = self.attr[maxProp] or 0
    end
    data.type = BaseAttributeView.cellType.normal
    table.insert(datas, data)
  end
  return datas
end

function ProfessionProxy:SetCurTypeBranch(curTypeBranch)
  self.curTypeBranch = curTypeBranch
end

function ProfessionProxy:GetCurTypeBranch()
  return self.curTypeBranch
end

function ProfessionProxy:GetFixedData()
  local datas = AdventureDataProxy.Instance:GetAllFixProp()
  if 0 < #datas then
    table.sort(datas, function(l, r)
      return l.prop.propVO.id < r.prop.propVO.id
    end)
  else
  end
  return datas
end

function ProfessionProxy:IsThisIdYiJiuZhi(id)
  if not id then
    return false
  end
  local curOcc = Game.Myself.data:GetCurOcc()
  self.curProfessionId = curOcc.profession
  if self.curProfessionId == id then
    return true
  end
  local curProfessionData = Table_Class[self.curProfessionId]
  local thisIdClassData = Table_Class[id]
  if curProfessionData == nil then
    return false
  end
  if thisIdClassData == nil then
    return false
  end
  local serverData = ProfessionProxy.Instance:GetProfessionQueryUserTable()[thisIdClassData.TypeBranch]
  if serverData then
    if id <= serverData.profession then
      return true
    else
      return false
    end
  else
    if self.GetJobDepth(id) == 1 then
      local advanceClassIdTable, sData = thisIdClassData.AdvanceClass
      for k, v in pairs(advanceClassIdTable) do
        sData = Table_Class[v] and ProfessionProxy.Instance:GetProfessionQueryUserTable()[Table_Class[v].TypeBranch]
        if sData and id <= sData.profession then
          return true
        end
      end
    end
    return false
  end
  if self.GetJobDepth(id) == 1 then
    if curProfessionData.Type == thisIdClassData.Type then
      return true
    end
  elseif self.GetJobDepth(id) >= 2 and curProfessionData.TypeBranch == thisIdClassData.TypeBranch and id <= self.curProfessionId then
    return true
  end
  return false
end

function ProfessionProxy:IsThisIdYiGouMai(id)
  local curOcc = Game.Myself.data:GetCurOcc()
  if curOcc and curOcc.professionData and curOcc.professionData.TypeBranch then
    self.curProfessionId = curOcc.profession
    local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
    for k, v in pairs(S_ProfessionDatas) do
      if v.iscurrent then
        self.curTypeBranch = v.branch
      end
    end
    local jobDepth = self.GetJobDepth(id)
    if jobDepth == 1 then
      local thisIdClassData, SClassData = Table_Class[id]
      for k, v in pairs(ProfessionProxy.Instance:GetProfessionQueryUserTable()) do
        SClassData = Table_Class[v.profession]
        if SClassData and thisIdClassData.Type == SClassData.Type then
          return true
        end
      end
    elseif 2 <= jobDepth then
      local thisIdClassData = Table_Class[id]
      local thisIdBranch = thisIdClassData and thisIdClassData.TypeBranch
      local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      if S_table[thisIdBranch] ~= nil and not S_table[thisIdBranch].Isjust1stJob then
        return true
      end
      if thisIdClassData and self.curTypeBranch == thisIdClassData.TypeBranch then
        if self.GetJobDepth(self.curProfessionId) == 1 then
          return false
        else
          return true
        end
      else
        return false
      end
    elseif jobDepth == 0 then
      local thisIdBranch = Table_Class[id].TypeBranch
      local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      if S_table[thisIdBranch] ~= nil then
        local prof = S_table[thisIdBranch].profession
        if self.GetRaceByProfession(prof) == Table_Class[id].Race then
          return true
        end
      end
    end
    return false
  else
    return false
  end
end

function ProfessionProxy:IsThisNoviceIdYiGouMai(id)
  if ProfessionProxy.IsNovice(id) then
    local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
    if self.IsHumanRace(id) then
      for k, v in pairs(S_table) do
        if self.IsHumanRace(v.profession) then
          return true
        end
      end
    elseif self.IsDoramRace(id) then
      for k, v in pairs(S_table) do
        if self.IsDoramRace(v.profession) then
          return true
        end
      end
    end
  end
end

function ProfessionProxy:Isjust1stJob(id)
  local thisIdBranch = Table_Class[id].TypeBranch
  local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  if S_table[thisIdBranch] ~= nil and S_table[thisIdBranch].Isjust1stJob then
    return true
  end
end

function ProfessionProxy:IsThisIdKeGouMai(id)
  if not ProfessionProxy.ProfInSale(id) then
    return false
  end
  if ProfessionProxy.IsNovice(id) then
    return true
  end
  local jobDepth = self.GetJobDepth(id)
  if jobDepth == 1 then
    return false
  elseif jobDepth == 2 or ProfessionProxy.GetSpecialJobDepth(id) == 3 then
    if self.IsDoramRace(id) and self.hasdora2nd or self.IsHumanRace(id) and self.hashuman2nd then
      return true
    end
  elseif ProfessionProxy.IsHero(id) then
    return true
  end
  return false
end

function ProfessionProxy:CheckHeroCanBuy(profId)
  local profData = profId and Table_Class[profId]
  local advanceClass = profData and profData.HeroAdvanceClass
  if advanceClass and 0 < #advanceClass then
    for i = 1, #advanceClass do
      if self:IsThisIdYiJiuZhi(advanceClass[i]) then
        return true, profData.HeroAdvanceClass
      end
    end
    return false, profData.HeroAdvanceClass
  end
  return true
end

function ProfessionProxy:isOriginProfession(id)
  local thisClassData = Table_Class[id]
  if thisClassData == nil then
    return false
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local isOriginProfession = false
  for k, v in pairs(S_data) do
    if v.isbuy == false and Table_Class[v.profession].Type == thisClassData.Type and Table_Class[v.profession].Race == thisClassData.Race then
      isOriginProfession = true
      break
    end
  end
  return isOriginProfession
end

function ProfessionProxy:IsMPOpen()
  if FunctionUnLockFunc.Me():CheckCanOpen(9006) == false then
    return false
  end
  local isOpen = false
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_data) do
    if self.GetJobDepth(v.profession) >= 3 then
      isOpen = true
    end
  end
  return isOpen
end

function ProfessionProxy:HasDepth2Class()
  local isOpen = false
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_data) do
    if self.GetJobDepth(v.profession) >= 2 then
      isOpen = true
    end
  end
  return isOpen
end

function ProfessionProxy:GetRightMoneyNumberAndMoneyTypeForThisId(id)
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    local isOriginProfession = self:isOriginProfession(id)
    if isOriginProfession then
      local needmoney = GameConfig.Profession.price_zeny or 10000
      return needmoney, Table_Item[100]
    elseif self:IsThisIdFirstBoughtOtherBranchId(id) then
      local needmoney = GameConfig.Profession.price_zeny_other_first or 2000000
      local item_100 = Table_Item[100]
      return needmoney, Table_Item[100]
    else
      local allProfTicket = GameConfig.Profession.all_profession_ticket or 6553
      return 1, Table_Item[allProfTicket]
    end
  end
end

function ProfessionProxy:GetJapanRightMoneyNumberAndMoneyTypeForThisId(id)
  local isOriginProfession = self:isOriginProfession(id)
  if isOriginProfession then
    local needmoney = GameConfig.Profession.price_zeny or 10000
    return needmoney, Table_Item[100]
  elseif self:IsThisIdFirstBoughtOtherBranchId(id) then
    local needmoney = GameConfig.Profession.price_zeny_other_first or 2000000
    local item_100 = Table_Item[100]
    return needmoney, Table_Item[100]
  else
    local allProfTicket = GameConfig.Profession.all_profession_ticket or 6553
    return 1, Table_Item[allProfTicket]
  end
end

function ProfessionProxy:GetMoneyNumberAndMoneyTypeForPurchaseThisId(id)
  if GameConfig.ProfessionExchangeTicket == nil then
    if ApplicationInfo.IsRunOnEditor() then
      MsgManager.FloatMsg(nil, "策划没有上传  GameConfig.ProfessionExchangeTicket！！！！")
    end
  else
    local typeBranch = self.GetTypeBranchFromProf(id)
    local branchConfig = Table_Branch[typeBranch]
    local ticketID = branchConfig and branchConfig.item
    if ticketID and BagProxy.Instance:GetItemNumByStaticID(ticketID, TICKETPACKAGECHECK) > 0 then
      return 1, Table_Item[ticketID]
    end
  end
  if ProfessionProxy.Instance:isOriginProfession(id) then
    return GameConfig.Profession.price_zeny, Table_Item[100]
  else
    local isHero = self.IsHero(id)
    local collaborHero = GameConfig.Profession.collabor_hero
    local isCollabor = collaborHero and 0 < _ArrayFindIndex(collaborHero, id) or false
    if isHero then
      if not isCollabor then
        allProfTicket = GameConfig.Profession.hero_ticket_id
      else
        local typeBranch = self.GetTypeBranchFromProf(id)
        local branchConfig = Table_Branch[typeBranch]
        allProfTicket = branchConfig and branchConfig.item
      end
    else
      allProfTicket = GameConfig.Profession.all_profession_ticket or 6553
    end
    if allProfTicket then
      return 1, Table_Item[allProfTicket]
    end
  end
end

function ProfessionProxy:JudgeTicketAndShowOrHide(id, callback)
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    local Ihaveticket = false
    local branch = Table_Class[id].TypeBranch
    local ticketName = ""
    local branch = Table_Class[id].TypeBranch
    if ProfessionProxy.IsNovice(id) then
      branch = ProfessionProxy.NoviceC2S[id]
    end
    local branchConfig = Table_Branch[branch]
    ticketName = Table_Item[branchConfig.item].NameZh or ""
    if branchConfig and branchConfig.item and BagProxy.Instance:GetItemNumByStaticID(branchConfig.item, TICKETPACKAGECHECK) > 0 then
      local customtext = Table_Sysmsg[25540].Text
      local replacestr = ticketName
      customtext = string.format(customtext, replacestr)
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(25540)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByIDWithCustomText(customtext, 25540, function()
          ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
        end, function()
          self:PurchaseLogic(id, callback)
        end)
      else
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end
    end
    return Ihaveticket
  end
  return false
end

function ProfessionProxy.CanChangeProfession(failPrompt)
  if HomeManager.Me():IsAtHome() then
    return true
  end
  local mapid = Game.MapManager:GetMapID()
  local canChangeMaps = GameConfig.Profession and GameConfig.Profession.canChangeFieldMap
  if canChangeMaps and 0 < _ArrayFindIndex(canChangeMaps, mapid) then
    return true
  end
  local mapType = Table_Map[mapid].Type
  local canChange = false
  if mapType == 4 or mapType == 6 then
    canChange = true
  elseif mapType == 3 then
    local dungeonIns = DungeonProxy.Instance
    if dungeonIns.roguelikeRaid then
      local subScenes, curRoomIndex = SceneProxy.Instance.currentScene.subScenes, dungeonIns.roguelikeRaid.curRoomIndex
      if subScenes and curRoomIndex and 0 < curRoomIndex then
        mapid = subScenes[curRoomIndex]
      end
    end
    canChange = Table_MapRaid and Table_MapRaid[mapid] and Table_MapRaid[mapid].ChangeClass == 1
  end
  if failPrompt and not canChange then
    MsgManager.ShowMsgByID(failPrompt)
  end
  return canChange
end

function ProfessionProxy.CanChangeProfession4NewPVPRule(failPrompt)
  local _ArrayFindIndex = TableUtility.ArrayFindIndex
  if HomeManager.Me():IsAtHome() then
    return true
  end
  local isRogue = Game.MapManager:IsPVEMode_Roguelike()
  if isRogue then
    local raid = DungeonProxy.Instance.roguelikeRaid
    if raid then
      local curRoomType = DungeonProxy.GetRoguelikeRoomTypeByIndex(raid.curRoomIndex)
      if curRoomType == 7 then
        return true
      end
    end
  end
  local mapid = Game.MapManager:GetMapID()
  local raidid = Game.MapManager:GetRaidID()
  local canChange = true
  if raidid ~= 0 then
    if Table_MapRaid and Table_MapRaid[raidid] then
      local canChangeRaidType = GameConfig.Profession and GameConfig.Profession.canChangeRaidType
      local forbidChangeEquipRaidType = GameConfig.Profession and GameConfig.Profession.forbidChangeEquipRaidType
      local raidType = Table_MapRaid[raidid].Type
      if forbidChangeEquipRaidType and raidType and 0 < _ArrayFindIndex(forbidChangeEquipRaidType, raidType) then
        if failPrompt then
          MsgManager.ShowMsgByID(failPrompt)
        end
        return false, false
      end
      canChange = canChangeRaidType and raidType and 0 < _ArrayFindIndex(canChangeRaidType, raidType)
    end
  else
    local canChangeMaps = GameConfig.Profession and GameConfig.Profession.canChangeFieldMap
    if canChangeMaps and 0 < _ArrayFindIndex(canChangeMaps, mapid) then
      return true, true
    end
  end
  if failPrompt and not canChange then
    MsgManager.ShowMsgByID(failPrompt)
  end
  return canChange, true
end

function ProfessionProxy:PurchaseFunc(id, callback)
  if not self.CanChangeProfession4NewPVPRule(25389) then
    return
  end
  local isOriginProfession = self:isOriginProfession(id)
  local branch = Table_Class[id].TypeBranch
  if ProfessionProxy.IsNovice(id) then
    branch = ProfessionProxy.NoviceC2S[id]
  end
  local branchConfig = Table_Branch[branch]
  if branchConfig and branchConfig.item and BagProxy.Instance:GetItemNumByStaticID(branchConfig.item, TICKETPACKAGECHECK) > 0 then
    local ticketConfig = Table_Item[branchConfig.item]
    local costStr = ticketConfig.NameZh
    MsgManager.ConfirmMsgByID(43287, function()
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    end, nil, nil, costStr)
    return
  end
  if isOriginProfession then
    local needmoney = GameConfig.Profession.price_zeny or 0
    if needmoney > MyselfProxy.Instance:GetROB() then
      local sysMsgID = 25419
      local item_100 = Table_Item[100]
      MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
    else
      local item_100 = Table_Item[100]
      local costStr = item_100.NameZh .. "x" .. needmoney
      MsgManager.ConfirmMsgByID(9630, function()
        ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
      end, nil, nil, costStr, Table_Class[id].NameZh)
    end
  else
    local allProfTicket
    local isHero = self.IsHero(id)
    if isHero then
      local collaborHero = GameConfig.Profession.collabor_hero
      local isCollabor = collaborHero and 0 < _ArrayFindIndex(collaborHero, id) or false
      if isCollabor and callback then
        callback()
        return
      end
      allProfTicket = GameConfig.Profession.hero_ticket_id
    else
      allProfTicket = GameConfig.Profession.all_profession_ticket or 6553
    end
    local allProfTicketItem = Table_Item[allProfTicket]
    if allProfTicketItem and 0 < BagProxy.Instance:GetItemNumByStaticID(allProfTicket, TICKETPACKAGECHECK) then
      local costStr = string.format(ZhString.Friend_RecallRewardItem, 1, allProfTicketItem.NameZh)
      MsgManager.ConfirmMsgByID(9630, function()
        if isHero then
          local typeBranch = ProfessionProxy.GetTypeBranchFromProf(id)
          ServiceSceneUser3Proxy.Instance:CallHeroBuyUserCmd(typeBranch)
        else
          ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
        end
      end, nil, nil, costStr, Table_Class[id].NameZh)
    elseif callback then
      callback()
    end
  end
end

function ProfessionProxy:PurchaseLogic(id, callback)
  local isOriginProfession = self:isOriginProfession(id)
  local needmoney, moneyType = self:GetRightMoneyNumberAndMoneyTypeForThisId(id)
  local classData = Table_Class[id]
  if not classData then
    helplog("!!!这个id找不到没法买！")
    return
  end
  local branch = classData.TypeBranch
  if isOriginProfession then
    if needmoney > MyselfProxy.Instance:GetROB() then
      local sysMsgID = 25419
      local item_100 = Table_Item[100]
      MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
    else
      helplog("1branch:" .. branch)
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    end
    return true
  elseif self:IsThisIdFirstBoughtOtherBranchId(id) then
    if needmoney > MyselfProxy.Instance:GetROB() then
      local sysMsgID = 25419
      local item_100 = Table_Item[100]
      MsgManager.ShowMsgByID(sysMsgID, item_100.NameZh)
    else
      helplog("2branch:" .. branch)
      ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
    end
    return true
  else
    local allProfTicket = GameConfig.Profession.all_profession_ticket or 6553
    if moneyType.id == allProfTicket then
      local allProfTicketItem = Table_Item[allProfTicket]
      if allProfTicketItem and BagProxy.Instance:GetItemNumByStaticID(allProfTicket, TICKETPACKAGECHECK) > 0 then
        local costStr = string.format(ZhString.Friend_RecallRewardItem, 1, allProfTicketItem.NameZh)
        MsgManager.ConfirmMsgByID(9630, function()
          ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
        end, nil, nil, costStr, Table_Class[id].NameZh)
      elseif callback then
        callback()
      end
    end
  end
end

function ProfessionProxy:TryPurchaseHero(id)
  local ticketID = GameConfig.Profession.hero_ticket_id or 6971
  return BagProxy.Instance:GetItemNumByStaticID(ticketID, TICKETPACKAGECHECK) > 0 and true or false
end

function ProfessionProxy:IsThisIdFirstBoughtOtherBranchId(id)
  if BranchMgr.IsJapan() then
    local isUseZeny = MyselfProxy.Instance:getVarByType(Var_pb.EVARTYPE_FIRST_DIFF_BRANCH_MONEY_BUY)
    if isUseZeny and isUseZeny.value == 1 then
      return false
    end
    return false
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local originProfession
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      originProfession = v.profession
    end
  end
  if originProfession then
    for k, v in pairs(S_data) do
      if v.isbuy == true and Table_Class[originProfession].Type ~= Table_Class[v.profession].Type then
        return false
      end
    end
  else
    helplog("if originProfession == false then")
  end
  return true
end

function ProfessionProxy:NeedShowSelfData(targetBranch)
  local currentBranch = ProfessionProxy.Instance:GetCurTypeBranch()
  if currentBranch == targetBranch then
    return true
  else
    return false
  end
end

function ProfessionProxy:NeedShowSaveInfoData(targetBranch)
  local cursaveData = BranchInfoSaveProxy.Instance:GetUsersaveData(targetBranch)
  if cursaveData then
    return true
  else
    return false
  end
end

function ProfessionProxy:SetTopScrollChooseID(id)
  self.topScrollChooseID = id
end

function ProfessionProxy:GetTopScrollChooseID()
  return self.topScrollChooseID
end

function ProfessionProxy:ShouldThisIdVisible(id)
  if ProfessionProxy.GetSpecialJobDepth(id) > 0 then
    return true
  end
  local find2ndJobId = id - id % 10 + 2
  if not self:IsThisIdYiJiuZhi(find2ndJobId) and self.GetJobDepth(id) >= 3 then
    return false
  end
  return true
end

function ProfessionProxy:GetThisIdChuShiId(id)
  local TypeBranch = Table_Class[id] and Table_Class[id].TypeBranch
  return TypeBranch and Table_Branch[TypeBranch] and Table_Branch[TypeBranch].base_id
end

function ProfessionProxy:GetThisJobIdXi(id)
  if Table_Class and Table_Class[id] then
    local result = math.modf(Table_Class[id].TypeBranch / 10 % 100)
    if result == 0 then
      helplog("该系职业" .. id .. "\t\t居然为0")
    end
    return result
  else
    helplog("无该系职业" .. id)
  end
end

function ProfessionProxy:GetAllProfessionDatasOfRace(race)
  self.raceProfessionMap = self.raceProfessionMap or {}
  if not next(self.raceProfessionMap) then
    for _, data in pairs(Table_Class) do
      if data.Race then
        self.raceProfessionMap[data.Race] = self.raceProfessionMap[data.Race] or {}
        table.insert(self.raceProfessionMap[data.Race], data)
      end
    end
  end
  return race and self.raceProfessionMap[race]
end

function ProfessionProxy:GetTopScrollViewIconTable()
  if self.topScrollViewIconTable then
    return self.topScrollViewIconTable
  end
  self.topScrollViewIconTable = {}
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local hashuman, hasdora
  for _, v in pairs(S_data) do
    local prof = v.profession
    if ProfessionProxy.IsDoramRace(prof) and not ProfessionProxy.IsNovice(prof) then
      hasdora = true
    elseif ProfessionProxy.IsHumanRace(prof) and not ProfessionProxy.IsNovice(prof) then
      hashuman = true
    end
  end
  if hashuman then
    for k, v in pairs(Table_Class) do
      if self.GetJobDepth(v.id) == 1 and not self.IsDoramRace(v.id) then
        local thisXi = self:GetThisJobIdXi(v.id)
        local job = {}
        job.id = v.id
        job.Type = thisXi
        job.isGrey = true
        job.order = v.Type
        table.insert(self.topScrollViewIconTable, job)
      end
    end
    local prof, v
    for i = 1, #ProfessionProxy.specialJobs do
      prof = ProfessionProxy.specialJobs[i]
      if ProfessionProxy.IsHumanRace(prof) then
        v = Table_Class[prof]
        if v then
          local thisXi = self:GetThisJobIdXi(v.id)
          local job = {}
          job.id = v.id
          job.Type = thisXi
          job.isGrey = true
          job.order = v.Type
          table.insert(self.topScrollViewIconTable, job)
        end
      end
    end
  elseif Table_Class and Table_Class[ProfessionProxy.humanNovice] and Table_Class[ProfessionProxy.humanTypical1st] then
    local v0 = Table_Class[ProfessionProxy.humanNovice]
    local v = Table_Class[ProfessionProxy.humanTypical1st]
    local thisXi = self:GetThisJobIdXi(v.id)
    local job = {}
    job.id = v0.id
    job.Type = thisXi
    job.isGrey = true
    job.order = v.Type
    table.insert(self.topScrollViewIconTable, job)
  else
    helplog("人族(初心者)没配，请检查配置表")
  end
  if hasdora then
    for k, v in pairs(Table_Class) do
      if self.GetJobDepth(v.id) == 1 and self.IsDoramRace(v.id) then
        local thisXi = self:GetThisJobIdXi(v.id)
        local job = {}
        job.id = v.id
        job.Type = thisXi
        job.isGrey = true
        job.order = v.Type
        table.insert(self.topScrollViewIconTable, job)
      end
    end
    local prof, v
    for i = 1, #ProfessionProxy.specialJobs do
      prof = ProfessionProxy.specialJobs[i]
      if ProfessionProxy.IsDoramRace(prof) then
        v = Table_Class[prof]
        if v then
          local thisXi = self:GetThisJobIdXi(v.id)
          local job = {}
          job.id = v.id
          job.Type = thisXi
          job.isGrey = true
          job.order = v.Type
          table.insert(self.topScrollViewIconTable, job)
        end
      end
    end
  elseif Table_Class and Table_Class[ProfessionProxy.doramNovice] and Table_Class[ProfessionProxy.doramTypical1st] then
    local v0 = Table_Class[ProfessionProxy.doramNovice]
    local v = Table_Class[ProfessionProxy.doramTypical1st]
    local thisXi = self:GetThisJobIdXi(v.id)
    local job = {}
    job.id = v0.id
    job.Type = thisXi
    job.isGrey = true
    job.order = v.Type
    table.insert(self.topScrollViewIconTable, job)
  else
    helplog("多兰族(初心喵)没配，请检查配置表")
  end
  local cacheForbiddenProf = ProfessionProxy.GetBannedProfessions()
  local unLockFunc = FunctionUnLockFunc.Me()
  for _, menuId in ipairs(GameConfig.MenuUnlockProfession or {}) do
    if not unLockFunc:CheckCanOpen(menuId) then
      local menuData = Table_Menu[menuId]
      if menuData and menuData.event and menuData.event.type == "unlockprofession" then
        for _, professionId in ipairs(menuData.event.param or {}) do
          cacheForbiddenProf[professionId] = 1
        end
      end
    end
  end
  if cacheForbiddenProf and next(cacheForbiddenProf) then
    for i = #self.topScrollViewIconTable, 1, -1 do
      if self.topScrollViewIconTable[i] and nil ~= cacheForbiddenProf[self.topScrollViewIconTable[i].id] then
        table.remove(self.topScrollViewIconTable, i)
      end
    end
  end
  local curOcc = Game.Myself.data:GetCurOcc()
  local curProfessionId = curOcc.profession
  local chushiid = 0
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      chushiid = self:GetThisIdChuShiId(v.profession)
    end
  end
  for k, v in pairs(self.topScrollViewIconTable) do
    if v.id == chushiid then
      v.order = 999999
      v.isGrey = false
    elseif self:IsThisIdYiGouMai(v.id) then
      v.isGrey = false
      v.order = 1000 - v.Type
    else
      v.isGrey = true
      v.order = -v.Type
    end
  end
  table.sort(self.topScrollViewIconTable, function(l, r)
    return l.order > r.order
  end)
  return self.topScrollViewIconTable
end

function ProfessionProxy:GetValidJobList()
  if self.multiProfessionList then
    TableUtility.ArrayClear(self.multiProfessionList)
  else
    self.multiProfessionList = {}
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local hashuman, hasdora
  local humanDepth = 0
  local doramDepth = 0
  for k, v in pairs(S_data) do
    local prof = v.profession
    if ProfessionProxy.IsDoramRace(prof) then
      hasdora = true
      local jobDepth = self.GetJobDepth(prof)
      if doramDepth < jobDepth then
        doramDepth = jobDepth
      end
    elseif ProfessionProxy.IsHumanRace(prof) then
      hashuman = true
      local jobDepth = self.GetJobDepth(prof)
      if humanDepth < jobDepth then
        humanDepth = jobDepth
      end
    end
    local classConfig = Table_Class[prof]
    local jobBranch = k
    local branchInfo = Table_Branch[jobBranch]
    if classConfig and (not (branchInfo and branchInfo.gender) or branchInfo.gender == self:GetCurSex()) then
      local data = {}
      data.id = prof
      data.isUnlock = true
      data.branch = jobBranch
      data.order = classConfig and classConfig.Type
      if not self.multiProfessionList[jobBranch] or self.multiProfessionList[jobBranch].id < data.id then
        self.multiProfessionList[jobBranch] = data
      end
    end
  end
  if 1 <= humanDepth and S_data[0] and S_data[0].profession == ProfessionProxy.humanNovice then
    self.multiProfessionList[0] = nil
  end
  if 1 <= doramDepth and S_data[0] and S_data[0].profession == ProfessionProxy.doramNovice then
    self.multiProfessionList[0] = nil
  end
  for k, v in pairs(self.multiProfessionList) do
    if S_data[k] and S_data[k].isbuy == false then
      local branchConfig = Table_Branch[k]
      if branchConfig then
        local raw_brotherList = string.split(branchConfig.brother_list, ",")
        for i = 1, #raw_brotherList do
          local branchid = tonumber(raw_brotherList[i])
          local targetBranchInfo = Table_Branch[branchid]
          if targetBranchInfo and (not targetBranchInfo.gender or targetBranchInfo.gender == self:GetCurSex()) then
            local proList = targetBranchInfo and string.split(targetBranchInfo.profession_list, ",")
            if proList then
              local classConfig = Table_Class[tonumber(proList[1])]
              local data = {}
              data.id = targetBranchInfo.base_id
              data.baseid = targetBranchInfo.base_id
              data.isUnlock = true
              data.branch = branchid
              data.order = classConfig and classConfig.Type
              if not self.multiProfessionList[branchid] then
                self.multiProfessionList[branchid] = data
                xdlog("添加假分支", classConfig.id, branchid, classConfig.Type)
              end
            end
          end
        end
      end
    end
  end
  if hashuman then
    if 1 <= humanDepth then
      for k, v in pairs(Table_Branch) do
        if not self.multiProfessionList[k] and not ProfessionProxy.IsNovice(v.base_id) and (not v.gender or v.gender == self:GetCurSex()) then
          local proList = string.split(v.profession_list, ",")
          local targetClass = proList and tonumber(proList[1])
          local classConfig = targetClass and Table_Class[targetClass]
          if classConfig and not ProfessionProxy.IsDoramRace(classConfig.id) then
            local jobData = {}
            jobData.id = targetClass
            jobData.baseid = v.base_id
            jobData.advClass = targetClass
            jobData.isUnlock = false
            jobData.branch = classConfig.TypeBranch
            jobData.order = classConfig.Type
            self.multiProfessionList[k] = jobData
          end
        end
      end
      local prof, v
      for i = 1, #ProfessionProxy.specialJobs do
        prof = ProfessionProxy.specialJobs[i]
        if ProfessionProxy.IsHumanRace(prof) and not ProfessionProxy.IsHero(prof) then
          v = Table_Class[prof]
          if v then
            local jobBranch = v.TypeBranch
            local jobData = {}
            jobData.id = v.id
            jobData.baseid = Table_Branch[jobBranch].base_id
            jobData.isUnlock = false
            jobData.order = v.Type
            jobData.branch = jobBranch
            if not self.multiProfessionList[jobBranch] then
              self.multiProfessionList[jobBranch] = jobData
            end
          end
        end
      end
    end
  elseif Table_Class and Table_Class[ProfessionProxy.humanNovice] and Table_Class[ProfessionProxy.humanTypical1st] then
    local v0 = Table_Class[ProfessionProxy.humanNovice]
    local v = Table_Class[ProfessionProxy.humanTypical1st]
    local jobBranch = v0.TypeBranch
    local jobData = {}
    jobData.id = v0.id
    jobData.baseid = v0.id
    jobData.isUnlock = false
    jobData.order = v.Type
    jobData.branch = jobBranch
    self.multiProfessionList[jobBranch] = jobData
  else
    helplog("人族(初心者)没配，请检查配置表")
  end
  if hasdora then
    if S_data[0] and S_data.profession == ProfessionProxy.doramNovice then
      local v0 = Table_Class[S_data.profession]
      local advClass = v0.AdvanceClass
      for k, v in pairs(Table_Class) do
        if ProfessionProxy.GetJobDepth(v.id) == 0 and self.IsDoramRace(v.id) and _ArrayFindIndex(advClass, v.id) == 0 then
          local jobData = {}
          jobData.id = v.id
          jobData.baseid = Table_Branch[v.TypeBranch].base_id
          jobData.isUnlock = false
          jobData.order = v.Type
          jobData.branch = v.TypeBranch
          self.multiProfessionList[v.TypeBranch] = jobData
        end
      end
    end
    local prof, v
    for i = 1, #ProfessionProxy.specialJobs do
      prof = ProfessionProxy.specialJobs[i]
      if ProfessionProxy.IsDoramRace(prof) and not ProfessionProxy.IsHero(prof) then
        v = Table_Class[prof]
        if v then
          local jobBranch = v.TypeBranch
          local jobData = {}
          jobData.id = v.id
          jobData.baseid = Table_Branch[jobBranch].base_id
          jobData.isUnlock = false
          jobData.order = v.Type
          jobData.branch = jobBranch
          if not self.multiProfessionList[jobBranch] then
            self.multiProfessionList[jobBranch] = jobData
          end
        end
      end
    end
  elseif Table_Class and Table_Class[ProfessionProxy.doramNovice] and Table_Class[ProfessionProxy.doramTypical1st] then
    local v0 = Table_Class[ProfessionProxy.doramNovice]
    local v = Table_Class[ProfessionProxy.doramTypical1st]
    local jobBranch = v.TypeBranch
    local jobData = {}
    jobData.id = v0.id
    jobData.baseid = v0.id
    jobData.isUnlock = false
    jobData.order = v.Type
    jobData.branch = jobBranch
    self.multiProfessionList[jobBranch] = jobData
  else
    helplog("多兰族(初心喵)没配，请检查配置表")
  end
  for k, v in pairs(Table_Branch) do
    if v.profession_skill and not self.multiProfessionList[k] then
      local proList = string.split(v.profession_list, ",")
      local targetClass = proList and tonumber(proList[1])
      local jobData = {}
      jobData.id = targetClass
      jobData.baseid = v.base_id
      jobData.advClass = targetClass
      jobData.isUnlock = false
      jobData.branch = k
      jobData.order = math.modf(k / 10)
      self.multiProfessionList[k] = jobData
    end
  end
  self:RefreshBannedProfList()
  if self.forbiddenProfMap and next(self.forbiddenProfMap) then
    for id, _ in pairs(self.forbiddenProfMap) do
      local classConfig = Table_Class[id]
      local jobBranch = classConfig and classConfig.TypeBranch
      if not S_data[jobBranch] and not self:CheckBranchShowValid(id) and self.multiProfessionList[jobBranch] then
        self.multiProfessionList[jobBranch] = nil
      end
    end
  end
  local curOcc = Game.Myself.data:GetCurOcc()
  local curProfessionId = curOcc.profession
  local curTypeBranch = ProfessionProxy.GetTypeBranchFromProf(curProfessionId)
  local chushiid = 0
  for k, v in pairs(S_data) do
    if v.isbuy == false then
      chushiid = self:GetThisIdChuShiId(v.profession)
    end
  end
  for k, v in pairs(self.multiProfessionList) do
    if k == curTypeBranch then
      v.order = 99999
    elseif self:IsThisIdYiGouMai(v.id) then
      if self.IsDoramRace(v.id) then
        v.order = 2000 - k
      else
        v.order = 4000 - k
      end
    elseif self.IsDoramRace(v.id) then
      v.order = -k - 2000
    else
      v.order = -k
    end
  end
  local tempList = {}
  for k, v in pairs(self.multiProfessionList) do
    local classType = math.modf(v.branch / 10)
    local profTypeList = tempList[classType] or {Type = classType}
    if not profTypeList.order or v.order > profTypeList.order then
      profTypeList.order = v.order
    end
    local branchList = profTypeList.branchList or {}
    table.insert(branchList, v)
    profTypeList.branchList = branchList
    tempList[classType] = profTypeList
  end
  for k, v in pairs(tempList) do
    local branchList = v.branchList
    table.sort(branchList, function(l, r)
      return l.branch < r.branch
    end)
  end
  local str = ""
  local format = "职业大分支 %s, 子BranchType:%s，排序"
  for k, v in pairs(tempList) do
    if v.branchList and 0 < #v.branchList then
      local branchStr = ""
      for i = 1, #v.branchList do
        branchStr = branchStr .. v.branchList[i].branch .. "/"
      end
      str = str .. string.format(format, k, branchStr, v.order) .. "\n"
    end
  end
  xdlog(str)
  local result = {}
  for k, v in pairs(tempList) do
    table.insert(result, v)
  end
  table.sort(result, function(l, r)
    if l.order and r.order then
      return l.order > r.order
    end
  end)
  return result
end

function ProfessionProxy:GetMultiProfessionList()
  return self.multiProfessionList or {}
end

function ProfessionProxy:RefreshBannedProfList()
  local cache_forbidden_Prof = ProfessionProxy.GetBannedProfessions()
  local unLockFunc = FunctionUnLockFunc.Me()
  for _, menuId in ipairs(GameConfig.MenuUnlockProfession or {}) do
    if not unLockFunc:CheckCanOpen(menuId) then
      local menuData = Table_Menu[menuId]
      if menuData and menuData.event and menuData.event.type == "unlockprofession" then
        for _, professionId in ipairs(menuData.event.param or {}) do
          cache_forbidden_Prof[professionId] = 1
        end
      end
    end
  end
  self.forbiddenProfMap = {}
  _TableShallowCopy(self.forbiddenProfMap, cache_forbidden_Prof)
end

function ProfessionProxy:CheckProfIsBanned(classid)
  if not self.forbiddenProfMap then
    return false
  end
  return nil ~= self.forbiddenProfMap[classid]
end

function ProfessionProxy:DoesThisIdCanBuyBranch(id, branch)
  if self.GetJobDepth(id) ~= 1 then
    helplog("GetThisIdCanBuyBranch reviewCode id:" .. id)
  end
  for k, v in pairs(Table_Class[id].AdvanceClass) do
    if Table_Class[v] and Table_Class[v].TypeBranch == branch then
      return true
    end
  end
  return false
end

function ProfessionProxy:GetCurSex()
  local userData = Game.Myself.data.userdata
  if userData then
    local gender = userData:Get(UDEnum.SEX)
    if gender then
      return gender
    end
  end
  return 1
end

function ProfessionProxy:SafeSetColor(object, colorKey)
  if ColorUtil[colorKey] then
    object = ColorUtil.CareerFlag4
  else
    helplog("策划配置表问题！！！请策划检查ColorUtil！！！表中缺乏colorKey：" .. colorKey .. "！！！！")
  end
end

function ProfessionProxy:SafeGetColorFromColorUtil(colorKey)
  if ColorUtil[colorKey] then
    return ColorUtil[colorKey]
  else
    helplog("策划配置表问题！！！请策划检查ColorUtil！！！表中缺乏colorKey：" .. colorKey .. "！！！！")
    return Color(1, 1, 1, 1)
  end
end

function ProfessionProxy.ProcessNoviceBranchValueS2C(branch, profession)
  local base_id = Table_Branch[branch] and Table_Branch[branch].base_id
  if base_id and Table_Class[base_id] and Table_Class[base_id].TypeBranch == 0 then
    if not profession or base_id == profession then
      return 0
    elseif Table_Class[profession] and Table_Class[profession].TypeBranch then
      return Table_Class[profession].TypeBranch, true
    end
  end
  return branch
end

function ProfessionProxy.GetProfessDepthByClassID(classID)
  return classID % 10
end

ProfessionData = class("ProfessionData")

function ProfessionData:ctor(data, depth)
  if data then
    self.id = data.id
    self.data = data
    self.depth = depth or 0
    self.nextProfessions = {}
    self.parentProfession = nil
  end
end

function ProfessionData:GetNextByBranch(typeBranch)
  return self.nextProfessions[typeBranch]
end

function ProfessionData:AddNext(profession)
  profession:SetParent(self)
  profession.depth = self.depth + 1
  self.nextProfessions[profession.data.TypeBranch] = profession
end

function ProfessionData:SetParent(parent)
  self.parentProfession = parent
end

ProfessionTree = class("ProfessionTree")

function ProfessionTree:ctor(root, transferRoot)
  self.root = root
  self.transferRoot = transferRoot
end

function ProfessionTree:GetProfessDataByClassID(classID)
  if self.transferRoot then
    return self:RecurseFindClass(self.transferRoot, classID)
  end
  return nil
end

function ProfessionTree:RecurseFindClass(profess, classID)
  if profess then
    if profess.id == classID then
      return profess
    else
      local find
      for branch, profession in pairs(profess.nextProfessions) do
        find = self:RecurseFindClass(profession, classID)
        if find then
          return find
        end
      end
    end
  end
  return nil
end

function ProfessionTree:InitSkillPath(classID)
  if self.classID ~= classID then
    self.classID = classID
    self.paths = {}
    self:RecurseParsePathByProfess(self.transferRoot, Table_Class[self.classID].TypeBranch)
    ProfessionTree.HandlePath(self.paths)
  end
end

function ProfessionTree:RecurseParsePathByProfess(data, typeBranch)
  if data then
    local skills = Table_Class[data.id].Skill
    if skills then
      ProfessionTree.ParsePath(skills, self.paths, data.id)
      for k, v in pairs(data.nextProfessions) do
        if k == typeBranch then
          self:RecurseParsePathByProfess(v, typeBranch)
        end
      end
    end
  end
end

function ProfessionTree.HandlePath(paths)
  local requiredID, values, value, posData, requiredData, combine, sortId, requiredIDs, multiSkill
  local map = ReusableTable.CreateTable()
  for y, datas in pairs(paths) do
    for x, data in pairs(datas) do
      requiredIDs = data.requiredIDs
      if requiredIDs then
        for i = 1, #requiredIDs do
          requiredID = data.requiredIDs[i]
          if requiredID ~= nil then
            values = map[requiredID]
            if values == nil then
              values = {}
              map[requiredID] = values
            end
            value = values[x]
            if value == nil then
              value = {}
              values[x] = value
            end
            sortId = math.floor(data.id / 1000)
            value[#value + 1] = sortId
            posData = ProfessionTree.GetPos(requiredID, data.profession) or {0, 0}
            requiredData = paths[posData[2]][posData[1]]
            multiSkill = requiredData.multiSkill
            if multiSkill == nil then
              multiSkill = {}
              requiredData.multiSkill = multiSkill
            end
            multiSkill[sortId] = 1
          end
        end
      else
        requiredID = data.requiredID
        if requiredID ~= nil then
          values = map[requiredID]
          if values == nil then
            values = {}
            map[requiredID] = values
          end
          value = values[x]
          if value == nil then
            value = {}
            values[x] = value
          end
          sortId = math.floor(data.id / 1000)
          value[#value + 1] = sortId
          if 1 < #value then
            posData = ProfessionTree.GetPos(requiredID, data.profession) or {0, 0}
            requiredData = paths[posData[2]][posData[1]]
            combine = requiredData.combine
            if combine == nil then
              combine = {}
              requiredData.combine = combine
              combine[value[1]] = 1
            end
            combine[sortId] = 1
          end
        end
      end
    end
  end
  ReusableTable.DestroyAndClearTable(map)
end

function ProfessionTree.ParsePath(skills, paths, profession)
  if skills then
    local skill, posData, path, requiredID, requiredSkills
    for i = 1, #skills do
      skill = skills[i]
      posData = ProfessionTree.GetPos(skill, profession)
      skill = Table_Skill[skill]
      if posData then
        path = paths[posData[2]]
        if path == nil then
          path = {}
          paths[posData[2]] = path
        end
        requiredSkills = skill.Contidion and skill.Contidion.skills or nil
        requiredID = skill.Contidion and skill.Contidion.skillid or nil
        requiredID = requiredID and math.floor(requiredID / 1000) * 1000 + 1
        path[posData[1]] = {
          id = skill.id,
          requiredID = requiredID,
          profession = profession
        }
        if requiredSkills then
          local skills = {}
          local skillid = 0
          for i = 1, #requiredSkills do
            skillid = math.floor(requiredSkills[i] / 1000) * 1000 + 1
            skills[#skills + 1] = skillid
          end
          path[posData[1]] = {
            id = skill.id,
            requiredIDs = skills,
            profession = profession
          }
        end
      end
    end
  end
end

function ProfessionTree.GetPos(skillid, profession)
  local data = Table_SkillMould[skillid]
  if data ~= nil then
    local pos = data.Pos
    if pos ~= nil and 0 < #pos then
      return pos
    end
    pos = data.ProfessionPos
    if pos ~= nil and profession ~= nil then
      return pos[profession]
    end
  end
  return nil
end

function ProfessionProxy.IsDoramForbidden()
  return not Table_Class or not Table_Class[ProfessionProxy.doramNovice] or GameConfig.roleDolanOpen == 0
end

function ProfessionProxy.GetJobDepth(profession)
  local curId = profession or MyselfProxy:GetMyProfession()
  if curId == 1 then
    return 0
  else
    return curId % 10
  end
end

function ProfessionProxy.GetSpecialJobDepth(profession)
  local curId = profession or MyselfProxy:GetMyProfession()
  local rawType = math.floor(curId / 10)
  if nil ~= ProfessionProxy.specialJobsRawType[rawType] then
    return curId % 10
  end
  return -1
end

function ProfessionProxy.GetRaceByProfession(profId)
  profId = profId or MyselfProxy:GetMyProfession()
  if ProfessionProxy.IsHumanRace(profId) then
    return ECHARRACE.ECHARRACE_HUMAN
  elseif ProfessionProxy.IsDoramRace(profId) then
    return ECHARRACE.ECHARRACE_CAT
  end
end

function ProfessionProxy.IsHumanRace(profId)
  return ProfessionProxy.CheckRace(profId or MyselfProxy:GetMyProfession(), ECHARRACE.ECHARRACE_HUMAN)
end

function ProfessionProxy.IsDoramRace(profId)
  return ProfessionProxy.CheckRace(profId or MyselfProxy:GetMyProfession(), ECHARRACE.ECHARRACE_CAT)
end

function ProfessionProxy.IsNovice(profId)
  profId = profId or MyselfProxy:GetMyProfession()
  return profId == ProfessionProxy.humanNovice or profId == ProfessionProxy.doramNovice
end

function ProfessionProxy.CheckRace(profId, race)
  local profData = profId and Table_Class[profId]
  return profData ~= nil and profData.Race == race
end

function ProfessionProxy:GetMaxHeroFeatureLv()
  if nil == self.maxHeroFeatureLv then
    self.maxHeroFeatureLv = GameConfig.Profession.max_hero_featureLv or 7
  end
  return self.maxHeroFeatureLv
end

function ProfessionProxy:GetMidHeroFeatureLv()
  if nil == self.midHeroFeatureLv then
    self.midHeroFeatureLv = GameConfig.Profession.hero_featureMidLv or 4
  end
  return self.midHeroFeatureLv
end

function ProfessionProxy.IsHero(profId)
  local profData = profId and Table_Class[profId]
  return profData and profData.FeatureSkill ~= nil
end

function ProfessionProxy.GetBoughtProfessionIdThroughBranch(branch)
  if nil ~= ProfessionProxy.NoviceBranches[branch] or nil ~= ProfessionProxy.specialJobBranches[branch] then
    return Table_Branch[branch].base_id
  end
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branch and v.id % 10 == 2 then
      return v.id
    end
  end
end

function ProfessionProxy.GetAllBranchProfessionId()
  local professionArray = {}
  local forbidBranch = ProfessionProxy.GetBannedBranches()
  for k, _ in pairs(Table_Branch) do
    if k < 1000 and nil == forbidBranch[k] and ProfessionProxy.GetBoughtProfessionIdThroughBranch(k) then
      TableUtility.InsertSort(professionArray, ProfessionProxy.GetBoughtProfessionIdThroughBranch(k), function(a, b)
        return a < b
      end)
    end
  end
  return professionArray
end

function ProfessionProxy.GetTypeBranchFromProf(profId)
  profId = profId or MyselfProxy.Instance:GetMyProfession()
  return not ProfessionProxy.NoviceC2S[profId] and Table_Class[profId] and Table_Class[profId].TypeBranch
end

function ProfessionProxy.GetTypeBranchBaseIdFromProf(profId)
  local tb = ProfessionProxy.GetTypeBranchFromProf(profId)
  return tb and Table_Branch[tb] and Table_Branch[tb].base_id
end

function ProfessionProxy.TypeBranchS2C(typeBranch)
  if nil ~= ProfessionProxy.NoviceBranches[typeBranch] then
    return 0
  end
  return typeBranch
end

function ProfessionProxy.ProfInSale(profId)
  local TypeBranch = ProfessionProxy.GetTypeBranchFromProf(profId)
  return Table_Branch[TypeBranch] and Table_Branch[TypeBranch].no_sale ~= 1
end

function ProfessionProxy.ProfEquipShield(profId)
  return ProfessionProxy.GetTypeBranchFromProf(profId) == 12 and ProfessionProxy.GetJobDepth(profId) >= 2
end

function ProfessionProxy.IsTaekwon()
  local TypeBranch = ProfessionProxy.GetTypeBranchFromProf()
  return TypeBranch == 131
end

local cache_forbidden_Prof = {}

function ProfessionProxy.GetBannedProfessions()
  _TableClear(cache_forbidden_Prof)
  for pro, funcStateId in pairs(Game.Config_ProfessionForbidMap) do
    if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
      cache_forbidden_Prof[pro] = 1
    end
  end
  return cache_forbidden_Prof
end

local cache_forbidden_Branch = {}

function ProfessionProxy.GetBannedBranches()
  _TableClear(cache_forbidden_Branch)
  for branchid, funcStateId in pairs(Game.Config_BranchForbidMap) do
    if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
      cache_forbidden_Branch[branchid] = 1
    end
  end
  return cache_forbidden_Branch
end

function ProfessionProxy:IsFastTransGemGet()
  return self.isFastTransGemGet or false
end

function ProfessionProxy:RecvFastTransGemQueryUserCmd(data)
  self.isFastTransGemGet = data.ischoose
end

function ProfessionProxy:GetTransferProfStaticData(id)
  if not self.transferProfStaticData then
    self.transferProfStaticData = {}
    for _, d in pairs(Table_ClassShowUI) do
      self.transferProfStaticData[d.classid] = d
    end
  end
  return self.transferProfStaticData[id]
end

function ProfessionProxy:GetTransferProfStaticDataByAnyProf(id)
  local tb = ProfessionProxy.GetTypeBranchFromProf(id)
  if tb then
    local cId = self:GetShowUiClassIdByTypeBranch(tb)
    if cId then
      return self:GetTransferProfStaticData(cId)
    end
  end
end

function ProfessionProxy:GetShowUiClassIdByTypeBranch(typeBranch)
  if not self.transferProfTypeBranchClassIdMap then
    self.transferProfTypeBranchClassIdMap = {}
    local tb
    for _, d in pairs(Table_ClassShowUI) do
      tb = ProfessionProxy.GetTypeBranchFromProf(d.classid)
      if tb then
        self.transferProfTypeBranchClassIdMap[tb] = d.classid
      end
    end
  end
  return self.transferProfTypeBranchClassIdMap[typeBranch]
end

local transferProfIconFields = {"Firsticon", "Thirdicon"}

function ProfessionProxy:GetTransferProfListByIconName(name)
  if not self.transferProfIconNameProfMap then
    self.transferProfIconNameProfMap = {}
    local list, d, field
    for i = 1, #Table_ClassShowUI do
      d = Table_ClassShowUI[i]
      for j = 1, #transferProfIconFields do
        field = transferProfIconFields[j]
        if not StringUtil.IsEmpty(d[field]) then
          list = self.transferProfIconNameProfMap[d[field]] or {}
          TableUtility.ArrayPushBack(list, d.classid)
          self.transferProfIconNameProfMap[d[field]] = list
        end
      end
    end
    for _, lst in pairs(self.transferProfIconNameProfMap) do
      table.sort(lst)
    end
  end
  return self.transferProfIconNameProfMap[name]
end

function ProfessionProxy:GetDefaultTeamRoleByPro(proid)
  local profession = Table_Class[proid]
  return profession and profession.TeamFunction and profession.TeamFunction.default
end

function ProfessionProxy:GetTeamRolesByPro(proid)
  local profession = Table_Class[proid]
  return profession and profession.TeamFunction and profession.TeamFunction.selects
end

function ProfessionProxy:GetSkillPointSolution(proid)
  local profession = Table_Class[proid]
  return profession and profession.SkillPointSolution
end

function ProfessionProxy.IsThanatos(profId)
  profId = profId or MyselfProxy:GetMyProfession()
  return profId == ProfessionProxy.Thanatos
end

function ProfessionProxy:InitFirstTransferClass()
  if self.firstTransferInited then
    return
  end
  self.firstTransferInited = true
  self.subClassMap = {}
  self.groupClassList = {}
  local _MyRace = MyselfProxy.Instance:GetMyRace()
  local list
  local _Gender = self:GetCurSex()
  for k, v in pairs(Table_TransferClass) do
    local gender = Table_Class[v.id].gender
    local matchGender = nil == gender or gender == _Gender
    if v.GroupClassID ~= v.id and matchGender then
      list = self.subClassMap[v.GroupClassID] or {}
      list[#list + 1] = v.id
      self.subClassMap[v.GroupClassID] = list
    end
    if Table_Class[v.id] then
      if Table_Class[v.id].Race == _MyRace then
        self.groupClassList[#self.groupClassList + 1] = v.GroupClassID
      end
    else
      redlog("TransferClass配置错误classid： ", v.id)
    end
  end
  for _, list in pairs(self.subClassMap) do
    table.sort(list)
  end
  TableUtility.ArrayUnique(self.groupClassList)
  table.sort(self.groupClassList)
  local staticData = Table_TransferClass[self.bornProfession]
  if not staticData then
    self.firstSelectionViewIndex = 1
  else
    self.firstSelectionViewIndex = _ArrayFindIndex(self.groupClassList, staticData.GroupClassID)
    if self.firstSelectionViewIndex == 0 then
      self.firstSelectionViewIndex = 1
    end
  end
end

function ProfessionProxy:GetGroupClassList()
  return self.groupClassList
end

function ProfessionProxy:GetFirstSelectionViewIndex()
  return self.firstSelectionViewIndex
end

function ProfessionProxy:GetSubClassList(groupid)
  return self.subClassMap[groupid]
end

function ProfessionProxy:HandleChooseNewProfessionMess(server_born_profession)
  self.bornProfession = server_born_profession
  helplog("bornProfession result ", self.bornProfession)
end

function ProfessionProxy:SaveChooseClassID(id)
  self.chooseTryClassid = id
end

function ProfessionProxy:TryUseNewClassID()
  if not self.chooseTryClassid then
    return
  end
  ServiceMessCCmdProxy.Instance:CallChooseNewProfessionMessCCmd(nil, self.chooseTryClassid)
  self.chooseTryClassid = nil
end

function ProfessionProxy:GetClassState(id)
  local curOcc = Game.Myself.data:GetCurOcc()
  local curProfessionId = curOcc.profession
  local typeBranch = ProfessionProxy.GetTypeBranchFromProf(id)
  local curTypeBranch = ProfessionProxy.Instance:GetCurTypeBranch()
  if id == curProfessionId then
    return ProfessionProxy.ClassState.State3
  elseif self:IsThisIdYiJiuZhi(id) and self:CheckJobSwitchValid(id) then
    return ProfessionProxy.ClassState.State1
  elseif self:IsThisIdYiJiuZhi(id) and self:CheckJobSwitchValid(id) == false then
    return ProfessionProxy.ClassState.State2
  elseif not self.IsHero(id) and self:GetThisIdPreviousId(id) == curProfessionId and (typeBranch == curTypeBranch or self:isOriginProfession(id) and self.GetBrotherBranch(typeBranch) == curTypeBranch or nil ~= ProfessionProxy.NoviceBranches[curTypeBranch]) then
    if self:NeedShowJinJie(id) then
      return ProfessionProxy.ClassState.State4
    else
      return ProfessionProxy.ClassState.State5
    end
  elseif self:IsThisIdYiGouMai(id) and self:IsThisIdYiJiuZhi(id) == false then
    if self.GetJobDepth(id) > 2 then
      return ProfessionProxy.ClassState.State8
    end
    return ProfessionProxy.ClassState.State7
  elseif self:IsThisIdYiGouMai(id) == false and self:IsThisIdKeGouMai(id) then
    if self:IsMPOpen() or ProfessionProxy.IsHero(id) then
      return ProfessionProxy.ClassState.State6
    else
      return ProfessionProxy.ClassState.State8
    end
  else
    return ProfessionProxy.ClassState.State8
  end
end

function ProfessionProxy:CheckJobSwitchValid(id)
  for k, v in pairs(self.ProfessionQueryUserTable) do
    if v.profession == id then
      return true
    end
  end
  return false
end

function ProfessionProxy:NeedShowJinJie(id)
  local S_ProfessionDatas = self:GetProfessionQueryUserTable()
  local previousId = self:GetThisIdPreviousId(id)
  local userData = Game.Myself.data.userdata
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  local curProf = userData:Get(UDEnum.PROFESSION) or 0
  if previousId == MyselfProxy.Instance:GetMyProfession() then
    local tiaojianlevel = self:GetThisIdJiuZhiTiaoJianLevel(id)
    local previouslevel = self:GetThisJobLevelForClient(previousId, MyselfProxy.Instance:JobLevel())
    local baseLvLimit = self:GetThisIdJiuZhiBaseLevel(id) or 0
    if tiaojianlevel == nil then
      helplog("if tiaojianlevel == nil then 请策划检查配置表")
      return false
    end
    if previouslevel == nil then
      helplog("if previouslevel == nil then")
      return false
    end
    if tiaojianlevel <= previouslevel and nowRoleLevel >= baseLvLimit then
      if id % 10 == 1 and nowRoleLevel < 40 then
        return false
      end
      return true
    end
  end
  return false
end

function ProfessionProxy:NeedShowNoviceJinjie()
  local curProf = MyselfProxy.Instance:GetMyProfession()
  if not ProfessionProxy.IsNovice(curProf) then
    return false
  end
  local jobLevel = self:GetThisJobLevelForClient(curProf, MyselfProxy.Instance:JobLevel())
  local nowRoleLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  xdlog(jobLevel, nowRoleLevel)
  if 10 <= jobLevel and 10 <= nowRoleLevel then
    return true
  end
end

autoImport("NewRechargeHeroData")

function ProfessionProxy:UpdateRechargeHeroList(heroShowUserCmd)
  if not self.rechargeHeroList then
    self.rechargeHeroList = {}
  else
    TableUtility.ArrayClear(self.rechargeHeroList)
  end
  local infos = heroShowUserCmd.infos
  for i = 1, #infos do
    local heroProfessionInfo = infos[i]
    local branchid = heroProfessionInfo.branch
    if _GameConfigHeroShop[branchid] then
      local d = NewRechargeHeroData.new(branchid)
      d:UpdateServerInfo(heroProfessionInfo)
      table.insert(self.rechargeHeroList, d)
    else
      LogUtility.Error(string.format("GameConfig中未找到英雄职业Branch的配置:%s", branchid))
    end
  end
  table.sort(self.rechargeHeroList, function(a, b)
    if a.sort ~= b.sort then
      return a.sort > b.sort
    end
    return a.classid > b.classid
  end)
end

function ProfessionProxy:GetRechargeHeroList()
  if not self.outRechargeHeroList then
    self.outRechargeHeroList = {}
  else
    TableUtility.TableClear(self.outRechargeHeroList)
  end
  local d
  if self.rechargeHeroList then
    for i = 1, #self.rechargeHeroList do
      d = self.rechargeHeroList[i]
      if d:GetLeftTime() then
        table.insert(self.outRechargeHeroList, d)
      end
    end
  end
  return self.outRechargeHeroList
end

function ProfessionProxy:IsRechargeHeroDateNew(branchid)
  local d
  if self.rechargeHeroList then
    for i = 1, #self.rechargeHeroList do
      d = self.rechargeHeroList[i]
      if d.branchId == branchid then
        return d:IsDateNew()
      end
    end
  end
end

function ProfessionProxy:IsSeeRechargeHero(branchid)
  local key = "RechargeHero" .. branchid
  return FunctionPlayerPrefs.Me():GetBool(key) == true
end

function ProfessionProxy:SeenRechargeHero(branchid)
  local key = "RechargeHero" .. branchid
  FunctionPlayerPrefs.Me():SetBool(key, true)
end

function ProfessionProxy.GetBrotherBranch(branchid)
  local branchConfig = Table_Branch[branchid]
  if not branchConfig then
    return
  end
  local raw_brotherList = string.split(branchConfig.brother_list, ",")
  local result = {}
  for i = 1, #raw_brotherList do
    local brotherBranch = tonumber(raw_brotherList[i])
    local branchInfo = Table_Branch[brotherBranch]
    local gender = branchInfo and branchInfo.gender
    if not gender or gender == MyselfProxy.Instance:GetMySex() then
      table.insert(result, brotherBranch)
    end
  end
  return #result == 1 and result[1]
end

function ProfessionProxy.GetProfList(branchid)
  local branchConfig = Table_Branch[branchid]
  if not branchConfig then
    return
  end
  local result = {}
  local proList = string.split(branchConfig.profession_list, ",")
  if proList then
    for i = 1, #proList do
      table.insert(result, tonumber(proList[i]))
    end
  end
  return result
end

function ProfessionProxy:CheckBranchShowValid(classid)
  local isTF = EnvChannel.IsTFBranch()
  local classConfig = Table_Class[classid]
  if not classConfig then
    return
  end
  local startTime, endTime
  if isTF then
    startTime = classConfig.TFShowStartTime
    endTime = classConfig.TFShowEndTime
  else
    startTime = classConfig.ShowStartTime
    endTime = classConfig.ShowEndTime
  end
  if not startTime or not endTime then
    return true
  end
  if KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) then
    xdlog("时间合法", typeBranch)
    return true
  else
    return false
  end
end

function ProfessionProxy:RechargeHeroNewDate()
  local checkList = self:GetRechargeHeroList()
  if checkList then
    for i = 1, #checkList do
      local heroData = checkList[i]
      if heroData:IsNew() then
        return heroData.newdate
      end
    end
  end
  return nil
end

function ProfessionProxy:HasDoramProf()
  local S_table = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  for k, v in pairs(S_table) do
    local prof = v.profession
    if ProfessionProxy.IsDoramRace(prof) then
      return true
    end
  end
end

function ProfessionProxy:RecvSwitchFashionEquipRecordItemCmd(data)
  local index = data.index
  xdlog("当前的幻化栏位", index)
  self.fashionSetIndex = index
end

function ProfessionProxy:GetCurFashionSetIndex()
  return self.fashionSetIndex
end

function ProfessionProxy:SetCurFashionSetIndex(index)
  if not index then
    self.fashionSetIndex = index
  end
end

function ProfessionProxy.ShieldPosCanEquipWeapon(profId, craeture)
  return ProfessionProxy.GetTypeBranchFromProf(profId) == 681 and craeture.data:ShieldPosCanEquipWeapon()
end

function ProfessionProxy:GetClassPreviewFirstRowTable()
  if not Table_TransferClass then
    redlog("缺少表格Table_TransferClass")
    return
  end
  local _MyRace = MyselfProxy.Instance:GetMyRace()
  local groupClass = {}
  for typeBranch, info in pairs(Table_TransferClass) do
    if not groupClass[info.GroupClassID] and Table_Class[info.GroupClassID].Race == _MyRace then
      groupClass[info.GroupClassID] = 1
    end
  end
  local result = {}
  for groupid, _ in pairs(groupClass) do
    table.insert(result, groupid)
  end
  table.sort(result, function(l, r)
    return l < r
  end)
  return result
end

function ProfessionProxy.IsSunshine(profId)
  profId = profId or MyselfProxy:GetMyProfession()
  return profId == ProfessionProxy.Sunshine
end
