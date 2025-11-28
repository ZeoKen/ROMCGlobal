ActivityDungeonRate = class("ActivityDungeonRate", SubView)
local raidTypeRatingClassMap = {
  Kumamoto = "KumamotoRatingCell",
  MaidRaid = "KumamotoRatingCell"
}
local ratinglist

function ActivityDungeonRate:Init()
  self:InitUI()
  self:SetRating()
  self:AddListen()
end

function ActivityDungeonRate:InitUI()
  self.raidType = self.container.raidType
  self.rategrid = self:FindGO("rateGrid"):GetComponent(UIGrid)
  local ratingClassName = raidTypeRatingClassMap[self.raidType] or "RatingCell"
  autoImport(ratingClassName)
  self.rateCtl = UIGridListCtrl.new(self.rategrid, _G[ratingClassName], "RatingCell")
  local headCellObj = self:FindGO("playercontainer")
  headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj)
  headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
  self.targetCell = PlayerFaceCell.new(headCellObj)
  self.targetCell:HideLevel()
  self.targetCell:HideHpMp()
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  self.targetCell:SetData(headData)
  local playername = self:FindGO("playername"):GetComponent(UILabel)
  playername.text = Game.Myself.data:GetName()
  local playerlv = self:FindGO("playerlv"):GetComponent(UILabel)
  playerlv.text = "LV." .. Game.Myself.data:GetBaseLv()
  timeRank = self.container.raidConfig.time_rank_desc
  killRank = self.container.raidConfig.kill_rank_desc
  if not timeRank and not killRank then
    LogUtility.Warning("Cannot find time_rank_desc. If the raid type is EvaRaid or Kumamoto or Slayers, you'd find out what's wrong.")
    return
  end
  ratinglist = timeRank or killRank
  self.myrate = self:FindGO("myrate")
  self.mymedal = self:FindGO("mymedal"):GetComponent(UIMultiSprite)
  self.mytitle = self:FindGO("mytitle"):GetComponent(UILabel)
  self.titlebg = self:FindGO("titlebg"):GetComponent(UISprite)
  self.rate = DungeonProxy.Instance:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end

function ActivityDungeonRate:SetRating()
  if not ratinglist then
    return
  end
  self.rateCtl:ResetDatas(ratinglist)
  self.rate = self:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end

function ActivityDungeonRate:GetMyRate()
  if self.raidType == "Kumamoto" or self.raidType == "MaidRaid" then
    local myscore = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_SCORE) or 0
    for i = 1, #ratinglist do
      local single = ratinglist[i]
      if myscore >= single.score then
        return single.id
      end
    end
    return 0
  else
    return DungeonProxy.Instance:GetMyRate()
  end
end

function ActivityDungeonRate:AddListen()
  self:AddListenEvt(ServiceEvent.NUserAltmanRewardUserCmd, self.SetRating)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.SetRating)
end

function ActivityDungeonRate:OnExit()
  ActivityDungeonRate.super.OnExit(self)
end
