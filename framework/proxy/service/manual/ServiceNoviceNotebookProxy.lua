autoImport("ServiceNoviceNotebookAutoProxy")
ServiceNoviceNotebookProxy = class("ServiceNoviceNotebookProxy", ServiceNoviceNotebookAutoProxy)
ServiceNoviceNotebookProxy.Instance = nil
ServiceNoviceNotebookProxy.NAME = "ServiceNoviceNotebookProxy"

function ServiceNoviceNotebookProxy:ctor(proxyName)
  if ServiceNoviceNotebookProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNoviceNotebookProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNoviceNotebookProxy.Instance = self
  end
end

function ServiceNoviceNotebookProxy:RecvNoviceNotebookCmd(data)
  redlog("ServiceNoviceNotebookProxy:RecvNoviceNotebook")
  JournalProxy.Instance:UpdateJournalData(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookCmd, data)
end

function ServiceNoviceNotebookProxy:RecvNoviceNotebookCoverOpenCmd(data)
  redlog("ServiceNoviceNotebookProxy:RecvNoviceNotebookCoverOpen")
  JournalProxy.Instance:UnlockJournal(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookCoverOpenCmd, data)
end

function ServiceNoviceNotebookProxy:RecvNoviceNotebookReceiveAwardCmd(data)
  redlog("ServiceNoviceNotebookProxy:RecvNoviceNotebookReceiveAward")
  JournalProxy.Instance:UpdateJournalRewardState(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookReceiveAwardCmd, data)
end
