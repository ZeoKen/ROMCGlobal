autoImport("ChatItemCombineCell")
ChatItemPage = class("ChatItemPage", SubView)

function ChatItemPage:OnEnter()
  self:UpdateItem()
end

function ChatItemPage:OnExit()
  ChatRoomProxy.Instance:ResetItemDataList()
end

function ChatItemPage:Init()
  self:AddViewEvts()
end

function ChatItemPage:TryInit()
  if self.isInit then
    return
  end
  self.isInit = true
  self:FindObjs()
  self:InitShow()
end

function ChatItemPage:FindObjs()
  self.contentScrollView = self:FindGO("ItemScrollView", self.container.PopUpWindow):GetComponent(UIScrollView)
end

function ChatItemPage:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateItem)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateItem)
end

function ChatItemPage:InitShow()
  self.localData = {}
  local container = self:FindGO("Item_Container", self.container.PopUpWindow)
  self.localData.wrapObj = container
  self.localData.pfbNum = 4
  self.localData.cellName = "ChatItemCombineCell"
  self.localData.control = ChatItemCombineCell
  self.localData.dir = 1
  self.itemWrapHelper = WrapCellHelper.new(self.localData)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:UpdateItem()
end

function ChatItemPage:UpdateItem()
  if self.isInit == nil then
    return
  end
  local data = ChatRoomProxy.Instance:GetChatItemInfo()
  self:ReUniteCellData(data, 11)
  self.itemWrapHelper:UpdateInfo(self.localData)
end

function ChatItemPage:HandleClickItem(cellctl)
  if cellctl.data then
    local content = ChatRoomProxy.Instance:TryParseItemDataToNormal(cellctl.data)
    self.container:SetContentInputValue(content)
    ChatRoomProxy.Instance:AddItemData(cellctl.data)
  end
end

function ChatItemPage:ReUniteCellData(datas, perRowNum)
  TableUtility.TableClear(self.localData)
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      self.localData[i1] = self.localData[i1] or {}
      if datas[i] == nil then
        self.localData[i1][i2] = nil
      else
        self.localData[i1][i2] = datas[i]
      end
    end
  end
end
