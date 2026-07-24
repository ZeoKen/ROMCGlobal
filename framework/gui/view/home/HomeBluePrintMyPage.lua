autoImport("BlueprintRecommendCell")
HomeBluePrintMyPage = class("HomeBluePrintMyPage", SubView)

function HomeBluePrintMyPage:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function HomeBluePrintMyPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.OnPrintUpdateHomeCmd)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
end

function HomeBluePrintMyPage:OnPrintUpdateHomeCmd(note)
  local data = note and note.body
  if not data then
    return
  end
  local action = data.action
  if action == HomeCmd_pb.EPRINTACTION_QUERY_SELF or action == HomeCmd_pb.EPRINTACTION_PRAISE or action == HomeCmd_pb.EPRINTACTION_UNPRAISE or action == HomeCmd_pb.EPRINTACTION_SAVE or action == HomeCmd_pb.EPRINTACTION_DELETE then
    self:RefreshView()
  end
end

function HomeBluePrintMyPage:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data or data.type ~= FunctionPhotoStorage.PhotoType.HomeBlueprint or not data.isThumb then
    return
  end
  local photoId = data.index
  local cells = self.bpMyList:GetCells()
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
      LogUtility.Error(string.format("[HomeBluePrintMyPage] Download failed: %s", tostring(data.error)))
      break
    end
  end
end

function HomeBluePrintMyPage:FindObjs()
  self.gameObject = self:FindGO("MyBpPage")
  local grid = self:FindComponent("Grid", UIGrid)
  self.bpMyList = UIGridListCtrl.new(grid, BlueprintRecommendCell, "BlueprintRecommendCell")
  self.bpMyList:AddEventListener(MouseEvent.MouseClick, self.OnBpMyClick, self)
end

function HomeBluePrintMyPage:OnSwitch(isShow)
  if isShow then
    self:RefreshView()
  end
end

function HomeBluePrintMyPage:RefreshView()
  local myList = HomeBlueprintProxy.Instance:GetMyList()
  for _, item in ipairs(myList) do
    item.cellMode = "my"
  end
  self.bpMyList:ResetDatas(myList)
  self.container.emptyTip.text = #myList == 0 and ZhString.HomeBluePrint_My_EmptyTip or ""
end

function HomeBluePrintMyPage:OnBpMyClick(cell)
  if not cell or not cell.data then
    return
  end
  self.container:ApplyBlueprintFromCell(cell.data)
end
