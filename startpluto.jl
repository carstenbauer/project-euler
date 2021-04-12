using Pkg
Pkg.activate(dirname(@__FILE__))
Pkg.instantiate()

using Pluto
Pluto.run()
