autoImport("PurifyProductData")
CraftingPotProxy = class("CraftingPotProxy", pm.Proxy)
CraftingPotProxy.Instance = nil
CraftingPotProxy.NAME = "CraftingPotProxy"
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.purify_products
local coupons = GameConfig.PurifyProducts and GameConfig.PurifyProducts.Coupon

function CraftingPotProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CraftingPotProxy.NAME
  if CraftingPotProxy.Instance == nil then
    CraftingPotProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function CraftingPotProxy:Init()
  self.products = {}
end

function CraftingPotProxy:InitCall(val)
  self.initCall = val
  if val then
    self.products = {}
  end
end

function CraftingPotProxy:RecvPurifyProductsMaterialsMessCCmd(data)
  if data.materials then
    local products = data.materials
    for i = 1, #products do
      if not self.products[products[i].productid] then
        self.products[products[i].productid] = PurifyProductData.new(products[i])
      else
        self.products[products[i].productid]:SetData(products[i])
        GameFacade.Instance:sendNotification(CraftingPotViewEvent.UpdateProduct)
      end
    end
  end
end

function CraftingPotProxy:SetChoosePurifyProducts(productID)
  for _productid, productData in pairs(self.products) do
    productData:SetChoose(productID == _productid)
  end
end

function CraftingPotProxy:GetPurifyProducts()
  local result = {}
  for _, productData in pairs(self.products) do
    if not productData:IsChoose() then
      result[#result + 1] = productData
    end
  end
  return result
end

function CraftingPotProxy:GetProduct(productid)
  return self.products[productid]
end

function CraftingPotProxy:GetComposingItems(productid)
  return self.products[productid] and self.products[productid]:GetMaterials()
end

function CraftingPotProxy:RecvPurifyProductsRefineMessCCmd(data)
  if data.materials then
    local products = data.materials
    for i = 1, #products do
      self.products[products[i].productid]:SetData(products[i])
    end
  end
end

function CraftingPotProxy:GetItemNumByStaticID(itemid)
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end

function CraftingPotProxy:IsSkipGetEffect()
  return LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.Crafting)
end

function CraftingPotProxy:UpdateMaterialListUsingCoupon(mat_list, mat_bag_type)
  local new_mat_list = {}
  local use, has = false, true
  local useCoupons = {}
  for i = 1, #mat_list do
    local mat = mat_list[i]
    local oriNeedMatNum = mat.num
    local hasMatNum = BagProxy.Instance:GetItemNumByStaticID(mat.id, mat_bag_type) or 0
    local config = Table_Item[mat.id]
    local quality = config and config.Quality or 0
    local _, coupon = TableUtility.TableFindByPredicate(coupons, function(k, v, args)
      local config = Table_Item[k]
      return config and config.Quality == args
    end, quality)
    if coupon then
      if not useCoupons[coupon] then
        useCoupons[coupon] = 0
      end
      local couponNum = BagProxy.Instance:GetItemNumByStaticID(coupon, mat_bag_type) or 0
      local availCouponNum = couponNum - useCoupons[coupon]
      local needCouponNum = oriNeedMatNum - hasMatNum
      if 0 < needCouponNum then
        local realUseCouponNum = math.min(needCouponNum, availCouponNum)
        useCoupons[coupon] = useCoupons[coupon] + realUseCouponNum
        mat.ori_num = oriNeedMatNum
        if 0 < realUseCouponNum then
          mat.coupon = coupon
        end
        mat.exchangenum = hasMatNum + realUseCouponNum
        mat.num = oriNeedMatNum - realUseCouponNum
        if couponNum == 0 then
          has = false
        end
      end
    end
    new_mat_list[#new_mat_list + 1] = mat
  end
  for coupon, num in pairs(useCoupons) do
    if 0 < num then
      use = true
      new_mat_list[#new_mat_list + 1] = {id = coupon, num = num}
    end
  end
  return new_mat_list, use, has
end

function CraftingPotProxy:GenerateDeductionMaterialInfo()
  if self.deductionMaterialInfo then
    return
  end
  self.deductionMaterialInfo = {}
  autoImport("Table_DeductionMaterial")
  for _, v in pairs(Table_DeductionMaterial) do
    for _, v2 in pairs(v.TargetItem) do
      if not self.deductionMaterialInfo[v2] then
        self.deductionMaterialInfo[v2] = {}
        table.insert(self.deductionMaterialInfo[v2], v.Deduction)
        table.insert(self.deductionMaterialInfo[v2], v.CostNum)
        table.insert(self.deductionMaterialInfo[v2], v.TargetNum)
      end
    end
  end
end

function CraftingPotProxy:TryGetDeductionMaterialInfo(targetItemId)
  self:GenerateDeductionMaterialInfo()
  local info = self.deductionMaterialInfo[targetItemId]
  if info then
    return unpack(info)
  end
end

function CraftingPotProxy:UpdateMaterialListUsingDeduction(mat_list, mat_bag_type)
  local new_mat_list = {}
  local dm_cnt_list = {}
  local dm_use_list = {}
  local dm_mat_ok = true
  for i = 1, #mat_list do
    local mat = mat_list[i]
    mat.ori_num = mat.ori_num or mat.num
    local skip_types = ItemData.CheckIsEquip(mat.id)
    local deduction, costNum, targetNum = self:TryGetDeductionMaterialInfo(mat.id)
    if not skip_types and deduction then
      if not dm_cnt_list[deduction] then
        dm_cnt_list[deduction] = BagProxy.Instance:GetItemNumByStaticID(deduction, mat_bag_type) or 0
        dm_use_list[deduction] = 0
      end
      local has_num = BagProxy.Instance:GetItemNumByStaticID(mat.id, mat_bag_type) or 0
      local need_dm_num = mat.num - has_num
      local avail_num = dm_cnt_list[deduction] - dm_use_list[deduction]
      if 0 < need_dm_num then
        if 0 < avail_num then
          local avail_times = math.floor(avail_num / costNum)
          local need_times = math.ceil(need_dm_num / targetNum)
          if 0 < avail_times then
            local real_times = math.min(avail_times, need_times)
            mat.deduction = deduction
            if avail_times >= need_times then
              mat.num = has_num
            else
              mat.num = mat.num - real_times * targetNum
            end
            local exchangenum = mat.exchangenum or 0
            exchangenum = exchangenum == 0 and has_num or exchangenum
            mat.exchangenum = exchangenum + real_times * targetNum
            dm_use_list[deduction] = dm_use_list[deduction] + real_times * costNum
          else
          end
        else
        end
        if dm_cnt_list[deduction] == 0 then
          dm_mat_ok = false
        end
      end
    end
    table.insert(new_mat_list, mat)
  end
  local use_dm = false
  for k, v in pairs(dm_use_list) do
    if 0 < v then
      local mat = {id = k, num = v}
      table.insert(new_mat_list, mat)
      use_dm = true
    end
  end
  return new_mat_list, use_dm, dm_mat_ok, dm_use_list
end
