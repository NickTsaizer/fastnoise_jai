#import "String";

#module_parameters(AUTOCOPY_DLL := true);

#if OS == .WINDOWS {
    #load "windows.jai";
    #if AUTOCOPY_DLL #run {
        #import "File_Utilities";
        options := get_build_options();

        copy_file(join(path_strip_filename(#filepath), "/win/FastNoise.dll"), join(options.output_path, "/FastNoise.dll"));
        
    }
}


Noise_Type :: enum s32 {
    #insert -> string {
        builder: String_Builder;
        other: String_Builder;

        meta_count := fnGetMetadataCount();

        for 0..meta_count-1 {
            name: string;
            name.data = fnGetMetadataName(it);
            name.count = c_style_strlen(name.data);
            print_to_builder(*builder, "% :: %;\n", name, it);
        }     

        return builder_to_string(*builder);
    }
}


Noise :: struct (type: Noise_Type) {
    Member_Id :: enum {
        #insert -> string {
            builder: String_Builder;
            variable_count := fnGetMetadataVariableCount(xx type);
            node_lookup_count := fnGetMetadataNodeLookupCount(xx type);
            hybrid_count := fnGetMetadataHybridCount(xx type);

            print_to_builder(*builder, "// Variable:\n");

            id := 0;

            for 0..variable_count-1 {
                name: string;
                name.data = fnGetMetadataVariableName(xx type, it);
                name.count = c_style_strlen(name.data);

                name = replace(name, " ", "");
                
                print_to_builder(*builder, "% :: %;\n", name, id);
                id +=1;
            }

            print_to_builder(*builder, "// Lookup:\n");

            for 0..node_lookup_count-1 {
                name: string;
                name.data = fnGetMetadataNodeLookupName(xx type, it);
                name.count = c_style_strlen(name.data);
                
                name = replace(name, " ", ""); 
                
                print_to_builder(*builder, "% :: %;\n", name, id);
                id +=1;
            }

            print_to_builder(*builder, "// Hybrid:\n");

            for 0..hybrid_count-1 {
                name: string;
                name.data = fnGetMetadataHybridName(xx type, it);
                name.count = c_style_strlen(name.data);

                name = replace(name, " ", "");
                
                print_to_builder(*builder, "% :: %;\n", name, id);
                id +=1;
            }

            print_to_builder(*builder, "MAX :: %;\n", id);
            return builder_to_string(*builder);
        }
    }


    metadata :: struct {
        Member :: struct {
            Member_Type :: enum {
                Float;
                Int;
                Enum;
                NodeLookup;
                Hybrid;
            }

            index: s32;
            name: string;
            type: Member_Type;
            enum_names: []string;
        }

        id :s32: xx type;
        name :: #run enum_names(Noise_Type)[type];
        members :: #run -> []Member {
            result := NewArray(xx Member_Id.MAX, Member);

            variable_count := fnGetMetadataVariableCount(xx type);
            node_lookup_count := fnGetMetadataNodeLookupCount(xx type);
            hybrid_count := fnGetMetadataHybridCount(xx type);

            id := 0;
            names := enum_names(Member_Id);

            for 0..variable_count-1 {
                result[id].name = names[id];
                result[id].type = xx fnGetMetadataVariableType(xx type, it);
                result[id].index = it;

                if result[id].type == Member.Member_Type.Enum {
                    names: [..]string;

                    enum_count := fnGetMetadataEnumCount(xx type, it);

                    for enid: 0..enum_count-1 {
                        name: string;
                        name.data = fnGetMetadataEnumName(xx type, it, enid);
                        name.count = c_style_strlen(name.data);

                        name = replace(name, " ", "");

                        array_add(*names, name);
                    }

                    result[id].enum_names = names;
                }

                id+=1;
            }

            for 0..node_lookup_count-1 {
                result[id].name = names[id];
                result[id].type = Member.Member_Type.NodeLookup;
                result[id].index = it;
                id+=1;
            }

            for 0..hybrid_count-1 {
                result[id].name = names[id];
                result[id].type = Member.Member_Type.Hybrid;
                result[id].index = it;
                id+=1;
            }
            return result;
        }
    }
    handle: *void;
}

make_noise :: ($type: Noise_Type) -> Noise(type) {
    result: Noise(type);
    result.handle = fnNewFromMetadata(xx type, 0);

    return result;
}

