this["JST"] = this["JST"] || {};

this["JST"]["addObjectSidebar"] = function template(locals) {
var buf = [];
var jade_mixins = {};

buf.push("<div class=\"title\">Add New Object</div><div class=\"types\">");
// iterate App.objectTypes
;(function(){
  var $$obj = App.objectTypes;
  if ('number' == typeof $$obj.length) {

    for (var key = 0, $$l = $$obj.length; key < $$l; key++) {
      var value = $$obj[key];

buf.push("<div" + (jade.attr("data-type", key, true, false)) + " class=\"object-type\"><div" + (jade.attr("style", "background-image:url(images/mainUI/vijualObjectSymbols/" + ( key ) + ".png)", true, false)) + " class=\"icon\"></div><div class=\"name\"><div class=\"text\">" + (jade.escape(null == (jade.interp = value.name) ? "" : jade.interp)) + "</div></div></div>");
    }

  } else {
    var $$l = 0;
    for (var key in $$obj) {
      $$l++;      var value = $$obj[key];

buf.push("<div" + (jade.attr("data-type", key, true, false)) + " class=\"object-type\"><div" + (jade.attr("style", "background-image:url(images/mainUI/vijualObjectSymbols/" + ( key ) + ".png)", true, false)) + " class=\"icon\"></div><div class=\"name\"><div class=\"text\">" + (jade.escape(null == (jade.interp = value.name) ? "" : jade.interp)) + "</div></div></div>");
    }

  }
}).call(this);

buf.push("</div>");;return buf.join("");
};

this["JST"]["colorPicker"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),current = locals_.current;
buf.push("<div class=\"color-picker\">");
var index = 0
// iterate _.first(App.colors, 24)
;(function(){
  var $$obj = _.first(App.colors, 24);
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var color = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", "" + ( index++ ) + "", true, false)) + (jade.attr("style", "background-color: " + ( color ) + "", true, false)) + (jade.cls(['color-bubble',"" + ( color === current ? 'current' : '' ) + ""], [null,true])) + "></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var color = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", "" + ( index++ ) + "", true, false)) + (jade.attr("style", "background-color: " + ( color ) + "", true, false)) + (jade.cls(['color-bubble',"" + ( color === current ? 'current' : '' ) + ""], [null,true])) + "></div>");
    }

  }
}).call(this);

buf.push("</div>");;return buf.join("");
};

this["JST"]["documentToolbar"] = function template(locals) {
var buf = [];
var jade_mixins = {};

buf.push("<div class=\"branding\"><div class=\"logo\"></div><div class=\"app-name\">Vijual</div></div><div class=\"file-actions\"><button class=\"action new-file\">New</button><button class=\"action load-file\">Open</button><button class=\"action save-file\">Save</button><input type=\"file\" class=\"file-uploader visually-hidden\"/><button class=\"action add-object\">Add Object</button></div><div class=\"app-actions\"><div class=\"bpm\"><button class=\"sync-button\">BPM</button><input type=\"text\" value=\"120\" class=\"bpm-value\"/></div><button class=\"action new-render-window\">Render</button><button class=\"action new-props-window\">Properties</button><button class=\"action new-scene-window\">Scene</button><button class=\"action toggle-stats\">Stats</button></div>");;return buf.join("");
};

this["JST"]["main"] = function template(locals) {
var buf = [];
var jade_mixins = {};

buf.push("<section id=\"documentToolbar\"></section><section id=\"tracks\"></section><section id=\"objectGrid\"><div id=\"objectHolder\" class=\"r\">");
// iterate [0, 1, 2, 3, 4, 5, 6, 7]
;(function(){
  var $$obj = [0, 1, 2, 3, 4, 5, 6, 7];
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var column = $$obj[$index];

// iterate [0, 1, 2, 3, 4, 5, 6, 7]
;(function(){
  var $$obj = [0, 1, 2, 3, 4, 5, 6, 7];
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var row = $$obj[$index];

buf.push("<div" + (jade.attr("id", "gridSlot_" + ( column ) + "_" + ( row ) + "", true, false)) + (jade.attr("data-x", column, true, false)) + (jade.attr("data-y", row, true, false)) + (jade.attr("style", "left: " + ( column * 12.5 ) + "%; top: " + ( row * 12.5 ) + "%;", true, false)) + " class=\"gridSlot\"></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var row = $$obj[$index];

buf.push("<div" + (jade.attr("id", "gridSlot_" + ( column ) + "_" + ( row ) + "", true, false)) + (jade.attr("data-x", column, true, false)) + (jade.attr("data-y", row, true, false)) + (jade.attr("style", "left: " + ( column * 12.5 ) + "%; top: " + ( row * 12.5 ) + "%;", true, false)) + " class=\"gridSlot\"></div>");
    }

  }
}).call(this);

    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var column = $$obj[$index];

// iterate [0, 1, 2, 3, 4, 5, 6, 7]
;(function(){
  var $$obj = [0, 1, 2, 3, 4, 5, 6, 7];
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var row = $$obj[$index];

buf.push("<div" + (jade.attr("id", "gridSlot_" + ( column ) + "_" + ( row ) + "", true, false)) + (jade.attr("data-x", column, true, false)) + (jade.attr("data-y", row, true, false)) + (jade.attr("style", "left: " + ( column * 12.5 ) + "%; top: " + ( row * 12.5 ) + "%;", true, false)) + " class=\"gridSlot\"></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var row = $$obj[$index];

buf.push("<div" + (jade.attr("id", "gridSlot_" + ( column ) + "_" + ( row ) + "", true, false)) + (jade.attr("data-x", column, true, false)) + (jade.attr("data-y", row, true, false)) + (jade.attr("style", "left: " + ( column * 12.5 ) + "%; top: " + ( row * 12.5 ) + "%;", true, false)) + " class=\"gridSlot\"></div>");
    }

  }
}).call(this);

    }

  }
}).call(this);

