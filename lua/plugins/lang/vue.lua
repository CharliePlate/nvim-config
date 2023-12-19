local Lang = require("util.lang")

return Lang.makeSpec({
  Lang.addFormatter({ vue = { { "prettierd" } } }),
  Lang.addLspServer("vuels"),
  Lang.addTreesitterFiletypes({ "vue" }),
})
