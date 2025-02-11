#run generate_bindings();

generate_bindings :: () -> bool {
    set_build_options_dc(.{do_output=false});

    output_filename: string = "windows.jai";
    opts: Generate_Bindings_Options;
    {
        using opts;

        array_add(*libpaths,      "./win");
        array_add(*libnames,      "FastNoise", "FastNoiseD");
        array_add(*include_paths, "./win/include", "./win/include", 
    );
        array_add(*source_files,
            "FastNoise/FastNoise_C.h");
        array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN", "-std=c++20");

        // strip_flags &= ~(Strip_Flags.CONSTRUCTORS | .DESTRUCTORS);
    }

    return generate_bindings(opts, output_filename);
}

#scope_file

#import "Basic";
#import "Compiler";
#import "BuildCpp";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "File_Utilities";
#import "String";
