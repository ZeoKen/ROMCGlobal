autoImport("MaidRaidRatingCell")
MaidDungeonRate = class("MaidDungeonRate", SubView)
local raidConfig = GameConfig.JanuaryRaid
local ratinglist = raidConfig.kill_rank_desc

function MaidDungeonRate:Init()
  self:InitUI()
  self:SetRating()
  self:AddListen()
end

function MaidDungeonRate:InitUI()
  self.rategrid = self:FindGO("rateGrid"):GetComponent(UIGrid)
  self.rateCtl = UIGridListCtrl.new(self.rategrid, MaidRaidRatingCell, "RatingCell")
  local headCellObj = self:FindGO("playercontainer")
  headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj)
  headCellObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
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
  self.myrate = self:FindGO("myrate")
  self.mymedal = self:FindGO("mymedal"):GetComponent(UIMultiSprite)
  self.mytitle = self:FindGO("mytitle"):GetComponent(UILabel)
  self.titlebg = self:FindGO("titlebg"):GetComponent(UISprite)
  self.rate = self:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end

function MaidDungeonRate:SetRating()
  self.rateCtl:ResetDatas(ratinglist)
  self.rate = self:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end

function MaidDungeonRate:GetMyRate()
  local myscore = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_JANUARY_SCORE) or 0
  for i = 1, #ratinglist do
    local single = ratinglist[i]
    if myscore >= single.score then
      return single.id
    end
  end
  return 0
end

function MaidDungeonRate:AddListen()
  self:AddListenEvt(ServiceEvent.NUserAltmanRewardUserCmd, self.SetRating)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.SetRating)
end

function MaidDungeonRate:OnExit()
  self.super.OnExit(self)
end
