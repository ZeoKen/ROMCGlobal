NFollowNpc = reusableClass("NFollowNpc", NNpc)

function NFollowNpc:DoConstruct(asArray, data)
  redlog("NFollowNpc:DoConstruct")
  NFollowNpc.super.DoConstruct(self, asArray, data)
  if self.ai then
    self.ai:Deconstruct(self)
  end
  self.ai = AI_CreatureFollowNpc.new()
  self.ai:Construct(self)
end
