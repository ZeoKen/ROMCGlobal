AppBundleConfig = {}
AppBundleConfig.BundleID = GetAppBundleVersion.BundleVersion
AppBundleConfig.IOSAppUrl = "https://itunes.apple.com/cn/app/xian-jing-chuan-shuoro/id1071801856?l=zh&ls=1&mt=8"
AppBundleConfig.AndroidAppUrl = "https://www.taptap.com/app/7133"
AppBundleConfig.iosApp_ID = "1071801856"
AppBundleConfig.IOSAppReviewUrl = string.format("http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1071801856&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", AppBundleConfig.iosApp_ID)
AppBundleConfig.AndroidAppReviewUrl = "https://www.taptap.com/app/7133/review"
AppBundleConfig.IOSAppTeasingUrl = "https://ro.com/bbs"
AppBundleConfig.AndroidAppTeasingUrl = "https://ro.com/bbs"
local XDSDK_Config = {
  ["com.xd.ro"] = {
    APP_ID = "2isp77irl1c0gc4",
    APP_SECRET = "4be2a070553dab1665fc6e91ea71714f",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.pinidea.ent.generalofgods"] = {
    APP_ID = "cf1j5axm7hckw48",
    APP_SECRET = "28450c8d55956f53d775eef31047870b",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro1"] = {
    APP_ID = "4qnxjf4p9zi8k4o",
    APP_SECRET = "ceeac4b5dec00d8c1022516e416d598e",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro2"] = {
    APP_ID = "93ff4crh0pogg80",
    APP_SECRET = "381411b2ed82fe9776f92e0fa0bdc534",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro3"] = {
    APP_ID = "6f7sft2ht3c4g80",
    APP_SECRET = "3935ce1c396a8015aed23ead8a331eb1",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro4"] = {
    APP_ID = "1wmiwtf3ckg08k4",
    APP_SECRET = "1bcb805a2d6f7bfd06eca20ea88f13fa",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.ro.xdapk"] = {
    APP_ID = "8ptdnizk5ukg4c0",
    ORIENTATION = 0
  },
  ["com.xd.ro.apk"] = {
    APP_ID = "8ptdnizk5ukg4c0",
    ORIENTATION = 0
  },
  ["com.xd.ro.roapk"] = {
    APP_ID = "9hshhxi7c4wso8o",
    ORIENTATION = 0
  },
  ["com.xd.windows.rotf"] = {
    APP_ID = "70lp3618xyscokw",
    APP_SECRET = "300776c0d272982e8bf19a3fd0509dcf",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  },
  ["com.xd.windows.rorelease"] = {
    APP_ID = "a2ofxipzmcgggs0",
    APP_SECRET = "8e71e7610fd49af21592f8008312c193",
    PRIVATE_SECRET = "",
    ORIENTATION = 0
  }
}

function AppBundleConfig.GetXDSDKInfo()
  if ApplicationInfo.IsWindows() then
    if EnvChannel.IsReleaseBranch() then
      return XDSDK_Config["com.xd.windows.rorelease"]
    elseif EnvChannel.IsTFBranch() then
      return XDSDK_Config["com.xd.windows.rotf"]
    elseif EnvChannel.IsStudioBranch() then
      return XDSDK_Config["com.xd.windows.rorelease"]
    else
      return XDSDK_Config["com.xd.windows.rorelease"]
    end
  elseif XDSDK_Config[AppBundleConfig.BundleID] == nil then
    if EnvChannel.IsReleaseBranch() then
      if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
        return XDSDK_Config["com.xd.ro"]
      elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
        return XDSDK_Config["com.xd.ro.roapk"]
      else
        return XDSDK_Config["com.xd.ro"]
      end
    elseif EnvChannel.IsTFBranch() then
      if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
        return XDSDK_Config["com.xd.ro2"]
      elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
        return XDSDK_Config["com.xd.ro.xdapk"]
      else
        return XDSDK_Config["com.xd.ro"]
      end
    else
      return XDSDK_Config["com.xd.ro"]
    end
  else
    return XDSDK_Config[AppBundleConfig.BundleID]
  end
end

local SocialShare_Config = {
  ["com.xd.ro"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  },
  ["com.xd.ro2"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  },
  ["com.xd.ro.xdapk"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  },
  ["com.xd.ro.roapk"] = {
    SINA_WEIBO_APP_KEY = "650343694",
    SINA_WEIBO_APP_SECRET = "5bd99ffa23bd05cbb649ea540963ab86",
    QQ_APP_ID = "1105442815",
    QQ_APP_KEY = "2b723a9b2c445b174b5bc60e6f7234cb",
    WECHAT_APP_ID = "wx9fdd68bd6b3c85a2",
    WECHAT_APP_SECRET = "b3558e97106af65d2326d43fcfd606aa"
  }
}
local temp = {}

