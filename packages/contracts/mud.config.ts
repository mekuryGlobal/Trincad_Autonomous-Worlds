import { mudConfig, resolveTableId } from "@latticexyz/world/register";

export default mudConfig({
  tables: {
    Builder:{
      schema: {
        builder1: { x: "int32", y: "int32" },
        builder2: { x: "int32", y: "int32" },
        builder3: { x: "int32", y: "int32" }
      },
    },

    GameObject: {
      schema: {
        x: "int32",
        y: "int32",
        type: "string" // Could be 'wooden' or 'rock'
      },
    },

    Resources: {
      schema: {
        wood: "uint32",
        stone: "uint32"
      },
    },

  },
    
  modules: [
    {
      name: "KeysWithValueModule",
      root: true,
      args: [resolveTableId("Builder"), resolveTableId("GameObject")],
    },
  ],
});
