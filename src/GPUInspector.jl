module GPUInspector

# stdlibs
using Statistics
using Random
using LinearAlgebra
using Libdl
using Base: UUID
using Pkg: Pkg
using Logging
using DocStringExtensions

# external
using Reexport
@reexport using ThreadPinning
using CpuId: cachesize
using HDF5: h5open
using UnicodePlots: UnicodePlots
using Glob: glob

include("backends.jl")
include("UnitPrefixedBytes.jl")
include("utility.jl")
include("utility_unroll.jl")
include("stresstest_cpu.jl")
include("monitoring.jl")
include("hdf5.jl")

function not_implemented_yet()
    return error(
        "Not implemented yet. You either haven't loaded a backend (like CUDA.jl) yet, or" *
        " the loaded backend doesn't provide this functionality.",
    )
end
include("stubs/stubs_gpuinfo.jl")
include("stubs/stubs_p2p_bandwidth.jl")
include("stubs/stubs_host2device_bandwidth.jl")
include("stubs/stubs_membw.jl")

# backends
export Backend, CUDABackend, ROCBackend, backend, backend!
export CUDAExt

# stubs gpuinfo
export ngpus, gpuinfo, gpuinfo_p2p_access, gpus
# stubs p2p bandwidth
export p2p_bandwidth,
    p2p_bandwidth_all, p2p_bandwidth_bidirectional, p2p_bandwidth_bidirectional_all
# stubs p2p bandwidth
export host2device_bandwidth
# stubs memory bandwidth
export theoretical_memory_bandwidth,
    memory_bandwidth,
    memory_bandwidth_scaling,
    memory_bandwidth_saxpy,
    memory_bandwidth_saxpy_scaling

# UnitPrefixedBytes
export UnitPrefixedBytes,
    B, KB, MB, GB, TB, KiB, MiB, GiB, TiB, bytes, simplify, change_base, value
# export get_temperatures, get_power_usages, get_gpu_utilizations
# export clear_gpu_memory,
#     clear_all_gpus_memory,
#     cublasGemmEx_wrapper!,
#     cublasGemmEx_wrapper_wrapper!,
#     toggle_tensorcoremath,
#     hastensorcores,
#     MultiLogger,
#     multi_log
# export get_cpusocket_temperatures, get_cpu_utilizations, get_cpu_utilization
export logspace
# export MonitoringResults,
#     monitoring_start,
#     monitoring_stop,
#     plot_monitoring_results,
#     savefig_monitoring_results,
#     livemonitor_temperature,
#     livemonitor_powerusage
# export gpuinfo, gpuinfo_p2p_access, gpus
# export p2p_bandwidth,
#     p2p_bandwidth_all, p2p_bandwidth_bidirectional, p2p_bandwidth_bidirectional_all
# export host2device_bandwidth
# export stresstest
export stresstest_cpu
# export peakflops_gpu,
#     peakflops_gpu_fmas,
#     peakflops_gpu_wmmas,
#     peakflops_gpu_matmul,
#     peakflops_gpu_matmul_graphs,
#     peakflops_gpu_matmul_scaling
# export theoretical_peakflops_gpu, theoretical_peakflops_gpu_tensorcores
# export memory_bandwidth,
#     memory_bandwidth_saxpy,
#     memory_bandwidth_scaling,
#     memory_bandwidth_saxpy_scaling,
#     theoretical_memory_bandwidth
# export save_monitoring_results, load_monitoring_results

end
