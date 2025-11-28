local GameFlowRoot_water_date2 = {
  btRoots = {
    [1] = {
      gid = 1,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 2,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 3,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1028785,
                  0,
                  -0.05232266,
                  3.0348
                },
                {
                  0,
                  0.1902355,
                  0,
                  -24.47571
                },
                {
                  0.179653,
                  0,
                  0.3532397,
                  15.19655
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
          [2] = {
            nid = 4,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 101
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
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 16,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 18,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 7,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 9,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [2] = {
      gid = 2,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.101971,
                  0,
                  -0.05182717,
                  2.996242
                },
                {
                  0,
                  0.1939091,
                  0,
                  -25.0079
                },
                {
                  0.1629333,
                  0,
                  0.3205745,
                  12.93591
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 102
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [3] = {
      gid = 3,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1098766,
                  0,
                  -0.03157951,
                  3.690808
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.1260467,
                  0,
                  0.2933536,
                  10.03589
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 103
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [4] = {
      gid = 4,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1125617,
                  0,
                  -0.02444921,
                  3.991641
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.09758672,
                  0,
                  0.3005222,
                  8.227252
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 104
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [5] = {
      gid = 5,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1125617,
                  0,
                  -0.02444921,
                  3.979409
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.09758672,
                  0,
                  0.3005222,
                  7.488921
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 105
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [6] = {
      gid = 6,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1125617,
                  0,
                  -0.02444921,
                  3.965574
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.09758672,
                  0,
                  0.3005222,
                  6.666595
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 106
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
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
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 3,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1075964,
                  0,
                  -0.04176912,
                  3.516079
                },
                {
                  0,
                  0.1902355,
                  0,
                  -24.47571
                },
                {
                  0.1269063,
                  0,
                  0.3269081,
                  7.220429
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
          [2] = {
            nid = 4,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 107
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
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 16,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 18,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 7,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 9,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [8] = {
      gid = 8,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1130676,
                  0,
                  -0.01731671,
                  2.978638
                },
                {
                  0,
                  0.1939091,
                  0,
                  -25.0079
                },
                {
                  0.05443994,
                  0,
                  0.3554596,
                  0.2372658
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 108
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [9] = {
      gid = 9,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1161119,
                  0,
                  -0.007397378,
                  3.058699
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.03318341,
                  0,
                  0.3484016,
                  -0.9011869
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 109
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [10] = {
      gid = 10,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1164379,
                  0,
                  0.002001326,
                  3.021206
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  -0.008527647,
                  0,
                  0.3318686,
                  -2.791931
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 110
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [11] = {
      gid = 11,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1164432,
                  0,
                  -0.001786369,
                  3.130042
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  0.007130123,
                  0,
                  0.3108852,
                  -3.060412
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 111
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [12] = {
      gid = 12,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1162657,
                  0,
                  0.005551338,
                  3.034171
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  -0.02429779,
                  0,
                  0.3403932,
                  -5.020076
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 112
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [13] = {
      gid = 13,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 5,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
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
                  0.1162657,
                  0,
                  0.005551338,
                  3.03728
                },
                {
                  0,
                  0.2407186,
                  0,
                  -31.1495
                },
                {
                  -0.02429779,
                  0,
                  0.3403932,
                  -5.830903
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
          [2] = {
            nid = 6,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 113
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
              nid = 9,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state3001"
            }
          }
        },
        [2] = {
          nid = 11,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 12,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "state2001"
            }
          }
        },
        [3] = {
          nid = 7,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "state1001"
        }
      }
    },
    [14] = {
      gid = 14,
      nid = 6,
      basetype = "Composite",
      type = "Parallel",
      service = {
        nid = 8,
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
          radius = 0.5,
          worldToLocalMatrix = {
            {
              0.6404371,
              0,
              0,
              21.00634
            },
            {
              0,
              0.5578079,
              0,
              -70.7691
            },
            {
              0,
              0,
              0.5578079,
              19.51212
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
          nid = 2,
          basetype = "Action",
          type = "UseSkill",
          skillId = 20102001,
          preCondition = {
            nid = 14,
            basetype = "Decorator",
            type = "CompareBB",
            serviceKey = "PlayerTriggerCollector",
            bbKey = 9,
            val = 0,
            op = 2
          }
        }
      }
    },
    [15] = {
      gid = 15,
      nid = 34,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 35,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 36,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.1985157,
                  0,
                  0,
                  6.50139
                },
                {
                  0,
                  0.1985157,
                  0,
                  -25.13805
                },
                {
                  0,
                  0,
                  0.1985157,
                  6.944081
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
          [2] = {
            nid = 37,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 5
          }
        }
      },
      children = {
        [1] = {
          nid = 38,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 39,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state3001"
            }
          }
        },
        [2] = {
          nid = 41,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 42,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 6,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state2001"
            }
          }
        },
        [3] = {
          nid = 8,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "mfx_water_date2_fengliu_state1001"
        }
      }
    },
    [16] = {
      gid = 16,
      nid = 6,
      basetype = "Composite",
      type = "Parallel",
      service = {
        nid = 8,
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
          radius = 0.5,
          worldToLocalMatrix = {
            {
              0.6404371,
              0,
              0,
              18.21403
            },
            {
              0,
              0.5578079,
              0,
              -69.80408
            },
            {
              0,
              0,
              0.5578079,
              18.50807
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
          nid = 2,
          basetype = "Action",
          type = "UseSkill",
          skillId = 20102001,
          preCondition = {
            nid = 14,
            basetype = "Decorator",
            type = "CompareBB",
            serviceKey = "PlayerTriggerCollector",
            bbKey = 9,
            val = 0,
            op = 2
          }
        }
      }
    },
    [17] = {
      gid = 17,
      nid = 34,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 35,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 36,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.1745242,
                  0,
                  0,
                  4.959978
                },
                {
                  0,
                  0.1745242,
                  0,
                  -21.83647
                },
                {
                  0,
                  0,
                  0.1745242,
                  5.787223
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
          [2] = {
            nid = 37,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 6
          }
        }
      },
      children = {
        [1] = {
          nid = 38,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 39,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state3001"
            }
          }
        },
        [2] = {
          nid = 41,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 42,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 6,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state2001"
            }
          }
        },
        [3] = {
          nid = 8,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "mfx_water_date2_fengliu_state1001"
        }
      }
    },
    [18] = {
      gid = 18,
      nid = 6,
      basetype = "Composite",
      type = "Parallel",
      service = {
        nid = 8,
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
          radius = 0.5,
          worldToLocalMatrix = {
            {
              0.6404371,
              0,
              0,
              3.400721
            },
            {
              0,
              0.5578079,
              0,
              -69.52518
            },
            {
              0,
              0,
              0.5578079,
              11.76417
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
          nid = 2,
          basetype = "Action",
          type = "UseSkill",
          skillId = 20102001,
          preCondition = {
            nid = 14,
            basetype = "Decorator",
            type = "CompareBB",
            serviceKey = "PlayerTriggerCollector",
            bbKey = 9,
            val = 0,
            op = 2
          }
        }
      }
    },
    [19] = {
      gid = 19,
      nid = 34,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 35,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 36,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.2083164,
                  0,
                  0,
                  1.089495
                },
                {
                  0,
                  0.2083164,
                  0,
                  -25.93747
                },
                {
                  0,
                  0,
                  0.2083164,
                  4.382977
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
          [2] = {
            nid = 37,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 6
          }
        }
      },
      children = {
        [1] = {
          nid = 38,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 39,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 4,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state3001"
            }
          }
        },
        [2] = {
          nid = 41,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 42,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 6,
              basetype = "Action",
              type = "PlayAnimation",
              tag = 1,
              id = 0,
              allAnimators = true,
              stateName = "mfx_water_date2_fengliu_state2001"
            }
          }
        },
        [3] = {
          nid = 8,
          basetype = "Action",
          type = "PlayAnimation",
          tag = 1,
          id = 0,
          allAnimators = true,
          stateName = "mfx_water_date2_fengliu_state1001"
        }
      }
    },
    [20] = {
      gid = 20,
      nid = 2,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 4,
        basetype = "Composite",
        type = "Sequence",
        children = {
          [1] = {
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
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.02314072,
                  0,
                  0,
                  0.3679375
                },
                {
                  0,
                  0.02865747,
                  0,
                  -3.547795
                },
                {
                  0,
                  0,
                  0.01785113,
                  0.1035365
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
          [2] = {
            nid = 8,
            basetype = "Service",
            type = "PlayerTriggerInOutCollector",
            preServiceName = "PlayerTriggerCollector",
            bbKey = 1001
          }
        }
      },
      children = {
        [1] = {
          nid = 12,
          basetype = "Action",
          type = "TogglePlayerSpEffect",
          effectId = 41,
          duration = 0,
          serviceKey = "PlayerTriggerInOutCollector",
          onBBKey = 1002,
          offBBKey = 1003
        }
      }
    },
    [21] = {
      gid = 21,
      nid = 2,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 4,
        basetype = "Composite",
        type = "Sequence",
        children = {
          [1] = {
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
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.05153147,
                  0,
                  0,
                  2.097331
                },
                {
                  0,
                  0.06381658,
                  0,
                  -8.091942
                },
                {
                  0,
                  0,
                  0.03975221,
                  0.9938052
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
          [2] = {
            nid = 8,
            basetype = "Service",
            type = "PlayerTriggerInOutCollector",
            preServiceName = "PlayerTriggerCollector",
            bbKey = 1001
          }
        }
      },
      children = {
        [1] = {
          nid = 12,
          basetype = "Action",
          type = "TogglePlayerSpEffect",
          effectId = 41,
          duration = 0,
          serviceKey = "PlayerTriggerInOutCollector",
          onBBKey = 1002,
          offBBKey = 1003
        }
      }
    },
    [22] = {
      gid = 22,
      nid = 142,
      basetype = "Composite",
      type = "Parallel",
      service = {
        nid = 36,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 3,
        collider = {
          type = 1,
          center = {
            0,
            0,
            0
          },
          radius = 1,
          worldToLocalMatrix = {
            {
              0.1529844,
              0,
              0,
              0.7098476
            },
            {
              0,
              0.1529844,
              0,
              -19.11234
            },
            {
              0,
              0,
              0.1529844,
              2.184617
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
      preCondition = {
        nid = 188,
        basetype = "Decorator",
        type = "CheckAnimatorProgress",
        invertResult = true,
        tag = 2,
        id = 8,
        stateName = "playshow",
        normalizedTime = 1,
        op = 5
      },
      children = {
        [1] = {
          nid = 130,
          basetype = "Composite",
          type = "Selector",
          children = {
            [1] = {
              nid = 2,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 39,
                  basetype = "Decorator",
                  type = "CompareBB",
                  serviceKey = "PlayerTriggerCollector",
                  bbKey = 7,
                  val = 0,
                  op = 2
                },
                [2] = {
                  nid = 126,
                  basetype = "Service",
                  type = "BBSetValue",
                  bbParam = {
                    name = "triggerState",
                    value = 3
                  }
                }
              }
            },
            [2] = {
              nid = 6,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 10,
                  basetype = "Decorator",
                  type = "CompareBB",
                  serviceKey = "PlayerTriggerCollector",
                  bbKey = 4,
                  val = 0,
                  op = 2
                },
                [2] = {
                  nid = 124,
                  basetype = "Service",
                  type = "BBSetValue",
                  bbParam = {
                    name = "triggerState",
                    value = 2
                  }
                }
              }
            },
            [3] = {
              nid = 134,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 136,
                  basetype = "Decorator",
                  type = "CompareBB",
                  serviceKey = "PlayerTriggerCollector",
                  bbKey = 1,
                  val = 0,
                  op = 2
                },
                [2] = {
                  nid = 138,
                  basetype = "Service",
                  type = "BBSetValue",
                  bbParam = {
                    name = "triggerState",
                    value = 1
                  }
                }
              }
            },
            [4] = {
              nid = 140,
              basetype = "Service",
              type = "BBSetValue",
              bbParam = {
                name = "triggerState",
                value = 0
              }
            }
          }
        },
        [2] = {
          nid = 144,
          basetype = "Composite",
          type = "Selector",
          service = {
            nid = 190,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 8
          },
          children = {
            [1] = {
              nid = 146,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 148,
                  basetype = "Decorator",
                  type = "CompareBBCustom",
                  bbParam = {
                    name = "triggerState",
                    value = 0
                  },
                  op = 2
                },
                [2] = {
                  nid = 150,
                  basetype = "Service",
                  type = "BBSetValue",
                  bbParam = {name = "patrol", value = false}
                },
                [3] = {
                  nid = 3,
                  basetype = "Action",
                  type = "SetAnimatorEnabled",
                  tag = 1,
                  id = 0,
                  allAnimators = false,
                  enabled = false
                },
                [4] = {
                  nid = 180,
                  basetype = "Composite",
                  type = "Selector",
                  children = {
                    [1] = {
                      nid = 172,
                      basetype = "Composite",
                      type = "Sequence",
                      children = {
                        [1] = {
                          nid = 176,
                          basetype = "Decorator",
                          type = "HasArrived",
                          tag = 1,
                          id = 0,
                          targetPosition = {
                            -2.41,
                            125,
                            -9.5
                          },
                          tolerance = 0.01
                        },
                        [2] = {
                          nid = 178,
                          basetype = "Service",
                          type = "BBSetValue",
                          bbParam = {name = "isMoving", value = false}
                        }
                      }
                    },
                    [2] = {
                      nid = 182,
                      basetype = "Composite",
                      type = "Sequence",
                      children = {
                        [1] = {
                          nid = 184,
                          basetype = "Action",
                          type = "TargetMoveTo",
                          tag = 1,
                          id = 0,
                          targetPosition = {
                            -2.41,
                            125,
                            -9.5
                          },
                          speed = 10
                        },
                        [2] = {
                          nid = 186,
                          basetype = "Service",
                          type = "BBSetValue",
                          bbParam = {name = "isMoving", value = true}
                        }
                      }
                    }
                  }
                }
              }
            },
            [2] = {
              nid = 100,
              basetype = "Composite",
              type = "Selector",
              service = {
                nid = 194,
                basetype = "Service",
                type = "BBSetValue",
                bbParam = {name = "isMoving", value = true}
              },
              children = {
                [1] = {
                  nid = 104,
                  basetype = "Decorator",
                  type = "CompareBBCustom",
                  bbParam = {name = "patrol", value = true},
                  op = 0
                },
                [2] = {
                  nid = 56,
                  basetype = "Composite",
                  type = "Sequence",
                  children = {
                    [1] = {
                      nid = 58,
                      basetype = "Decorator",
                      type = "HasArrived",
                      tag = 1,
                      id = 0,
                      targetPosition = {
                        15.39,
                        126.75,
                        -7.79
                      },
                      tolerance = 0.01
                    },
                    [2] = {
                      nid = 102,
                      basetype = "Service",
                      type = "BBSetValue",
                      bbParam = {name = "patrol", value = true}
                    },
                    [3] = {
                      nid = 5,
                      basetype = "Action",
                      type = "SetAnimatorEnabled",
                      tag = 1,
                      id = 0,
                      allAnimators = false,
                      enabled = true
                    },
                    [4] = {
                      nid = 9,
                      basetype = "Action",
                      type = "PlayAnimation",
                      tag = 1,
                      id = 0,
                      allAnimators = false,
                      stateName = "patrol",
                      forceReplay = true
                    }
                  }
                },
                [3] = {
                  nid = 64,
                  basetype = "Action",
                  type = "TargetMoveTo",
                  tag = 1,
                  id = 0,
                  targetPosition = {
                    15.39,
                    126.75,
                    -7.79
                  },
                  speed = 10
                }
              }
            }
          }
        },
        [3] = {
          nid = 114,
          basetype = "Composite",
          type = "Selector",
          service = {
            nid = 152,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 80
          },
          children = {
            [1] = {
              nid = 106,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 108,
                  basetype = "Decorator",
                  type = "CompareBBCustom",
                  bbParam = {name = "isMoving", value = true},
                  op = 0
                },
                [2] = {
                  nid = 4,
                  basetype = "Composite",
                  type = "Parallel",
                  children = {
                    [1] = {
                      nid = 112,
                      basetype = "Action",
                      type = "PlayAnimation",
                      tag = 1,
                      id = 0,
                      allAnimators = false,
                      stateName = "walk"
                    },
                    [2] = {
                      nid = 156,
                      basetype = "Action",
                      type = "TargetSetActive",
                      tag = 2,
                      id = 800,
                      active = false
                    }
                  }
                }
              }
            },
            [2] = {
              nid = 116,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 118,
                  basetype = "Decorator",
                  type = "CompareBBCustom",
                  bbParam = {
                    name = "triggerState",
                    value = 3
                  },
                  op = 0
                },
                [2] = {
                  nid = 7,
                  basetype = "Composite",
                  type = "Parallel",
                  children = {
                    [1] = {
                      nid = 120,
                      basetype = "Action",
                      type = "PlayAnimation",
                      tag = 1,
                      id = 0,
                      allAnimators = false,
                      stateName = "playshow"
                    },
                    [2] = {
                      nid = 162,
                      basetype = "Action",
                      type = "TargetSetActive",
                      tag = 2,
                      id = 800,
                      active = true
                    }
                  }
                }
              }
            },
            [3] = {
              nid = 164,
              basetype = "Composite",
              type = "Sequence",
              children = {
                [1] = {
                  nid = 166,
                  basetype = "Decorator",
                  type = "CompareBBCustom",
                  bbParam = {
                    name = "triggerState",
                    value = 2
                  },
                  op = 0
                },
                [2] = {
                  nid = 11,
                  basetype = "Composite",
                  type = "Parallel",
                  children = {
                    [1] = {
                      nid = 168,
                      basetype = "Action",
                      type = "PlayAnimation",
                      tag = 1,
                      id = 0,
                      allAnimators = false,
                      stateName = "playshow"
                    },
                    [2] = {
                      nid = 170,
                      basetype = "Action",
                      type = "TargetSetActive",
                      tag = 2,
                      id = 800,
                      active = false
                    }
                  }
                }
              }
            },
            [4] = {
              nid = 8,
              basetype = "Composite",
              type = "Parallel",
              children = {
                [1] = {
                  nid = 122,
                  basetype = "Action",
                  type = "PlayAnimation",
                  tag = 1,
                  id = 0,
                  allAnimators = false,
                  stateName = "wait"
                },
                [2] = {
                  nid = 158,
                  basetype = "Action",
                  type = "TargetSetActive",
                  tag = 2,
                  id = 220101,
                  active = false
                }
              }
            }
          }
        }
      }
    },
    [23] = {
      gid = 23,
      nid = 2,
      basetype = "Composite",
      type = "Sequence",
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
          radius = 0.5,
          worldToLocalMatrix = {
            {
              0.1407526,
              0,
              0,
              3.86366
            },
            {
              0,
              0.1407526,
              0,
              -18.31473
            },
            {
              0,
              0,
              0.1407526,
              -2.266117
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
          basetype = "Decorator",
          type = "CompareBB",
          serviceKey = "PlayerTriggerCollector",
          bbKey = 9,
          val = 0,
          op = 2
        },
        [2] = {
          nid = 8,
          basetype = "Decorator",
          type = "CompareBBCustom",
          bbParam = {name = "myInteger", value = 1},
          op = 1
        },
        [3] = {
          nid = 10,
          basetype = "Service",
          type = "BBSetValue",
          bbParam = {name = "myInteger", value = 1}
        },
        [4] = {
          nid = 12,
          basetype = "Action",
          type = "PlayTimeline",
          assetId = "50009",
          bbOnComplete = {name = "myInteger", value = 0}
        }
      }
    },
    [24] = {
      gid = 24,
      nid = 2,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.9728503,
                  0,
                  0,
                  11.85126
                },
                {
                  0,
                  0.426097,
                  0,
                  -52.65664
                },
                {
                  0,
                  0,
                  0.426097,
                  12.43308
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
          [2] = {
            nid = 1,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 201
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [25] = {
      gid = 25,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5542762,
                  0,
                  0,
                  5.686873
                },
                {
                  0,
                  0.3884262,
                  0,
                  -48.00094
                },
                {
                  0,
                  0,
                  0.3884262,
                  11.44304
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 203
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [26] = {
      gid = 26,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5322259,
                  0,
                  0,
                  4.969926
                },
                {
                  0,
                  0.3729739,
                  0,
                  -46.0895
                },
                {
                  0,
                  0,
                  0.3729739,
                  11.46373
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 204
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [27] = {
      gid = 27,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5365137,
                  0,
                  0,
                  5.923112
                },
                {
                  0,
                  0.3759787,
                  0,
                  -46.45668
                },
                {
                  0,
                  0,
                  0.3759787,
                  10.54996
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 202
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [28] = {
      gid = 28,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5550117,
                  0,
                  0,
                  5.139409
                },
                {
                  0,
                  0.3889418,
                  0,
                  -48.16577
                },
                {
                  0,
                  0,
                  0.3889418,
                  9.128463
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 205
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [29] = {
      gid = 29,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.4701997,
                  0,
                  0,
                  5.139283
                },
                {
                  0,
                  0.3295071,
                  0,
                  -41.07307
                },
                {
                  0,
                  0,
                  0.3295071,
                  4.817394
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 206
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [30] = {
      gid = 30,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.4851088,
                  0,
                  0,
                  4.768619
                },
                {
                  0,
                  0.3399551,
                  0,
                  -42.5243
                },
                {
                  0,
                  0,
                  0.3399551,
                  4.439814
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 207
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [31] = {
      gid = 31,
      nid = 2,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.9728503,
                  0,
                  0,
                  13.40588
                },
                {
                  0,
                  0.426097,
                  0,
                  -53.45557
                },
                {
                  0,
                  0,
                  0.426097,
                  4.21836
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
          [2] = {
            nid = 1,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 208
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [32] = {
      gid = 32,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5365137,
                  0,
                  0,
                  6.862011
                },
                {
                  0,
                  0.3759787,
                  0,
                  -47.1763
                },
                {
                  0,
                  0,
                  0.3759787,
                  3.301093
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 209
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [33] = {
      gid = 33,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5542762,
                  0,
                  0,
                  6.518288
                },
                {
                  0,
                  0.3884262,
                  0,
                  -48.66864
                },
                {
                  0,
                  0,
                  0.3884262,
                  4.008559
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 210
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [34] = {
      gid = 34,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5322259,
                  0,
                  0,
                  5.897063
                },
                {
                  0,
                  0.3729739,
                  0,
                  -46.66836
                },
                {
                  0,
                  0,
                  0.3729739,
                  4.248546
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 211
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [35] = {
      gid = 35,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.5550117,
                  0,
                  0,
                  5.484626
                },
                {
                  0,
                  0.3889418,
                  0,
                  -48.71418
                },
                {
                  0,
                  0,
                  0.3889418,
                  3.838855
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 212
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [36] = {
      gid = 36,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.4701997,
                  0,
                  0,
                  3.902658
                },
                {
                  0,
                  0.3295071,
                  0,
                  -41.31163
                },
                {
                  0,
                  0,
                  0.3295071,
                  3.047941
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 213
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [37] = {
      gid = 37,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.4851088,
                  0,
                  0,
                  10.17758
                },
                {
                  0,
                  0.3399551,
                  0,
                  -43.40207
                },
                {
                  0,
                  0,
                  0.3399551,
                  0.9756711
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 214
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [38] = {
      gid = 38,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 3,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 4,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.4851088,
                  0,
                  0,
                  12.62738
                },
                {
                  0,
                  0.3399551,
                  0,
                  -43.65703
                },
                {
                  0,
                  0,
                  0.3399551,
                  0.7479012
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
          [2] = {
            nid = 2,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 215
          }
        }
      },
      children = {
        [1] = {
          nid = 18,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 20,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "SetAnimatorParam",
              tag = 1,
              id = 0,
              allAnimators = true,
              paramName = "dir",
              paramVal = -1,
              paramType = 2
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Action",
          type = "SetAnimatorParam",
          tag = 1,
          id = 0,
          allAnimators = true,
          paramName = "dir",
          paramVal = 1,
          paramType = 2
        }
      }
    },
    [39] = {
      gid = 39,
      nid = 142,
      basetype = "Composite",
      type = "Parallel",
      service = {
        nid = 12,
        basetype = "Composite",
        type = "Parallel",
        children = {
          [1] = {
            nid = 13,
            basetype = "Service",
            type = "PlayerTriggerCollector",
            groupRange = 3,
            collider = {
              type = 1,
              center = {
                0,
                0,
                0
              },
              radius = 0.5,
              worldToLocalMatrix = {
                {
                  0.07603087,
                  0,
                  0,
                  0.5633887
                },
                {
                  0,
                  0.05328099,
                  0,
                  -6.602048
                },
                {
                  0,
                  0,
                  0.05328099,
                  1.099187
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
          [2] = {
            nid = 15,
            basetype = "Service",
            type = "BBChangeTarget",
            tag = 2,
            id = 300
          }
        }
      },
      children = {
        [1] = {
          nid = 2,
          basetype = "Action",
          type = "BoidDetectTarget",
          tag = 1,
          id = 0,
          goalService = "PlayerTriggerCollector",
          goalBBKey = 1002,
          obstacleService = "PlayerTriggerCollector",
          obstacleBBKey = 1001
        }
      }
    }
  }
}
return GameFlowRoot_water_date2
