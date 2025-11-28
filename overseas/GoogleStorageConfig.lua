GoogleStorageConfig = {}
if BackwardCompatibilityUtil.CompatibilityMode_V38 then
  GoogleStorageConfig.googleStorageDownLoad = RO.Config.BuildBundleEnvInfo.CdnWithEnv
  GoogleStorageConfig.googleStorageUpLoad = RO.Config.BuildBundleEnvInfo.CdnWithEnv
else
  GoogleStorageConfig.googleStorageDownLoad = RO.Config.BuildBundleEnvInfo.ResCDN
  GoogleStorageConfig.googleStorageUpLoad = RO.Config.BuildBundleEnvInfo.ResCDN
end
if BranchMgr.IsTW() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-tw-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://tw-ugc.ro.com"
elseif BranchMgr.IsSEA() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-sea-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://sea-ugc.ro.com"
elseif BranchMgr.IsKorea() then
  GoogleStorageConfig.googleStorageDownLoad = "http://kr-ugc.ro.com"
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-kr-gcs.storage.googleapis.com"
elseif BranchMgr.IsJapan() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-kr-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://jp-cdn.ro.com"
elseif BranchMgr.IsNA() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-na-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://na-ugc.ro.com"
elseif BranchMgr.IsEU() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-eu-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://eu-cdn.ro.com"
elseif BranchMgr.IsNO() or BranchMgr.IsNOTW() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-no-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://no-cdn.ro.com"
elseif BranchMgr.IsNOEN() then
  GoogleStorageConfig.googleStorageUpLoad = "http://ro-noen-gcs.storage.googleapis.com"
  GoogleStorageConfig.googleStorageDownLoad = "http://noen-cdn.ro.com"
end
