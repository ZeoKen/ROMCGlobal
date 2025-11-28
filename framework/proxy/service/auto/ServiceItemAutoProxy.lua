ServiceItemAutoProxy = class("ServiceItemAutoProxy", ServiceProxy)
ServiceItemAutoProxy.Instance = nil
ServiceItemAutoProxy.NAME = "ServiceItemAutoProxy"

function ServiceItemAutoProxy:ctor(proxyName)
  if ServiceItemAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceItemAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceItemAutoProxy.Instance = self
  end
end

function ServiceItemAutoProxy:Init()
end

function ServiceItemAutoProxy:onRegister()
  self:Listen(6, 1, function(data)
    self:RecvPackageItem(data)
  end)
  self:Listen(6, 2, function(data)
    self:RecvPackageUpdate(data)
  end)
  self:Listen(6, 3, function(data)
    self:RecvItemUse(data)
  end)
  self:Listen(6, 4, function(data)
    self:RecvPackageSort(data)
  end)
  self:Listen(6, 5, function(data)
    self:RecvEquip(data)
  end)
  self:Listen(6, 6, function(data)
    self:RecvSellItem(data)
  end)
  self:Listen(6, 7, function(data)
    self:RecvEquipStrength(data)
  end)
  self:Listen(6, 9, function(data)
    self:RecvProduce(data)
  end)
  self:Listen(6, 10, function(data)
    self:RecvProduceDone(data)
  end)
  self:Listen(6, 11, function(data)
    self:RecvEquipRefine(data)
  end)
  self:Listen(6, 12, function(data)
    self:RecvEquipDecompose(data)
  end)
  self:Listen(6, 13, function(data)
    self:RecvQueryEquipData(data)
  end)
  self:Listen(6, 14, function(data)
    self:RecvBrowsePackage(data)
  end)
  self:Listen(6, 15, function(data)
    self:RecvEquipCard(data)
  end)
  self:Listen(6, 16, function(data)
    self:RecvItemShow(data)
  end)
  self:Listen(6, 35, function(data)
    self:RecvItemShow64(data)
  end)
  self:Listen(6, 17, function(data)
    self:RecvEquipRepair(data)
  end)
  self:Listen(6, 18, function(data)
    self:RecvHintNtf(data)
  end)
  self:Listen(6, 19, function(data)
    self:RecvEnchantEquip(data)
  end)
  self:Listen(6, 122, function(data)
    self:RecvEnchantRes(data)
  end)
  self:Listen(6, 20, function(data)
    self:RecvProcessEnchantItemCmd(data)
  end)
  self:Listen(6, 21, function(data)
    self:RecvEquipExchangeItemCmd(data)
  end)
  self:Listen(6, 22, function(data)
    self:RecvOnOffStoreItemCmd(data)
  end)
  self:Listen(6, 23, function(data)
    self:RecvPackSlotNtfItemCmd(data)
  end)
  self:Listen(6, 24, function(data)
    self:RecvRestoreEquipItemCmd(data)
  end)
  self:Listen(6, 25, function(data)
    self:RecvUseCountItemCmd(data)
  end)
  self:Listen(6, 28, function(data)
    self:RecvExchangeCardItemCmd(data)
  end)
  self:Listen(6, 29, function(data)
    self:RecvGetCountItemCmd(data)
  end)
  self:Listen(6, 30, function(data)
    self:RecvSaveLoveLetterCmd(data)
  end)
  self:Listen(6, 31, function(data)
    self:RecvItemDataShow(data)
  end)
  self:Listen(6, 32, function(data)
    self:RecvLotteryCmd(data)
  end)
  self:Listen(6, 33, function(data)
    self:RecvLotteryRecoveryCmd(data)
  end)
  self:Listen(6, 34, function(data)
    self:RecvQueryLotteryInfo(data)
  end)
  self:Listen(6, 40, function(data)
    self:RecvReqQuotaLogCmd(data)
  end)
  self:Listen(6, 41, function(data)
    self:RecvReqQuotaDetailCmd(data)
  end)
  self:Listen(6, 42, function(data)
    self:RecvEquipPosDataUpdate(data)
  end)
  self:Listen(6, 36, function(data)
    self:RecvHighRefineMatComposeCmd(data)
  end)
  self:Listen(6, 37, function(data)
    self:RecvHighRefineCmd(data)
  end)
  self:Listen(6, 38, function(data)
    self:RecvNtfHighRefineDataCmd(data)
  end)
  self:Listen(6, 39, function(data)
    self:RecvUpdateHighRefineDataCmd(data)
  end)
  self:Listen(6, 43, function(data)
    self:RecvUseCodItemCmd(data)
  end)
  self:Listen(6, 44, function(data)
    self:RecvAddJobLevelItemCmd(data)
  end)
  self:Listen(6, 46, function(data)
    self:RecvLotterGivBuyCountCmd(data)
  end)
  self:Listen(6, 47, function(data)
    self:RecvGiveWeddingDressCmd(data)
  end)
  self:Listen(6, 48, function(data)
    self:RecvQuickStoreItemCmd(data)
  end)
  self:Listen(6, 49, function(data)
    self:RecvQuickSellItemCmd(data)
  end)
  self:Listen(6, 50, function(data)
    self:RecvEnchantTransItemCmd(data)
  end)
  self:Listen(6, 51, function(data)
    self:RecvQueryLotteryHeadItemCmd(data)
  end)
  self:Listen(6, 52, function(data)
    self:RecvLotteryRateQueryCmd(data)
  end)
  self:Listen(6, 53, function(data)
    self:RecvEquipComposeItemCmd(data)
  end)
  self:Listen(6, 54, function(data)
    self:RecvQueryDebtItemCmd(data)
  end)
  self:Listen(6, 57, function(data)
    self:RecvLotteryActivityNtfCmd(data)
  end)
  self:Listen(6, 56, function(data)
    self:RecvFavoriteItemActionItemCmd(data)
  end)
  self:Listen(6, 59, function(data)
    self:RecvQueryLotteryExtraBonusItemCmd(data)
  end)
  self:Listen(6, 120, function(data)
    self:RecvQueryLotteryExtraBonusCfgCmd(data)
  end)
  self:Listen(6, 60, function(data)
    self:RecvGetLotteryExtraBonusItemCmd(data)
  end)
  self:Listen(6, 58, function(data)
    self:RecvRollCatLitterBoxItemCmd(data)
  end)
  self:Listen(6, 63, function(data)
    self:RecvAlterFashionEquipBuffCmd(data)
  end)
  self:Listen(6, 61, function(data)
    self:RecvQueryRideLotteryInfo(data)
  end)
  self:Listen(6, 62, function(data)
    self:RecvExecRideLotteryCmd(data)
  end)
  self:Listen(6, 64, function(data)
    self:RecvGemSkillAppraisalItemCmd(data)
  end)
  self:Listen(6, 65, function(data)
    self:RecvGemSkillComposeSameItemCmd(data)
  end)
  self:Listen(6, 66, function(data)
    self:RecvGemSkillComposeQualityItemCmd(data)
  end)
  self:Listen(6, 67, function(data)
    self:RecvGemAttrComposeItemCmd(data)
  end)
  self:Listen(6, 68, function(data)
    self:RecvGemAttrUpgradeItemCmd(data)
  end)
  self:Listen(6, 69, function(data)
    self:RecvGemMountItemCmd(data)
  end)
  self:Listen(6, 70, function(data)
    self:RecvGemUnmountItemCmd(data)
  end)
  self:Listen(6, 71, function(data)
    self:RecvGemCarveItemCmd(data)
  end)
  self:Listen(6, 74, function(data)
    self:RecvGemSmeltItemCmd(data)
  end)
  self:Listen(6, 72, function(data)
    self:RecvRideLotteyPickItemCmd(data)
  end)
  self:Listen(6, 73, function(data)
    self:RecvRideLotteyPickInfoCmd(data)
  end)
  self:Listen(6, 75, function(data)
    self:RecvSandExchangeItemCmd(data)
  end)
  self:Listen(6, 76, function(data)
    self:RecvGemDataUpdateItemCmd(data)
  end)
  self:Listen(6, 81, function(data)
    self:RecvLotteryDollQueryItemCmd(data)
  end)
  self:Listen(6, 82, function(data)
    self:RecvLotteryDollPayItemCmd(data)
  end)
  self:Listen(6, 83, function(data)
    self:RecvPersonalArtifactExchangeItemCmd(data)
  end)
  self:Listen(6, 84, function(data)
    self:RecvPersonalArtifactDecomposeItemCmd(data)
  end)
  self:Listen(6, 85, function(data)
    self:RecvPersonalArtifactComposeItemCmd(data)
  end)
  self:Listen(6, 86, function(data)
    self:RecvPersonalArtifactRemouldItemCmd(data)
  end)
  self:Listen(6, 87, function(data)
    self:RecvPersonalArtifactAttrSaveItemCmd(data)
  end)
  self:Listen(6, 90, function(data)
    self:RecvPersonalArtifactAppraisalItemCmd(data)
  end)
  self:Listen(6, 96, function(data)
    self:RecvEquipPosCDNtfItemCmd(data)
  end)
  self:Listen(6, 88, function(data)
    self:RecvBatchRefineItemCmd(data)
  end)
  self:Listen(6, 91, function(data)
    self:RecvMixLotteryArchiveCmd(data)
  end)
  self:Listen(6, 107, function(data)
    self:RecvQueryPackMailItemCmd(data)
  end)
  self:Listen(6, 108, function(data)
    self:RecvPackMailUpdateItemCmd(data)
  end)
  self:Listen(6, 109, function(data)
    self:RecvPackMailActionItemCmd(data)
  end)
  self:Listen(6, 110, function(data)
    self:RecvFavoriteQueryItemCmd(data)
  end)
  self:Listen(6, 111, function(data)
    self:RecvFavoriteGiveItemCmd(data)
  end)
  self:Listen(6, 112, function(data)
    self:RecvFavoriteRewardItemCmd(data)
  end)
  self:Listen(6, 113, function(data)
    self:RecvFavoriteInteractItemCmd(data)
  end)
  self:Listen(6, 116, function(data)
    self:RecvFavoriteDesireConditionItemCmd(data)
  end)
  self:Listen(6, 97, function(data)
    self:RecvEquipEnchantTransferItemCmd(data)
  end)
  self:Listen(6, 98, function(data)
    self:RecvEquipRefineTransferItemCmd(data)
  end)
  self:Listen(6, 99, function(data)
    self:RecvEquipPowerInputItemCmd(data)
  end)
  self:Listen(6, 100, function(data)
    self:RecvEquipPowerOutputItemCmd(data)
  end)
  self:Listen(6, 101, function(data)
    self:RecvColoringQueryItemCmd(data)
  end)
  self:Listen(6, 102, function(data)
    self:RecvColoringModifyItemCmd(data)
  end)
  self:Listen(6, 103, function(data)
    self:RecvColoringShareItemCmd(data)
  end)
  self:Listen(6, 104, function(data)
    self:RecvPosStrengthItemCmd(data)
  end)
  self:Listen(6, 115, function(data)
    self:RecvLotteryHeadwearExchange(data)
  end)
  self:Listen(6, 106, function(data)
    self:RecvRandSelectRewardItemCmd(data)
  end)
  self:Listen(6, 118, function(data)
    self:RecvEquipRecoveryQueryItemCmd(data)
  end)
  self:Listen(6, 119, function(data)
    self:RecvEquipRecoveryItemCmd(data)
  end)
  self:Listen(6, 114, function(data)
    self:RecvOneClickPutTakeStoreCmd(data)
  end)
  self:Listen(6, 117, function(data)
    self:RecvQuestionResultItemCmd(data)
  end)
  self:Listen(6, 105, function(data)
    self:RecvPosStrengthSyncItemCmd(data)
  end)
  self:Listen(6, 121, function(data)
    self:RecvEquipPowerQuery(data)
  end)
  self:Listen(6, 92, function(data)
    self:RecvMagicSuitSave(data)
  end)
  self:Listen(6, 94, function(data)
    self:RecvMagicSuitNtf(data)
  end)
  self:Listen(6, 93, function(data)
    self:RecvMagicSuitApply(data)
  end)
  self:Listen(6, 95, function(data)
    self:RecvPotionStoreNtf(data)
  end)
  self:Listen(6, 123, function(data)
    self:RecvEnchantHighestBuffNotify(data)
  end)
  self:Listen(6, 124, function(data)
    self:RecvLotteryDataSyncItemCmd(data)
  end)
  self:Listen(6, 125, function(data)
    self:RecvArtifactFlagmentAdd(data)
  end)
  self:Listen(6, 127, function(data)
    self:RecvLotteryDailyRewardSyncItemCmd(data)
  end)
  self:Listen(6, 128, function(data)
    self:RecvLotteryDailyRewardGetItemCmd(data)
  end)
  self:Listen(6, 126, function(data)
    self:RecvAutoSellItemCmd(data)
  end)
  self:Listen(6, 129, function(data)
    self:RecvQueryAfricanPoringItemCmd(data)
  end)
  self:Listen(6, 130, function(data)
    self:RecvAfricanPoringUpdateItemCmd(data)
  end)
  self:Listen(6, 131, function(data)
    self:RecvAfricanPoringLotteryItemCmd(data)
  end)
  self:Listen(6, 135, function(data)
    self:RecvExtractLevelUpItemCmd(data)
  end)
  self:Listen(6, 132, function(data)
    self:RecvEnchantRefreshAttr(data)
  end)
  self:Listen(6, 133, function(data)
    self:RecvProcessEnchantRefreshAttr(data)
  end)
  self:Listen(6, 134, function(data)
    self:RecvEnchantUpgradeAttr(data)
  end)
  self:Listen(6, 136, function(data)
    self:RecvRefreshEquipAttrCmd(data)
  end)
  self:Listen(6, 139, function(data)
    self:RecvQuenchEquipItemCmd(data)
  end)
  self:Listen(6, 140, function(data)
    self:RecvMountFashionSyncCmd(data)
  end)
  self:Listen(6, 141, function(data)
    self:RecvMountFashionChangeCmd(data)
  end)
  self:Listen(6, 137, function(data)
    self:RecvEquipPromote(data)
  end)
  self:Listen(6, 142, function(data)
    self:RecvSwitchFashionEquipRecordItemCmd(data)
  end)
  self:Listen(6, 138, function(data)
    self:RecvOldItemExchangeItemCmd(data)
  end)
  self:Listen(6, 143, function(data)
    self:RecvBuyMixLotteryItemCmd(data)
  end)
  self:Listen(6, 144, function(data)
    self:RecvCardLotteryPrayItemCmd(data)
  end)
  self:Listen(6, 145, function(data)
    self:RecvSyncCardLotteryPrayItemCmd(data)
  end)
  self:Listen(6, 153, function(data)
    self:RecvGemBagExpSyncItemCmd(data)
  end)
  self:Listen(6, 151, function(data)
    self:RecvSecretLandGemCmd(data)
  end)
  self:Listen(6, 146, function(data)
    self:RecvMountFashionQueryStateCmd(data)
  end)
  self:Listen(6, 147, function(data)
    self:RecvMountFashionActiveCmd(data)
  end)
  self:Listen(6, 148, function(data)
    self:RecvStorePutItemItemCmd(data)
  end)
  self:Listen(6, 149, function(data)
    self:RecvStoreOffItemItemCmd(data)
  end)
  self:Listen(6, 154, function(data)
    self:RecvFullGemSkill(data)
  end)
  self:Listen(6, 155, function(data)
    self:RecvQueryBossCardComposeRateCmd(data)
  end)
  self:Listen(6, 156, function(data)
    self:RecvMemoryEmbedItemCmd(data)
  end)
  self:Listen(6, 157, function(data)
    self:RecvMemoryUnEmbedItemCmd(data)
  end)
  self:Listen(6, 158, function(data)
    self:RecvMemoryLevelupItemCmd(data)
  end)
  self:Listen(6, 159, function(data)
    self:RecvMemoryDecomposeItemCmd(data)
  end)
  self:Listen(6, 160, function(data)
    self:RecvMemoryEffectOperItemCmd(data)
  end)
  self:Listen(6, 161, function(data)
    self:RecvMemoryAutoDecomposeOptionItemCmd(data)
  end)
  self:Listen(6, 162, function(data)
    self:RecvUpdateMemoryPosItemCmd(data)
  end)
  self:Listen(6, 163, function(data)
    self:RecvDecomposeGemItemCmd(data)
  end)
  self:Listen(6, 164, function(data)
    self:RecvUpgradeGemItemCmd(data)
  end)
  self:Listen(6, 165, function(data)
    self:RecvMemoryUpgradeItemCmd(data)
  end)
  self:Listen(6, 166, function(data)
    self:RecvCardLevelupItemCmd(data)
  end)
  self:Listen(6, 167, function(data)
    self:RecvBalanceModeMemorySetItemCmd(data)
  end)
  self:Listen(6, 168, function(data)
    self:RecvBalanceModeMemoryUpdateItemCmd(data)
  end)
end

