illusions = null
illusionDict = {}
currentIllusionList = 0

currentDraggingType = 0
currentDraggingData = null

DRAGGING_ILLUSION_FROM_LIST = 1
DRAGGING_ILLUSION_FROM_PANEL = 2
DRAGGING_OUTPUT_FROM_PANEL = 3

panel_janish = [
]

_id = 0
get_unique_id = (illusion) ->
  return illusion["illusion"].toLowerCase() + "_" + (_id++)

setInput = (value, path, variable) ->
  path = path.substring(5)
  paths = path.split(".")
  working = panel_janish
  json_path = ""
  for p in paths
    if p.indexOf("|") >= 0
      p_id = p.split("|")[0]
      p_sub = p.split("|")[1]
#      console.log "working", working
      if Array.isArray(working)
        for i, j of working
          if j["id"] == p_id
            json_path += ("[" + i + "]")
            working = j["sub"][p_sub]
            json_path += (".sub[\"" + p_sub + "\"]")
  #          console.log "change working", working
            break
      else
        working = working["sub"][p_sub]
    else
      for i, j of working
        if j["id"] == p
          json_path +=  ("[" + i + "]")
          working = j
          break
  working["input"][variable] = value
#  console.log(working)
#  console.log(panel_janish)
  loadJanish()


createJanish = (path, illusion)->
#  console.log(path)
#  console.log(illusion)
  path = path.substring(5)
  paths = path.split(".")
  working = panel_janish
  json_path = ""
  for p in paths
    if p.indexOf("|") >= 0
      p_id = p.split("|")[0]
      p_sub = p.split("|")[1]
      #      console.log "working", working
      if Array.isArray(working)
        for i, j of working
          if j["id"] == p_id
            json_path += ("[" + i + "]")
            if ! j["sub"]
              j["sub"] = {}
            if ! j["sub"][p_sub]
              j["sub"][p_sub] = []
            working = j["sub"][p_sub]
            json_path += (".sub[\"" + p_sub + "\"]")
            #          console.log "change working", working
            break
      else
        working = working["sub"][p_sub]
    else
      for i, j of working
        if j["id"] == p
          json_path +=  ("[" + i + "]")
          working = j
          break
#  console.log(json_path)
#  console.log(working)

  janish = {
    "id": get_unique_id(illusion)
    "illusion": illusion["illusion"]
    "input": {}
  }

  try
    eval("panel_janish" + json_path + ".push(janish)")
  catch ex
    val("panel_janish" + json_path + " = [janish]")
  loadJanish()


deleteJanish = (path) ->
  path = path.substring(5)
  paths = path.split(".")
  working = panel_janish
  json_path = ""
  for p in paths
    if p.indexOf("|") >= 0
      p_id = p.split("|")[0]
      p_sub = p.split("|")[1]
      #      console.log "working", working
      if Array.isArray(working)
        for i, j of working
          if j["id"] == p_id
            json_path += ("[" + i + "]")
            if ! j["sub"]
              j["sub"] = {}
            if ! j["sub"][p_sub]
              j["sub"][p_sub] = []
            working = j["sub"][p_sub]
            json_path += (".sub[\"" + p_sub + "\"]")
            #          console.log "change working", working
            break
      else
        working = working["sub"][p_sub]
    else
      for i, j of working
        if j["id"] == p
          json_path +=  ("[" + i + "]")
          working = j
          break
#  console.log eval("delete panel_janish" + json_path)
#  console.log(eval("panel_janish" + json_path))
  id = json_path.substring(json_path.lastIndexOf("[")+1, json_path.lastIndexOf("]"))
  base_path = "panel_janish" + json_path.substring(0, json_path.lastIndexOf("["))
  eval(base_path+".splice(" + id + ",1)")
  console.log(id, base_path)
  loadJanish()



logLocation = ->
  $illusion1 = $("#illusion-2")
  console.log $("#illusion-1").position()
  console.log $("#illusion-2").position()
  console.log $("#illusion-3").position()


drawLine = (p1_x, p1_y, p2_x, p2_y) ->
  # FILL IN CANVAS ID
  c = document.getElementById('panel-background')
  # 2d line
  context = c.getContext('2d')
  # starting point
  context.beginPath()
  context.moveTo p1_x, p1_y
  # ending point
  context.lineTo p2_x, p2_y
  # set line color
  context.strokeStyle = '#A4A4A4'
  # set line width
  context.lineWidth = 4
  # line up
  context.stroke()

