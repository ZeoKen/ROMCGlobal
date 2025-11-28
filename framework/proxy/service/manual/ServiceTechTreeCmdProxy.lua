autoImport("ServiceTechTreeCmdAutoProxy")
ServiceTechTreeCmdProxy = class("ServiceTechTreeCmdProxy", ServiceTechTreeCmdAutoProxy)
ServiceTechTreeCmdProxy.Instance = nil
ServiceTechTreeCmdProxy.NAME = "ServiceTechTreeCmdProxy"

function ServiceTechTreeCmdProxy:ctor(proxyName)
  if ServiceTechTreeCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTechTreeCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTechTreeCmdProxy.Instance = self
  end
end

function ServiceTechTreeCmdProxy:RecvTechTreeUnlockLeafCmd(data)
  TechTreeProxy.Instance:RecvUnlockLeaf(data.leaf.leafid, data.leaf.level, data.nodeinfo)
  ServiceTechTreeCmdProxy.super.RecvTechTreeUnlockLeafCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvTechTreeSyncLeafCmd(data)
  TechTreeProxy.Instance:RecvSyncLeaf(data)
  ServiceTechTreeCmdProxy.super.RecvTechTreeSyncLeafCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvAddToyDrawingCmd(data)
  TechTreeProxy.Instance:RecvAddToy(data.drawingid)
  ServiceTechTreeCmdProxy.super.RecvAddToyDrawingCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvSyncToyDrawingCmd(data)
  TechTreeProxy.Instance:RecvSyncToy(data.drawings)
  ServiceTechTreeCmdProxy.super.RecvSyncToyDrawingCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvTechTreeLevelAwardCmd(data)
  TechTreeProxy.Instance:RecvTechTreeReward(data)
  ServiceTechTreeCmdProxy.super.RecvTechTreeLevelAwardCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvTechTreeProduceCollectCmd(data)
  ServiceTechTreeCmdProxy.super.RecvTechTreeProduceCollectCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvTechTreeProdecInfoCmd(data)
  TechTreeProxy.Instance:RecvTechTreeProduceInfo(data)
  ServiceTechTreeCmdProxy.super.RecvTechTreeProdecInfoCmd(self, data)
end

function ServiceTechTreeCmdProxy:RecvTechTreeInjectInfoCmd(data)
  TechTreeProxy.Instance:RecvTechTreeInjectInfoCmd(data)
  ServiceTechTreeCmdProxy.super.RecvTechTreeInjectInfoCmd(self, data)
end