function ServiceItemAutoProxy:CallPackageItem(type, data, maxslot)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackageItem()
    if type ~= nil then
      msg.type = type
    end
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    if maxslot ~= nil then
      msg.maxslot = maxslot
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackageItem.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    if maxslot ~= nil then
      msgParam.maxslot = maxslot
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPackageUpdate(type, updateItems, delItems)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackageUpdate()
    if type ~= nil then
      msg.type = type
    end
    if updateItems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updateItems == nil then
        msg.updateItems = {}
      end
      for i = 1, #updateItems do
        table.insert(msg.updateItems, updateItems[i])
      end
    end
    if delItems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delItems == nil then
        msg.delItems = {}
      end
      for i = 1, #delItems do
        table.insert(msg.delItems, delItems[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackageUpdate.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if updateItems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updateItems == nil then
        msgParam.updateItems = {}
      end
      for i = 1, #updateItems do
        table.insert(msgParam.updateItems, updateItems[i])
      end
    end
    if delItems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delItems == nil then
        msgParam.delItems = {}
      end
      for i = 1, #delItems do
        table.insert(msgParam.delItems, delItems[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallItemUse(itemguid, targets, count, value, targetItemguids, str_value)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ItemUse()
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    if targets ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.targets == nil then
        msg.targets = {}
      end
      for i = 1, #targets do
        table.insert(msg.targets, targets[i])
      end
    end
    if count ~= nil then
      msg.count = count
    end
    if value ~= nil then
      msg.value = value
    end
    if targetItemguids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.targetItemguids == nil then
        msg.targetItemguids = {}
      end
      for i = 1, #targetItemguids do
        table.insert(msg.targetItemguids, targetItemguids[i])
      end
    end
    if str_value ~= nil then
      msg.str_value = str_value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemUse.id
    local msgParam = {}
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    if targets ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.targets == nil then
        msgParam.targets = {}
      end
      for i = 1, #targets do
        table.insert(msgParam.targets, targets[i])
      end
    end
    if count ~= nil then
      msgParam.count = count
    end
    if value ~= nil then
      msgParam.value = value
    end
    if targetItemguids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.targetItemguids == nil then
        msgParam.targetItemguids = {}
      end
      for i = 1, #targetItemguids do
        table.insert(msgParam.targetItemguids, targetItemguids[i])
      end
    end
    if str_value ~= nil then
      msgParam.str_value = str_value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPackageSort(type, item)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackageSort()
    if type ~= nil then
      msg.type = type
    end
    if item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      for i = 1, #item do
        table.insert(msg.item, item[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackageSort.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      for i = 1, #item do
        table.insert(msgParam.item, item[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquip(oper, pos, guid, transfer, count)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.Equip()
    if oper ~= nil then
      msg.oper = oper
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if transfer ~= nil then
      msg.transfer = transfer
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Equip.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if transfer ~= nil then
      msgParam.transfer = transfer
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSellItem(npcid, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SellItem()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SellItem.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipStrength(guid, destcount, count, cricount, oldlv, newlv, result, type)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipStrength()
    if guid ~= nil then
      msg.guid = guid
    end
    if destcount ~= nil then
      msg.destcount = destcount
    end
    if count ~= nil then
      msg.count = count
    end
    if cricount ~= nil then
      msg.cricount = cricount
    end
    if oldlv ~= nil then
      msg.oldlv = oldlv
    end
    if newlv ~= nil then
      msg.newlv = newlv
    end
    if result ~= nil then
      msg.result = result
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipStrength.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if destcount ~= nil then
      msgParam.destcount = destcount
    end
    if count ~= nil then
      msgParam.count = count
    end
    if cricount ~= nil then
      msgParam.cricount = cricount
    end
    if oldlv ~= nil then
      msgParam.oldlv = oldlv
    end
    if newlv ~= nil then
      msgParam.newlv = newlv
    end
    if result ~= nil then
      msgParam.result = result
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallProduce(type, composeid, npcid, itemid, count, qucikproduce, use_deduction, upgrade_items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.Produce()
    if type ~= nil then
      msg.type = type
    end
    if composeid ~= nil then
      msg.composeid = composeid
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    if qucikproduce ~= nil then
      msg.qucikproduce = qucikproduce
    end
    if use_deduction ~= nil then
      msg.use_deduction = use_deduction
    end
    if upgrade_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.upgrade_items == nil then
        msg.upgrade_items = {}
      end
      for i = 1, #upgrade_items do
        table.insert(msg.upgrade_items, upgrade_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Produce.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if composeid ~= nil then
      msgParam.composeid = composeid
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if qucikproduce ~= nil then
      msgParam.qucikproduce = qucikproduce
    end
    if use_deduction ~= nil then
      msgParam.use_deduction = use_deduction
    end
    if upgrade_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.upgrade_items == nil then
        msgParam.upgrade_items = {}
      end
      for i = 1, #upgrade_items do
        table.insert(msgParam.upgrade_items, upgrade_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallProduceDone(type, npcid, charid, delay, itemid, count)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ProduceDone()
    if type ~= nil then
      msg.type = type
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProduceDone.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipRefine(guid, composeid, refinelv, eresult, npcid, saferefine, itemguid, to_safelv, damage)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipRefine()
    if guid ~= nil then
      msg.guid = guid
    end
    if composeid ~= nil then
      msg.composeid = composeid
    end
    if refinelv ~= nil then
      msg.refinelv = refinelv
    end
    if eresult ~= nil then
      msg.eresult = eresult
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if saferefine ~= nil then
      msg.saferefine = saferefine
    end
    if itemguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemguid == nil then
        msg.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msg.itemguid, itemguid[i])
      end
    end
    if to_safelv ~= nil then
      msg.to_safelv = to_safelv
    end
    if damage ~= nil then
      msg.damage = damage
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipRefine.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if composeid ~= nil then
      msgParam.composeid = composeid
    end
    if refinelv ~= nil then
      msgParam.refinelv = refinelv
    end
    if eresult ~= nil then
      msgParam.eresult = eresult
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if saferefine ~= nil then
      msgParam.saferefine = saferefine
    end
    if itemguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemguid == nil then
        msgParam.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msgParam.itemguid, itemguid[i])
      end
    end
    if to_safelv ~= nil then
      msgParam.to_safelv = to_safelv
    end
    if damage ~= nil then
      msgParam.damage = damage
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipDecompose(equips, result, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipDecompose()
    if equips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.equips == nil then
        msg.equips = {}
      end
      for i = 1, #equips do
        table.insert(msg.equips, equips[i])
      end
    end
    if result ~= nil then
      msg.result = result
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipDecompose.id
    local msgParam = {}
    if equips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.equips == nil then
        msgParam.equips = {}
      end
      for i = 1, #equips do
        table.insert(msgParam.equips, equips[i])
      end
    end
    if result ~= nil then
      msgParam.result = result
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryEquipData(guid, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryEquipData()
    if guid ~= nil then
      msg.guid = guid
    end
    if data ~= nil and data.strengthlv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.strengthlv = data.strengthlv
    end
    if data ~= nil and data.refinelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.refinelv = data.refinelv
    end
    if data ~= nil and data.strengthCost ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.strengthCost = data.strengthCost
    end
    if data ~= nil and data.refineCompose ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.refineCompose == nil then
        msg.data.refineCompose = {}
      end
      for i = 1, #data.refineCompose do
        table.insert(msg.data.refineCompose, data.refineCompose[i])
      end
    end
    if data ~= nil and data.cardslot ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.cardslot = data.cardslot
    end
    if data ~= nil and data.buffid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.buffid == nil then
        msg.data.buffid = {}
      end
      for i = 1, #data.buffid do
        table.insert(msg.data.buffid, data.buffid[i])
      end
    end
    if data ~= nil and data.damage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.damage = data.damage
    end
    if data ~= nil and data.lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.lv = data.lv
    end
    if data ~= nil and data.color ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.color = data.color
    end
    if data ~= nil and data.breakstarttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.breakstarttime = data.breakstarttime
    end
    if data ~= nil and data.breakendtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.breakendtime = data.breakendtime
    end
    if data ~= nil and data.strengthlv2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.strengthlv2 = data.strengthlv2
    end
    if data ~= nil and data.quenchper ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.quenchper = data.quenchper
    end
    if data ~= nil and data.strengthlv2cost ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.strengthlv2cost == nil then
        msg.data.strengthlv2cost = {}
      end
      for i = 1, #data.strengthlv2cost do
        table.insert(msg.data.strengthlv2cost, data.strengthlv2cost[i])
      end
    end
    if data ~= nil and data.attrs ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.attrs == nil then
        msg.data.attrs = {}
      end
      for i = 1, #data.attrs do
        table.insert(msg.data.attrs, data.attrs[i])
      end
    end
    if data ~= nil and data.extra_refine_value ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.extra_refine_value = data.extra_refine_value
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryEquipData.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if data ~= nil and data.strengthlv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.strengthlv = data.strengthlv
    end
    if data ~= nil and data.refinelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.refinelv = data.refinelv
    end
    if data ~= nil and data.strengthCost ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.strengthCost = data.strengthCost
    end
    if data ~= nil and data.refineCompose ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.refineCompose == nil then
        msgParam.data.refineCompose = {}
      end
      for i = 1, #data.refineCompose do
        table.insert(msgParam.data.refineCompose, data.refineCompose[i])
      end
    end
    if data ~= nil and data.cardslot ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.cardslot = data.cardslot
    end
    if data ~= nil and data.buffid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.buffid == nil then
        msgParam.data.buffid = {}
      end
      for i = 1, #data.buffid do
        table.insert(msgParam.data.buffid, data.buffid[i])
      end
    end
    if data ~= nil and data.damage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.damage = data.damage
    end
    if data ~= nil and data.lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.lv = data.lv
    end
    if data ~= nil and data.color ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.color = data.color
    end
    if data ~= nil and data.breakstarttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.breakstarttime = data.breakstarttime
    end
    if data ~= nil and data.breakendtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.breakendtime = data.breakendtime
    end
    if data ~= nil and data.strengthlv2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.strengthlv2 = data.strengthlv2
    end
    if data ~= nil and data.quenchper ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.quenchper = data.quenchper
    end
    if data ~= nil and data.strengthlv2cost ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.strengthlv2cost == nil then
        msgParam.data.strengthlv2cost = {}
      end
      for i = 1, #data.strengthlv2cost do
        table.insert(msgParam.data.strengthlv2cost, data.strengthlv2cost[i])
      end
    end
    if data ~= nil and data.attrs ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.attrs == nil then
        msgParam.data.attrs = {}
      end
      for i = 1, #data.attrs do
        table.insert(msgParam.data.attrs, data.attrs[i])
      end
    end
    if data ~= nil and data.extra_refine_value ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.extra_refine_value = data.extra_refine_value
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallBrowsePackage(type)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.BrowsePackage()
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BrowsePackage.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipCard(oper, cardguid, equipguid, pos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipCard()
    if oper ~= nil then
      msg.oper = oper
    end
    if cardguid ~= nil then
      msg.cardguid = cardguid
    end
    if equipguid ~= nil then
      msg.equipguid = equipguid
    end
    if pos ~= nil then
      msg.pos = pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipCard.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if cardguid ~= nil then
      msgParam.cardguid = cardguid
    end
    if equipguid ~= nil then
      msgParam.equipguid = equipguid
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallItemShow(items, delay, spec_icon)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ItemShow()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if spec_icon ~= nil then
      msg.spec_icon = spec_icon
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemShow.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if spec_icon ~= nil then
      msgParam.spec_icon = spec_icon
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallItemShow64(id, count)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ItemShow64()
    if id ~= nil then
      msg.id = id
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemShow64.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipRepair(targetguid, success, stuffguid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipRepair()
    if targetguid ~= nil then
      msg.targetguid = targetguid
    end
    if success ~= nil then
      msg.success = success
    end
    if stuffguid ~= nil then
      msg.stuffguid = stuffguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipRepair.id
    local msgParam = {}
    if targetguid ~= nil then
      msgParam.targetguid = targetguid
    end
    if success ~= nil then
      msgParam.success = success
    end
    if stuffguid ~= nil then
      msgParam.stuffguid = stuffguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallHintNtf(itemid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.HintNtf()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HintNtf.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantEquip(type, guid, is_improve, must_buff_item, count, lockitem)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantEquip()
    if type ~= nil then
      msg.type = type
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if is_improve ~= nil then
      msg.is_improve = is_improve
    end
    if must_buff_item ~= nil then
      msg.must_buff_item = must_buff_item
    end
    if count ~= nil then
      msg.count = count
    end
    if lockitem ~= nil then
      msg.lockitem = lockitem
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantEquip.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if is_improve ~= nil then
      msgParam.is_improve = is_improve
    end
    if must_buff_item ~= nil then
      msgParam.must_buff_item = must_buff_item
    end
    if count ~= nil then
      msgParam.count = count
    end
    if lockitem ~= nil then
      msgParam.lockitem = lockitem
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantRes(results)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantRes()
    if results ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.results == nil then
        msg.results = {}
      end
      for i = 1, #results do
        table.insert(msg.results, results[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantRes.id
    local msgParam = {}
    if results ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.results == nil then
        msgParam.results = {}
      end
      for i = 1, #results do
        table.insert(msgParam.results, results[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallProcessEnchantItemCmd(save, itemid, choice_index)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ProcessEnchantItemCmd()
    if save ~= nil then
      msg.save = save
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if choice_index ~= nil then
      msg.choice_index = choice_index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessEnchantItemCmd.id
    local msgParam = {}
    if save ~= nil then
      msgParam.save = save
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if choice_index ~= nil then
      msgParam.choice_index = choice_index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipExchangeItemCmd(guid, type, materials, upgrade_add_lv, use_deduction)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipExchangeItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if type ~= nil then
      msg.type = type
    end
    if materials ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.materials == nil then
        msg.materials = {}
      end
      for i = 1, #materials do
        table.insert(msg.materials, materials[i])
      end
    end
    if upgrade_add_lv ~= nil then
      msg.upgrade_add_lv = upgrade_add_lv
    end
    if use_deduction ~= nil then
      msg.use_deduction = use_deduction
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipExchangeItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if materials ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.materials == nil then
        msgParam.materials = {}
      end
      for i = 1, #materials do
        table.insert(msgParam.materials, materials[i])
      end
    end
    if upgrade_add_lv ~= nil then
      msgParam.upgrade_add_lv = upgrade_add_lv
    end
    if use_deduction ~= nil then
      msgParam.use_deduction = use_deduction
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallOnOffStoreItemCmd(open)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.OnOffStoreItemCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OnOffStoreItemCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPackSlotNtfItemCmd(type, maxslot)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackSlotNtfItemCmd()
    if type ~= nil then
      msg.type = type
    end
    if maxslot ~= nil then
      msg.maxslot = maxslot
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackSlotNtfItemCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if maxslot ~= nil then
      msgParam.maxslot = maxslot
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRestoreEquipItemCmd(equipid, strengthlv, cardids, enchant, upgrade, strengthlv2, upgrade_target_lv, quench)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RestoreEquipItemCmd()
    if equipid ~= nil then
      msg.equipid = equipid
    end
    if strengthlv ~= nil then
      msg.strengthlv = strengthlv
    end
    if cardids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cardids == nil then
        msg.cardids = {}
      end
      for i = 1, #cardids do
        table.insert(msg.cardids, cardids[i])
      end
    end
    if enchant ~= nil then
      msg.enchant = enchant
    end
    if upgrade ~= nil then
      msg.upgrade = upgrade
    end
    if strengthlv2 ~= nil then
      msg.strengthlv2 = strengthlv2
    end
    if upgrade_target_lv ~= nil then
      msg.upgrade_target_lv = upgrade_target_lv
    end
    if quench ~= nil then
      msg.quench = quench
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RestoreEquipItemCmd.id
    local msgParam = {}
    if equipid ~= nil then
      msgParam.equipid = equipid
    end
    if strengthlv ~= nil then
      msgParam.strengthlv = strengthlv
    end
    if cardids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cardids == nil then
        msgParam.cardids = {}
      end
      for i = 1, #cardids do
        table.insert(msgParam.cardids, cardids[i])
      end
    end
    if enchant ~= nil then
      msgParam.enchant = enchant
    end
    if upgrade ~= nil then
      msgParam.upgrade = upgrade
    end
    if strengthlv2 ~= nil then
      msgParam.strengthlv2 = strengthlv2
    end
    if upgrade_target_lv ~= nil then
      msgParam.upgrade_target_lv = upgrade_target_lv
    end
    if quench ~= nil then
      msgParam.quench = quench
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallUseCountItemCmd(itemid, count)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.UseCountItemCmd()
    if msg == nil then
      msg = {}
    end
    msg.itemid = itemid
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseCountItemCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.itemid = itemid
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallExchangeCardItemCmd(type, npcid, material, charid, cardid, anim, items, compose_num)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ExchangeCardItemCmd()
    if type ~= nil then
      msg.type = type
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if material ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.material == nil then
        msg.material = {}
      end
      for i = 1, #material do
        table.insert(msg.material, material[i])
      end
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if cardid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cardid == nil then
        msg.cardid = {}
      end
      for i = 1, #cardid do
        table.insert(msg.cardid, cardid[i])
      end
    end
    if anim ~= nil then
      msg.anim = anim
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if compose_num ~= nil then
      msg.compose_num = compose_num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeCardItemCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if material ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.material == nil then
        msgParam.material = {}
      end
      for i = 1, #material do
        table.insert(msgParam.material, material[i])
      end
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if cardid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cardid == nil then
        msgParam.cardid = {}
      end
      for i = 1, #cardid do
        table.insert(msgParam.cardid, cardid[i])
      end
    end
    if anim ~= nil then
      msgParam.anim = anim
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if compose_num ~= nil then
      msgParam.compose_num = compose_num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGetCountItemCmd(itemid, count, sources)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GetCountItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    if sources ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sources == nil then
        msg.sources = {}
      end
      for i = 1, #sources do
        table.insert(msg.sources, sources[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetCountItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if sources ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sources == nil then
        msgParam.sources = {}
      end
      for i = 1, #sources do
        table.insert(msgParam.sources, sources[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSaveLoveLetterCmd(dwID)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SaveLoveLetterCmd()
    if dwID ~= nil then
      msg.dwID = dwID
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SaveLoveLetterCmd.id
    local msgParam = {}
    if dwID ~= nil then
      msgParam.dwID = dwID
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallItemDataShow(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ItemDataShow()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ItemDataShow.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryCmd(year, month, npcid, skip_anim, price, ticket, type, count, items, charid, guid, today_cnt, today_extra_cnt, today_ten_cnt, free)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryCmd()
    if year ~= nil then
      msg.year = year
    end
    if month ~= nil then
      msg.month = month
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if skip_anim ~= nil then
      msg.skip_anim = skip_anim
    end
    if price ~= nil then
      msg.price = price
    end
    if ticket ~= nil then
      msg.ticket = ticket
    end
    if type ~= nil then
      msg.type = type
    end
    if count ~= nil then
      msg.count = count
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if today_cnt ~= nil then
      msg.today_cnt = today_cnt
    end
    if today_extra_cnt ~= nil then
      msg.today_extra_cnt = today_extra_cnt
    end
    if today_ten_cnt ~= nil then
      msg.today_ten_cnt = today_ten_cnt
    end
    if free ~= nil then
      msg.free = free
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryCmd.id
    local msgParam = {}
    if year ~= nil then
      msgParam.year = year
    end
    if month ~= nil then
      msgParam.month = month
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if skip_anim ~= nil then
      msgParam.skip_anim = skip_anim
    end
    if price ~= nil then
      msgParam.price = price
    end
    if ticket ~= nil then
      msgParam.ticket = ticket
    end
    if type ~= nil then
      msgParam.type = type
    end
    if count ~= nil then
      msgParam.count = count
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if today_cnt ~= nil then
      msgParam.today_cnt = today_cnt
    end
    if today_extra_cnt ~= nil then
      msgParam.today_extra_cnt = today_extra_cnt
    end
    if today_ten_cnt ~= nil then
      msgParam.today_ten_cnt = today_ten_cnt
    end
    if free ~= nil then
      msgParam.free = free
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryRecoveryCmd(items, npcid, type)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryRecoveryCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryRecoveryCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryLotteryInfo(infos, type, today_cnt, max_cnt, today_extra_cnt, max_extra_cnt, once_max_cnt, mixlotterycnts, safetyinfo, today_ten_cnt, max_ten_cnt, free_cnt, card_free_total_cnt, card_free_used_cnt)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryLotteryInfo()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if type ~= nil then
      msg.type = type
    end
    if today_cnt ~= nil then
      msg.today_cnt = today_cnt
    end
    if max_cnt ~= nil then
      msg.max_cnt = max_cnt
    end
    if today_extra_cnt ~= nil then
      msg.today_extra_cnt = today_extra_cnt
    end
    if max_extra_cnt ~= nil then
      msg.max_extra_cnt = max_extra_cnt
    end
    if once_max_cnt ~= nil then
      msg.once_max_cnt = once_max_cnt
    end
    if mixlotterycnts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mixlotterycnts == nil then
        msg.mixlotterycnts = {}
      end
      for i = 1, #mixlotterycnts do
        table.insert(msg.mixlotterycnts, mixlotterycnts[i])
      end
    end
    if safetyinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.safetyinfo == nil then
        msg.safetyinfo = {}
      end
      for i = 1, #safetyinfo do
        table.insert(msg.safetyinfo, safetyinfo[i])
      end
    end
    if today_ten_cnt ~= nil then
      msg.today_ten_cnt = today_ten_cnt
    end
    if max_ten_cnt ~= nil then
      msg.max_ten_cnt = max_ten_cnt
    end
    if free_cnt ~= nil then
      msg.free_cnt = free_cnt
    end
    if card_free_total_cnt ~= nil then
      msg.card_free_total_cnt = card_free_total_cnt
    end
    if card_free_used_cnt ~= nil then
      msg.card_free_used_cnt = card_free_used_cnt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryLotteryInfo.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if type ~= nil then
      msgParam.type = type
    end
    if today_cnt ~= nil then
      msgParam.today_cnt = today_cnt
    end
    if max_cnt ~= nil then
      msgParam.max_cnt = max_cnt
    end
    if today_extra_cnt ~= nil then
      msgParam.today_extra_cnt = today_extra_cnt
    end
    if max_extra_cnt ~= nil then
      msgParam.max_extra_cnt = max_extra_cnt
    end
    if once_max_cnt ~= nil then
      msgParam.once_max_cnt = once_max_cnt
    end
    if mixlotterycnts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mixlotterycnts == nil then
        msgParam.mixlotterycnts = {}
      end
      for i = 1, #mixlotterycnts do
        table.insert(msgParam.mixlotterycnts, mixlotterycnts[i])
      end
    end
    if safetyinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.safetyinfo == nil then
        msgParam.safetyinfo = {}
      end
      for i = 1, #safetyinfo do
        table.insert(msgParam.safetyinfo, safetyinfo[i])
      end
    end
    if today_ten_cnt ~= nil then
      msgParam.today_ten_cnt = today_ten_cnt
    end
    if max_ten_cnt ~= nil then
      msgParam.max_ten_cnt = max_ten_cnt
    end
    if free_cnt ~= nil then
      msgParam.free_cnt = free_cnt
    end
    if card_free_total_cnt ~= nil then
      msgParam.card_free_total_cnt = card_free_total_cnt
    end
    if card_free_used_cnt ~= nil then
      msgParam.card_free_used_cnt = card_free_used_cnt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallReqQuotaLogCmd(page_index, log)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ReqQuotaLogCmd()
    if page_index ~= nil then
      msg.page_index = page_index
    end
    if log ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.log == nil then
        msg.log = {}
      end
      for i = 1, #log do
        table.insert(msg.log, log[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqQuotaLogCmd.id
    local msgParam = {}
    if page_index ~= nil then
      msgParam.page_index = page_index
    end
    if log ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.log == nil then
        msgParam.log = {}
      end
      for i = 1, #log do
        table.insert(msgParam.log, log[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallReqQuotaDetailCmd(page_index, detail)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ReqQuotaDetailCmd()
    if page_index ~= nil then
      msg.page_index = page_index
    end
    if detail ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.detail == nil then
        msg.detail = {}
      end
      for i = 1, #detail do
        table.insert(msg.detail, detail[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqQuotaDetailCmd.id
    local msgParam = {}
    if page_index ~= nil then
      msgParam.page_index = page_index
    end
    if detail ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.detail == nil then
        msgParam.detail = {}
      end
      for i = 1, #detail do
        table.insert(msgParam.detail, detail[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPosDataUpdate(datas)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPosDataUpdate()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPosDataUpdate.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallHighRefineMatComposeCmd(dataid, npcid, mainmaterial, vicematerial, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.HighRefineMatComposeCmd()
    if dataid ~= nil then
      msg.dataid = dataid
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if mainmaterial ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mainmaterial == nil then
        msg.mainmaterial = {}
      end
      for i = 1, #mainmaterial do
        table.insert(msg.mainmaterial, mainmaterial[i])
      end
    end
    if vicematerial ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.vicematerial == nil then
        msg.vicematerial = {}
      end
      for i = 1, #vicematerial do
        table.insert(msg.vicematerial, vicematerial[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HighRefineMatComposeCmd.id
    local msgParam = {}
    if dataid ~= nil then
      msgParam.dataid = dataid
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if mainmaterial ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mainmaterial == nil then
        msgParam.mainmaterial = {}
      end
      for i = 1, #mainmaterial do
        table.insert(msgParam.mainmaterial, mainmaterial[i])
      end
    end
    if vicematerial ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.vicematerial == nil then
        msgParam.vicematerial = {}
      end
      for i = 1, #vicematerial do
        table.insert(msgParam.vicematerial, vicematerial[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallHighRefineCmd(dataid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.HighRefineCmd()
    if dataid ~= nil then
      msg.dataid = dataid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HighRefineCmd.id
    local msgParam = {}
    if dataid ~= nil then
      msgParam.dataid = dataid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallNtfHighRefineDataCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.NtfHighRefineDataCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NtfHighRefineDataCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallUpdateHighRefineDataCmd(data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.UpdateHighRefineDataCmd()
    if data ~= nil and data.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.pos = data.pos
    end
    if data ~= nil and data.level ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.level == nil then
        msg.data.level = {}
      end
      for i = 1, #data.level do
        table.insert(msg.data.level, data.level[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateHighRefineDataCmd.id
    local msgParam = {}
    if data ~= nil and data.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.pos = data.pos
    end
    if data ~= nil and data.level ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.level == nil then
        msgParam.data.level = {}
      end
      for i = 1, #data.level do
        table.insert(msgParam.data.level, data.level[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallUseCodItemCmd(guid, code)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.UseCodItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if code ~= nil then
      msg.code = code
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseCodItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if code ~= nil then
      msgParam.code = code
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallAddJobLevelItemCmd(item, num)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.AddJobLevelItemCmd()
    if item ~= nil then
      msg.item = item
    end
    if num ~= nil then
      msg.num = num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddJobLevelItemCmd.id
    local msgParam = {}
    if item ~= nil then
      msgParam.item = item
    end
    if num ~= nil then
      msgParam.num = num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotterGivBuyCountCmd(got_count, max_count)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotterGivBuyCountCmd()
    if got_count ~= nil then
      msg.got_count = got_count
    end
    if max_count ~= nil then
      msg.max_count = max_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotterGivBuyCountCmd.id
    local msgParam = {}
    if got_count ~= nil then
      msgParam.got_count = got_count
    end
    if max_count ~= nil then
      msgParam.max_count = max_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGiveWeddingDressCmd(guid, content, receiverid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GiveWeddingDressCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if content ~= nil then
      msg.content = content
    end
    if receiverid ~= nil then
      msg.receiverid = receiverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiveWeddingDressCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if content ~= nil then
      msgParam.content = content
    end
    if receiverid ~= nil then
      msgParam.receiverid = receiverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQuickStoreItemCmd(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QuickStoreItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuickStoreItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQuickSellItemCmd(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QuickSellItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuickSellItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantTransItemCmd(from_guid, to_guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantTransItemCmd()
    if from_guid ~= nil then
      msg.from_guid = from_guid
    end
    if to_guid ~= nil then
      msg.to_guid = to_guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantTransItemCmd.id
    local msgParam = {}
    if from_guid ~= nil then
      msgParam.from_guid = from_guid
    end
    if to_guid ~= nil then
      msgParam.to_guid = to_guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryLotteryHeadItemCmd(ids)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryLotteryHeadItemCmd()
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryLotteryHeadItemCmd.id
    local msgParam = {}
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryRateQueryCmd(type, infos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryRateQueryCmd()
    if type ~= nil then
      msg.type = type
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryRateQueryCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipComposeItemCmd(id, materialequips, retmsg, use_deduction)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipComposeItemCmd()
    if id ~= nil then
      msg.id = id
    end
    if materialequips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.materialequips == nil then
        msg.materialequips = {}
      end
      for i = 1, #materialequips do
        table.insert(msg.materialequips, materialequips[i])
      end
    end
    if retmsg ~= nil then
      msg.retmsg = retmsg
    end
    if use_deduction ~= nil then
      msg.use_deduction = use_deduction
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipComposeItemCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if materialequips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.materialequips == nil then
        msgParam.materialequips = {}
      end
      for i = 1, #materialequips do
        table.insert(msgParam.materialequips, materialequips[i])
      end
    end
    if retmsg ~= nil then
      msgParam.retmsg = retmsg
    end
    if use_deduction ~= nil then
      msgParam.use_deduction = use_deduction
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryDebtItemCmd(acc_items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryDebtItemCmd()
    if acc_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.acc_items == nil then
        msg.acc_items = {}
      end
      for i = 1, #acc_items do
        table.insert(msg.acc_items, acc_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryDebtItemCmd.id
    local msgParam = {}
    if acc_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.acc_items == nil then
        msgParam.acc_items = {}
      end
      for i = 1, #acc_items do
        table.insert(msgParam.acc_items, acc_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryActivityNtfCmd(infos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryActivityNtfCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryActivityNtfCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteItemActionItemCmd(action, guids, packtype)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteItemActionItemCmd()
    if action ~= nil then
      msg.action = action
    end
    if guids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guids == nil then
        msg.guids = {}
      end
      for i = 1, #guids do
        table.insert(msg.guids, guids[i])
      end
    end
    if packtype ~= nil then
      msg.packtype = packtype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteItemActionItemCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if guids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guids == nil then
        msgParam.guids = {}
      end
      for i = 1, #guids do
        table.insert(msgParam.guids, guids[i])
      end
    end
    if packtype ~= nil then
      msgParam.packtype = packtype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryLotteryExtraBonusItemCmd(etype, lotterycount, extrabonus)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryLotteryExtraBonusItemCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if lotterycount ~= nil then
      msg.lotterycount = lotterycount
    end
    if extrabonus ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extrabonus == nil then
        msg.extrabonus = {}
      end
      for i = 1, #extrabonus do
        table.insert(msg.extrabonus, extrabonus[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryLotteryExtraBonusItemCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if lotterycount ~= nil then
      msgParam.lotterycount = lotterycount
    end
    if extrabonus ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extrabonus == nil then
        msgParam.extrabonus = {}
      end
      for i = 1, #extrabonus do
        table.insert(msgParam.extrabonus, extrabonus[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryLotteryExtraBonusCfgCmd(etype, extrabonus)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryLotteryExtraBonusCfgCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if extrabonus ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extrabonus == nil then
        msg.extrabonus = {}
      end
      for i = 1, #extrabonus do
        table.insert(msg.extrabonus, extrabonus[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryLotteryExtraBonusCfgCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if extrabonus ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extrabonus == nil then
        msgParam.extrabonus = {}
      end
      for i = 1, #extrabonus do
        table.insert(msgParam.extrabonus, extrabonus[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGetLotteryExtraBonusItemCmd(etype, lotterycount, npcid, optionalbonusindex)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GetLotteryExtraBonusItemCmd()
    if etype ~= nil then
      msg.etype = etype
    end
    if lotterycount ~= nil then
      msg.lotterycount = lotterycount
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if optionalbonusindex ~= nil then
      msg.optionalbonusindex = optionalbonusindex
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetLotteryExtraBonusItemCmd.id
    local msgParam = {}
    if etype ~= nil then
      msgParam.etype = etype
    end
    if lotterycount ~= nil then
      msgParam.lotterycount = lotterycount
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if optionalbonusindex ~= nil then
      msgParam.optionalbonusindex = optionalbonusindex
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRollCatLitterBoxItemCmd(count, rewards)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RollCatLitterBoxItemCmd()
    if count ~= nil then
      msg.count = count
    end
    if rewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rewards == nil then
        msg.rewards = {}
      end
      for i = 1, #rewards do
        table.insert(msg.rewards, rewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RollCatLitterBoxItemCmd.id
    local msgParam = {}
    if count ~= nil then
      msgParam.count = count
    end
    if rewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rewards == nil then
        msgParam.rewards = {}
      end
      for i = 1, #rewards do
        table.insert(msgParam.rewards, rewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallAlterFashionEquipBuffCmd(guid, addbuff)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.AlterFashionEquipBuffCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if addbuff ~= nil then
      msg.addbuff = addbuff
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AlterFashionEquipBuffCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if addbuff ~= nil then
      msgParam.addbuff = addbuff
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryRideLotteryInfo(update, finished, infos, skipanimation, chooseids, skinid, batch)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryRideLotteryInfo()
    if update ~= nil then
      msg.update = update
    end
    if finished ~= nil then
      msg.finished = finished
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if skipanimation ~= nil then
      msg.skipanimation = skipanimation
    end
    if chooseids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chooseids == nil then
        msg.chooseids = {}
      end
      for i = 1, #chooseids do
        table.insert(msg.chooseids, chooseids[i])
      end
    end
    if skinid ~= nil then
      msg.skinid = skinid
    end
    if batch ~= nil then
      msg.batch = batch
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryRideLotteryInfo.id
    local msgParam = {}
    if update ~= nil then
      msgParam.update = update
    end
    if finished ~= nil then
      msgParam.finished = finished
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if skipanimation ~= nil then
      msgParam.skipanimation = skipanimation
    end
    if chooseids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chooseids == nil then
        msgParam.chooseids = {}
      end
      for i = 1, #chooseids do
        table.insert(msgParam.chooseids, chooseids[i])
      end
    end
    if skinid ~= nil then
      msgParam.skinid = skinid
    end
    if batch ~= nil then
      msgParam.batch = batch
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallExecRideLotteryCmd(id, finish, skipanimation, tenpick, ids)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ExecRideLotteryCmd()
    if id ~= nil then
      msg.id = id
    end
    if finish ~= nil then
      msg.finish = finish
    end
    if skipanimation ~= nil then
      msg.skipanimation = skipanimation
    end
    if tenpick ~= nil then
      msg.tenpick = tenpick
    end
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExecRideLotteryCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if finish ~= nil then
      msgParam.finish = finish
    end
    if skipanimation ~= nil then
      msgParam.skipanimation = skipanimation
    end
    if tenpick ~= nil then
      msgParam.tenpick = tenpick
    end
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemSkillAppraisalItemCmd(itemid, count, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemSkillAppraisalItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemSkillAppraisalItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemSkillComposeSameItemCmd(groups, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemSkillComposeSameItemCmd()
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemSkillComposeSameItemCmd.id
    local msgParam = {}
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemSkillComposeQualityItemCmd(compose_type, groups, profession, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemSkillComposeQualityItemCmd()
    if compose_type ~= nil then
      msg.compose_type = compose_type
    end
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    if profession ~= nil then
      msg.profession = profession
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemSkillComposeQualityItemCmd.id
    local msgParam = {}
    if compose_type ~= nil then
      msgParam.compose_type = compose_type
    end
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    if profession ~= nil then
      msgParam.profession = profession
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemAttrComposeItemCmd(level, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemAttrComposeItemCmd()
    if level ~= nil then
      msg.level = level
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemAttrComposeItemCmd.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemAttrUpgradeItemCmd(guid, items, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemAttrUpgradeItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemAttrUpgradeItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemMountItemCmd(gem_type, guid, pos, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemMountItemCmd()
    if gem_type ~= nil then
      msg.gem_type = gem_type
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemMountItemCmd.id
    local msgParam = {}
    if gem_type ~= nil then
      msgParam.gem_type = gem_type
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemUnmountItemCmd(gem_type, guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemUnmountItemCmd()
    if gem_type ~= nil then
      msg.gem_type = gem_type
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemUnmountItemCmd.id
    local msgParam = {}
    if gem_type ~= nil then
      msgParam.gem_type = gem_type
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemCarveItemCmd(guid, type, pos, reset, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemCarveItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if type ~= nil then
      msg.type = type
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if reset ~= nil then
      msg.reset = reset
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemCarveItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if reset ~= nil then
      msgParam.reset = reset
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemSmeltItemCmd(itemid, groups, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemSmeltItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemSmeltItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRideLotteyPickItemCmd()
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RideLotteyPickItemCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RideLotteyPickItemCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRideLotteyPickInfoCmd(totalnum, donenum, itemid, itemnum, done)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RideLotteyPickInfoCmd()
    if totalnum ~= nil then
      msg.totalnum = totalnum
    end
    if donenum ~= nil then
      msg.donenum = donenum
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if itemnum ~= nil then
      msg.itemnum = itemnum
    end
    if done ~= nil then
      msg.done = done
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RideLotteyPickInfoCmd.id
    local msgParam = {}
    if totalnum ~= nil then
      msgParam.totalnum = totalnum
    end
    if donenum ~= nil then
      msgParam.donenum = donenum
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if itemnum ~= nil then
      msgParam.itemnum = itemnum
    end
    if done ~= nil then
      msgParam.done = done
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSandExchangeItemCmd(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SandExchangeItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SandExchangeItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemDataUpdateItemCmd(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemDataUpdateItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemDataUpdateItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryDollQueryItemCmd(total_infos, my_infos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryDollQueryItemCmd()
    if total_infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.total_infos == nil then
        msg.total_infos = {}
      end
      for i = 1, #total_infos do
        table.insert(msg.total_infos, total_infos[i])
      end
    end
    if my_infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.my_infos == nil then
        msg.my_infos = {}
      end
      for i = 1, #my_infos do
        table.insert(msg.my_infos, my_infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryDollQueryItemCmd.id
    local msgParam = {}
    if total_infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.total_infos == nil then
        msgParam.total_infos = {}
      end
      for i = 1, #total_infos do
        table.insert(msgParam.total_infos, total_infos[i])
      end
    end
    if my_infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.my_infos == nil then
        msgParam.my_infos = {}
      end
      for i = 1, #my_infos do
        table.insert(msgParam.my_infos, my_infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryDollPayItemCmd(info)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryDollPayItemCmd()
    if info ~= nil and info.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.id = info.id
    end
    if info ~= nil and info.weight ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.weight = info.weight
    end
    if info.item ~= nil and info.item.guid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.guid = info.item.guid
    end
    if info.item ~= nil and info.item.id ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.id = info.item.id
    end
    if info.item ~= nil and info.item.count ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.count = info.item.count
    end
    if info.item ~= nil and info.item.index ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.index = info.item.index
    end
    if info.item ~= nil and info.item.createtime ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.createtime = info.item.createtime
    end
    if info.item ~= nil and info.item.cd ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.cd = info.item.cd
    end
    if info.item ~= nil and info.item.type ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.type = info.item.type
    end
    if info.item ~= nil and info.item.bind ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.bind = info.item.bind
    end
    if info.item ~= nil and info.item.expire ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.expire = info.item.expire
    end
    if info.item ~= nil and info.item.quality ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.quality = info.item.quality
    end
    if info.item ~= nil and info.item.equipType ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.equipType = info.item.equipType
    end
    if info.item ~= nil and info.item.source ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.source = info.item.source
    end
    if info.item ~= nil and info.item.isnew ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.isnew = info.item.isnew
    end
    if info.item ~= nil and info.item.maxcardslot ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.maxcardslot = info.item.maxcardslot
    end
    if info.item ~= nil and info.item.ishint ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.ishint = info.item.ishint
    end
    if info.item ~= nil and info.item.isactive ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.isactive = info.item.isactive
    end
    if info.item ~= nil and info.item.source_npc ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.source_npc = info.item.source_npc
    end
    if info.item ~= nil and info.item.refinelv ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.refinelv = info.item.refinelv
    end
    if info.item ~= nil and info.item.chargemoney ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.chargemoney = info.item.chargemoney
    end
    if info.item ~= nil and info.item.overtime ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.overtime = info.item.overtime
    end
    if info.item ~= nil and info.item.quota ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.quota = info.item.quota
    end
    if info.item ~= nil and info.item.usedtimes ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.usedtimes = info.item.usedtimes
    end
    if info.item ~= nil and info.item.usedtime ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.usedtime = info.item.usedtime
    end
    if info.item ~= nil and info.item.isfavorite ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.isfavorite = info.item.isfavorite
    end
    if info ~= nil and info.item.mailhint ~= nil then
      if msg.info.item == nil then
        msg.info.item = {}
      end
      if msg.info.item.mailhint == nil then
        msg.info.item.mailhint = {}
      end
      for i = 1, #info.item.mailhint do
        table.insert(msg.info.item.mailhint, info.item.mailhint[i])
      end
    end
    if info.item ~= nil and info.item.subsource ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.subsource = info.item.subsource
    end
    if info.item ~= nil and info.item.randkey ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.randkey = info.item.randkey
    end
    if info.item ~= nil and info.item.sceneinfo ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.sceneinfo = info.item.sceneinfo
    end
    if info.item ~= nil and info.item.local_charge ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.local_charge = info.item.local_charge
    end
    if info.item ~= nil and info.item.charge_deposit_id ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.charge_deposit_id = info.item.charge_deposit_id
    end
    if info.item ~= nil and info.item.issplit ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.issplit = info.item.issplit
    end
    if info.item.tmp ~= nil and info.item.tmp.none ~= nil then
      if msg.info.item == nil then
        msg.info.item = {}
      end
      if msg.info.item.tmp == nil then
        msg.info.item.tmp = {}
      end
      msg.info.item.tmp.none = info.item.tmp.none
    end
    if info.item.tmp ~= nil and info.item.tmp.num_param ~= nil then
      if msg.info.item == nil then
        msg.info.item = {}
      end
      if msg.info.item.tmp == nil then
        msg.info.item.tmp = {}
      end
      msg.info.item.tmp.num_param = info.item.tmp.num_param
    end
    if info.item.tmp ~= nil and info.item.tmp.from_reward ~= nil then
      if msg.info.item == nil then
        msg.info.item = {}
      end
      if msg.info.item.tmp == nil then
        msg.info.item.tmp = {}
      end
      msg.info.item.tmp.from_reward = info.item.tmp.from_reward
    end
    if info.item ~= nil and info.item.mount_fashion_activated ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.mount_fashion_activated = info.item.mount_fashion_activated
    end
    if info.item ~= nil and info.item.no_trade_reason ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.item == nil then
        msg.info.item = {}
      end
      msg.info.item.no_trade_reason = info.item.no_trade_reason
    end
    if info.item.card_info ~= nil and info.item.card_info.lv ~= nil then
      if msg.info.item == nil then
        msg.info.item = {}
      end
      if msg.info.item.card_info == nil then
        msg.info.item.card_info = {}
      end
      msg.info.item.card_info.lv = info.item.card_info.lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryDollPayItemCmd.id
    local msgParam = {}
    if info ~= nil and info.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.id = info.id
    end
    if info ~= nil and info.weight ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.weight = info.weight
    end
    if info.item ~= nil and info.item.guid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.guid = info.item.guid
    end
    if info.item ~= nil and info.item.id ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.id = info.item.id
    end
    if info.item ~= nil and info.item.count ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.count = info.item.count
    end
    if info.item ~= nil and info.item.index ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.index = info.item.index
    end
    if info.item ~= nil and info.item.createtime ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.createtime = info.item.createtime
    end
    if info.item ~= nil and info.item.cd ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.cd = info.item.cd
    end
    if info.item ~= nil and info.item.type ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.type = info.item.type
    end
    if info.item ~= nil and info.item.bind ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.bind = info.item.bind
    end
    if info.item ~= nil and info.item.expire ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.expire = info.item.expire
    end
    if info.item ~= nil and info.item.quality ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.quality = info.item.quality
    end
    if info.item ~= nil and info.item.equipType ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.equipType = info.item.equipType
    end
    if info.item ~= nil and info.item.source ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.source = info.item.source
    end
    if info.item ~= nil and info.item.isnew ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.isnew = info.item.isnew
    end
    if info.item ~= nil and info.item.maxcardslot ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.maxcardslot = info.item.maxcardslot
    end
    if info.item ~= nil and info.item.ishint ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.ishint = info.item.ishint
    end
    if info.item ~= nil and info.item.isactive ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.isactive = info.item.isactive
    end
    if info.item ~= nil and info.item.source_npc ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.source_npc = info.item.source_npc
    end
    if info.item ~= nil and info.item.refinelv ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.refinelv = info.item.refinelv
    end
    if info.item ~= nil and info.item.chargemoney ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.chargemoney = info.item.chargemoney
    end
    if info.item ~= nil and info.item.overtime ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.overtime = info.item.overtime
    end
    if info.item ~= nil and info.item.quota ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.quota = info.item.quota
    end
    if info.item ~= nil and info.item.usedtimes ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.usedtimes = info.item.usedtimes
    end
    if info.item ~= nil and info.item.usedtime ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.usedtime = info.item.usedtime
    end
    if info.item ~= nil and info.item.isfavorite ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.isfavorite = info.item.isfavorite
    end
    if info ~= nil and info.item.mailhint ~= nil then
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      if msgParam.info.item.mailhint == nil then
        msgParam.info.item.mailhint = {}
      end
      for i = 1, #info.item.mailhint do
        table.insert(msgParam.info.item.mailhint, info.item.mailhint[i])
      end
    end
    if info.item ~= nil and info.item.subsource ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.subsource = info.item.subsource
    end
    if info.item ~= nil and info.item.randkey ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.randkey = info.item.randkey
    end
    if info.item ~= nil and info.item.sceneinfo ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.sceneinfo = info.item.sceneinfo
    end
    if info.item ~= nil and info.item.local_charge ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.local_charge = info.item.local_charge
    end
    if info.item ~= nil and info.item.charge_deposit_id ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.charge_deposit_id = info.item.charge_deposit_id
    end
    if info.item ~= nil and info.item.issplit ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.issplit = info.item.issplit
    end
    if info.item.tmp ~= nil and info.item.tmp.none ~= nil then
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      if msgParam.info.item.tmp == nil then
        msgParam.info.item.tmp = {}
      end
      msgParam.info.item.tmp.none = info.item.tmp.none
    end
    if info.item.tmp ~= nil and info.item.tmp.num_param ~= nil then
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      if msgParam.info.item.tmp == nil then
        msgParam.info.item.tmp = {}
      end
      msgParam.info.item.tmp.num_param = info.item.tmp.num_param
    end
    if info.item.tmp ~= nil and info.item.tmp.from_reward ~= nil then
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      if msgParam.info.item.tmp == nil then
        msgParam.info.item.tmp = {}
      end
      msgParam.info.item.tmp.from_reward = info.item.tmp.from_reward
    end
    if info.item ~= nil and info.item.mount_fashion_activated ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.mount_fashion_activated = info.item.mount_fashion_activated
    end
    if info.item ~= nil and info.item.no_trade_reason ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      msgParam.info.item.no_trade_reason = info.item.no_trade_reason
    end
    if info.item.card_info ~= nil and info.item.card_info.lv ~= nil then
      if msgParam.info.item == nil then
        msgParam.info.item = {}
      end
      if msgParam.info.item.card_info == nil then
        msgParam.info.item.card_info = {}
      end
      msgParam.info.item.card_info.lv = info.item.card_info.lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactExchangeItemCmd(itemid, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactExchangeItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactExchangeItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactDecomposeItemCmd(items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactDecomposeItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactDecomposeItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactComposeItemCmd(itemid, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactComposeItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactComposeItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactRemouldItemCmd(guid, type, lock_attrs)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactRemouldItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if type ~= nil then
      msg.type = type
    end
    if lock_attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lock_attrs == nil then
        msg.lock_attrs = {}
      end
      for i = 1, #lock_attrs do
        table.insert(msg.lock_attrs, lock_attrs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactRemouldItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if lock_attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lock_attrs == nil then
        msgParam.lock_attrs = {}
      end
      for i = 1, #lock_attrs do
        table.insert(msgParam.lock_attrs, lock_attrs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactAttrSaveItemCmd(guid, save)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactAttrSaveItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if save ~= nil then
      msg.save = save
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactAttrSaveItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if save ~= nil then
      msgParam.save = save
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPersonalArtifactAppraisalItemCmd(itemid, count, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PersonalArtifactAppraisalItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if count ~= nil then
      msg.count = count
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PersonalArtifactAppraisalItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPosCDNtfItemCmd(poscd)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPosCDNtfItemCmd()
    if poscd ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.poscd == nil then
        msg.poscd = {}
      end
      for i = 1, #poscd do
        table.insert(msg.poscd, poscd[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPosCDNtfItemCmd.id
    local msgParam = {}
    if poscd ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.poscd == nil then
        msgParam.poscd = {}
      end
      for i = 1, #poscd do
        table.insert(msgParam.poscd, poscd[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallBatchRefineItemCmd(equips, npcid, result)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.BatchRefineItemCmd()
    if equips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.equips == nil then
        msg.equips = {}
      end
      for i = 1, #equips do
        table.insert(msg.equips, equips[i])
      end
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BatchRefineItemCmd.id
    local msgParam = {}
    if equips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.equips == nil then
        msgParam.equips = {}
      end
      for i = 1, #equips do
        table.insert(msgParam.equips, equips[i])
      end
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMixLotteryArchiveCmd(type, price, once_max_cnt, discount, groups, data_index, last_data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MixLotteryArchiveCmd()
    if type ~= nil then
      msg.type = type
    end
    if price ~= nil then
      msg.price = price
    end
    if once_max_cnt ~= nil then
      msg.once_max_cnt = once_max_cnt
    end
    if discount ~= nil then
      msg.discount = discount
    end
    if groups ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.groups == nil then
        msg.groups = {}
      end
      for i = 1, #groups do
        table.insert(msg.groups, groups[i])
      end
    end
    if data_index ~= nil then
      msg.data_index = data_index
    end
    if last_data ~= nil then
      msg.last_data = last_data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MixLotteryArchiveCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if price ~= nil then
      msgParam.price = price
    end
    if once_max_cnt ~= nil then
      msgParam.once_max_cnt = once_max_cnt
    end
    if discount ~= nil then
      msgParam.discount = discount
    end
    if groups ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.groups == nil then
        msgParam.groups = {}
      end
      for i = 1, #groups do
        table.insert(msgParam.groups, groups[i])
      end
    end
    if data_index ~= nil then
      msgParam.data_index = data_index
    end
    if last_data ~= nil then
      msgParam.last_data = last_data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryPackMailItemCmd(mails)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryPackMailItemCmd()
    if mails ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mails == nil then
        msg.mails = {}
      end
      for i = 1, #mails do
        table.insert(msg.mails, mails[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPackMailItemCmd.id
    local msgParam = {}
    if mails ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mails == nil then
        msgParam.mails = {}
      end
      for i = 1, #mails do
        table.insert(msgParam.mails, mails[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPackMailUpdateItemCmd(mails, dels)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackMailUpdateItemCmd()
    if mails ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mails == nil then
        msg.mails = {}
      end
      for i = 1, #mails do
        table.insert(msg.mails, mails[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackMailUpdateItemCmd.id
    local msgParam = {}
    if mails ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mails == nil then
        msgParam.mails = {}
      end
      for i = 1, #mails do
        table.insert(msgParam.mails, mails[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPackMailActionItemCmd(action, id)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PackMailActionItemCmd()
    if action ~= nil then
      msg.action = action
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackMailActionItemCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteQueryItemCmd(activityid, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteQueryItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if data ~= nil and data.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardids == nil then
        msg.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msg.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.desires == nil then
        msg.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msg.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.show_favorite = data.show_favorite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteQueryItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if data ~= nil and data.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardids == nil then
        msgParam.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msgParam.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.desires == nil then
        msgParam.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msgParam.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.show_favorite = data.show_favorite
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteGiveItemCmd(activityid, items, once, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteGiveItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if once ~= nil then
      msg.once = once
    end
    if data ~= nil and data.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardids == nil then
        msg.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msg.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.desires == nil then
        msg.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msg.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.show_favorite = data.show_favorite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteGiveItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if once ~= nil then
      msgParam.once = once
    end
    if data ~= nil and data.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardids == nil then
        msgParam.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msgParam.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.desires == nil then
        msgParam.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msgParam.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.show_favorite = data.show_favorite
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteRewardItemCmd(activityid, rewardid, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteRewardItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if rewardid ~= nil then
      msg.rewardid = rewardid
    end
    if data ~= nil and data.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardids == nil then
        msg.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msg.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.desires == nil then
        msg.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msg.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.show_favorite = data.show_favorite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteRewardItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if rewardid ~= nil then
      msgParam.rewardid = rewardid
    end
    if data ~= nil and data.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardids == nil then
        msgParam.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msgParam.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.desires == nil then
        msgParam.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msgParam.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.show_favorite = data.show_favorite
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteInteractItemCmd(activityid, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteInteractItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if data ~= nil and data.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardids == nil then
        msg.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msg.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.desires == nil then
        msg.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msg.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.show_favorite = data.show_favorite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteInteractItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if data ~= nil and data.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardids == nil then
        msgParam.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msgParam.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.desires == nil then
        msgParam.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msgParam.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.show_favorite = data.show_favorite
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFavoriteDesireConditionItemCmd(activityid, count, type, data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FavoriteDesireConditionItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if count ~= nil then
      msg.count = count
    end
    if type ~= nil then
      msg.type = type
    end
    if data ~= nil and data.activityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.rewardids == nil then
        msg.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msg.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.desires == nil then
        msg.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msg.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.show_favorite = data.show_favorite
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FavoriteDesireConditionItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if count ~= nil then
      msgParam.count = count
    end
    if type ~= nil then
      msgParam.type = type
    end
    if data ~= nil and data.activityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.activityid = data.activityid
    end
    if data ~= nil and data.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.level = data.level
    end
    if data ~= nil and data.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.exp = data.exp
    end
    if data ~= nil and data.favorite_item ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.favorite_item = data.favorite_item
    end
    if data ~= nil and data.interact_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.interact_times = data.interact_times
    end
    if data ~= nil and data.rewardids ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.rewardids == nil then
        msgParam.data.rewardids = {}
      end
      for i = 1, #data.rewardids do
        table.insert(msgParam.data.rewardids, data.rewardids[i])
      end
    end
    if data ~= nil and data.desires ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.desires == nil then
        msgParam.data.desires = {}
      end
      for i = 1, #data.desires do
        table.insert(msgParam.data.desires, data.desires[i])
      end
    end
    if data ~= nil and data.has_interact ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.has_interact = data.has_interact
    end
    if data ~= nil and data.show_favorite ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.show_favorite = data.show_favorite
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipEnchantTransferItemCmd(src_guid, dest_guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipEnchantTransferItemCmd()
    if src_guid ~= nil then
      msg.src_guid = src_guid
    end
    if dest_guid ~= nil then
      msg.dest_guid = dest_guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipEnchantTransferItemCmd.id
    local msgParam = {}
    if src_guid ~= nil then
      msgParam.src_guid = src_guid
    end
    if dest_guid ~= nil then
      msgParam.dest_guid = dest_guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipRefineTransferItemCmd(src_guid, dest_guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipRefineTransferItemCmd()
    if src_guid ~= nil then
      msg.src_guid = src_guid
    end
    if dest_guid ~= nil then
      msg.dest_guid = dest_guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipRefineTransferItemCmd.id
    local msgParam = {}
    if src_guid ~= nil then
      msgParam.src_guid = src_guid
    end
    if dest_guid ~= nil then
      msgParam.dest_guid = dest_guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPowerInputItemCmd(items, npcfunction, after_power)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPowerInputItemCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if npcfunction ~= nil then
      msg.npcfunction = npcfunction
    end
    if after_power ~= nil then
      msg.after_power = after_power
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPowerInputItemCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if npcfunction ~= nil then
      msgParam.npcfunction = npcfunction
    end
    if after_power ~= nil then
      msgParam.after_power = after_power
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPowerOutputItemCmd(npcfunction, after_power)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPowerOutputItemCmd()
    if npcfunction ~= nil then
      msg.npcfunction = npcfunction
    end
    if after_power ~= nil then
      msg.after_power = after_power
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPowerOutputItemCmd.id
    local msgParam = {}
    if npcfunction ~= nil then
      msgParam.npcfunction = npcfunction
    end
    if after_power ~= nil then
      msgParam.after_power = after_power
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallColoringQueryItemCmd(itemid, pics, texts)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ColoringQueryItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if pics ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pics == nil then
        msg.pics = {}
      end
      for i = 1, #pics do
        table.insert(msg.pics, pics[i])
      end
    end
    if texts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.texts == nil then
        msg.texts = {}
      end
      for i = 1, #texts do
        table.insert(msg.texts, texts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ColoringQueryItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if pics ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pics == nil then
        msgParam.pics = {}
      end
      for i = 1, #pics do
        table.insert(msgParam.pics, pics[i])
      end
    end
    if texts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.texts == nil then
        msgParam.texts = {}
      end
      for i = 1, #texts do
        table.insert(msgParam.texts, texts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallColoringModifyItemCmd(itemid, pics, texts, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ColoringModifyItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if pics ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pics == nil then
        msg.pics = {}
      end
      for i = 1, #pics do
        table.insert(msg.pics, pics[i])
      end
    end
    if texts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.texts == nil then
        msg.texts = {}
      end
      for i = 1, #texts do
        table.insert(msg.texts, texts[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ColoringModifyItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if pics ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pics == nil then
        msgParam.pics = {}
      end
      for i = 1, #pics do
        table.insert(msgParam.pics, pics[i])
      end
    end
    if texts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.texts == nil then
        msgParam.texts = {}
      end
      for i = 1, #texts do
        table.insert(msgParam.texts, texts[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallColoringShareItemCmd(itemid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ColoringShareItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ColoringShareItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPosStrengthItemCmd(epos, type, destcount, newlv, result, new_sum_lv)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PosStrengthItemCmd()
    if epos ~= nil then
      msg.epos = epos
    end
    if type ~= nil then
      msg.type = type
    end
    if destcount ~= nil then
      msg.destcount = destcount
    end
    if newlv ~= nil then
      msg.newlv = newlv
    end
    if result ~= nil then
      msg.result = result
    end
    if new_sum_lv ~= nil then
      msg.new_sum_lv = new_sum_lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PosStrengthItemCmd.id
    local msgParam = {}
    if epos ~= nil then
      msgParam.epos = epos
    end
    if type ~= nil then
      msgParam.type = type
    end
    if destcount ~= nil then
      msgParam.destcount = destcount
    end
    if newlv ~= nil then
      msgParam.newlv = newlv
    end
    if result ~= nil then
      msgParam.result = result
    end
    if new_sum_lv ~= nil then
      msgParam.new_sum_lv = new_sum_lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryHeadwearExchange(items, success, type)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryHeadwearExchange()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if success ~= nil then
      msg.success = success
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryHeadwearExchange.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if success ~= nil then
      msgParam.success = success
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRandSelectRewardItemCmd(guid, rand_items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RandSelectRewardItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if rand_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.rand_items == nil then
        msg.rand_items = {}
      end
      for i = 1, #rand_items do
        table.insert(msg.rand_items, rand_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RandSelectRewardItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if rand_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.rand_items == nil then
        msgParam.rand_items = {}
      end
      for i = 1, #rand_items do
        table.insert(msgParam.rand_items, rand_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipRecoveryQueryItemCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipRecoveryQueryItemCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipRecoveryQueryItemCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipRecoveryItemCmd(guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipRecoveryItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipRecoveryItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallOneClickPutTakeStoreCmd(from, to, page, furn_guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.OneClickPutTakeStoreCmd()
    if from ~= nil then
      msg.from = from
    end
    if to ~= nil then
      msg.to = to
    end
    if page ~= nil then
      msg.page = page
    end
    if furn_guid ~= nil then
      msg.furn_guid = furn_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OneClickPutTakeStoreCmd.id
    local msgParam = {}
    if from ~= nil then
      msgParam.from = from
    end
    if to ~= nil then
      msgParam.to = to
    end
    if page ~= nil then
      msgParam.page = page
    end
    if furn_guid ~= nil then
      msgParam.furn_guid = furn_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQuestionResultItemCmd(data, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QuestionResultItemCmd()
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.results ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.results == nil then
        msg.data.results = {}
      end
      for i = 1, #data.results do
        table.insert(msg.data.results, data.results[i])
      end
    end
    if data ~= nil and data.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.time = data.time
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuestionResultItemCmd.id
    local msgParam = {}
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.results ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.results == nil then
        msgParam.data.results = {}
      end
      for i = 1, #data.results do
        table.insert(msgParam.data.results, data.results[i])
      end
    end
    if data ~= nil and data.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.time = data.time
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPosStrengthSyncItemCmd(strength_data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PosStrengthSyncItemCmd()
    if strength_data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.strength_data == nil then
        msg.strength_data = {}
      end
      for i = 1, #strength_data do
        table.insert(msg.strength_data, strength_data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PosStrengthSyncItemCmd.id
    local msgParam = {}
    if strength_data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.strength_data == nil then
        msgParam.strength_data = {}
      end
      for i = 1, #strength_data do
        table.insert(msgParam.strength_data, strength_data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPowerQuery(data)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPowerQuery()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPowerQuery.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMagicSuitSave(suit_index, name)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MagicSuitSave()
    if suit_index ~= nil then
      msg.suit_index = suit_index
    end
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MagicSuitSave.id
    local msgParam = {}
    if suit_index ~= nil then
      msgParam.suit_index = suit_index
    end
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMagicSuitNtf(suits)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MagicSuitNtf()
    if suits ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.suits == nil then
        msg.suits = {}
      end
      for i = 1, #suits do
        table.insert(msg.suits, suits[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MagicSuitNtf.id
    local msgParam = {}
    if suits ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.suits == nil then
        msgParam.suits = {}
      end
      for i = 1, #suits do
        table.insert(msgParam.suits, suits[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMagicSuitApply(suitdest)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MagicSuitApply()
    if suitdest ~= nil then
      msg.suitdest = suitdest
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MagicSuitApply.id
    local msgParam = {}
    if suitdest ~= nil then
      msgParam.suitdest = suitdest
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallPotionStoreNtf(hp_setting, sp_setting)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.PotionStoreNtf()
    if hp_setting ~= nil and hp_setting.auto_on ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.hp_setting == nil then
        msg.hp_setting = {}
      end
      msg.hp_setting.auto_on = hp_setting.auto_on
    end
    if hp_setting ~= nil and hp_setting.edge ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.hp_setting == nil then
        msg.hp_setting = {}
      end
      msg.hp_setting.edge = hp_setting.edge
    end
    if hp_setting ~= nil and hp_setting.item ~= nil then
      if msg.hp_setting == nil then
        msg.hp_setting = {}
      end
      if msg.hp_setting.item == nil then
        msg.hp_setting.item = {}
      end
      for i = 1, #hp_setting.item do
        table.insert(msg.hp_setting.item, hp_setting.item[i])
      end
    end
    if sp_setting ~= nil and sp_setting.auto_on ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sp_setting == nil then
        msg.sp_setting = {}
      end
      msg.sp_setting.auto_on = sp_setting.auto_on
    end
    if sp_setting ~= nil and sp_setting.edge ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.sp_setting == nil then
        msg.sp_setting = {}
      end
      msg.sp_setting.edge = sp_setting.edge
    end
    if sp_setting ~= nil and sp_setting.item ~= nil then
      if msg.sp_setting == nil then
        msg.sp_setting = {}
      end
      if msg.sp_setting.item == nil then
        msg.sp_setting.item = {}
      end
      for i = 1, #sp_setting.item do
        table.insert(msg.sp_setting.item, sp_setting.item[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PotionStoreNtf.id
    local msgParam = {}
    if hp_setting ~= nil and hp_setting.auto_on ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.hp_setting == nil then
        msgParam.hp_setting = {}
      end
      msgParam.hp_setting.auto_on = hp_setting.auto_on
    end
    if hp_setting ~= nil and hp_setting.edge ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.hp_setting == nil then
        msgParam.hp_setting = {}
      end
      msgParam.hp_setting.edge = hp_setting.edge
    end
    if hp_setting ~= nil and hp_setting.item ~= nil then
      if msgParam.hp_setting == nil then
        msgParam.hp_setting = {}
      end
      if msgParam.hp_setting.item == nil then
        msgParam.hp_setting.item = {}
      end
      for i = 1, #hp_setting.item do
        table.insert(msgParam.hp_setting.item, hp_setting.item[i])
      end
    end
    if sp_setting ~= nil and sp_setting.auto_on ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sp_setting == nil then
        msgParam.sp_setting = {}
      end
      msgParam.sp_setting.auto_on = sp_setting.auto_on
    end
    if sp_setting ~= nil and sp_setting.edge ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.sp_setting == nil then
        msgParam.sp_setting = {}
      end
      msgParam.sp_setting.edge = sp_setting.edge
    end
    if sp_setting ~= nil and sp_setting.item ~= nil then
      if msgParam.sp_setting == nil then
        msgParam.sp_setting = {}
      end
      if msgParam.sp_setting.item == nil then
        msgParam.sp_setting.item = {}
      end
      for i = 1, #sp_setting.item do
        table.insert(msgParam.sp_setting.item, sp_setting.item[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantHighestBuffNotify(guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantHighestBuffNotify()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantHighestBuffNotify.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryDataSyncItemCmd(free_types)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryDataSyncItemCmd()
    if free_types ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.free_types == nil then
        msg.free_types = {}
      end
      for i = 1, #free_types do
        table.insert(msg.free_types, free_types[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryDataSyncItemCmd.id
    local msgParam = {}
    if free_types ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.free_types == nil then
        msgParam.free_types = {}
      end
      for i = 1, #free_types do
        table.insert(msgParam.free_types, free_types[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallArtifactFlagmentAdd(guid, cost, artid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ArtifactFlagmentAdd()
    if guid ~= nil then
      msg.guid = guid
    end
    if cost ~= nil and cost.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cost == nil then
        msg.cost = {}
      end
      msg.cost.guid = cost.guid
    end
    if cost ~= nil and cost.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.cost == nil then
        msg.cost = {}
      end
      msg.cost.count = cost.count
    end
    if artid ~= nil then
      msg.artid = artid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ArtifactFlagmentAdd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if cost ~= nil and cost.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cost == nil then
        msgParam.cost = {}
      end
      msgParam.cost.guid = cost.guid
    end
    if cost ~= nil and cost.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.cost == nil then
        msgParam.cost = {}
      end
      msgParam.cost.count = cost.count
    end
    if artid ~= nil then
      msgParam.artid = artid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryDailyRewardSyncItemCmd(dailyrewards)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryDailyRewardSyncItemCmd()
    if dailyrewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dailyrewards == nil then
        msg.dailyrewards = {}
      end
      for i = 1, #dailyrewards do
        table.insert(msg.dailyrewards, dailyrewards[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryDailyRewardSyncItemCmd.id
    local msgParam = {}
    if dailyrewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dailyrewards == nil then
        msgParam.dailyrewards = {}
      end
      for i = 1, #dailyrewards do
        table.insert(msgParam.dailyrewards, dailyrewards[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallLotteryDailyRewardGetItemCmd(activityid, lotterytype, day)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.LotteryDailyRewardGetItemCmd()
    if activityid ~= nil then
      msg.activityid = activityid
    end
    if lotterytype ~= nil then
      msg.lotterytype = lotterytype
    end
    if day ~= nil then
      msg.day = day
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LotteryDailyRewardGetItemCmd.id
    local msgParam = {}
    if activityid ~= nil then
      msgParam.activityid = activityid
    end
    if lotterytype ~= nil then
      msgParam.lotterytype = lotterytype
    end
    if day ~= nil then
      msgParam.day = day
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallAutoSellItemCmd(on)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.AutoSellItemCmd()
    if on ~= nil then
      msg.on = on
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AutoSellItemCmd.id
    local msgParam = {}
    if on ~= nil then
      msgParam.on = on
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryAfricanPoringItemCmd(freenormalcount, lotterycount, nextfreenormaltime, status, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryAfricanPoringItemCmd()
    if freenormalcount ~= nil then
      msg.freenormalcount = freenormalcount
    end
    if lotterycount ~= nil then
      msg.lotterycount = lotterycount
    end
    if nextfreenormaltime ~= nil then
      msg.nextfreenormaltime = nextfreenormaltime
    end
    if status ~= nil then
      msg.status = status
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryAfricanPoringItemCmd.id
    local msgParam = {}
    if freenormalcount ~= nil then
      msgParam.freenormalcount = freenormalcount
    end
    if lotterycount ~= nil then
      msgParam.lotterycount = lotterycount
    end
    if nextfreenormaltime ~= nil then
      msgParam.nextfreenormaltime = nextfreenormaltime
    end
    if status ~= nil then
      msgParam.status = status
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallAfricanPoringUpdateItemCmd(freenormalcount, lotterycount, status, items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.AfricanPoringUpdateItemCmd()
    if freenormalcount ~= nil then
      msg.freenormalcount = freenormalcount
    end
    if lotterycount ~= nil then
      msg.lotterycount = lotterycount
    end
    if status ~= nil then
      msg.status = status
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AfricanPoringUpdateItemCmd.id
    local msgParam = {}
    if freenormalcount ~= nil then
      msgParam.freenormalcount = freenormalcount
    end
    if lotterycount ~= nil then
      msgParam.lotterycount = lotterycount
    end
    if status ~= nil then
      msgParam.status = status
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallAfricanPoringLotteryItemCmd(groupid, action, rewardid, hitpos, reward_items)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.AfricanPoringLotteryItemCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if action ~= nil then
      msg.action = action
    end
    if rewardid ~= nil then
      msg.rewardid = rewardid
    end
    if hitpos ~= nil then
      msg.hitpos = hitpos
    end
    if reward_items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reward_items == nil then
        msg.reward_items = {}
      end
      for i = 1, #reward_items do
        table.insert(msg.reward_items, reward_items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AfricanPoringLotteryItemCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if action ~= nil then
      msgParam.action = action
    end
    if rewardid ~= nil then
      msgParam.rewardid = rewardid
    end
    if hitpos ~= nil then
      msgParam.hitpos = hitpos
    end
    if reward_items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reward_items == nil then
        msgParam.reward_items = {}
      end
      for i = 1, #reward_items do
        table.insert(msgParam.reward_items, reward_items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallExtractLevelUpItemCmd(grid, costequips)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ExtractLevelUpItemCmd()
    if grid ~= nil then
      msg.grid = grid
    end
    if costequips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.costequips == nil then
        msg.costequips = {}
      end
      for i = 1, #costequips do
        table.insert(msg.costequips, costequips[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtractLevelUpItemCmd.id
    local msgParam = {}
    if grid ~= nil then
      msgParam.grid = grid
    end
    if costequips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.costequips == nil then
        msgParam.costequips = {}
      end
      for i = 1, #costequips do
        table.insert(msgParam.costequips, costequips[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantRefreshAttr(itemid, multi, attrs)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantRefreshAttr()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if multi ~= nil then
      msg.multi = multi
    end
    if attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.attrs == nil then
        msg.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msg.attrs, attrs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantRefreshAttr.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if multi ~= nil then
      msgParam.multi = multi
    end
    if attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.attrs == nil then
        msgParam.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msgParam.attrs, attrs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallProcessEnchantRefreshAttr(save, itemid, index)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.ProcessEnchantRefreshAttr()
    if save ~= nil then
      msg.save = save
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessEnchantRefreshAttr.id
    local msgParam = {}
    if save ~= nil then
      msgParam.save = save
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEnchantUpgradeAttr(itemid, etype)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EnchantUpgradeAttr()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnchantUpgradeAttr.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallRefreshEquipAttrCmd(guid, attr_id, formula_id, increase)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.RefreshEquipAttrCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if attr_id ~= nil then
      msg.attr_id = attr_id
    end
    if formula_id ~= nil then
      msg.formula_id = formula_id
    end
    if increase ~= nil then
      msg.increase = increase
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RefreshEquipAttrCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if attr_id ~= nil then
      msgParam.attr_id = attr_id
    end
    if formula_id ~= nil then
      msgParam.formula_id = formula_id
    end
    if increase ~= nil then
      msgParam.increase = increase
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQuenchEquipItemCmd(guid, destper)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QuenchEquipItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if destper ~= nil then
      msg.destper = destper
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuenchEquipItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if destper ~= nil then
      msgParam.destper = destper
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMountFashionSyncCmd(fashion)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MountFashionSyncCmd()
    if fashion ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.fashion == nil then
        msg.fashion = {}
      end
      for i = 1, #fashion do
        table.insert(msg.fashion, fashion[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MountFashionSyncCmd.id
    local msgParam = {}
    if fashion ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.fashion == nil then
        msgParam.fashion = {}
      end
      for i = 1, #fashion do
        table.insert(msgParam.fashion, fashion[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMountFashionChangeCmd(mount_id, pos, style)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MountFashionChangeCmd()
    if mount_id ~= nil then
      msg.mount_id = mount_id
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if style ~= nil then
      msg.style = style
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MountFashionChangeCmd.id
    local msgParam = {}
    if mount_id ~= nil then
      msgParam.mount_id = mount_id
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if style ~= nil then
      msgParam.style = style
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallEquipPromote(guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.EquipPromote()
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipPromote.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSwitchFashionEquipRecordItemCmd(index)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SwitchFashionEquipRecordItemCmd()
    if index ~= nil then
      msg.index = index
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SwitchFashionEquipRecordItemCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallOldItemExchangeItemCmd(itemid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.OldItemExchangeItemCmd()
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OldItemExchangeItemCmd.id
    local msgParam = {}
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallBuyMixLotteryItemCmd(item_id, price)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.BuyMixLotteryItemCmd()
    if item_id ~= nil then
      msg.item_id = item_id
    end
    if price ~= nil then
      msg.price = price
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuyMixLotteryItemCmd.id
    local msgParam = {}
    if item_id ~= nil then
      msgParam.item_id = item_id
    end
    if price ~= nil then
      msgParam.price = price
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallCardLotteryPrayItemCmd(lotterytype, cardid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.CardLotteryPrayItemCmd()
    if lotterytype ~= nil then
      msg.lotterytype = lotterytype
    end
    if cardid ~= nil then
      msg.cardid = cardid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CardLotteryPrayItemCmd.id
    local msgParam = {}
    if lotterytype ~= nil then
      msgParam.lotterytype = lotterytype
    end
    if cardid ~= nil then
      msgParam.cardid = cardid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSyncCardLotteryPrayItemCmd(lotterytype, pray_open, cardid, cur_pray, max_pray, left_pray)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SyncCardLotteryPrayItemCmd()
    if lotterytype ~= nil then
      msg.lotterytype = lotterytype
    end
    if pray_open ~= nil then
      msg.pray_open = pray_open
    end
    if cardid ~= nil then
      msg.cardid = cardid
    end
    if cur_pray ~= nil then
      msg.cur_pray = cur_pray
    end
    if max_pray ~= nil then
      msg.max_pray = max_pray
    end
    if left_pray ~= nil then
      msg.left_pray = left_pray
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncCardLotteryPrayItemCmd.id
    local msgParam = {}
    if lotterytype ~= nil then
      msgParam.lotterytype = lotterytype
    end
    if pray_open ~= nil then
      msgParam.pray_open = pray_open
    end
    if cardid ~= nil then
      msgParam.cardid = cardid
    end
    if cur_pray ~= nil then
      msgParam.cur_pray = cur_pray
    end
    if max_pray ~= nil then
      msgParam.max_pray = max_pray
    end
    if left_pray ~= nil then
      msgParam.left_pray = left_pray
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallGemBagExpSyncItemCmd(exp)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.GemBagExpSyncItemCmd()
    if exp ~= nil then
      msg.exp = exp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GemBagExpSyncItemCmd.id
    local msgParam = {}
    if exp ~= nil then
      msgParam.exp = exp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallSecretLandGemCmd(type, guid, exp, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.SecretLandGemCmd()
    if type ~= nil then
      msg.type = type
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if exp ~= nil then
      msg.exp = exp
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SecretLandGemCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if exp ~= nil then
      msgParam.exp = exp
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMountFashionQueryStateCmd(mount_id, active_style_ids)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MountFashionQueryStateCmd()
    if mount_id ~= nil then
      msg.mount_id = mount_id
    end
    if active_style_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.active_style_ids == nil then
        msg.active_style_ids = {}
      end
      for i = 1, #active_style_ids do
        table.insert(msg.active_style_ids, active_style_ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MountFashionQueryStateCmd.id
    local msgParam = {}
    if mount_id ~= nil then
      msgParam.mount_id = mount_id
    end
    if active_style_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.active_style_ids == nil then
        msgParam.active_style_ids = {}
      end
      for i = 1, #active_style_ids do
        table.insert(msgParam.active_style_ids, active_style_ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMountFashionActiveCmd(mount_id, pos, style_id)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MountFashionActiveCmd()
    if mount_id ~= nil then
      msg.mount_id = mount_id
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if style_id ~= nil then
      msg.style_id = style_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MountFashionActiveCmd.id
    local msgParam = {}
    if mount_id ~= nil then
      msgParam.mount_id = mount_id
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if style_id ~= nil then
      msgParam.style_id = style_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallStorePutItemItemCmd(topack, itemguid, furn_guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.StorePutItemItemCmd()
    if topack ~= nil then
      msg.topack = topack
    end
    if itemguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemguid == nil then
        msg.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msg.itemguid, itemguid[i])
      end
    end
    if furn_guid ~= nil then
      msg.furn_guid = furn_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StorePutItemItemCmd.id
    local msgParam = {}
    if topack ~= nil then
      msgParam.topack = topack
    end
    if itemguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemguid == nil then
        msgParam.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msgParam.itemguid, itemguid[i])
      end
    end
    if furn_guid ~= nil then
      msgParam.furn_guid = furn_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallStoreOffItemItemCmd(frompack, itemguid, furn_guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.StoreOffItemItemCmd()
    if frompack ~= nil then
      msg.frompack = frompack
    end
    if itemguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemguid == nil then
        msg.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msg.itemguid, itemguid[i])
      end
    end
    if furn_guid ~= nil then
      msg.furn_guid = furn_guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StoreOffItemItemCmd.id
    local msgParam = {}
    if frompack ~= nil then
      msgParam.frompack = frompack
    end
    if itemguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemguid == nil then
        msgParam.itemguid = {}
      end
      for i = 1, #itemguid do
        table.insert(msgParam.itemguid, itemguid[i])
      end
    end
    if furn_guid ~= nil then
      msgParam.furn_guid = furn_guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallFullGemSkill(guid, success)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.FullGemSkill()
    if guid ~= nil then
      msg.guid = guid
    end
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FullGemSkill.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallQueryBossCardComposeRateCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.QueryBossCardComposeRateCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryBossCardComposeRateCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryEmbedItemCmd(memory_guid, pos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryEmbedItemCmd()
    if memory_guid ~= nil then
      msg.memory_guid = memory_guid
    end
    if pos ~= nil then
      msg.pos = pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryEmbedItemCmd.id
    local msgParam = {}
    if memory_guid ~= nil then
      msgParam.memory_guid = memory_guid
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryUnEmbedItemCmd(pos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryUnEmbedItemCmd()
    if pos ~= nil then
      msg.pos = pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryUnEmbedItemCmd.id
    local msgParam = {}
    if pos ~= nil then
      msgParam.pos = pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryLevelupItemCmd(memory_guid, equip_pos, dest_lv)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryLevelupItemCmd()
    if memory_guid ~= nil then
      msg.memory_guid = memory_guid
    end
    if equip_pos ~= nil then
      msg.equip_pos = equip_pos
    end
    if dest_lv ~= nil then
      msg.dest_lv = dest_lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryLevelupItemCmd.id
    local msgParam = {}
    if memory_guid ~= nil then
      msgParam.memory_guid = memory_guid
    end
    if equip_pos ~= nil then
      msgParam.equip_pos = equip_pos
    end
    if dest_lv ~= nil then
      msgParam.dest_lv = dest_lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryDecomposeItemCmd(guid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryDecomposeItemCmd()
    if guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guid == nil then
        msg.guid = {}
      end
      for i = 1, #guid do
        table.insert(msg.guid, guid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryDecomposeItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guid == nil then
        msgParam.guid = {}
      end
      for i = 1, #guid do
        table.insert(msgParam.guid, guid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryEffectOperItemCmd(oper, equip_pos, memory_guid, index, effectid, rand)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryEffectOperItemCmd()
    if oper ~= nil then
      msg.oper = oper
    end
    if equip_pos ~= nil then
      msg.equip_pos = equip_pos
    end
    if memory_guid ~= nil then
      msg.memory_guid = memory_guid
    end
    if index ~= nil then
      msg.index = index
    end
    if effectid ~= nil then
      msg.effectid = effectid
    end
    if rand ~= nil then
      msg.rand = rand
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryEffectOperItemCmd.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if equip_pos ~= nil then
      msgParam.equip_pos = equip_pos
    end
    if memory_guid ~= nil then
      msgParam.memory_guid = memory_guid
    end
    if index ~= nil then
      msgParam.index = index
    end
    if effectid ~= nil then
      msgParam.effectid = effectid
    end
    if rand ~= nil then
      msgParam.rand = rand
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryAutoDecomposeOptionItemCmd(quality)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryAutoDecomposeOptionItemCmd()
    if quality ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quality == nil then
        msg.quality = {}
      end
      for i = 1, #quality do
        table.insert(msg.quality, quality[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryAutoDecomposeOptionItemCmd.id
    local msgParam = {}
    if quality ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quality == nil then
        msgParam.quality = {}
      end
      for i = 1, #quality do
        table.insert(msgParam.quality, quality[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallUpdateMemoryPosItemCmd(pos)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.UpdateMemoryPosItemCmd()
    if pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      for i = 1, #pos do
        table.insert(msg.pos, pos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateMemoryPosItemCmd.id
    local msgParam = {}
    if pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      for i = 1, #pos do
        table.insert(msgParam.pos, pos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallDecomposeGemItemCmd(guids)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.DecomposeGemItemCmd()
    if guids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guids == nil then
        msg.guids = {}
      end
      for i = 1, #guids do
        table.insert(msg.guids, guids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DecomposeGemItemCmd.id
    local msgParam = {}
    if guids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guids == nil then
        msgParam.guids = {}
      end
      for i = 1, #guids do
        table.insert(msgParam.guids, guids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallUpgradeGemItemCmd(guid, buffid, paramid)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.UpgradeGemItemCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if buffid ~= nil then
      msg.buffid = buffid
    end
    if paramid ~= nil then
      msg.paramid = paramid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpgradeGemItemCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if buffid ~= nil then
      msgParam.buffid = buffid
    end
    if paramid ~= nil then
      msgParam.paramid = paramid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallMemoryUpgradeItemCmd(memory_guid, equip_pos, quality_type)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.MemoryUpgradeItemCmd()
    if memory_guid ~= nil then
      msg.memory_guid = memory_guid
    end
    if equip_pos ~= nil then
      msg.equip_pos = equip_pos
    end
    if quality_type ~= nil then
      msg.quality_type = quality_type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MemoryUpgradeItemCmd.id
    local msgParam = {}
    if memory_guid ~= nil then
      msgParam.memory_guid = memory_guid
    end
    if equip_pos ~= nil then
      msgParam.equip_pos = equip_pos
    end
    if quality_type ~= nil then
      msgParam.quality_type = quality_type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallCardLevelupItemCmd(card_guid, dest_lv)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.CardLevelupItemCmd()
    if card_guid ~= nil then
      msg.card_guid = card_guid
    end
    if dest_lv ~= nil then
      msg.dest_lv = dest_lv
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CardLevelupItemCmd.id
    local msgParam = {}
    if card_guid ~= nil then
      msgParam.card_guid = card_guid
    end
    if dest_lv ~= nil then
      msgParam.dest_lv = dest_lv
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallBalanceModeMemorySetItemCmd(pos, effect)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.BalanceModeMemorySetItemCmd()
    if pos ~= nil then
      msg.pos = pos
    end
    if effect ~= nil and effect.index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.effect == nil then
        msg.effect = {}
      end
      msg.effect.index = effect.index
    end
    if effect ~= nil and effect.effect_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.effect == nil then
        msg.effect = {}
      end
      msg.effect.effect_id = effect.effect_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BalanceModeMemorySetItemCmd.id
    local msgParam = {}
    if pos ~= nil then
      msgParam.pos = pos
    end
    if effect ~= nil and effect.index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.effect == nil then
        msgParam.effect = {}
      end
      msgParam.effect.index = effect.index
    end
    if effect ~= nil and effect.effect_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.effect == nil then
        msgParam.effect = {}
      end
      msgParam.effect.effect_id = effect.effect_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:CallBalanceModeMemoryUpdateItemCmd(balance_memory)
  if not NetConfig.PBC then
    local msg = SceneItem_pb.BalanceModeMemoryUpdateItemCmd()
    if balance_memory ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.balance_memory == nil then
        msg.balance_memory = {}
      end
      for i = 1, #balance_memory do
        table.insert(msg.balance_memory, balance_memory[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BalanceModeMemoryUpdateItemCmd.id
    local msgParam = {}
    if balance_memory ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.balance_memory == nil then
        msgParam.balance_memory = {}
      end
      for i = 1, #balance_memory do
        table.insert(msgParam.balance_memory, balance_memory[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceItemAutoProxy:RecvPackageItem(data)
  self:Notify(ServiceEvent.ItemPackageItem, data)
end

function ServiceItemAutoProxy:RecvPackageUpdate(data)
  self:Notify(ServiceEvent.ItemPackageUpdate, data)
end

function ServiceItemAutoProxy:RecvItemUse(data)
  self:Notify(ServiceEvent.ItemItemUse, data)
end

function ServiceItemAutoProxy:RecvPackageSort(data)
  self:Notify(ServiceEvent.ItemPackageSort, data)
end

function ServiceItemAutoProxy:RecvEquip(data)
  self:Notify(ServiceEvent.ItemEquip, data)
end

function ServiceItemAutoProxy:RecvSellItem(data)
  self:Notify(ServiceEvent.ItemSellItem, data)
end

function ServiceItemAutoProxy:RecvEquipStrength(data)
  self:Notify(ServiceEvent.ItemEquipStrength, data)
end

function ServiceItemAutoProxy:RecvProduce(data)
  self:Notify(ServiceEvent.ItemProduce, data)
end

function ServiceItemAutoProxy:RecvProduceDone(data)
  self:Notify(ServiceEvent.ItemProduceDone, data)
end

function ServiceItemAutoProxy:RecvEquipRefine(data)
  self:Notify(ServiceEvent.ItemEquipRefine, data)
end

function ServiceItemAutoProxy:RecvEquipDecompose(data)
  self:Notify(ServiceEvent.ItemEquipDecompose, data)
end

function ServiceItemAutoProxy:RecvQueryEquipData(data)
  self:Notify(ServiceEvent.ItemQueryEquipData, data)
end

function ServiceItemAutoProxy:RecvBrowsePackage(data)
  self:Notify(ServiceEvent.ItemBrowsePackage, data)
end

function ServiceItemAutoProxy:RecvEquipCard(data)
  self:Notify(ServiceEvent.ItemEquipCard, data)
end

function ServiceItemAutoProxy:RecvItemShow(data)
  self:Notify(ServiceEvent.ItemItemShow, data)
end

function ServiceItemAutoProxy:RecvItemShow64(data)
  self:Notify(ServiceEvent.ItemItemShow64, data)
end

function ServiceItemAutoProxy:RecvEquipRepair(data)
  self:Notify(ServiceEvent.ItemEquipRepair, data)
end

function ServiceItemAutoProxy:RecvHintNtf(data)
  self:Notify(ServiceEvent.ItemHintNtf, data)
end

function ServiceItemAutoProxy:RecvEnchantEquip(data)
  self:Notify(ServiceEvent.ItemEnchantEquip, data)
end

function ServiceItemAutoProxy:RecvEnchantRes(data)
  self:Notify(ServiceEvent.ItemEnchantRes, data)
end

function ServiceItemAutoProxy:RecvProcessEnchantItemCmd(data)
  self:Notify(ServiceEvent.ItemProcessEnchantItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipExchangeItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipExchangeItemCmd, data)
end

function ServiceItemAutoProxy:RecvOnOffStoreItemCmd(data)
  self:Notify(ServiceEvent.ItemOnOffStoreItemCmd, data)
end

function ServiceItemAutoProxy:RecvPackSlotNtfItemCmd(data)
  self:Notify(ServiceEvent.ItemPackSlotNtfItemCmd, data)
end

function ServiceItemAutoProxy:RecvRestoreEquipItemCmd(data)
  self:Notify(ServiceEvent.ItemRestoreEquipItemCmd, data)
end

function ServiceItemAutoProxy:RecvUseCountItemCmd(data)
  self:Notify(ServiceEvent.ItemUseCountItemCmd, data)
end

function ServiceItemAutoProxy:RecvExchangeCardItemCmd(data)
  self:Notify(ServiceEvent.ItemExchangeCardItemCmd, data)
end

function ServiceItemAutoProxy:RecvGetCountItemCmd(data)
  self:Notify(ServiceEvent.ItemGetCountItemCmd, data)
end

function ServiceItemAutoProxy:RecvSaveLoveLetterCmd(data)
  self:Notify(ServiceEvent.ItemSaveLoveLetterCmd, data)
end

function ServiceItemAutoProxy:RecvItemDataShow(data)
  self:Notify(ServiceEvent.ItemItemDataShow, data)
end

function ServiceItemAutoProxy:RecvLotteryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryRecoveryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryRecoveryCmd, data)
end

function ServiceItemAutoProxy:RecvQueryLotteryInfo(data)
  self:Notify(ServiceEvent.ItemQueryLotteryInfo, data)
end

function ServiceItemAutoProxy:RecvReqQuotaLogCmd(data)
  self:Notify(ServiceEvent.ItemReqQuotaLogCmd, data)
end

function ServiceItemAutoProxy:RecvReqQuotaDetailCmd(data)
  self:Notify(ServiceEvent.ItemReqQuotaDetailCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPosDataUpdate(data)
  self:Notify(ServiceEvent.ItemEquipPosDataUpdate, data)
end

function ServiceItemAutoProxy:RecvHighRefineMatComposeCmd(data)
  self:Notify(ServiceEvent.ItemHighRefineMatComposeCmd, data)
end

function ServiceItemAutoProxy:RecvHighRefineCmd(data)
  self:Notify(ServiceEvent.ItemHighRefineCmd, data)
end

function ServiceItemAutoProxy:RecvNtfHighRefineDataCmd(data)
  self:Notify(ServiceEvent.ItemNtfHighRefineDataCmd, data)
end

function ServiceItemAutoProxy:RecvUpdateHighRefineDataCmd(data)
  self:Notify(ServiceEvent.ItemUpdateHighRefineDataCmd, data)
end

function ServiceItemAutoProxy:RecvUseCodItemCmd(data)
  self:Notify(ServiceEvent.ItemUseCodItemCmd, data)
end

function ServiceItemAutoProxy:RecvAddJobLevelItemCmd(data)
  self:Notify(ServiceEvent.ItemAddJobLevelItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotterGivBuyCountCmd(data)
  self:Notify(ServiceEvent.ItemLotterGivBuyCountCmd, data)
end

function ServiceItemAutoProxy:RecvGiveWeddingDressCmd(data)
  self:Notify(ServiceEvent.ItemGiveWeddingDressCmd, data)
end

function ServiceItemAutoProxy:RecvQuickStoreItemCmd(data)
  self:Notify(ServiceEvent.ItemQuickStoreItemCmd, data)
end

function ServiceItemAutoProxy:RecvQuickSellItemCmd(data)
  self:Notify(ServiceEvent.ItemQuickSellItemCmd, data)
end

function ServiceItemAutoProxy:RecvEnchantTransItemCmd(data)
  self:Notify(ServiceEvent.ItemEnchantTransItemCmd, data)
end

function ServiceItemAutoProxy:RecvQueryLotteryHeadItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryLotteryHeadItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryRateQueryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryRateQueryCmd, data)
end

function ServiceItemAutoProxy:RecvEquipComposeItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipComposeItemCmd, data)
end

function ServiceItemAutoProxy:RecvQueryDebtItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryDebtItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryActivityNtfCmd(data)
  self:Notify(ServiceEvent.ItemLotteryActivityNtfCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteItemActionItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteItemActionItemCmd, data)
end

function ServiceItemAutoProxy:RecvQueryLotteryExtraBonusItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryLotteryExtraBonusItemCmd, data)
end

function ServiceItemAutoProxy:RecvQueryLotteryExtraBonusCfgCmd(data)
  self:Notify(ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd, data)
end

function ServiceItemAutoProxy:RecvGetLotteryExtraBonusItemCmd(data)
  self:Notify(ServiceEvent.ItemGetLotteryExtraBonusItemCmd, data)
end

function ServiceItemAutoProxy:RecvRollCatLitterBoxItemCmd(data)
  self:Notify(ServiceEvent.ItemRollCatLitterBoxItemCmd, data)
end

function ServiceItemAutoProxy:RecvAlterFashionEquipBuffCmd(data)
  self:Notify(ServiceEvent.ItemAlterFashionEquipBuffCmd, data)
end

function ServiceItemAutoProxy:RecvQueryRideLotteryInfo(data)
  self:Notify(ServiceEvent.ItemQueryRideLotteryInfo, data)
end

function ServiceItemAutoProxy:RecvExecRideLotteryCmd(data)
  self:Notify(ServiceEvent.ItemExecRideLotteryCmd, data)
end

function ServiceItemAutoProxy:RecvGemSkillAppraisalItemCmd(data)
  self:Notify(ServiceEvent.ItemGemSkillAppraisalItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemSkillComposeSameItemCmd(data)
  self:Notify(ServiceEvent.ItemGemSkillComposeSameItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemSkillComposeQualityItemCmd(data)
  self:Notify(ServiceEvent.ItemGemSkillComposeQualityItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemAttrComposeItemCmd(data)
  self:Notify(ServiceEvent.ItemGemAttrComposeItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemAttrUpgradeItemCmd(data)
  self:Notify(ServiceEvent.ItemGemAttrUpgradeItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemMountItemCmd(data)
  self:Notify(ServiceEvent.ItemGemMountItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemUnmountItemCmd(data)
  self:Notify(ServiceEvent.ItemGemUnmountItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemCarveItemCmd(data)
  self:Notify(ServiceEvent.ItemGemCarveItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemSmeltItemCmd(data)
  self:Notify(ServiceEvent.ItemGemSmeltItemCmd, data)
end

function ServiceItemAutoProxy:RecvRideLotteyPickItemCmd(data)
  self:Notify(ServiceEvent.ItemRideLotteyPickItemCmd, data)
end

function ServiceItemAutoProxy:RecvRideLotteyPickInfoCmd(data)
  self:Notify(ServiceEvent.ItemRideLotteyPickInfoCmd, data)
end

function ServiceItemAutoProxy:RecvSandExchangeItemCmd(data)
  self:Notify(ServiceEvent.ItemSandExchangeItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemDataUpdateItemCmd(data)
  self:Notify(ServiceEvent.ItemGemDataUpdateItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryDollQueryItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDollQueryItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryDollPayItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDollPayItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactExchangeItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactExchangeItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactDecomposeItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactDecomposeItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactComposeItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactComposeItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactRemouldItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactRemouldItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactAttrSaveItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactAttrSaveItemCmd, data)
end

function ServiceItemAutoProxy:RecvPersonalArtifactAppraisalItemCmd(data)
  self:Notify(ServiceEvent.ItemPersonalArtifactAppraisalItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPosCDNtfItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipPosCDNtfItemCmd, data)
end

function ServiceItemAutoProxy:RecvBatchRefineItemCmd(data)
  self:Notify(ServiceEvent.ItemBatchRefineItemCmd, data)
end

function ServiceItemAutoProxy:RecvMixLotteryArchiveCmd(data)
  self:Notify(ServiceEvent.ItemMixLotteryArchiveCmd, data)
end

function ServiceItemAutoProxy:RecvQueryPackMailItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryPackMailItemCmd, data)
end

function ServiceItemAutoProxy:RecvPackMailUpdateItemCmd(data)
  self:Notify(ServiceEvent.ItemPackMailUpdateItemCmd, data)
end

function ServiceItemAutoProxy:RecvPackMailActionItemCmd(data)
  self:Notify(ServiceEvent.ItemPackMailActionItemCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteQueryItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteQueryItemCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteGiveItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteGiveItemCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteRewardItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteRewardItemCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteInteractItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteInteractItemCmd, data)
end

function ServiceItemAutoProxy:RecvFavoriteDesireConditionItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteDesireConditionItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipEnchantTransferItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipEnchantTransferItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipRefineTransferItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipRefineTransferItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPowerInputItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipPowerInputItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPowerOutputItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipPowerOutputItemCmd, data)
end

function ServiceItemAutoProxy:RecvColoringQueryItemCmd(data)
  self:Notify(ServiceEvent.ItemColoringQueryItemCmd, data)
end

function ServiceItemAutoProxy:RecvColoringModifyItemCmd(data)
  self:Notify(ServiceEvent.ItemColoringModifyItemCmd, data)
end

function ServiceItemAutoProxy:RecvColoringShareItemCmd(data)
  self:Notify(ServiceEvent.ItemColoringShareItemCmd, data)
end

function ServiceItemAutoProxy:RecvPosStrengthItemCmd(data)
  self:Notify(ServiceEvent.ItemPosStrengthItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryHeadwearExchange(data)
  self:Notify(ServiceEvent.ItemLotteryHeadwearExchange, data)
end

function ServiceItemAutoProxy:RecvRandSelectRewardItemCmd(data)
  self:Notify(ServiceEvent.ItemRandSelectRewardItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipRecoveryQueryItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipRecoveryQueryItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipRecoveryItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipRecoveryItemCmd, data)
end

function ServiceItemAutoProxy:RecvOneClickPutTakeStoreCmd(data)
  self:Notify(ServiceEvent.ItemOneClickPutTakeStoreCmd, data)
end

function ServiceItemAutoProxy:RecvQuestionResultItemCmd(data)
  self:Notify(ServiceEvent.ItemQuestionResultItemCmd, data)
end

function ServiceItemAutoProxy:RecvPosStrengthSyncItemCmd(data)
  self:Notify(ServiceEvent.ItemPosStrengthSyncItemCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPowerQuery(data)
  self:Notify(ServiceEvent.ItemEquipPowerQuery, data)
end

function ServiceItemAutoProxy:RecvMagicSuitSave(data)
  self:Notify(ServiceEvent.ItemMagicSuitSave, data)
end

function ServiceItemAutoProxy:RecvMagicSuitNtf(data)
  self:Notify(ServiceEvent.ItemMagicSuitNtf, data)
end

function ServiceItemAutoProxy:RecvMagicSuitApply(data)
  self:Notify(ServiceEvent.ItemMagicSuitApply, data)
end

function ServiceItemAutoProxy:RecvPotionStoreNtf(data)
  self:Notify(ServiceEvent.ItemPotionStoreNtf, data)
end

function ServiceItemAutoProxy:RecvEnchantHighestBuffNotify(data)
  self:Notify(ServiceEvent.ItemEnchantHighestBuffNotify, data)
end

function ServiceItemAutoProxy:RecvLotteryDataSyncItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDataSyncItemCmd, data)
end

function ServiceItemAutoProxy:RecvArtifactFlagmentAdd(data)
  self:Notify(ServiceEvent.ItemArtifactFlagmentAdd, data)
end

function ServiceItemAutoProxy:RecvLotteryDailyRewardSyncItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDailyRewardSyncItemCmd, data)
end

function ServiceItemAutoProxy:RecvLotteryDailyRewardGetItemCmd(data)
  self:Notify(ServiceEvent.ItemLotteryDailyRewardGetItemCmd, data)
end

function ServiceItemAutoProxy:RecvAutoSellItemCmd(data)
  self:Notify(ServiceEvent.ItemAutoSellItemCmd, data)
end

function ServiceItemAutoProxy:RecvQueryAfricanPoringItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryAfricanPoringItemCmd, data)
end

function ServiceItemAutoProxy:RecvAfricanPoringUpdateItemCmd(data)
  self:Notify(ServiceEvent.ItemAfricanPoringUpdateItemCmd, data)
end

function ServiceItemAutoProxy:RecvAfricanPoringLotteryItemCmd(data)
  self:Notify(ServiceEvent.ItemAfricanPoringLotteryItemCmd, data)
end

function ServiceItemAutoProxy:RecvExtractLevelUpItemCmd(data)
  self:Notify(ServiceEvent.ItemExtractLevelUpItemCmd, data)
end

function ServiceItemAutoProxy:RecvEnchantRefreshAttr(data)
  self:Notify(ServiceEvent.ItemEnchantRefreshAttr, data)
end

function ServiceItemAutoProxy:RecvProcessEnchantRefreshAttr(data)
  self:Notify(ServiceEvent.ItemProcessEnchantRefreshAttr, data)
end

function ServiceItemAutoProxy:RecvEnchantUpgradeAttr(data)
  self:Notify(ServiceEvent.ItemEnchantUpgradeAttr, data)
end

function ServiceItemAutoProxy:RecvRefreshEquipAttrCmd(data)
  self:Notify(ServiceEvent.ItemRefreshEquipAttrCmd, data)
end

function ServiceItemAutoProxy:RecvQuenchEquipItemCmd(data)
  self:Notify(ServiceEvent.ItemQuenchEquipItemCmd, data)
end

function ServiceItemAutoProxy:RecvMountFashionSyncCmd(data)
  self:Notify(ServiceEvent.ItemMountFashionSyncCmd, data)
end

function ServiceItemAutoProxy:RecvMountFashionChangeCmd(data)
  self:Notify(ServiceEvent.ItemMountFashionChangeCmd, data)
end

function ServiceItemAutoProxy:RecvEquipPromote(data)
  self:Notify(ServiceEvent.ItemEquipPromote, data)
end

function ServiceItemAutoProxy:RecvSwitchFashionEquipRecordItemCmd(data)
  self:Notify(ServiceEvent.ItemSwitchFashionEquipRecordItemCmd, data)
end

function ServiceItemAutoProxy:RecvOldItemExchangeItemCmd(data)
  self:Notify(ServiceEvent.ItemOldItemExchangeItemCmd, data)
end

function ServiceItemAutoProxy:RecvBuyMixLotteryItemCmd(data)
  self:Notify(ServiceEvent.ItemBuyMixLotteryItemCmd, data)
end

function ServiceItemAutoProxy:RecvCardLotteryPrayItemCmd(data)
  self:Notify(ServiceEvent.ItemCardLotteryPrayItemCmd, data)
end

function ServiceItemAutoProxy:RecvSyncCardLotteryPrayItemCmd(data)
  self:Notify(ServiceEvent.ItemSyncCardLotteryPrayItemCmd, data)
end

function ServiceItemAutoProxy:RecvGemBagExpSyncItemCmd(data)
  self:Notify(ServiceEvent.ItemGemBagExpSyncItemCmd, data)
end

function ServiceItemAutoProxy:RecvSecretLandGemCmd(data)
  self:Notify(ServiceEvent.ItemSecretLandGemCmd, data)
end

function ServiceItemAutoProxy:RecvMountFashionQueryStateCmd(data)
  self:Notify(ServiceEvent.ItemMountFashionQueryStateCmd, data)
end

function ServiceItemAutoProxy:RecvMountFashionActiveCmd(data)
  self:Notify(ServiceEvent.ItemMountFashionActiveCmd, data)
end

function ServiceItemAutoProxy:RecvStorePutItemItemCmd(data)
  self:Notify(ServiceEvent.ItemStorePutItemItemCmd, data)
end

function ServiceItemAutoProxy:RecvStoreOffItemItemCmd(data)
  self:Notify(ServiceEvent.ItemStoreOffItemItemCmd, data)
end

function ServiceItemAutoProxy:RecvFullGemSkill(data)
  self:Notify(ServiceEvent.ItemFullGemSkill, data)
end

function ServiceItemAutoProxy:RecvQueryBossCardComposeRateCmd(data)
  self:Notify(ServiceEvent.ItemQueryBossCardComposeRateCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryEmbedItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryEmbedItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryUnEmbedItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryUnEmbedItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryLevelupItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryLevelupItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryDecomposeItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryDecomposeItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryEffectOperItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryEffectOperItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryAutoDecomposeOptionItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryAutoDecomposeOptionItemCmd, data)
end

function ServiceItemAutoProxy:RecvUpdateMemoryPosItemCmd(data)
  self:Notify(ServiceEvent.ItemUpdateMemoryPosItemCmd, data)
end

function ServiceItemAutoProxy:RecvDecomposeGemItemCmd(data)
  self:Notify(ServiceEvent.ItemDecomposeGemItemCmd, data)
end

function ServiceItemAutoProxy:RecvUpgradeGemItemCmd(data)
  self:Notify(ServiceEvent.ItemUpgradeGemItemCmd, data)
end

function ServiceItemAutoProxy:RecvMemoryUpgradeItemCmd(data)
  self:Notify(ServiceEvent.ItemMemoryUpgradeItemCmd, data)
end

function ServiceItemAutoProxy:RecvCardLevelupItemCmd(data)
  self:Notify(ServiceEvent.ItemCardLevelupItemCmd, data)
end

function ServiceItemAutoProxy:RecvBalanceModeMemorySetItemCmd(data)
  self:Notify(ServiceEvent.ItemBalanceModeMemorySetItemCmd, data)
end

function ServiceItemAutoProxy:RecvBalanceModeMemoryUpdateItemCmd(data)
  self:Notify(ServiceEvent.ItemBalanceModeMemoryUpdateItemCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ItemPackageItem = "ServiceEvent_ItemPackageItem"
ServiceEvent.ItemPackageUpdate = "ServiceEvent_ItemPackageUpdate"
ServiceEvent.ItemItemUse = "ServiceEvent_ItemItemUse"
ServiceEvent.ItemPackageSort = "ServiceEvent_ItemPackageSort"
ServiceEvent.ItemEquip = "ServiceEvent_ItemEquip"
ServiceEvent.ItemSellItem = "ServiceEvent_ItemSellItem"
ServiceEvent.ItemEquipStrength = "ServiceEvent_ItemEquipStrength"
ServiceEvent.ItemProduce = "ServiceEvent_ItemProduce"
ServiceEvent.ItemProduceDone = "ServiceEvent_ItemProduceDone"
ServiceEvent.ItemEquipRefine = "ServiceEvent_ItemEquipRefine"
ServiceEvent.ItemEquipDecompose = "ServiceEvent_ItemEquipDecompose"
ServiceEvent.ItemQueryEquipData = "ServiceEvent_ItemQueryEquipData"
ServiceEvent.ItemBrowsePackage = "ServiceEvent_ItemBrowsePackage"
ServiceEvent.ItemEquipCard = "ServiceEvent_ItemEquipCard"
ServiceEvent.ItemItemShow = "ServiceEvent_ItemItemShow"
ServiceEvent.ItemItemShow64 = "ServiceEvent_ItemItemShow64"
ServiceEvent.ItemEquipRepair = "ServiceEvent_ItemEquipRepair"
ServiceEvent.ItemHintNtf = "ServiceEvent_ItemHintNtf"
ServiceEvent.ItemEnchantEquip = "ServiceEvent_ItemEnchantEquip"
ServiceEvent.ItemEnchantRes = "ServiceEvent_ItemEnchantRes"
ServiceEvent.ItemProcessEnchantItemCmd = "ServiceEvent_ItemProcessEnchantItemCmd"
ServiceEvent.ItemEquipExchangeItemCmd = "ServiceEvent_ItemEquipExchangeItemCmd"
ServiceEvent.ItemOnOffStoreItemCmd = "ServiceEvent_ItemOnOffStoreItemCmd"
ServiceEvent.ItemPackSlotNtfItemCmd = "ServiceEvent_ItemPackSlotNtfItemCmd"
ServiceEvent.ItemRestoreEquipItemCmd = "ServiceEvent_ItemRestoreEquipItemCmd"
ServiceEvent.ItemUseCountItemCmd = "ServiceEvent_ItemUseCountItemCmd"
ServiceEvent.ItemExchangeCardItemCmd = "ServiceEvent_ItemExchangeCardItemCmd"
ServiceEvent.ItemGetCountItemCmd = "ServiceEvent_ItemGetCountItemCmd"
ServiceEvent.ItemSaveLoveLetterCmd = "ServiceEvent_ItemSaveLoveLetterCmd"
ServiceEvent.ItemItemDataShow = "ServiceEvent_ItemItemDataShow"
ServiceEvent.ItemLotteryCmd = "ServiceEvent_ItemLotteryCmd"
ServiceEvent.ItemLotteryRecoveryCmd = "ServiceEvent_ItemLotteryRecoveryCmd"
ServiceEvent.ItemQueryLotteryInfo = "ServiceEvent_ItemQueryLotteryInfo"
ServiceEvent.ItemReqQuotaLogCmd = "ServiceEvent_ItemReqQuotaLogCmd"
ServiceEvent.ItemReqQuotaDetailCmd = "ServiceEvent_ItemReqQuotaDetailCmd"
ServiceEvent.ItemEquipPosDataUpdate = "ServiceEvent_ItemEquipPosDataUpdate"
ServiceEvent.ItemHighRefineMatComposeCmd = "ServiceEvent_ItemHighRefineMatComposeCmd"
ServiceEvent.ItemHighRefineCmd = "ServiceEvent_ItemHighRefineCmd"
ServiceEvent.ItemNtfHighRefineDataCmd = "ServiceEvent_ItemNtfHighRefineDataCmd"
ServiceEvent.ItemUpdateHighRefineDataCmd = "ServiceEvent_ItemUpdateHighRefineDataCmd"
ServiceEvent.ItemUseCodItemCmd = "ServiceEvent_ItemUseCodItemCmd"
ServiceEvent.ItemAddJobLevelItemCmd = "ServiceEvent_ItemAddJobLevelItemCmd"
ServiceEvent.ItemLotterGivBuyCountCmd = "ServiceEvent_ItemLotterGivBuyCountCmd"
ServiceEvent.ItemGiveWeddingDressCmd = "ServiceEvent_ItemGiveWeddingDressCmd"
ServiceEvent.ItemQuickStoreItemCmd = "ServiceEvent_ItemQuickStoreItemCmd"
ServiceEvent.ItemQuickSellItemCmd = "ServiceEvent_ItemQuickSellItemCmd"
ServiceEvent.ItemEnchantTransItemCmd = "ServiceEvent_ItemEnchantTransItemCmd"
ServiceEvent.ItemQueryLotteryHeadItemCmd = "ServiceEvent_ItemQueryLotteryHeadItemCmd"
ServiceEvent.ItemLotteryRateQueryCmd = "ServiceEvent_ItemLotteryRateQueryCmd"
ServiceEvent.ItemEquipComposeItemCmd = "ServiceEvent_ItemEquipComposeItemCmd"
ServiceEvent.ItemQueryDebtItemCmd = "ServiceEvent_ItemQueryDebtItemCmd"
ServiceEvent.ItemLotteryActivityNtfCmd = "ServiceEvent_ItemLotteryActivityNtfCmd"
ServiceEvent.ItemFavoriteItemActionItemCmd = "ServiceEvent_ItemFavoriteItemActionItemCmd"
ServiceEvent.ItemQueryLotteryExtraBonusItemCmd = "ServiceEvent_ItemQueryLotteryExtraBonusItemCmd"
ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd = "ServiceEvent_ItemQueryLotteryExtraBonusCfgCmd"
ServiceEvent.ItemGetLotteryExtraBonusItemCmd = "ServiceEvent_ItemGetLotteryExtraBonusItemCmd"
ServiceEvent.ItemRollCatLitterBoxItemCmd = "ServiceEvent_ItemRollCatLitterBoxItemCmd"
ServiceEvent.ItemAlterFashionEquipBuffCmd = "ServiceEvent_ItemAlterFashionEquipBuffCmd"
ServiceEvent.ItemQueryRideLotteryInfo = "ServiceEvent_ItemQueryRideLotteryInfo"
ServiceEvent.ItemExecRideLotteryCmd = "ServiceEvent_ItemExecRideLotteryCmd"
ServiceEvent.ItemGemSkillAppraisalItemCmd = "ServiceEvent_ItemGemSkillAppraisalItemCmd"
ServiceEvent.ItemGemSkillComposeSameItemCmd = "ServiceEvent_ItemGemSkillComposeSameItemCmd"
ServiceEvent.ItemGemSkillComposeQualityItemCmd = "ServiceEvent_ItemGemSkillComposeQualityItemCmd"
ServiceEvent.ItemGemAttrComposeItemCmd = "ServiceEvent_ItemGemAttrComposeItemCmd"
ServiceEvent.ItemGemAttrUpgradeItemCmd = "ServiceEvent_ItemGemAttrUpgradeItemCmd"
ServiceEvent.ItemGemMountItemCmd = "ServiceEvent_ItemGemMountItemCmd"
ServiceEvent.ItemGemUnmountItemCmd = "ServiceEvent_ItemGemUnmountItemCmd"
ServiceEvent.ItemGemCarveItemCmd = "ServiceEvent_ItemGemCarveItemCmd"
ServiceEvent.ItemGemSmeltItemCmd = "ServiceEvent_ItemGemSmeltItemCmd"
ServiceEvent.ItemRideLotteyPickItemCmd = "ServiceEvent_ItemRideLotteyPickItemCmd"
ServiceEvent.ItemRideLotteyPickInfoCmd = "ServiceEvent_ItemRideLotteyPickInfoCmd"
ServiceEvent.ItemSandExchangeItemCmd = "ServiceEvent_ItemSandExchangeItemCmd"
ServiceEvent.ItemGemDataUpdateItemCmd = "ServiceEvent_ItemGemDataUpdateItemCmd"
ServiceEvent.ItemLotteryDollQueryItemCmd = "ServiceEvent_ItemLotteryDollQueryItemCmd"
ServiceEvent.ItemLotteryDollPayItemCmd = "ServiceEvent_ItemLotteryDollPayItemCmd"
ServiceEvent.ItemPersonalArtifactExchangeItemCmd = "ServiceEvent_ItemPersonalArtifactExchangeItemCmd"
ServiceEvent.ItemPersonalArtifactDecomposeItemCmd = "ServiceEvent_ItemPersonalArtifactDecomposeItemCmd"
ServiceEvent.ItemPersonalArtifactComposeItemCmd = "ServiceEvent_ItemPersonalArtifactComposeItemCmd"
ServiceEvent.ItemPersonalArtifactRemouldItemCmd = "ServiceEvent_ItemPersonalArtifactRemouldItemCmd"
ServiceEvent.ItemPersonalArtifactAttrSaveItemCmd = "ServiceEvent_ItemPersonalArtifactAttrSaveItemCmd"
ServiceEvent.ItemPersonalArtifactAppraisalItemCmd = "ServiceEvent_ItemPersonalArtifactAppraisalItemCmd"
ServiceEvent.ItemEquipPosCDNtfItemCmd = "ServiceEvent_ItemEquipPosCDNtfItemCmd"
ServiceEvent.ItemBatchRefineItemCmd = "ServiceEvent_ItemBatchRefineItemCmd"
ServiceEvent.ItemMixLotteryArchiveCmd = "ServiceEvent_ItemMixLotteryArchiveCmd"
ServiceEvent.ItemQueryPackMailItemCmd = "ServiceEvent_ItemQueryPackMailItemCmd"
ServiceEvent.ItemPackMailUpdateItemCmd = "ServiceEvent_ItemPackMailUpdateItemCmd"
ServiceEvent.ItemPackMailActionItemCmd = "ServiceEvent_ItemPackMailActionItemCmd"
ServiceEvent.ItemFavoriteQueryItemCmd = "ServiceEvent_ItemFavoriteQueryItemCmd"
ServiceEvent.ItemFavoriteGiveItemCmd = "ServiceEvent_ItemFavoriteGiveItemCmd"
ServiceEvent.ItemFavoriteRewardItemCmd = "ServiceEvent_ItemFavoriteRewardItemCmd"
ServiceEvent.ItemFavoriteInteractItemCmd = "ServiceEvent_ItemFavoriteInteractItemCmd"
ServiceEvent.ItemFavoriteDesireConditionItemCmd = "ServiceEvent_ItemFavoriteDesireConditionItemCmd"
ServiceEvent.ItemEquipEnchantTransferItemCmd = "ServiceEvent_ItemEquipEnchantTransferItemCmd"
ServiceEvent.ItemEquipRefineTransferItemCmd = "ServiceEvent_ItemEquipRefineTransferItemCmd"
ServiceEvent.ItemEquipPowerInputItemCmd = "ServiceEvent_ItemEquipPowerInputItemCmd"
ServiceEvent.ItemEquipPowerOutputItemCmd = "ServiceEvent_ItemEquipPowerOutputItemCmd"
ServiceEvent.ItemColoringQueryItemCmd = "ServiceEvent_ItemColoringQueryItemCmd"
ServiceEvent.ItemColoringModifyItemCmd = "ServiceEvent_ItemColoringModifyItemCmd"
ServiceEvent.ItemColoringShareItemCmd = "ServiceEvent_ItemColoringShareItemCmd"
ServiceEvent.ItemPosStrengthItemCmd = "ServiceEvent_ItemPosStrengthItemCmd"
ServiceEvent.ItemLotteryHeadwearExchange = "ServiceEvent_ItemLotteryHeadwearExchange"
ServiceEvent.ItemRandSelectRewardItemCmd = "ServiceEvent_ItemRandSelectRewardItemCmd"
ServiceEvent.ItemEquipRecoveryQueryItemCmd = "ServiceEvent_ItemEquipRecoveryQueryItemCmd"
ServiceEvent.ItemEquipRecoveryItemCmd = "ServiceEvent_ItemEquipRecoveryItemCmd"
ServiceEvent.ItemOneClickPutTakeStoreCmd = "ServiceEvent_ItemOneClickPutTakeStoreCmd"
ServiceEvent.ItemQuestionResultItemCmd = "ServiceEvent_ItemQuestionResultItemCmd"
ServiceEvent.ItemPosStrengthSyncItemCmd = "ServiceEvent_ItemPosStrengthSyncItemCmd"
ServiceEvent.ItemEquipPowerQuery = "ServiceEvent_ItemEquipPowerQuery"
ServiceEvent.ItemMagicSuitSave = "ServiceEvent_ItemMagicSuitSave"
ServiceEvent.ItemMagicSuitNtf = "ServiceEvent_ItemMagicSuitNtf"
ServiceEvent.ItemMagicSuitApply = "ServiceEvent_ItemMagicSuitApply"
ServiceEvent.ItemPotionStoreNtf = "ServiceEvent_ItemPotionStoreNtf"
ServiceEvent.ItemEnchantHighestBuffNotify = "ServiceEvent_ItemEnchantHighestBuffNotify"
ServiceEvent.ItemLotteryDataSyncItemCmd = "ServiceEvent_ItemLotteryDataSyncItemCmd"
ServiceEvent.ItemArtifactFlagmentAdd = "ServiceEvent_ItemArtifactFlagmentAdd"
ServiceEvent.ItemLotteryDailyRewardSyncItemCmd = "ServiceEvent_ItemLotteryDailyRewardSyncItemCmd"
ServiceEvent.ItemLotteryDailyRewardGetItemCmd = "ServiceEvent_ItemLotteryDailyRewardGetItemCmd"
ServiceEvent.ItemAutoSellItemCmd = "ServiceEvent_ItemAutoSellItemCmd"
ServiceEvent.ItemQueryAfricanPoringItemCmd = "ServiceEvent_ItemQueryAfricanPoringItemCmd"
ServiceEvent.ItemAfricanPoringUpdateItemCmd = "ServiceEvent_ItemAfricanPoringUpdateItemCmd"
ServiceEvent.ItemAfricanPoringLotteryItemCmd = "ServiceEvent_ItemAfricanPoringLotteryItemCmd"
ServiceEvent.ItemExtractLevelUpItemCmd = "ServiceEvent_ItemExtractLevelUpItemCmd"
ServiceEvent.ItemEnchantRefreshAttr = "ServiceEvent_ItemEnchantRefreshAttr"
ServiceEvent.ItemProcessEnchantRefreshAttr = "ServiceEvent_ItemProcessEnchantRefreshAttr"
ServiceEvent.ItemEnchantUpgradeAttr = "ServiceEvent_ItemEnchantUpgradeAttr"
ServiceEvent.ItemRefreshEquipAttrCmd = "ServiceEvent_ItemRefreshEquipAttrCmd"
ServiceEvent.ItemQuenchEquipItemCmd = "ServiceEvent_ItemQuenchEquipItemCmd"
ServiceEvent.ItemMountFashionSyncCmd = "ServiceEvent_ItemMountFashionSyncCmd"
ServiceEvent.ItemMountFashionChangeCmd = "ServiceEvent_ItemMountFashionChangeCmd"
ServiceEvent.ItemEquipPromote = "ServiceEvent_ItemEquipPromote"
ServiceEvent.ItemSwitchFashionEquipRecordItemCmd = "ServiceEvent_ItemSwitchFashionEquipRecordItemCmd"
ServiceEvent.ItemOldItemExchangeItemCmd = "ServiceEvent_ItemOldItemExchangeItemCmd"
ServiceEvent.ItemBuyMixLotteryItemCmd = "ServiceEvent_ItemBuyMixLotteryItemCmd"
ServiceEvent.ItemCardLotteryPrayItemCmd = "ServiceEvent_ItemCardLotteryPrayItemCmd"
ServiceEvent.ItemSyncCardLotteryPrayItemCmd = "ServiceEvent_ItemSyncCardLotteryPrayItemCmd"
ServiceEvent.ItemGemBagExpSyncItemCmd = "ServiceEvent_ItemGemBagExpSyncItemCmd"
ServiceEvent.ItemSecretLandGemCmd = "ServiceEvent_ItemSecretLandGemCmd"
ServiceEvent.ItemMountFashionQueryStateCmd = "ServiceEvent_ItemMountFashionQueryStateCmd"
ServiceEvent.ItemMountFashionActiveCmd = "ServiceEvent_ItemMountFashionActiveCmd"
ServiceEvent.ItemStorePutItemItemCmd = "ServiceEvent_ItemStorePutItemItemCmd"
ServiceEvent.ItemStoreOffItemItemCmd = "ServiceEvent_ItemStoreOffItemItemCmd"
ServiceEvent.ItemFullGemSkill = "ServiceEvent_ItemFullGemSkill"
ServiceEvent.ItemQueryBossCardComposeRateCmd = "ServiceEvent_ItemQueryBossCardComposeRateCmd"
ServiceEvent.ItemMemoryEmbedItemCmd = "ServiceEvent_ItemMemoryEmbedItemCmd"
ServiceEvent.ItemMemoryUnEmbedItemCmd = "ServiceEvent_ItemMemoryUnEmbedItemCmd"
ServiceEvent.ItemMemoryLevelupItemCmd = "ServiceEvent_ItemMemoryLevelupItemCmd"
ServiceEvent.ItemMemoryDecomposeItemCmd = "ServiceEvent_ItemMemoryDecomposeItemCmd"
ServiceEvent.ItemMemoryEffectOperItemCmd = "ServiceEvent_ItemMemoryEffectOperItemCmd"
ServiceEvent.ItemMemoryAutoDecomposeOptionItemCmd = "ServiceEvent_ItemMemoryAutoDecomposeOptionItemCmd"
ServiceEvent.ItemUpdateMemoryPosItemCmd = "ServiceEvent_ItemUpdateMemoryPosItemCmd"
ServiceEvent.ItemDecomposeGemItemCmd = "ServiceEvent_ItemDecomposeGemItemCmd"
ServiceEvent.ItemUpgradeGemItemCmd = "ServiceEvent_ItemUpgradeGemItemCmd"
ServiceEvent.ItemMemoryUpgradeItemCmd = "ServiceEvent_ItemMemoryUpgradeItemCmd"
ServiceEvent.ItemCardLevelupItemCmd = "ServiceEvent_ItemCardLevelupItemCmd"
ServiceEvent.ItemBalanceModeMemorySetItemCmd = "ServiceEvent_ItemBalanceModeMemorySetItemCmd"
ServiceEvent.ItemBalanceModeMemoryUpdateItemCmd = "ServiceEvent_ItemBalanceModeMemoryUpdateItemCmd"
