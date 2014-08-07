package = "dorf"
version = "0.1-0"
source = {
  url = "https://github.com/OlivineLabs/dorf/archive/v0.1.tar.gz",
  dir = "dorf-0.1"
}
description = {
  summary = "",
  detailed = [[
  ]],
  homepage = "http://olivinelabs.com/dorf/",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lanes >= 3.9.6-1",
  "luasocket >= 3.0rc1-1",
  "lua >= 5.1",
  "uuid >= 0.2-1",
  "penlight >= 1.3.1-1",
}
build = {
  type = "builtin",
  modules = {
  }
}
