using BloqadeExpr, BloqadeLattices, BloqadeWaveforms
import CloudQS 
nsites = 10
atoms = generate_sites(ChainLattice(), nsites, scale = 5.74)
T_end = 1.
Δ = ϕ = piecewise_linear(; clocks = [0, T_end], values = [0., 0.])
Ω = piecewise_linear(; clocks = [0, T_end], values = [2π, 2π])
h = rydberg_h(atoms; Ω = Ω, Δ = Δ, ϕ=ϕ)

clconf = CloudQS.CloudConfig()
CloudQS.add_server!(clconf, "127.0.0.1", 8000)

qstates = 0:2^nsites-1
isodd = [x%2 for x in qstates]
rydberg = [Base.count_ones(x) for x in qstates]
observables = [isodd, rydberg]
time_points = 10
data, meta = CloudQS.cloud_simulate(h, time_points, observables, clconf)
