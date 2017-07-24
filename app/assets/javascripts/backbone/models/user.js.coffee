class FoxTrot.Models.User extends Backbone.Model
  paramRoot: 'user'


class FoxTrot.Collections.UsersCollection extends Backbone.Collection
  model: FoxTrot.Models.User
  url: '/users'
