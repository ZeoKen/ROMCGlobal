local GameFlow_sample = {
  btRoots = {
    [1] = {
      basetype = "Composite",
      type = "ConditionalSelector",
      alwaysExec = false,
      service = {
        basetype = "Service",
        type = "PlayerTrigger",
        groupRange = 1.5,
        collectHandInHand = 1,
        collider = {
          basetype = "Collider",
          type = 1,
          center = {
            -23.883,
            129.8102,
            6.000748
          },
          extents = {
            5,
            5,
            5
          }
        }
      },
      preCondition = {
        basetype = "Decorator",
        type = "SelectCondition",
        children = {
          [1] = {
            basetype = "Decorator",
            type = "CompareBB",
            serviceKey = "PlayerTrigger",
            bbKey = 4,
            val = 0,
            op = 2
          },
          [2] = {
            basetype = "Decorator",
            type = "CompareBB",
            serviceKey = "PlayerTrigger",
            bbKey = 1,
            val = 0,
            op = 2
          }
        }
      },
      children = {
        [1] = {
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = "ObjectFinder",
          id = 1,
          allAnimators = true,
          paramName = "state",
          paramVal = 2
        },
        [2] = {
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = "ObjectFinder",
          id = 1,
          allAnimators = true,
          paramName = "state",
          paramVal = 1
        },
        [3] = {
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = "ObjectFinder",
          id = 1,
          allAnimators = true,
          paramName = "state",
          paramVal = 0
        }
      }
    }
  }
}
return GameFlow_sample