noise_set :: (noise: Noise, member_id: noise.Member_Id, value: $T) {
    member: noise.metadata.Member = noise.metadata.members[member_id];
    
    #if T == string {
        if member.type == noise.metadata.Member.Member_Type.Enum {
            finded, index := array_find(member.enum_names, value);
            if !finded || !fnSetVariableIntEnum(noise.handle, member.index, xx index) {
                log_error("Failed to set enum value");
            }
        }
    }

    #if #run IsScalar(T) {
        if member.type == {
            case noise.metadata.Member.Member_Type.Int; #through;
            case noise.metadata.Member.Member_Type.Enum; {
                if !fnSetVariableIntEnum(noise.handle, member.index, xx value) {
                    log_error("Failed to set int/enum value");
                }
            }

            case noise.metadata.Member.Member_Type.Float; {
                if !fnSetVariableFloat(noise.handle, member.index, xx value) {
                    log_error("Failed to set float value");
                }
            }

            case noise.metadata.Member.Member_Type.Hybrid; {
                if !fnSetHybridFloat(noise.handle, member.index, xx value) {
                    log_error("Failed to set hybrid float value");
                }
            }
        }
    }

    #if T == Noise {
        if member.type == {
            case noise.metadata.Member.Member_Type.NodeLookup; {
                if !fnSetNodeLookup(noise.handle, member.index, value.handle) {
                    log_error("Failed to set NodeLookup value");
                }
            }
            case member.type == noise.metadata.Member.Member_Type.Hybrid; {
                if !fnSetHybridNodeLookup(noise.handle, member.index, value.handle) {
                    log_error("Failed to set Hybrid NodeLookup value");
                }
            }
        }
    }


} 


noise_gen_uniform_2d :: (noise: Noise, 
                            x: s32, y: s32, 
                            size_x: s32, size_y: s32, 
                            frequency: float32, seed: s32) -> (result: []float32, min_max: [2]float32) {

    result := NewArray(size_x * size_y, float32);
    min_max: [2]float;

    fnGenUniformGrid2D(noise.handle, result.data, 
                            x, y, 
                            size_x, size_y, 
                            frequency, seed, min_max.data);

    return result, min_max;
}

noise_gen_uniform_3d :: (noise: Noise, 
                            x: s32, y: s32, z: s32, 
                            size_x: s32, size_y: s32, size_z: s32, 
                            frequency: float32, seed: s32) -> (result: []float32, min_max: [2]float32) {

    result := NewArray(size_x * size_y * size_z, float32);
    min_max: [2]float;

    fnGenUniformGrid3D(noise.handle, result.data, 
                            x, y, z,
                            size_x, size_y, size_z, 
                            frequency, seed, min_max.data);

    return result, min_max;
}

noise_gen_uniform_4d :: (noise: Noise, 
                            x: s32, y: s32, z: s32, w: s32, 
                            size_x: s32, size_y: s32, size_z: s32, size_2: s32, 
                            frequency: float32, seed: s32) -> (result: []float32, min_max: [2]float32) {

    result := NewArray(size_x * size_y * size_z * size_w, float32);
    min_max: [2]float;

    fnGenUniformGrid4D(noise.handle, result.data, 
                            x, y, z, w,
                            size_x, size_y, size_z, size_w,
                            frequency, seed, min_max.data);

    return result, min_max;
}

noise_gen_tileable_2d :: (noise: Noise,
                            size_x: s32, size_y: s32, 
                            frequency: float32, seed: s32) -> (result: []float32, min_max: [2]float32) {

    result := NewArray(size_x * size_y, float32);
    min_max: [2]float;

    fnGenTileable2D(noise.handle, result.data, 
                            size_x, size_y, 
                            frequency, seed, min_max.data);

    return result, min_max;
}

noise_gen_single_2d :: (noise: Noise, x: float32, y: float32, seed: s32) -> float {
    return fnGenSingle2D(noise.handle, x, y, seed);
}

noise_gen_single_3d :: (noise: Noise, x: float32, y: float32, z: float32, seed: s32) -> float {
    return fnGenSingle3D(noise.handle, x, y, z, seed);
}

noise_gen_single_4d :: (noise: Noise, x: float32, y: float32, z: float32, w: float32, seed: s32) -> float {
    return fnGenSingle4D(noise.handle, x, y, z, w, seed);
}

noise_gen_position_2d :: (noise: Noise, 
                            x_arr: []float, y_arr: []float, 
                            x_offset: float, y_offset: float,
                            seed: s32) {

    result := NewArray(x_arr.count, float32);
    min_max: [2]float;

    fnGenPositionArray2D(noise.handle, result.data, x_arr.count,
                            x_arr.data, y_arr.data, x_offset, y_offset,
                            seed, min_max.data);

    return result, min_max;
}

//TODO: test everyrthing and 

#import "Compiler";