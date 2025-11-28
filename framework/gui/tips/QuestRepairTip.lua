QuestRepairTip = class("QuestRepairTip", BaseTip)

function QuestRepairTip:Init()
  QuestRepairTip.super.Init(self)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.repairBtn = self:FindGO("RepairBtn")
  self.askServiceBtn = self:FindGO("AskServiceBtn")
  self:AddClickEvent(self.repairBtn, function()
    xdlog("点击修理", self.questIdReadyToRepair)
    ServiceQuestProxy.Instance:CallQuestAction(7, self.questIdReadyToRepair)
    MyselfProxy.Instance:SetQuestRepairMode(false)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.askServiceBtn, function()
    self:ApplyService()
    xdlog("请求客服")
    self:CloseSelf()
  end)
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipManager.CloseTip()
  end
end

function QuestRepairTip:SetData(data)
  self.data = data
  local questName = self.data.staticData.Name or ""
  self.tipLabel.text = string.format(ZhString.QuestRepair_HelpTip, questName)
  self.questIdReadyToRepair = self.data.id
end

function QuestRepairTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function QuestRepairTip:HandleShowRepairPopUp()
  if cellCtrl and cellCtrl.data then
    local data = cellCtrl.data
    local questName = data.staticData.Name or ""
    self.tipLabel.text = string.format(ZhString.QuestRepair_HelpTip, questName)
    self.repairQuestPopUp:SetActive(true)
    self.repairPopUp_TweenAlpha:ResetToBeginning()
    self.repairPopUp_TweenAlpha:PlayForward()
    self.questIdReadyToRepair = data.id
  end
end

function QuestRepairTip:ApplyService()
  if BranchMgr.IsChina() then
    local url = "https://www.xd.com/service/form/ro/"
    Application.OpenURL(url)
  elseif BranchMgr.IsTW() then
    local url = "https://www.gnjoy.com.tw/Cs"
    Application.OpenURL(url)
  else
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or 1
    local resVersion = VersionUpdateManager.CurrentVersion
    if resVersion == nil then
      resVersion = "Unknown"
    end
    local currentVersion = CompatibilityVersion.version
    local bundleVersion = GetAppBundleVersion.BundleVersion
    local version = string.format("%s,%s,%s", resVersion, currentVersion, bundleVersion)
    FunctionSDK.Instance:EnterUserCenter(serverID, "未登入", version)
  end
end

function QuestRepairTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function QuestRepairTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  xdlog("QuestRepairTip:CloseSelf")
  TipsView.Me():HideCurrent()
end

function QuestRepairTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
