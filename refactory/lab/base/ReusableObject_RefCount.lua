local Assert_ = function(condition, msg)
  return assert(condition, msg)
end
ReusableObject_RefCount = class("ReusableObject_RefCount", ReusableObject)

function ReusableObject_RefCount:ctor()
  ReusableObject_RefCount.super.ctor(self)
  self.ref = 0
end

function ReusableObject_RefCount:Construct(asArray, args)
  Assert_(0 == self.ref, "ref count is not zero")
  self.ref = 1
  ReusableObject_RefCount.super.Construct(self, asArray, args)
end

function ReusableObject_RefCount:RefRetain()
  Assert_(0 < self.ref, "ref count is not valid")
  self.ref = self.ref + 1
end

function ReusableObject_RefCount:RefRelease()
  Assert_(0 < self.ref, "ref count is not valid")
  self.ref = self.ref - 1
  if 0 == self.ref then
    self:Destroy()
  end
end
