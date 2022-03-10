# Example: GPU Stress Test

!!! note
    **Test system:** DGX with 8x A100 GPUs

## Single GPU

```julia
julia> stresstest(device(); duration=10)
[ Info: Will try to run for approximately 10 seconds on each GPU.
[ Info: Running StressTest{Float32} on Julia thread 2 and CuDevice(0).
[ Info: Ran 11241 iterations on CuDevice(0).
[ Info: Clearing GPU memory.
[ Info: Took 10.0 seconds to run the tests.
```

## Multiple GPUs

First, make sure to run Julia with enough threads (more or equal to the number of GPU devices). Then, to run a GPU Stress test, use [`stresstest`](@ref).

In the following example, I started Julia with `julia -t 20` (why not? 😄).

```julia
julia> using GPUInspector

julia> stresstest(CUDA.devices(); duration=10)
[ Info: Will try to run for approximately 10 seconds on each GPU.
[ Info: Running StressTest{Float32} on Julia thread 2 and CuDevice(0).
[ Info: Running StressTest{Float32} on Julia thread 8 and CuDevice(6).
[ Info: Running StressTest{Float32} on Julia thread 4 and CuDevice(2).
[ Info: Running StressTest{Float32} on Julia thread 7 and CuDevice(5).
[ Info: Running StressTest{Float32} on Julia thread 5 and CuDevice(3).
[ Info: Running StressTest{Float32} on Julia thread 9 and CuDevice(7).
[ Info: Running StressTest{Float32} on Julia thread 6 and CuDevice(4).
[ Info: Running StressTest{Float32} on Julia thread 3 and CuDevice(1).
[ Info: Ran 11222 iterations on CuDevice(3).
[ Info: Ran 11203 iterations on CuDevice(6).
[ Info: Ran 11227 iterations on CuDevice(2).
[ Info: Ran 11230 iterations on CuDevice(4).
[ Info: Ran 11231 iterations on CuDevice(1).
[ Info: Ran 11199 iterations on CuDevice(0).
[ Info: Ran 11215 iterations on CuDevice(5).
[ Info: Ran 11246 iterations on CuDevice(7).
[ Info: Clearing GPU memory.
[ Info: Took 10.0 seconds to run the tests.
```

## Monitoring

To verify that the GPUs are actually busy you could use external tools like, e.g., `nvidia-smi`. However, we also provide built-in monitoring tools.

```julia
julia> using GPUInspector                                                       
                                                                                    
julia> monitoring_start()                                                           
[ Info: Spawning monitoring on Julia thread 20.

julia> stresstest(devices(); duration=10) # all devices, 10 seconds
[ Info: Will try to run for approximately 10 seconds on each GPU.
[ Info: Running StressTest{Float32} on Julia thread 4 and CuDevice(2).
[ Info: Running StressTest{Float32} on Julia thread 2 and CuDevice(0).
[ Info: Running StressTest{Float32} on Julia thread 6 and CuDevice(4).
[ Info: Running StressTest{Float32} on Julia thread 3 and CuDevice(1).
[ Info: Running StressTest{Float32} on Julia thread 9 and CuDevice(7).
[ Info: Running StressTest{Float32} on Julia thread 7 and CuDevice(5).
[ Info: Running StressTest{Float32} on Julia thread 5 and CuDevice(3).
[ Info: Running StressTest{Float32} on Julia thread 8 and CuDevice(6).
[ Info: Ran 11215 iterations on CuDevice(2).
[ Info: Ran 11241 iterations on CuDevice(6).
[ Info: Ran 11261 iterations on CuDevice(1).
[ Info: Ran 11236 iterations on CuDevice(5).
[ Info: Ran 11263 iterations on CuDevice(4).
[ Info: Ran 11261 iterations on CuDevice(3).
[ Info: Ran 11270 iterations on CuDevice(7).
[ Info: Ran 11241 iterations on CuDevice(0).
[ Info: Clearing GPU memory.
[ Info: Took 10.0 seconds to run the tests.

julia> results = monitoring_stop();
[ Info: Stopping monitoring and fetching results...
```

