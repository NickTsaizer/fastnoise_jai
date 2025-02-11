# [FastNoise2](https://github.com/Auburn/FastNoise2) jai bindings

Usecase:

1. make noise generator
2. generate noise
3. ???

```odin
noise := make_noise(Noise_Type.CellularValue);
values, minmax := noise_gen_uniform_2d(noise, x=125, y=550, size_x=W, size_y=H, frequency=0.02, seed=634634);
```

Done: 

* Uniform 2D/3D/4D
* Single 2D/3D/4D
* From position array 2D
* Noise node compile-time metadata generation (WIP)
