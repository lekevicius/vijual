window.App = window.App or {}
window.App.data = {}
window.App.Views = {}
window.App.VO = {}
window.App.TrackFilters = {}
window.App.VUI = {}
App.Connections = {}
App.Behaviors = {}
App.Mixins = {}
App.BehaviorGroupNames = { intro: "Intro", outro: "Outro", looping: "Continuos", beat: "Beat", trigger: "Trigger", operator: "Operator", generator: "Generator" }
window.App.isTouch = `'ontouchstart' in document.documentElement`
window.SHADERS = {}

App.MasterHostname = location.hostname
App.LinkingData = null

WAGNER.vertexShadersPath = 'shaders/vertex-shaders';
WAGNER.fragmentShadersPath = 'shaders/fragment-shaders';
WAGNER.assetsPath = 'shaders/assets/';

App.resetState = ->
  window.App.VO.GlobalLookup = {}
  App.GlobalTrackCount = 0
App.resetState()

App.config =
  defaultActivationState: false
  renderer:
    width: 1024
    height: 768
    lowWidth: 160
    lowHeight: 120
    lowDisplayWidth: 640
    lowDisplayHeight: 480

App.RenderWindow = {}
App.RenderWindow.all = {}
App.WindowManager = {}
App.WindowManager.all = {}

App.VUI.ongoingTouches = []
App.VUI.globalPadding = 4
App.VUI.activationDragDistance = 30

App.VUI.defaultColor = '#fff'
App.VUI.defaultControlColor = '#fff'
App.VUI.disabledColor = '#444'
App.VUI.recordingColor = '#c42127'
App.VUI.linkColor = '#2cffb2'

App.BlendingModes = [ THREE.NormalBlending, THREE.AdditiveBlending, THREE.SubtractiveBlending, THREE.MultiplyBlending ]

App.fonts = [
  'Futura TL'
  'Helvetica'
  'Georgia'
  'Aller'
  'Verdana'
  'Archer'
  'Calcite Pro'
  'Chevin'
  'Ideal Sans'
  'Katarine'
  'M+ 1m'
  'Source Sans Pro'
]

App.VUI.colors =
  blue: '#13ebfc'
  yellow: '#ffbe00'
  green: '#7ac919'
  pink: '#e1315a'

App.colors = [
  '#861e11',
  '#863413',
  '#874c14',
  '#896c17',
  '#898b1b',
  '#6d8b19',
  '#538c18',
  '#3c8b18',
  '#1c8b22',
  '#168d36',
  '#1d8b51',
  '#1c8c6c',
  '#1d8b89',
  '#186c87',
  '#195f8c',
  '#225090',
  '#263c92',
  '#282392',
  '#382192',
  '#481c8f',
  '#5a1290',
  '#690087',
  '#860088',
  '#86006b',
  '#333333'
]

App.MIDIDevices = {}
App.MIDIModels = {}



App.clipboard = []
App.emptyDocument = '
  {
    "tracks":[
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] },
      { "objects":[], "filters":[] }
    ]
  }'




