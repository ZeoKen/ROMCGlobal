autoImport("BaseTip")
BindWalletTip = class("BindWalletTip", BaseTip)
local PACKAGE_CHECK = GameConfig.PackageMaterialCheck.default
local WalletMoneyRef = GameConfig.Wallet and GameConfig.Wallet.MoneyRef

function BindWalletTip:Init()
  self:FindObj()
  BindWalletTip.super.Init(self)
end

function BindWalletTip:FindObj()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.item = self:FindComponent("Item", UISprite)
  self.itemNum = self:FindComponent("Num", UILabel)
  self.bindItem = self:FindComponent("BindItem", UISprite)
  self.itemBindNum = self:FindComponent("BindNum", UILabel)
end

function BindWalletTip:SetData(data)
  self.data = data
  if not self.data or 2 ~= #self.data then
    return
  end
  self:Refresh()
end

function BindWalletTip:Refresh()
  local data, myData, n1, n2 = self.data, Game.Myself.data.userdata
  local sp1 = Table_Item[data[1]].Icon
  local sp2 = Table_Item[data[2]].Icon
  IconManager:SetItemIcon(sp1, self.item)
  IconManager:SetItemIcon(sp2, self.bindItem)
  n1 = WalletMoneyRef[data[1]] and myData:Get(WalletMoneyRef[data[1]]) or BagProxy.Instance:GetItemNumByStaticID(data[1], PACKAGE_CHECK)
  n2 = WalletMoneyRef[data[2]] and myData:Get(WalletMoneyRef[data[2]]) or BagProxy.Instance:GetItemNumByStaticID(data[2], PACKAGE_CHECK)
  self.itemNum.text = StringUtil.NumThousandFormat(n1)
  self.itemBindNum.text = StringUtil.NumThousandFormat(n2)
  self.item:MakePixelPerfect()
  self.bindItem:MakePixelPerfect()
end

function BindWalletTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function BindWalletTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
