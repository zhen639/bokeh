
define [
  "backbone"
  "tool/tool"
  "./inspect_tool_list_item_template"
], (Backbone, Tool, inspect_tool_list_item_template) ->

  class InspectToolListItemView extends Backbone.View
    className: "bk-toolbar-inspector"
    template: inspect_tool_list_item_template
    events: {
      'click [type="checkbox"]': '_clicked'
    }

    initialize: (options) ->
      @listenTo(@model, 'change:active', @render)
      @render()

    render: () ->
      @$el.html(@template(@model.attrs_and_props()))
      return @

    _clicked: (e) ->
      active = @model.get('active')
      @model.set('active', not active)

  class InspectToolView extends Tool.View

  class InspectTool extends Tool.Model
    event_type: "move"

    bind_bokeh_events: () ->
      super()
      @listenTo(events, 'move', @_inspect)

    initialize: (attrs, options) ->
      super(attrs, options)

      names = @get('names')
      renderers = @get('renderers')

      if renderers.length == 0
        all_renderers = @get('plot').get('renderers')
        renderers = (r for r in all_renderers when r.type == "Glyph")

      if names.length > 0
        renderers = (r for r in renderers when names.indexOf(r.get('name')) >= 0)

      @set('renderers', renderers)

    _inspect: (vx, vy, e) ->

    _exit_inner: () ->

    _exit_outer: () ->

    defaults: ->
      return _.extend {}, super(), {
        renderers: []
        names: []
        inner_only: true
        active: true
        event_type: 'move'
      }

  return {
    "Model": InspectTool
    "View": InspectToolView
    "ListItemView": InspectToolListItemView
  }
