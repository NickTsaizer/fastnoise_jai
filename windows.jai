//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



fnNewFromEncodedNodeTree :: (encodedString: *u8, simdLevel: u32) -> *void #foreign fastnoise;

fnDeleteNodeRef :: (node: *void) -> void #foreign fastnoise;

fnGetSIMDLevel :: (node: *void) -> u32 #foreign fastnoise;
fnGetMetadataID :: (node: *void) -> s32 #foreign fastnoise;

fnGenUniformGrid2D :: (node: *void, noiseOut: *float, xStart: s32, yStart: s32, xSize: s32, ySize: s32, frequency: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenUniformGrid3D :: (node: *void, noiseOut: *float, xStart: s32, yStart: s32, zStart: s32, xSize: s32, ySize: s32, zSize: s32, frequency: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenUniformGrid4D :: (node: *void, noiseOut: *float, xStart: s32, yStart: s32, zStart: s32, wStart: s32, xSize: s32, ySize: s32, zSize: s32, wSize: s32, frequency: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenPositionArray2D :: (node: *void, noiseOut: *float, count: s32, xPosArray: *float, yPosArray: *float, xOffset: float, yOffset: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenPositionArray3D :: (node: *void, noiseOut: *float, count: s32, xPosArray: *float, yPosArray: *float, zPosArray: *float, xOffset: float, yOffset: float, zOffset: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenPositionArray4D :: (node: *void, noiseOut: *float, count: s32, xPosArray: *float, yPosArray: *float, zPosArray: *float, wPosArray: *float, xOffset: float, yOffset: float, zOffset: float, wOffset: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenTileable2D :: (node: *void, noiseOut: *float, xSize: s32, ySize: s32, frequency: float, seed: s32, outputMinMax: *float) -> void #foreign fastnoise;

fnGenSingle2D :: (node: *void, x: float, y: float, seed: s32) -> float #foreign fastnoise;
fnGenSingle3D :: (node: *void, x: float, y: float, z: float, seed: s32) -> float #foreign fastnoise;
fnGenSingle4D :: (node: *void, x: float, y: float, z: float, w: float, seed: s32) -> float #foreign fastnoise;

fnGetMetadataCount :: () -> s32 #foreign fastnoise;
fnGetMetadataName :: (id: s32) -> *u8 #foreign fastnoise;
fnNewFromMetadata :: (id: s32, simdLevel: u32) -> *void #foreign fastnoise;

fnGetMetadataVariableCount :: (id: s32) -> s32 #foreign fastnoise;
fnGetMetadataVariableName :: (id: s32, variableIndex: s32) -> *u8 #foreign fastnoise;
fnGetMetadataVariableType :: (id: s32, variableIndex: s32) -> s32 #foreign fastnoise;
fnGetMetadataVariableDimensionIdx :: (id: s32, variableIndex: s32) -> s32 #foreign fastnoise;
fnGetMetadataEnumCount :: (id: s32, variableIndex: s32) -> s32 #foreign fastnoise;
fnGetMetadataEnumName :: (id: s32, variableIndex: s32, enumIndex: s32) -> *u8 #foreign fastnoise;
fnSetVariableFloat :: (node: *void, variableIndex: s32, value: float) -> bool #foreign fastnoise;
fnSetVariableIntEnum :: (node: *void, variableIndex: s32, value: s32) -> bool #foreign fastnoise;

fnGetMetadataNodeLookupCount :: (id: s32) -> s32 #foreign fastnoise;
fnGetMetadataNodeLookupName :: (id: s32, nodeLookupIndex: s32) -> *u8 #foreign fastnoise;
fnGetMetadataNodeLookupDimensionIdx :: (id: s32, nodeLookupIndex: s32) -> s32 #foreign fastnoise;
fnSetNodeLookup :: (node: *void, nodeLookupIndex: s32, nodeLookup: *void) -> bool #foreign fastnoise;

fnGetMetadataHybridCount :: (id: s32) -> s32 #foreign fastnoise;
fnGetMetadataHybridName :: (id: s32, hybridIndex: s32) -> *u8 #foreign fastnoise;
fnGetMetadataHybridDimensionIdx :: (id: s32, hybridIndex: s32) -> s32 #foreign fastnoise;
fnSetHybridNodeLookup :: (node: *void, hybridIndex: s32, nodeLookup: *void) -> bool #foreign fastnoise;
fnSetHybridFloat :: (node: *void, hybridIndex: s32, value: float) -> bool #foreign fastnoise;

#scope_file

#import "Basic"; // For assert

fastnoise :: #library "./win/FastNoise";
fastnoised :: #library "./win/FastNoiseD";