App.defaultDocument = '
  {
    "tracks":[
      {
        "id": "5d7328d3-d376-4781-a905-dcc68b553b82",
        "objects":[
          {
            "id": "501b0534-faea-4a13-8280-e238bce44421",
            "screenPosition":[0.9,0.5],
            "material.color":"#ffff00",
            "material.doublesided":true,
            "scale":0.1,
            "type":"circle",
            "behaviors":[
              {
                "id": "37f4f98d-c0f1-4284-a484-877665f2788b",
                "type":"spin3d",
                "active": false,
                "xSpin":2,
                "ySpin":1,
                "zSpin":1.2
              },
              {
                "id": "8759b271-c47b-4d2d-92ef-af0fe4bffcfc",
                "type":"placeInCenter"
              }
            ]
          },
          {
            "id": "8c094611-6dd9-47eb-8562-948bf2f218a0",
            "screenPosition":[0.1,0.75],
            "material.color":"#ff0000",
            "material.doublesided":true,
            "scale":0.1,
            "type":"plane",
            "behaviors":[]
          },
          {
            "id": "8c094611-6dd9-47eb-8562-948bf2f218a1",
            "screenPosition":[0.5,0.5],
            "material.doublesided":true,
            "type":"drawing",
            "behaviors":[],
            "active":true,
            "drawingData":{"objects":[{"type":"path","originX":"center","originY":"center","left":475.13,"top":200,"width":449,"height":200,"fill":null,"stroke":"#ff0000","strokeWidth":8,"strokeDashArray":null,"strokeLineCap":"round","strokeLineJoin":"round","strokeMiterLimit":10,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"shadow":null,"visible":true,"clipTo":null,"backgroundColor":"","path":[["M",149.25,200],["Q",149.25,200,149.75,200],["Q",150.25,200,0,150],["Q",-150.25,100,149.75,50],["L",449.75,0]],"pathOffset":{"x":0,"y":0}}],"background":""}
          }
        ],
        "filters":[
          {
            "id": "b46122ef-9abe-4532-92c0-4bf90a561d90",
            "type": "invert"
          }
        ]
      },
      {
        "id": "220deb83-ca2a-4d83-abf6-b2835222cd29",
        "objects":[
          {
            "id": "b0466d8d-b6f8-432c-ae85-643d59f47cfd",
            "editor.color":23,
            "editor.gridPosition":[1,1],
            "editor.name":"Octahedron",
            "screenPosition": [0.5,0.75],
            "material.color":"#6666ff",
            "scale":0.1,
            "type":"octahedron",
            "behaviors":[ ]
          }
        ],
        "filters":[

        ]
      },
      {
        "id": "9ab529e4-f511-4fe0-979f-5cd5d4f9e0dc",
        "editor.color":6,
        "objects":[
          {
            "id": "a3c25784-abb3-4a73-bef5-4cab998bf279",
            "editor.color":8,
            "editor.gridPosition":[2,2],
            "editor.name":"Sphering",
            "screenPosition":[0.3,0.5],
            "material.color":"#00ffff",
            "scale":0.1,
            "type":"sphere",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b785-8f4aa76fa423",
            "screenPosition":[0.1,0.5],
            "material.color":"#ffffff",
            "scale":0.1,
            "type":"torus",
            "behaviors":[]
          }
        ],
        "filters":[

        ]
      },
      {
        "id": "6dd7d510-8d4b-4362-b42d-4550753fc9a6",
        "editor.color":9,
        "attributeLinksIn": {
          "6dd7d510-8d4b-4362-b42d-4550753fc9a6 opacity": {
            "from": { "id": "e769e7f3-52a2-4605-b755-7347320a5e9b", "key": "opacity" },
            "to": { "id": "6dd7d510-8d4b-4362-b42d-4550753fc9a6", "key": "opacity" }
          }
        },
        "objects":[
          {
            "id": "05ff62d3-1ace-4b25-ad19-92a44dc93e89",
            "editor.color":10,
            "editor.gridPosition":[0,0],
            "editor.name":"My Cylinder",
            "screenPosition":[0.5,0.5],
            "material.color":"#ff0080",
            "scale":0.1,
            "type":"cylinder",
            "behaviors":[]
          }
        ],
        "filters":[

        ]
      },
      {
        "id": "e769e7f3-52a2-4605-b755-7347320a5e9b",
        "editor.name":"Cube",
        "editor.color":12,
        "objects":[
          {
            "id": "6477e06a-c2f4-44cc-a779-d5c7662b0026",
            "editor.color":12,
            "editor.gridPosition":[1,0],
            "editor.name":"The Cube",
            "screenPosition":[0.7,0.5],
            "material.color":"#00ff00",
            "scale":0.1,
            "type":"cube",
            "behaviors":[]
          },
          {
            "id": "8f187639-a1b0-40b1-9b08-7f7b3aaa91f4",
            "screenPosition":[0,0],
            "material.color":"#00ff00",
            "scale":0.01,
            "type":"cube",
            "behaviors":[]
          },
          {
            "id": "f258e0d8-274c-42d3-ab2b-1025d8ae9c12",
            "screenPosition":[0,1],
            "material.color":"#00ff00",
            "scale":0.01,
            "type":"cube",
            "behaviors":[]
          },
          {
            "id": "411e4b43-7102-4f76-b3fb-ceb5ef368b2f",
            "screenPosition":[1,0],
            "material.color":"#00ff00",
            "scale":0.01,
            "type":"cube",
            "behaviors":[]
          },
          {
            "id": "76dac699-237e-4366-b09d-5a78b752bf75",
            "screenPosition":[1,1],
            "material.color":"#00ff00",
            "scale":0.01,
            "type":"cube",
            "behaviors":[]
          }
        ],
        "filters":[

        ]
      },
      {
        "id": "24f4426c-be3b-4160-be86-f82f0512b737",
        "editor.color":15,
        "blending":1,
        "opacity":0.25,
        "objects":[
          {
            "id": "fb53a311-0970-4053-a39e-a2678506dfbc",
            "editor.color":15,
            "editor.gridPosition":[7,7],
            "editor.name":"Torus Knot",
            "screenPosition":[0.6,0.5],
            "material.color":"#ff00ff",
            "scale":0.6,
            "type":"torusknot",
            "behaviors":[
              {
                "id": "12dd10b9-cb43-47fd-8194-a6ba6c4601bb",
                "type": "spin3d",
                "active": true
              }
            ]
          }
        ],
        "filters":[
          {
            "id": "7cba60d7-f0ff-4568-936c-8c580c3773ae",
            "type": "halftone"
          }
        ]
      },
      {
        "id": "1969b959-7cc8-4abf-8404-156f1c62aa7a",
        "editor.name":"Platonic Solids",
        "editor.color":18,
        "objects":[
          {
            "id": "bf7868c8-ca40-4727-b7c7-9a898b375d5c",
            "editor.color":0,
            "editor.gridPosition":[1,0],
            "editor.name":"Tetrahedron",
            "screenPosition":[0.3,0.75],
            "material.color":"#ff0000",
            "scale":0.1,
            "type":"tetrahedron",
            "behaviors":[]
          },
          {
            "id": "c42b054c-4e50-4030-82e6-0e6b955cb646",
            "editor.color":18,
            "editor.gridPosition":[1,1],
            "editor.name":"Icosahedron",
            "screenPosition":[0.7,0.75],
            "material.color":"#800080",
            "scale":0.1,
            "type":"icosahedron",
            "behaviors":[ ]
          }
        ],
        "filters":[

        ]
      },
      {
        "id": "48a45421-c018-4171-8adf-e6c590a11793",
        "editor.color":21,
        "objects":[
          {
            "id": "828202e0-7c3f-450c-b786-aa4aa76fa423",
            "screenPosition":[0.5,0.5],
            "editor.gridPosition":[2,2],
            "editor.name": "My Color",
            "material.color":"#ffffff",
            "scale":0.6,
            "type":"color",
            "canvas.color": "#ffff66",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b786-ab4aa76fa423",
            "screenPosition":[0.2,0.25],
            "editor.name": "My Gradient",
            "material.color":"#ffffff",
            "scale":0.1,
            "type":"gradient",
            "canvas.startColor": "#c000ff",
            "canvas.endColor": "#003399",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b786-ac4aa76fa423",
            "screenPosition":[0.4,0.25],
            "editor.name": "My Image",
            "material.color":"#ffffff",
            "scale":0.1,
            "type":"image",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b786-ad4aa76fa423",
            "screenPosition":[0.6,0.25],
            "editor.name": "Dance",
            "material.color":"#ffffff",
            "scale":0.1,
            "type":"video",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b786-ae4aa76fa423",
            "screenPosition":[0.8,0.25],
            "editor.name": "Shaping up",
            "material.color":"#ffffff",
            "scale":0.1,
            "type":"shape",
            "shape.color": "#86d628",
            "behaviors":[]
          },
          {
            "id": "828202e0-7c3f-450c-b786-af4aa76fa423",
            "screenPosition":[0.5,0.1],
            "editor.name": "Texty",
            "material.color":"#ffffff",
            "scale":0.4,
            "type":"text",
            "text.text":"Welcome to Vijual",
            "text.color":"#139fff",
            "behaviors":[]
          }
        ],
        "filters":[

        ]
      }
    ]
  }'