clearContext =  ->
  # FILL IN CANVAS ID
  c = document.getElementById('panel-background')
  context = c.getContext('2d')
  context.clearRect(0, 0, c.width, c.height)


loadIllusions = ->
  for illusionType in illusions
    for illusion in illusionType["list"]
      illusionDict[illusion["illusion"]] = illusion
  templateIllusionTypeItem = _template($("#template-illusion-type-item").html())
  $illusionType = $("#illusion-type")
  $illusionType.html("")
  for str_i, ill of illusions
    i = parseInt(str_i)
    if currentIllusionList == i
      ill["current"] = true
    else
      ill["current"] = false
    $item = $(templateIllusionTypeItem(ill))
    setChangeCurrentIllusionList = ->
      newListId = i
      onClick = ->
        currentIllusionList = newListId
        loadIllusions()
      onClick
    $item.click setChangeCurrentIllusionList()
    $illusionType.append($item)

  templateIllusionItem = _template($("#template-illusion-item").html())
  $illusionList = $("#illusion-list")
  $illusionList.html("")
  for str_i, ill of illusions[currentIllusionList]["list"]
    $item = $(templateIllusionItem(ill))
    createDragStart = ->
      currentIll = ill
      dragStart = ->
        currentDraggingType = DRAGGING_ILLUSION_FROM_LIST
        currentDraggingData = currentIll
      dragStart

    $item.on("dragstart", createDragStart())
    $illusionList.append($item)


setupDropEvent = ->
  $(".janish-plus").on("dragover", (e) ->
    e.preventDefault()
    $(this).addClass "drag-over"
  )
  $(".janish-plus").on("dragleave", (e) ->
    e.preventDefault()
    $(this).removeClass "drag-over"
  )
  $(".janish-plus").on("drop",(e) ->
    if currentDraggingType = DRAGGING_ILLUSION_FROM_LIST
      currentDraggingData
      path = $(this).attr("path")
      createJanish(path, currentDraggingData)
  )
  $(".value-output-having").on("click", (e) ->
    $this = $(this)
    my_path = $this.closest(".janish").attr("path")
    my_name = $this.closest(".value-item").find(".value-input").html()
    setInput(null, my_path, my_name)
  )
  $(".value-no").on("dblclick", (e) ->
    $this = $(this);
    $input = $("<input class='transparent'>")
    $this.html("").append($input)
    $input.focus()
    my_path = $this.closest(".janish").attr("path")
    my_name = $this.closest(".value-item").find(".value-input").html()
    $input.on("blur", ->
      setInput(this.value, my_path, my_name)
    )
  )
  $(".value-no").on("dragover", (e) ->
    e.preventDefault()
  )
  $(".value-no").on("drop", (e) ->
    if currentDraggingType != DRAGGING_OUTPUT_FROM_PANEL
      return
    value = currentDraggingData
    $this = $(this)
    my_path = $this.closest(".janish").attr("path")
    my_name = $this.closest(".value-item").find(".value-input").html()
    setInput(value, my_path, my_name)
  )
  $(".value-output-use").on("dragstart", (e) ->
    $this = $(this)
    name = $this.html()
    path = $this.closest(".janish").attr("path").split(".")
    id = path[path.length-1]
    currentDraggingType = DRAGGING_OUTPUT_FROM_PANEL
    currentDraggingData = "#" + id + "." + name
    console.log(currentDraggingData)
  )
  $(".janish .icon").on("dblclick", ->
    $this = $(this).closest(".janish")
    path = $this.attr("path")
    deleteJanish(path)
  )
#  $(".value-output").click (e) ->
#    $this = $(this)
#    console.log($this.html())
#    path = $this.closest(".janish").attr("path")
#    console.log path



colHeight = (col) ->
  $col = $("#janish-col-" + col)
  $last = $col.children().last()
  if $last.length
    $last.position().top + $last.height() + 45
  else
    0



