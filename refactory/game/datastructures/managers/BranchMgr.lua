BranchMgr = _G.BranchMgr or {
  None = true,
  China = false,
  Japan = false,
  Korea = false,
  TW = false,
  SEA = false,
  NA = false,
  EU = false,
  VN = false,
  NO = false,
  NOTW = false,
  NOEN = false
}
BranchMgr.Language = {
  ELANGUAGE_Afrikaans = 0,
  ELANGUAGE_Arabic = 1,
  ELANGUAGE_Basque = 2,
  ELANGUAGE_Belarusian = 3,
  ELANGUAGE_Bulgarian = 4,
  ELANGUAGE_Catalan = 5,
  ELANGUAGE_Chinese = 6,
  ELANGUAGE_Czech = 7,
  ELANGUAGE_Danish = 8,
  ELANGUAGE_Dutch = 9,
  ELANGUAGE_English = 10,
  ELANGUAGE_Estonian = 11,
  ELANGUAGE_Faroese = 12,
  ELANGUAGE_Finnish = 13,
  ELANGUAGE_French = 14,
  ELANGUAGE_German = 15,
  ELANGUAGE_Greek = 16,
  ELANGUAGE_Hebrew = 17,
  ELANGUAGE_Hungarian = 18,
  ELANGUAGE_Icelandic = 19,
  ELANGUAGE_Indonesian = 20,
  ELANGUAGE_Italian = 21,
  ELANGUAGE_Japanese = 22,
  ELANGUAGE_Korean = 23,
  ELANGUAGE_Latvian = 24,
  ELANGUAGE_Lithuanian = 25,
  ELANGUAGE_Norwegian = 26,
  ELANGUAGE_Polish = 27,
  ELANGUAGE_Portuguese = 28,
  ELANGUAGE_Romanian = 29,
  ELANGUAGE_Russian = 30,
  ELANGUAGE_SerboCroatian = 31,
  ELANGUAGE_Slovak = 32,
  ELANGUAGE_Slovenian = 33,
  ELANGUAGE_Spanish = 34,
  ELANGUAGE_Swedish = 35,
  ELANGUAGE_Thai = 36,
  ELANGUAGE_Turkish = 37,
  ELANGUAGE_Ukrainian = 38,
  ELANGUAGE_Vietnamese = 39,
  ELANGUAGE_CHINESE_SIMPLIFIED = 40,
  ELANGUAGE_CHINESE_TRADITIONAL = 41,
  ELANGUAGE_Unknown = 42
}

function BranchMgr.Init()
  BranchMgr.Reset()
  ISNoviceServerType = false
  local branchName = BranchInfo.GetBranchName()
  if branchName == "None" then
    BranchMgr.None = true
  elseif branchName == "China" then
    BranchMgr.China = true
  elseif branchName == "Oversea_Japan" then
    BranchMgr.Japan = true
  elseif branchName == "Oversea_Korea" then
    BranchMgr.Korea = true
  elseif branchName == "Oversea_Taiwan" then
    BranchMgr.TW = true
    using("OverSeas_TW")
  elseif branchName == "Oversea_SouthEast" then
    BranchMgr.SEA = true
  elseif branchName == "Oversea_NorthAmerica" then
    BranchMgr.NA = true
  elseif branchName == "Oversea_Europe" then
    BranchMgr.EU = true
  elseif branchName == "Oversea_Vietnam" then
    BranchMgr.VN = true
  elseif branchName == "Oversea_NoviceWW" then
    BranchMgr.NO = true
    ISNoviceServerType = true
  elseif branchName == "Oversea_NoviceTW" then
    BranchMgr.NOTW = true
    ISNoviceServerType = true
  elseif branchName == "Oversea_NoviceEN" then
    BranchMgr.NOEN = true
    ISNoviceServerType = true
  end
end

function BranchMgr.Reset()
  BranchMgr.None = true
  BranchMgr.China = false
  BranchMgr.Japan = false
  BranchMgr.Korea = false
  BranchMgr.TW = false
  BranchMgr.SEA = false
  BranchMgr.NA = false
  BranchMgr.EU = false
  BranchMgr.VN = false
  BranchMgr.NO = false
  BranchMgr.NOTW = false
  BranchMgr.NOEN = false
end

function BranchMgr.IsChina()
  return BranchMgr.China
end

function BranchMgr.IsJapan()
  return BranchMgr.Japan
end

function BranchMgr.IsKorea()
  return BranchMgr.Korea
end

function BranchMgr.IsTW()
  return BranchMgr.TW
end

function BranchMgr.IsSEA()
  return BranchMgr.SEA
end

function BranchMgr.IsNA()
  return BranchMgr.NA
end

function BranchMgr.IsEU()
  return BranchMgr.EU
end

function BranchMgr.IsVN()
  return BranchMgr.VN
end

function BranchMgr.IsNO()
  return BranchMgr.NO
end

function BranchMgr.IsNOTW()
  return BranchMgr.NOTW
end

function BranchMgr.IsNOEN()
  return BranchMgr.NOEN
end

function BranchMgr.IsAll()
  return BranchMgr.None
end

function BranchMgr.GetLanguage()
  local result = 0
  if BranchMgr.IsJapan() then
    result = BranchMgr.Language.ELANGUAGE_Japanese
  elseif BranchMgr.IsTW() then
    result = BranchMgr.Language.ELANGUAGE_CHINESE_TRADITIONAL
  elseif BranchMgr.IsKorea() then
    result = BranchMgr.Language.ELANGUAGE_Korean
  elseif BranchMgr.IsVN() then
    result = BranchMgr.Language.ELANGUAGE_Vietnamese
  else
    result = BranchMgr.Language.ELANGUAGE_Chinese
  end
  return result
end

function BranchMgr.GetBranchName()
  local branch = "None"
  if BranchMgr.IsSEA() then
    branch = "SEA"
  elseif BranchMgr.IsNA() then
    branch = "NA"
  elseif BranchMgr.IsEU() then
    branch = "EU"
  elseif BranchMgr.IsTW() then
    branch = "TW"
  elseif BranchMgr.IsKorea() then
    branch = "KR"
  elseif BranchMgr.IsJapan() then
    branch = "JP"
  elseif BranchMgr.IsVN() then
    branch = "VN"
  elseif BranchMgr.IsNO() then
    branch = "NO"
  elseif BranchMgr.IsNOTW() then
    branch = "NOTW"
  elseif BranchMgr.IsNOEN() then
    branch = "NOEN"
  end
  return branch
end

function BranchMgr.GetBranchName_Simple()
  if BranchMgr.IsSEA() then
    return "WW"
  elseif BranchMgr.IsChina() then
    return "CN"
  else
    return BranchMgr.GetBranchName()
  end
end

function BranchMgr.Get_EAREA()
  if BranchMgr.IsChina() then
    return "CH"
  else
    return BranchMgr.GetBranchName_Simple()
  end
end
