BTAnimatorAction = class("BTAnimatorAction", BTAction)
local ArrayClear = TableUtility.ArrayClear

function BTAnimatorAction:ctor(config)
  BTAnimatorAction.super.ctor(self, config)
  self.tag = config.tag
  self.id = config.id
  self.allAnimators = config.allAnimators
  self.animators = nil
end

function BTAnimatorAction:Dispose()
  BTAnimatorAction.super.Dispose(self)
  if self.animators then
    ArrayClear(self.animators)
    self.animators = nil
  end
end

function BTAnimatorAction:ValidateAnimators(context, filter)
  if self.animators == nil then
    local obj = BTDefine.GetTarget(self.tag, self.id, context)
    if obj == nil or LuaGameObject.ObjectIsNull(obj) then
      self.enabled = false
      redlog("[bt] object become nil", self.id)
      return
    end
    if self.allAnimators then
      local animators = obj:GetComponentsInChildren(Animator)
      if filter then
        self.animators = {}
        for i, v in ipairs(animators) do
          if filter(v) then
            table.insert(self.animators, v)
          end
        end
      else
        self.animators = animators
      end
    else
      local animator = obj:GetComponentInChildren(Animator)
      if animator then
        self.animators = {animator}
      end
    end
    if self.animators == nil or self.animators[1] == nil then
      redlog("[bt] no animator found", self.id)
      self.enabled = false
    end
  end
  return self.enabled
end
