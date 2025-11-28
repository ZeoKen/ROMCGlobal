UIModelMiyinStrengthen = class("UIModelMiyinStrengthen")

function UIModelMiyinStrengthen:Ins()
  if UIModelMiyinStrengthen.ins == nil then
    UIModelMiyinStrengthen.ins = UIModelMiyinStrengthen.new()
  end
  return UIModelMiyinStrengthen.ins
end

local miyinConfID = 5030

function UIModelMiyinStrengthen:GetOwnMiyinCount()
  return BagProxy.Instance:GetItemNumByStaticID(miyinConfID)
end
