// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import { IStore } from "@latticexyz/store/src/IStore.sol";
import {Builder, BuilderTableId, GameObject, GameObjectTableId, Resources} from "../codegen/Tables.sol";
import { addressToEntityKey } from "../addressToEntityKey.sol";

contract MoveSystem is System {
  function move(uint builderNumber, int32 x, int32 y) public {
    bytes32 player = addressToEntityKey(address(_msgSender()));

    // Check if there's a GameObject at the new position
    bytes32[] memory gameObjectAtPosition = getKeysWithValue(GameObjectTableId, GameObject.encode(x,y));
    require(gameObjectAtPosition.length == 0, "There's a GameObject at the new position");

    // Update the position of the specified builder
    if (builderNumber == 1) {
      Builder.set(player, { builder1: { x: x, y: y }, builder2: Builder.get(player).builder2, builder3: Builder.get(player).builder3 });
    } else if (builderNumber == 2) {
      Builder.set(player, { builder1: Builder.get(player).builder1, builder2: { x: x, y: y }, builder3: Builder.get(player).builder3 });
    } else if (builderNumber == 3) {
      Builder.set(player, { builder1: Builder.get(player).builder1, builder2: Builder.get(player).builder2, builder3: { x: x, y: y } });
    } else {
      revert("Invalid builder number");
    }
  }
}