buf.push("</div></section><section id=\"sidebar\"></section>");;return buf.join("");
};

this["JST"]["props"] = function template(locals) {
var buf = [];
var jade_mixins = {};

buf.push("<div id=\"properties-grid\" class=\"properties-grid\"></div><div id=\"propertiesModalBackground\"></div>");;return buf.join("");
};

this["JST"]["propsRecordingsModal"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),index = locals_.index,recordings = locals_.recordings,totalSeconds = locals_.totalSeconds,seconds = locals_.seconds,displaySeconds = locals_.displaySeconds,minutes = locals_.minutes;
buf.push("<div class=\"recordings\">");
index = 0
// iterate recordings
;(function(){
  var $$obj = recordings;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var recording = $$obj[$index];

buf.push("<div" + (jade.attr("data-number", index, true, false)) + " class=\"recording\">");
index++
buf.push("<div class=\"playAction\"><div class=\"name\"><span>►</span> Recording " + (jade.escape((jade.interp =  index ) == null ? '' : jade.interp)) + "</div>");
totalSeconds = Math.ceil(recording.frames / 60)
seconds = totalSeconds % 60
displaySeconds = seconds
if ( seconds < 10)
displaySeconds = "0" + seconds
minutes = Math.floor(totalSeconds / 60)
buf.push("<div class=\"duration\">" + (jade.escape((jade.interp =  minutes ) == null ? '' : jade.interp)) + ":" + (jade.escape((jade.interp =  displaySeconds ) == null ? '' : jade.interp)) + "</div></div><div class=\"deleteAction\">&times;</div></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var recording = $$obj[$index];

buf.push("<div" + (jade.attr("data-number", index, true, false)) + " class=\"recording\">");
index++
buf.push("<div class=\"playAction\"><div class=\"name\"><span>►</span> Recording " + (jade.escape((jade.interp =  index ) == null ? '' : jade.interp)) + "</div>");
totalSeconds = Math.ceil(recording.frames / 60)
seconds = totalSeconds % 60
displaySeconds = seconds
if ( seconds < 10)
displaySeconds = "0" + seconds
minutes = Math.floor(totalSeconds / 60)
buf.push("<div class=\"duration\">" + (jade.escape((jade.interp =  minutes ) == null ? '' : jade.interp)) + ":" + (jade.escape((jade.interp =  displaySeconds ) == null ? '' : jade.interp)) + "</div></div><div class=\"deleteAction\">&times;</div></div>");
    }

  }
}).call(this);

buf.push("</div>");;return buf.join("");
};

this["JST"]["scene"] = function template(locals) {
var buf = [];
var jade_mixins = {};

buf.push("<div class=\"canvas-holder\"><div class=\"r\"><canvas id=\"sceneCanvas\"" + (jade.attr("width", (App.config.renderer.lowDisplayWidth), true, false)) + (jade.attr("height", (App.config.renderer.lowDisplayHeight), true, false)) + "></canvas></div></div><div id=\"interaction-layer\" class=\"interaction-layer\"><div class=\"interaction-object\"></div></div><div class=\"sceneActions\"><button class=\"streamToggle\">Stream</button></div>");;return buf.join("");
};

