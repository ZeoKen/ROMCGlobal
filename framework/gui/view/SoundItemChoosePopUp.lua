autoImport("SoundItemCell")
autoImport("HappyShopBuyItemCell")
SoundItemChoosePopUp = class("SoundItemChoosePopUp", BaseView)
SoundItemChoosePopUp.ViewType = UIViewType.PopUpLayer
local soundItemId = "SoundItem"

function SoundItemChoosePopUp:Init()
  self:InitData()
  self:InitUI()
  self:AddListenEvts()
end

function SoundItemChoosePopUp:InitData()
  self.npc = self.viewdata.viewdata.npc
  if not self.npc then
    self.furniture = self.viewdata.viewdata.furniture
  end
end

function SoundItemChoosePopUp:InitUI()
  self.soundItemCtl = UIGridListCtrl.new(self:FindComponent("SoundListGrid", UIGrid), SoundItemCell, "SoundItemCell")
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Play, self.OnClickPlay, self)
  self.soundItemCtl:AddEventListener(SoundItemCellEvent.Buy, self.OnClickPlay, self)
  self:UpdateSoundItems()
end

function SoundItemChoosePopUp:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateSoundItems)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
end

local comparer = function(a, b)
  local hasA = a.id ~= soundItemId
  local hasB = b.id ~= soundItemId
  if hasA ~= hasB then
    return hasA
  end
  return a.staticData.id < b.staticData.id
end

function SoundItemChoosePopUp:UpdateSoundItems()
  local soundItems, bagIns = ReusableTable.CreateArray(), BagProxy.Instance
  for _, mdata in pairs(Table_MusicBox) do
    local item = bagIns:GetItemByStaticID(mdata.id)
    if not item and mdata.SaleChannel ~= 0 then
      item = ItemData.new(soundItemId, mdata.id)
    end
    table.insert(soundItems, item)
  end
  table.sort(soundItems, comparer)
  self.soundItemCtl:ResetDatas(soundItems)
  ReusableTable.DestroyAndClearArray(soundItems)
end

function SoundItemChoosePopUp:OnClickPlay(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  if self:GetRemainingMusicCountOfList() <= 0 then
    MsgManager.ShowMsgByID(42086)
    return
  end
  self:DoPlay(data.staticData.id, 1, self.npc and self.npc.data.id, self.furniture and self.furniture.data.id, data.num == 0)
end

function SoundItemChoosePopUp:DoPlay(musicId, count, npcId, furnitureId, checkRob)
  if not musicId or not Table_Item[musicId] then
    return
  end
  count = count or 1
  local remainingCount = self:GetRemainingMusicCountOfList()
  if count > remainingCount then
    MsgManager.ShowMsgByID(42086)
    return
  end
  local MusicCost = GameConfig.Music.cost and GameConfig.Music.cost[2] or 10000
  if checkRob and MyselfProxy.Instance:GetROB() < MusicCost * count then
    MsgManager.ShowMsgByID(40803)
    return
  end
  for i = 1, count do
    if npcId then
      ServiceNUserProxy.Instance:CallDemandMusic(npcId, musicId)
    elseif furnitureId then
      ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_RADIO_DEMAND, furnitureId, musicId)
    end
  end
  AudioUtil.Play2DRandomSound(AudioMap.Maps.PlayMusic)
end

function SoundItemChoosePopUp:GetRemainingMusicCountOfList()
  local list
  if self.npc then
    list = ServiceNUserProxy.Instance.musicList
  elseif self.furniture then
    list = HomeProxy.Instance.curSoundList
  end
  return GameConfig.Music.max_music_count - (list and #list or 0)
end