function AppBundleConfig.GetSocialShareInfo()
  local config = SocialShare_Config[AppBundleConfig.BundleID]
  if config then
    return config
  else
    return temp
  end
end

function AppBundleConfig.JumpToAppStore()
  AppBundleConfig.JumpToIOSAppStore()
  AppBundleConfig.JumpToAndroidAppStore()
end

function AppBundleConfig.JumpToIOSAppStore()
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    Application.OpenURL(AppBundleConfig.IOSAppUrl)
  end
end

function AppBundleConfig.JumpToAndroidAppStore()
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Application.OpenURL(AppBundleConfig.AndroidAppUrl)
  end
end

function AppBundleConfig.JumpToAppReview()
  local config = GameConfig.AppBundleConfig
  if config == nil then
    config = AppBundleConfig
  end
  AppBundleConfig.JumpToIOSAppReview(config)
  AppBundleConfig.JumpToAndroidAppReview(config)
end

function AppBundleConfig.JumpToIOSAppReview(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    Application.OpenURL(config.IOSAppReviewUrl)
  end
end

function AppBundleConfig.JumpToAndroidAppReview(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Application.OpenURL(config.AndroidAppReviewUrl)
  end
end

function AppBundleConfig.JumpToAppTeasing()
  local config = GameConfig.AppBundleConfig
  if config == nil then
    config = AppBundleConfig
  end
  AppBundleConfig.JumpToAndroidAppTeasing(config)
  AppBundleConfig.JumpToIOSAppTeasing(config)
end

function AppBundleConfig.JumpToAndroidAppTeasing(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    Application.OpenURL(config.AndroidAppTeasingUrl)
  end
end

function AppBundleConfig.JumpToIOSAppTeasing(config)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    Application.OpenURL(config.IOSAppTeasingUrl)
  end
end

local langConf = {
  English = "en",
  Indonesian = "id",
  Japanese = "jp",
  Portuguese = "pt",
  Russian = "ru",
  Spanish = "es",
  Thai = "th",
  Vietnamese = "vn",
  ChineseSimplified = "cn",
  ChineseTraditional = "tw",
  Korean = "kr",
  German = "de",
  French = "en",
  Turkish = "en"
}

function AppBundleConfig.GetSDKLang()
  local curLang = OverSea.LangManager.Instance().CurSysLang
  if langConf[curLang] ~= nil then
    return langConf[curLang]
  end
  return "en"
end

local tdsg_lang = {
  cn = 0,
  tw = 1,
  en = 2,
  th = 3,
  id = 4,
  kr = 5,
  jp = 6,
  de = 7,
  fr = 2,
  pt = 9,
  es = 10,
  tr = 2,
  ru = 12
}
if ApplicationInfo.IsWindows() then
  if BranchMgr.IsJapan() then
    AppBundleConfig.BundleID = "jp.gungho.ragnarokm"
  elseif BranchMgr.IsKorea() then
    AppBundleConfig.BundleID = "com.gravity.rom.aos"
  elseif BranchMgr.IsTW() then
    AppBundleConfig.BundleID = "com.gravity.ro.and"
  elseif BranchMgr.IsSEA() then
    AppBundleConfig.BundleID = "com.gravity.romi"
  elseif BranchMgr.IsNA() then
    AppBundleConfig.BundleID = "com.gravity.romgi"
  elseif BranchMgr.IsEU() then
    AppBundleConfig.BundleID = "com.gravity.romEUi"
  elseif BranchMgr.IsVN() then
    AppBundleConfig.BundleID = "com.n9.romi"
  elseif BranchMgr.IsNO() then
    if EnvChannel.IsTFBranch() then
      AppBundleConfig.BundleID = "com.gravityus.romzenybeta.ios"
    else
      AppBundleConfig.BundleID = "com.gravityus.romzeny.ios"
    end
  elseif BranchMgr.IsNOTW() then
    AppBundleConfig.BundleID = "com.gravityus.romtwzeny.ios"
  elseif BranchMgr.IsNOEN() then
    AppBundleConfig.BundleID = "com.gravityus.romgzeny.ios"
  end
end
AppBundleConfig.TDSG_Config = {
  ["com.gravity.ro.ios"] = "JN6hT05LuxoT28rDf9",
  ["com.gravity.ro.and"] = "JN6hT05LuxoT28rDf9",
  ["jp.gungho.ragnarokm"] = "wFAXZjCjXPbJIsVGz3",
  ["com.gravity.rom.ios"] = "sLzwlNcUopNUdYkMa5",
  ["com.gravity.rom.aos"] = "sLzwlNcUopNUdYkMa5",
  ["com.gravity.romi"] = "AShxBZLJv0hXkc5ugE",
  ["com.gravity.romg"] = "AShxBZLJv0hXkc5ugE",
  ["com.gravity.romgi"] = "7HK6Ik54sRVYOjpfU0",
  ["com.gravity.romNAg"] = "7HK6Ik54sRVYOjpfU0",
  ["com.gravity.romEUi"] = "VmAB9hNbJlb1PIoDfp",
  ["com.gravity.romEUg"] = "VmAB9hNbJlb1PIoDfp",
  ["com.n9.romi"] = "74mku5hgkzkzqaa9kf",
  ["com.n9.romg"] = "74mku5hgkzkzqaa9kf",
  ["com.gravityus.romzeny.aos"] = "uwkyu08gfavqeg7ivf",
  ["com.gravityus.romzeny.ios"] = "uwkyu08gfavqeg7ivf",
  ["com.gravityus.romzenybeta.ios"] = "6inbf8qkqgk0hv4da1",
  ["com.gravityus.romzenybeta.aos"] = "6inbf8qkqgk0hv4da1",
  ["com.gravityus.romtwzeny.ios"] = "gwhvwhzdyowuchb7dj",
  ["com.gravityus.romtwzeny.aos"] = "gwhvwhzdyowuchb7dj",
  ["com.gravityus.romgzeny.ios"] = "74rhviyx49ygth3mrr",
  ["com.gravityus.romgzeny.aos"] = "74rhviyx49ygth3mrr"
}

function AppBundleConfig.GetSDKLang_TDSG()
  helplog("AppBundleConfig => GetSDKLang_TDSG")
  if BranchMgr.IsTW() then
    return tdsg_lang.tw
  elseif BranchMgr.IsKorea() then
    return tdsg_lang.kr
  elseif BranchMgr.IsJapan() then
    return tdsg_lang.jp
  else
    return tonumber(tdsg_lang[AppBundleConfig.GetSDKLang()])
  end
  return 2
end

local tdsg_adjust_config = {
  sdkLogin = "Login",
  crateRole = "charater create",
  changeJob = "Change Job quest end",
  appPurchase = "In App Purchase Revenue",
  firstPay = "First Purchase User",
  server = "Server Check"
}
local tdsg_adjust_config_tw = {
  sdkLogin = "SDKLogin",
  crateRole = "FirstCreateRole",
  Level_10 = "Level_10",
  Level_120 = "Level_120",
  Monthly_card = "Monthly_card",
  changeJob = "Change Job quest end",
  appPurchase = "In App Purchase Revenue",
  firstPay = "First Purchase User",
  server = "Server Check"
}

function AppBundleConfig.GetAdjustByName(eventName)
  local config = tdsg_adjust_config
  if BranchMgr.IsTW() then
    config = tdsg_adjust_config_tw
  end
  return config[eventName]
end

local conf_NA = {
  ["6"] = "ChineseSimplified",
  ["10"] = "English",
  ["28"] = "Portuguese",
  ["40"] = "ChineseSimplified",
  ["41"] = "ChineseSimplified",
  ["23"] = "Korean",
  ["34"] = "Spanish"
}
local conf_EU = {
  ["6"] = "ChineseSimplified",
  ["10"] = "English",
  ["14"] = "French",
  ["15"] = "German",
  ["37"] = "Turkish",
  ["28"] = "Portuguese",
  ["30"] = "Russian",
  ["34"] = "Spanish",
  ["40"] = "ChineseSimplified",
  ["41"] = "ChineseSimplified"
}
local conf_WW = {
  ["6"] = "ChineseSimplified",
  ["10"] = "English",
  ["20"] = "Indonesian",
  ["36"] = "Thai",
  ["40"] = "ChineseSimplified",
  ["41"] = "ChineseSimplified"
}
local conf_NO = {
  ["6"] = "ChineseSimplified",
  ["10"] = "English",
  ["20"] = "Indonesian",
  ["36"] = "Thai",
  ["40"] = "ChineseSimplified",
  ["41"] = "ChineseSimplified"
}
local conf_NOEN = {
  ["6"] = "ChineseSimplified",
  ["10"] = "English",
  ["14"] = "French",
  ["15"] = "German",
  ["37"] = "Turkish",
  ["28"] = "Portuguese",
  ["30"] = "Russian",
  ["34"] = "Spanish",
  ["40"] = "ChineseSimplified",
  ["41"] = "ChineseSimplified"
}

function AppBundleConfig.GetLangString(lang)
  local conf
  if BranchMgr.IsSEA() then
    conf = conf_WW
  elseif BranchMgr.IsNA() then
    conf = conf_NA
  elseif BranchMgr.IsEU() then
    conf = conf_EU
  elseif BranchMgr.IsNOEN() then
    conf = conf_NOEN
  elseif BranchMgr.IsNO() or BranchMgr.IsNOTW() then
    conf = conf_NO
  end
  if conf and conf[lang] then
    return conf[lang]
  end
  return "English"
end
