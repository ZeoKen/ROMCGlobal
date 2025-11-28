TimeStamp = class("TimeStamp", ReusableObject_RefCount)

function TimeStamp.Create()
  return ReusableObject.Create(TimeStamp, true)
end

function TimeStamp:DoConstruct(asArray)
  self.time = UnityTime
  self.unscaledTime = UnityUnscaledTime
  self.frameCount = UnityFrameCount
end

function TimeStamp:DoDeconstruct(asArray, args)
end
