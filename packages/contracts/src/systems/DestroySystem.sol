// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import {Builder, BuilderTableId, GameObject, GameObjectTableId, Resources} from "../codegen/Tables.sol";
import { addressToEntityKey } from "../addressToEntityKey.sol";

contract DestroySystem is System {
  function destroy(uint builderNumber, int32 x, int32 y) public {
    bytes32 player = addressToEntityKey(address(_msgSender()));
    
    // Get the builder's current position
    int32 builderX;
    int32 builderY;
    if (builderNumber == 1) {
      builderX = Builder.get(player).builder1.x;
      builderY = Builder.get(player).builder1.y;
    } else if (builderNumber == 2) {
      builderX = Builder.get(player).builder2.x;
      builderY = Builder.get(player).builder2.y;
    } else if (builderNumber == 3) {
      builderX = Builder.get(player).builder3.x;
      builderY = Builder.get(player).builder3.y;
    } else {
      revert("Invalid builder number");
    }

    // Check if the builder is at the specified position
    require(builderX == x && builderY == y, "The builder is not at the specified position");

    // Check if there is a GameObject at the position
    bytes32[] memory gameObjectAtPosition = getKeysWithValue(GameObjectTableId, GameObject.encode(x,y));
    require(gameObjectAtPosition.length == 1, "No GameObject at the given position");
    
    // Get the GameObject
    bytes32 gameObject = gameObjectAtPosition[0];
    string memory gameObjectType = GameObject.get(gameObject).type;

    // Update player's resources based on the type of the GameObject
    if (keccak256(abi.encodePacked(gameObjectType)) == keccak256(abi.encodePacked("wooden"))) {
      uint32 currentWood = Resources.get(player).wood;
      Resources.set(player, { wood: currentWood + 250, stone: Resources.get(player).stone });
    } else if (keccak256(abi.encodePacked(gameObjectType)) == keccak256(abi.encodePacked("rock"))) {
      uint32 currentStone = Resources.get(player).stone;
      Resources.set(player, { wood: Resources.get(player).wood, stone: currentStone + 50 });
    } else {
      revert("Invalid GameObject type");
    }

    // Destroy the GameObject
    GameObject.deleteRecord(gameObject);
  }
}
