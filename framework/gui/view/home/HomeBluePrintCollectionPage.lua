autoImport("BlueprintRecommendCell")
HomeBluePrintCollectionPage = class("HomeBluePrintCollectionPage", SubView)

function HomeBluePrintCollectionPage:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function HomeBluePrintCollectionPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.OnPrintUpdateHomeCmd)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
end

function HomeBluePrintCollectionPage:OnPrintUpdateHomeCmd(note)
  local data = note and note.body
  if not data then
    return
  end
  local action = data.action
  if action == HomeCmd_pb.EPRINTACTION_QUERY_SELF_COLLECTION or action == HomeCmd_pb.EPRINTACTION_PRAISE or action == HomeCmd_pb.EPRINTACTION_UNPRAISE or action == HomeCmd_pb.EPRINTACTION_COLLECT_IN or action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
    self:RefreshView()
  end
end

function HomeBluePrintCollectionPage:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data or data.type ~= FunctionPhotoStorage.PhotoType.HomeBlueprint or not data.isThumb then
    return
  end
  local photoId = data.index
  local cells = self.bpCollectionList:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    local cellData = cell and cell.data
    if cellData and not cellData.isOfficial and cellData.photoId == photoId and cellData:GetPhotoKey() == data.customParam then
      if data.byte then
        cell:SetPhoto(data.byte)
        break
      end
      cell:ClearPhoto()
      LogUtility.Error(string.format("[HomeBluePrintCollectionPage] Download failed: %s", tostring(data.error)))
      break
    end
  end
end

function HomeBluePrintCollectionPage:FindObjs()
  self.gameObject = self:FindGO("CollectionPage")
  local grid = self:FindComponent("Grid", UIGrid)
  self.bpCollectionList = UIGridListCtrl.new(grid, BlueprintRecommendCell, "BlueprintRecommendCell")
  self.bpCollectionList:AddEventListener(MouseEvent.MouseClick, self.OnBpCollectionClick, self)
end

function HomeBluePrintCollectionPage:OnSwitch(isShow)
  if isShow then
    self:RefreshView()
  end
end

function HomeBluePrintCollectionPage:RefreshView()
  local curHouseType = self.container:GetCurrentContextHouseType()
  local collectionList = HomeBlueprintProxy.Instance:GetCollectionList(curHouseType)
  for _, item in ipairs(collectionList) do
    item.cellMode = "collection"
  end
  self.bpCollectionList:ResetDatas(collectionList)
  self.container.emptyTip.text = #collectionList == 0 and ZhString.HomeBluePrint_Collection_EmptyTip or ""
end

function HomeBluePrintCollectionPage:OnBpCollectionClick(cell)
  if not cell or not cell.data then
    return
  end
  self.container:ApplyBlueprintFromCell(cell.data)
end
