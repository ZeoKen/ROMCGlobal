NewPeddlerShopWrapListCtrl = class("NewPeddlerShopWrapListCtrl", WrapListCtrl)

function NewPeddlerShopWrapListCtrl:_AddWrapEvent()
  function self.wrap.onInitializeItem(obj, wrapI, realI)
    if not self.ctls then
      return
    end
    local index = self:GetDataIndexFromRealIndex(realI)
    if index <= #self.datas and self.ctls[wrapI] then
      self.ctls[wrapI]:SetData(self.datas[index])
    end
    if self.update_call then
      self.update_call(self.update_callParam)
    end
  end
end
