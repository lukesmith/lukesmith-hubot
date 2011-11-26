# Remembers things you ask him to.
#
# remember the idea <idea> - Remembers the idea
# what ideas have I come up with? - Lists the ideas that you've told him.

class Items
  constructor: (@robot) ->
    @robot.brain.data.remember = []

  add: (whatToRemember) ->
    item = { text: whatToRemember, date: new Date().getTime() }
    @robot.brain.data.remember.push(item)

    count = 0
    for item in @robot.brain.data.remember
      item.id = count++

  list: ->
    return @robot.brain.data.remember.sort((a, b) -> a.date - b.date)

  removeAll: ->
    @robot.brain.data.remember = []

  remove: (id) ->
    items = @robot.brain.data.remember or []
    @robot.brain.data.remember = (item for item in items when item.id isnt id)

    count = 0
    for item in @robot.brain.data.remember
      item.id = count++

module.exports = (robot) ->
  items = new Items robot

  robot.respond /remember (.*)/i, (msg) ->
    items.add msg.match[1]

  robot.respond /what have (I|i) asked you to remember?/i, (msg) ->
    for item in items.list()
      msg.send "#{item.id} - #{item.text}"

  robot.respond /forget everything i've asked you to remember/i, (msg) ->
    items.removeAll()

  robot.respond /forget item number (\d?)/i, (msg) ->
    items.remove parseInt(msg.match[1])
