autoImport("ChatBarrageCell")
ChatBarrageView = class("ChatBarrageView", ContainerView)
ChatBarrageView.ViewType = UIViewType.ProcessLayer

function ChatBarrageView:Init()
  ChatRoomProxy.ChatBarrageViewInstance = self
end

function ChatBarrageView:AddBarrage()
  local datas = ChatRoomProxy.Instance:GetBarrageContent()
  if 0 < #datas then
    local cellCtr = ChatBarrageCell.CreateAsTable(self.gameObject.transform)
    local cellData = ReusableTable.CreateTable()
    cellData.name = datas[1]:GetName()
    cellData.text = datas[1]:GetShowStr(true)
    cellCtr:SetData(cellData)
    ReusableTable.DestroyTable(cellData)
    table.remove(datas, 1)
  end
end

function ChatBarrageView:OnExit()
  ChatRoomProxy.ChatBarrageViewInstance = nil
  ChatBarrageView.super.OnExit(self)
end