this["JST"]["sidebar"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),icon = locals_.icon,color = locals_.color,model = locals_.model;
buf.push("<div" + (jade.cls(['block-header',"type-" + ( icon ) + ""], [null,true])) + "><div class=\"object-toggles\"><div class=\"activation-toggle\"></div><div" + (jade.attr("style", "background-color: " + ( color ) + "", true, false)) + " class=\"editor-color\"></div></div><div" + (jade.attr("style", "background-image:url(images/mainUI/vijualObjectSymbols/" + ( icon ) + ".png)", true, false)) + " class=\"icon\"></div><div class=\"names\"><div class=\"type\">" + (jade.escape(null == (jade.interp = icon) ? "" : jade.interp)) + "</div><input type=\"text\"" + (jade.attr("value", model.get('editor.name'), true, false)) + " class=\"editor-name\"/>");
if ( (icon == 'track'))
{
buf.push("<select class=\"blending-mode\"><option value=\"0\"" + (jade.attr("selected", model.get('blending')==0, true, false)) + ">Blending: Normal</option><option value=\"1\"" + (jade.attr("selected", model.get('blending')==1, true, false)) + ">Blending: Add</option><option value=\"2\"" + (jade.attr("selected", model.get('blending')==2, true, false)) + ">Blending: Subtract</option><option value=\"3\"" + (jade.attr("selected", model.get('blending')==3, true, false)) + ">Blending: Multiply</option></select>");
}
buf.push("</div>");
if ( (icon != 'track'))
{
buf.push("<div class=\"delete\">&times;</div>");
}
buf.push("</div><div class=\"controls\">");
if ( (icon != 'track'))
{
buf.push("<div class=\"behaviors\"><div class=\"behavior-list\">");
// iterate model.get('behaviors').toArray()
;(function(){
  var $$obj = model.get('behaviors').toArray();
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var behavior = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", behavior.id, true, false)) + (jade.cls(['behavior-item',( (behavior.get('active') ? 'active' : 'inactive') + ' ' + behavior.groupName )], [null,true])) + "><div class=\"behavior-activation-toggle\"></div><div class=\"name\"><span class=\"className\">" + (jade.escape(null == (jade.interp = behavior.name) ? "" : jade.interp)) + "</span><span class=\"type\">" + (jade.escape(null == (jade.interp = App.BehaviorGroupNames[behavior.groupName]) ? "" : jade.interp)) + "</span></div><div class=\"delete-behavior delete\">&times;</div></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var behavior = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", behavior.id, true, false)) + (jade.cls(['behavior-item',( (behavior.get('active') ? 'active' : 'inactive') + ' ' + behavior.groupName )], [null,true])) + "><div class=\"behavior-activation-toggle\"></div><div class=\"name\"><span class=\"className\">" + (jade.escape(null == (jade.interp = behavior.name) ? "" : jade.interp)) + "</span><span class=\"type\">" + (jade.escape(null == (jade.interp = App.BehaviorGroupNames[behavior.groupName]) ? "" : jade.interp)) + "</span></div><div class=\"delete-behavior delete\">&times;</div></div>");
    }

  }
}).call(this);

buf.push("</div><select class=\"add-new-behavior\"></select></div>");
}
else
{
buf.push("<div class=\"filters\"><div class=\"filter-list\">");
// iterate model.get('filters').toArray()
;(function(){
  var $$obj = model.get('filters').toArray();
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var filter = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", filter.id, true, false)) + (jade.cls(['filter-item',(filter.get('active') ? 'active' : 'inactive')], [null,true])) + "><div class=\"filter-activation-toggle\"></div><div class=\"name\"><span class=\"className\">" + (jade.escape(null == (jade.interp = filter.name) ? "" : jade.interp)) + "</span></div><div class=\"delete-filter delete\">&times;</div></div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var filter = $$obj[$index];

buf.push("<div" + (jade.attr("data-id", filter.id, true, false)) + (jade.cls(['filter-item',(filter.get('active') ? 'active' : 'inactive')], [null,true])) + "><div class=\"filter-activation-toggle\"></div><div class=\"name\"><span class=\"className\">" + (jade.escape(null == (jade.interp = filter.name) ? "" : jade.interp)) + "</span></div><div class=\"delete-filter delete\">&times;</div></div>");
    }

  }
}).call(this);

buf.push("</div><select class=\"add-new-filter\"></select></div>");
}
buf.push("</div>");;return buf.join("");
};

this["JST"]["track"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),color = locals_.color,track = locals_.track;
buf.push("<div class=\"r\"><div" + (jade.attr("style", "background-color: " + ( color ) + "", true, false)) + " class=\"color-background\"></div><div" + (jade.attr("style", "background-color: " + ( color ) + "; width: " + ( track.get('opacity') * 100 + '%' ) + "", true, false)) + " class=\"opacity-bar\"></div><div class=\"name\">" + (jade.escape(null == (jade.interp = track.get('editor.name')) ? "" : jade.interp)) + "</div></div>");;return buf.join("");
};

this["JST"]["vijualObject"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var locals_ = (locals || {}),object = locals_.object,color = locals_.color;
buf.push("<div" + (jade.cls(['block',object.get('active') ? 'active' : 'inactive'], [null,true])) + "><div" + (jade.attr("style", "background-color: " + ( color ) + "", true, false)) + " class=\"block-background\"></div><div" + (jade.attr("style", "background-image:url(images/mainUI/vijualObjectSymbols/" + ( object.get('type') ) + ".png)", true, false)) + " class=\"object-icon\"></div><div" + (jade.attr("style", "background-color: " + ( color ) + "; width: " + ( object.get('material.opacity') * 100 + '%' ) + "", true, false)) + " class=\"object-opacity-bar\"></div><div class=\"object-activation-toggle\"></div><div class=\"object-name\">" + (jade.escape(null == (jade.interp = object.get('editor.name')) ? "" : jade.interp)) + "</div></div>");;return buf.join("");
};