drawPadding = (col, height) ->
  if height - 7 - colHeight(col) > 0
    $padding = $("<div></div>")
    $padding.css("height", height - colHeight(col))
    $("#janish-col-" + col).append($padding)

janishPlusHtml = $("#template-janish-plus").html()
createPlus = (col, path) ->
  $janishPlus = $(janishPlusHtml)
  $janishPlus.attr("path", path)
  $("#janish-col-" + col).append($janishPlus)


templateJanishItem = _template($("#template-janish-item").html())
templateJanishSub = _template($("#template-janish-sub").html())
drawJanish = (janish, col, path) ->
  if Array.isArray(janish)
    for j in janish
      drawJanish(j, col, path + "." + j["id"])
#    $("#janish-col-" + col).append($janishPlus)
  else
    illusion = illusionDict[janish["illusion"]]
#    console.log(path, janish, illusion)
#    console.log(illusionDict)
    # Get minimum padding requirement
    min = 0
    for i in [(col+1)...20]
      h = colHeight(i)
      if h > min
        min = h
    drawPadding(col, min)
    janishItemValue = JSON.parse(JSON.stringify(illusion))
    janishItemValue["janishInput"] = janish["input"]
    $janish = $(templateJanishItem(janishItemValue))
    $janish.attr("path", path)
#    $janish.attr("id", "janish-" + janish["id"])
    $("#janish-col-" + col).append($janish)
    if illusion.sub
      count = 0
      sub_list = []
      for key, output of illusion.sub
        sub_list.push({
          "name": key
          "output": output
        })
      sub_list.reverse()
      base_height = $janish.position().top
      drawLine(col*380 + 100, base_height + 60, (col+sub_list.length)*380 + 100, base_height + 60)
      for item in sub_list
        name = item["name"]
        output = item["output"]
        sub_path = path + "|" + name
        c = col + Object.keys(illusion.sub).length - count
        count++
        drawPadding(c, base_height)
        $sub_header = $(templateJanishSub(item))
        $sub_header.attr("path", path)
        $("#janish-col-" + c).append($sub_header)
        if janish["sub"] && janish["sub"][name]
          sub_janish = janish["sub"][name]
          drawJanish(sub_janish, c, sub_path)
        createPlus(c, sub_path)
        left = c*380 + 230
        end_top = $("#janish-col-" + c).children().last().position().top
        drawLine(left, base_height+60, left, end_top+70)


loadJanish = ->
#  console.log(panel_janish)
  clearContext()
  $janishPanel = $("#janish-panel")
  $janishPanel.html("")
  for i in [0...20]
    $item = $('<div class="janish-col"></div>')
    $item.attr("id", "janish-col-" + i)
    $janishPanel.append($item)
  drawJanish(panel_janish, 0, "main")
  createPlus(0, "main")
  start_p = $("#janish-col-0").children().first().position()
  end_p = $("#janish-col-0").children().last().position()
  drawLine(start_p.left + 150, start_p.top + 30, end_p.left + 150, end_p.top + 70)
  setupDropEvent()


documentReady = ->
  $.ajax
    "url": "illusions.json"
    "dataType": "json"
    "success": (data) ->
      illusions = data
      loadIllusions()
      loadJanish()
      sample = document.URL.split("?")[1]
      if sample
        sample = sample.replace("#", "")
      if sample
        $.ajax
          "url": "sample/" + sample + ".json"
          "dataType": "json"
          "success": (data) ->
            panel_janish = data
            console.log(panel_janish)
            loadJanish()


$(document).ready documentReady



monitorShowed = false
window.displayMonitor = ->
  $("#pre-branish").html("")
  $("#pre-bash").html("")
  if monitorShowed
    $("#code").hide()
    $("#monitor").removeClass("current")
  else
    # do program
    $("#pre-bash").html("Compiling...")
    $("#code").show()
    $("#monitor").addClass("current")
    $.ajax
      url: "/compile"
      data: JSON.stringify(panel_janish)
      contentType: "application/json"
      type: "post"
      success: (ret) ->
        $("#pre-bash").html(ret)
        console.log window.hljs
        if window.hljs
          window.hljs.highlightBlock($("#pre-bash")[0])
  monitorShowed = ! monitorShowed


window.displayRun = ->
  $("#run").show()

window.hideRun = ->
  $("#run").hide()
