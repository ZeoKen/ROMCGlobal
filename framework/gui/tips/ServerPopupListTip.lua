ServerPopupListTip = class("ServerPopupListTip", BaseTip)
autoImport("NewServerListCell")

function ServerPopupListTip:Init()
  ServerPopupListTip.super.Init(self)
  self.content = self:FindGO("content")
  self.closecomp = self:FindComponent("content", CloseWhenClickOtherPlace)
  self.bgsprite = self.content:GetComponent(UISprite)
  self.gridCmp = self:FindComponent("ServerListTable", UIGrid)
  self.serverList = UIGridListCtrl.new(self.gridCmp, NewServerListCell, "NewServerListCell")
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.scrollPanel = self:FindComponent("ScrollView", UIPanel)
  self.serverList:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function ServerPopupListTip:ClickItem(cell)
  local serverData = cell.data
  local loginData = FunctionLogin.Me():getLoginData()
  local flag = loginData ~= nil and loginData.flag or 0
  self:sendNotification(ServiceEvent.ChooseServer, serverData)
  self:CloseSelf()
end

function ServerPopupListTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

local tempV3 = LuaVector3()

function ServerPopupListTip:SetData()
  local list = FunctionLogin.Me():getServerDatas()
  self.serverList:ResetDatas(list)
  if list and 0 < #list then
    local heightCount = 3 < #list and 3 or #list
    local gridHeight = self.gridCmp.cellHeight * heightCount
    self.bgsprite.height = gridHeight + 48
    self.scrollPanel:SetRect(self.scrollPanel.baseClipRegion.x, self.scrollPanel.baseClipRegion.y, self.scrollPanel.baseClipRegion.z, gridHeight - 6)
    tempV3[2] = 68 - gridHeight / 2
    self.content.gameObject.transform.localPosition = tempV3
    self.serverList:Layout()
    self.scrollView:ResetPosition()
  end
  local targetCell
  local cells = self.serverList:GetCells()
  for i = 1, #cells do
    if cells[i].data and cells[i].data.state == 4 then
      targetCell = cells[i]
      break
    end
  end
  if targetCell then
    local panel = self.scrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollView:MoveRelative(offset)
  end
end

function ServerPopupListTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function ServerPopupListTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
  self.closecomp = nil
end

function ServerPopupListTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
