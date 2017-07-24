class FoxTrot.Models.Visit extends Backbone.Model
  paramRoot: 'visit'

class FoxTrot.Collections.VisitsCollection extends Backbone.Collection
  model: FoxTrot.Models.Visit
  url: '/visits'
