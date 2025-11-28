local GameFlowRoot_sc_mvp3 = {
  btRoots = {
    [1] = {
      gid = 1,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 180,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 1,
          center = {
            0,
            0,
            0
          },
          radius = 15,
          worldToLocalMatrix = {
            {
              1,
              0,
              0,
              8.36
            },
            {
              0,
              1,
              0,
              -21.27
            },
            {
              0,
              0,
              1,
              -49.82
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320110,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 11
            }
          }
        }
      }
    },
    [2] = {
      gid = 2,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.04496309,
              0,
              0.08932144,
              4.146582
            },
            {
              0,
              0.2,
              0,
              -3.62
            },
            {
              -0.1786429,
              0,
              0.08992618,
              -13.56129
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320130,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 12
            }
          }
        }
      }
    },
    [3] = {
      gid = 3,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.142391,
              0,
              -0.01153155,
              4.072427
            },
            {
              0,
              0.2,
              0,
              -3.24
            },
            {
              0.01614417,
              0,
              0.1993474,
              18.64707
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 8,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 10,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320140,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 12,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 13
            }
          }
        }
      }
    },
    [4] = {
      gid = 4,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.2196001,
              0,
              -0.1194814,
              -9.248098
            },
            {
              0,
              0.2,
              0,
              -3.63
            },
            {
              0.06827506,
              0,
              0.1254858,
              5.584891
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320150,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 14
            }
          }
        }
      }
    },
    [5] = {
      gid = 5,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.1,
              0,
              0,
              -4.334
            },
            {
              0,
              1,
              0,
              -26.42
            },
            {
              0,
              0,
              0.05,
              -0.549
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320120,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 15
            }
          }
        }
      }
    },
    [6] = {
      gid = 6,
      nid = 4,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 6,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 1,
          center = {
            0,
            0,
            0
          },
          radius = 15,
          worldToLocalMatrix = {
            {
              1,
              0,
              0,
              7.91
            },
            {
              0,
              1,
              0,
              -20.67
            },
            {
              0,
              0,
              1,
              -50.27
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 8,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 10,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 9,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 12,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 100,
              msgtype = 2,
              msgid = 43201,
              visible = true
            }
          }
        },
        [2] = {
          nid = 14,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 16,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 10,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 18,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 100,
              msgtype = 2,
              msgid = 43201,
              visible = false
            }
          }
        }
      }
    },
    [7] = {
      gid = 7,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 2,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 1,
          center = {
            0,
            0,
            0
          },
          radius = 16,
          worldToLocalMatrix = {
            {
              1,
              0,
              0,
              41.3
            },
            {
              0,
              1,
              0,
              -17.62
            },
            {
              0,
              0,
              1,
              109.03
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 3,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 4,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 2,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 103,
              msgtype = 1,
              msgid = 43216,
              visible = true
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 7,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 10,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 8,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 103,
              msgtype = 1,
              msgid = 43216,
              visible = false
            }
          }
        }
      }
    }
  }
}
return GameFlowRoot_sc_mvp3