Here, `results` is a named tuple with time series information about GPU utilization, temperature, and more. See [`monitoring_stop`](@ref) for details.

You can use [`save_monitoring_results`](@ref) to save the results on disk. We also provide [`plot_monitoring_results`](@ref) to visualize the results, which should give you an output like this.

```
julia> plot_monitoring_results(results)

             ⠀⠀⠀⠀⠀⠀⠀⠀⠀GPU Utilization (Compute)
             ┌────────────────────────────────────────┐        
         105 │⠀⠀⠀⠀⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 0: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 1: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 2: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 3: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 4: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 5: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 6: NVIDIA A100-SXM4-40GB
   U [%]     │⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 7: NVIDIA A100-SXM4-40GB
             │⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             │⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             │⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             │⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             │⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             │⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
           0 │⣀⣀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                             
             └────────────────────────────────────────┘                             
             ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀20⠀                             
             ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Time [s]⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                          
                                                                                                                 
            ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀GPU Temperature⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                             
            ┌────────────────────────────────────────┐                             
         63 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 0: NVIDIA A100-SXM4-40GB
            │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠤⠤⠤⠒⢒⣲⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 1: NVIDIA A100-SXM4-40GB
            │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠤⠒⠊⣁⠤⣤⠤⠶⠮⠛⠛⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 2: NVIDIA A100-SXM4-40GB
            │⠀⠀⠀⠀⠀⠀⠀⡠⣒⣉⣉⣭⣓⠭⠛⠋⠉⠉⠉⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 3: NVIDIA A100-SXM4-40GB 
            │⠀⠀⠀⠀⠀⢠⣮⠮⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⢤⣤⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 4: NVIDIA A100-SXM4-40GB 
            │⠀⠀⠀⠀⢠⡿⠁⠀⠀⠀⠀⠀⢀⡠⠤⣤⠤⠶⠮⠛⠋⣉⠭⠥⠤⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 5: NVIDIA A100-SXM4-40GB 
            │⠀⠀⠀⢠⣷⠁⠀⣠⣒⠶⠒⢉⣉⢭⣛⣒⣒⡪⠝⠛⠛⠊⠉⠉⠉⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 6: NVIDIA A100-SXM4-40GB 
   T [C]    │⠀⠀⠀⣼⠃⢠⠊⣁⠤⠔⠚⠓⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡞⠲⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 7: NVIDIA A100-SXM4-40GB 
            │⠀⠀⢠⡏⢠⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            │⠀⠀⣼⢡⣷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            │⠤⠤⡟⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡳⡢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            │⠉⠛⢇⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠪⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            │⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            │⠒⠒⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
         28 │⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
            └────────────────────────────────────────┘                              
            ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀20⠀                              
            ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Time [s]⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                              
                                                                                                                 
             ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀GPU Power Usage⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                              
             ┌────────────────────────────────────────┐                             
         340 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 0: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⠀⣤⣠⣤⣤⣶⡶⠶⠶⠶⠾⠿⠿⣶⣿⣷⣶⣶⣶⣒⣒⣺⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 1: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢰⡯⡭⡿⠟⠛⠛⠛⠛⠛⠛⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 2: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢸⠋⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 3: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⢸⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 4: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 5: NVIDIA A100-SXM4-40GB
             │⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 6: NVIDIA A100-SXM4-40GB
   P [W]     │⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ GPU 7: NVIDIA A100-SXM4-40GB
             │⠀⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             │⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             │⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             │⠀⠀⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             │⠀⠀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             │⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
          56 │⣶⣶⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│                              
             └────────────────────────────────────────┘                              
             ⠀0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀20⠀                              
             ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Time [s]⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                              
```